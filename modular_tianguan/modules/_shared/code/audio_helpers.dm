// THIS IS A TIANGUAN MODULE FILE
// Shared jukebox catalog, pre-transfer asset helpers, and audio broadcast helpers
// used by admin_countdown and admin_sound_board.

/// Returns directory-listing-cached assoc list:
/// track_file -> list("name" = display_name, "path" = full_path, "length" = cached_ds_or_null)
/proc/tianguan_jukebox_catalog()
	var/static/list/catalog
	var/static/list/cached_listing
	var/list/tracks = flist(CONFIG_JUKEBOX_SOUNDS)
	if(!isnull(catalog) && length(tracks ^ cached_listing) == 0)
		return catalog
	catalog = list()
	cached_listing = tracks.Copy()
	for(var/track_file in tracks)
		var/path = "[CONFIG_JUKEBOX_SOUNDS][track_file]"
		if(!IS_SOUND_FILE_SAFE(path))
			continue
		var/list/track_data = splittext(track_file, "+")
		if(!length(track_data))
			continue
		var/track_name = strip_filepath_extension(track_data[JUKEBOX_NAME], SSsounds.safe_formats)
		if(!length(track_name))
			continue
		catalog[track_file] = list(
			"name" = track_name,
			"path" = path,
			"length" = null,
		)
	return catalog

/// Returns list(list("key" = track_file, "name" = display_name), ...) for TGUI selectors.
/proc/tianguan_jukebox_catalog_options()
	var/list/options = list()
	var/list/catalog = tianguan_jukebox_catalog()
	for(var/track_file in catalog)
		var/list/track = catalog[track_file]
		options += list(list("key" = track_file, "name" = track["name"]))
	return options

/// Lazy-caches sound duration in deciseconds so menu opens do not read every audio file on disk.
/proc/tianguan_jukebox_track_length(track_file)
	var/list/track = tianguan_jukebox_catalog()[track_file]
	if(!track)
		return 0
	if(isnull(track["length"]))
		track["length"] = SSsounds.get_sound_length(track["path"])
	return track["length"]

/// Registers an uploaded audio file in SSassets using its filename key (sharing md5 cache with sound()).
/proc/tianguan_jukebox_register_asset(track_file)
	var/list/track = tianguan_jukebox_catalog()[track_file]
	if(!track)
		return null
	var/datum/asset_transport/transport = SSassets.transport
	if(!transport)
		return null
	var/asset_key = track_file
	if(!SSassets.cache[asset_key])
		transport.register_asset(asset_key, file(track["path"]))
	return asset_key

/// Sends a registered jukebox asset to a single client and flushes their browse queue.
/proc/tianguan_jukebox_send_asset(client/player, track_file)
	var/asset_key = tianguan_jukebox_register_asset(track_file)
	if(!asset_key || QDELETED(player))
		return FALSE
	var/datum/asset_transport/transport = SSassets.transport
	if(!transport)
		return FALSE
	transport.send_assets(player, asset_key)
	player.browse_queue_flush()
	return TRUE

/// Builds a shared player transfer status table payload for TGUI transfer monitors.
/proc/tianguan_transfer_status_table(list/status, total_files, queue_left = null)
	var/ready = 0
	var/list/rows = list()
	for(var/key in status)
		var/list/entry = status[key]
		var/client/player = GLOB.directory[key]
		if(entry["ready"])
			ready++
		rows += list(list(
			"ckey" = key,
			"name" = entry["name"],
			"pushed" = entry["pushed"],
			"total" = total_files,
			"ready" = entry["ready"] ? TRUE : FALSE,
			"online" = (!isnull(player) && !QDELETED(player)),
			"left" = entry["left"] ? TRUE : FALSE,
		))
	var/list/result = list(
		"players" = rows,
		"ready_count" = ready,
		"online_count" = length(GLOB.clients),
		"total" = total_files,
	)
	if(!isnull(queue_left))
		result["queue_left"] = queue_left
	return result

/// Removes all queued transfer entries for a removed/missing track file.
/proc/tianguan_prune_transfer_queue(list/queue, track_file)
	for(var/i = length(queue); i >= 1; i--)
		var/list/pair = queue[i]
		if(pair && pair[2] == track_file)
			queue.Cut(i, i + 1)

/// Broadcasts a catalog track on CHANNEL_JUKEBOX scaled per client's admin MIDI volume preference.
/// Note: sound(path) + CHANNEL_JUKEBOX without SOUND_STREAM avoids silent playback in client tests.
/proc/tianguan_jukebox_broadcast(track_file, base_volume)
	var/list/track = tianguan_jukebox_catalog()[track_file]
	if(!track)
		return null
	var/clamped_volume = clamp(base_volume, 1, 100)
	var/sound/playing = sound(track["path"])
	playing.channel = CHANNEL_JUKEBOX
	playing.volume = clamped_volume
	var/heard = 0
	var/skipped = 0
	var/lowest_volume = 999
	for(var/mob/player_mob as anything in GLOB.player_list)
		var/client/player = player_mob.client
		if(!player)
			continue
		var/volume_modifier = player.prefs?.read_preference(/datum/preference/numeric/volume/sound_midi)
		if(volume_modifier > 0)
			playing.volume = clamped_volume * (volume_modifier / 100)
			SEND_SOUND(player_mob, playing)
			heard++
			lowest_volume = min(lowest_volume, playing.volume)
			playing.volume = clamped_volume
		else
			skipped++
	return list(
		"track" = track,
		"base_volume" = clamped_volume,
		"heard" = heard,
		"skipped" = skipped,
		"lowest_volume" = lowest_volume,
	)

/// Plays a catalog track once to a single mob on CHANNEL_JUKEBOX for admin preview.
/proc/tianguan_jukebox_preview(mob/target_mob, track_file, base_volume)
	var/list/track = tianguan_jukebox_catalog()[track_file]
	if(!track || QDELETED(target_mob))
		return null
	var/sound/preview = sound(track["path"])
	preview.channel = CHANNEL_JUKEBOX
	preview.volume = clamp(base_volume, 1, 100)
	SEND_SOUND(target_mob, preview)
	return track

/// Stops active jukebox channel audio for all connected mobs.
/proc/tianguan_jukebox_stop_broadcast()
	for(var/mob/player_mob as anything in GLOB.player_list)
		if(player_mob.client)
			SEND_SOUND(player_mob, sound(null, channel = CHANNEL_JUKEBOX))

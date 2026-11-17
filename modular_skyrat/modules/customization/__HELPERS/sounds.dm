/**
 * conditional_pref_sound is similar to `playsound` but it does not pass through walls, doesn't play for ghosts, and checks for prefs.
 * This is useful for content that some players may prefer to mute individually via preferences.
 *
 * source - Origin of sound.
 * soundin - Either a file, or a string that can be used to get an SFX.
 * vol - The volume of the sound, excluding falloff and pressure affection.
 * vary - bool that determines if the sound changes pitch every time it plays.
 * extrarange - modifier for sound range. This gets added on top of SOUND_RANGE.
 * falloff_exponent - Rate of falloff for the audio. Higher means quicker drop to low volume. Should generally be over 1 to indicate a quick dive to 0 rather than a slow dive.
 * frequency - playback speed of audio.
 * channel - The channel the sound is played at.
 * pressure_affected - Whether or not difference in pressure affects the sound (E.g. if you can hear in space).
 * ignore_walls - Whether or not the sound can pass through walls.
 * falloff_distance - Distance at which falloff begins. Sound is at peak volume (in regards to falloff) aslong as it is in this range.
 * pref_to_check - the path of the pref that we want to check
 */
/proc/conditional_pref_sound(
	atom/source,
	soundin,
	vol as num,
	vary,
	extrarange as num,
	falloff_exponent = SOUND_FALLOFF_EXPONENT,
	frequency = null,
	channel = 0,
	pressure_affected = TRUE,
	ignore_walls = FALSE,
	falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE,
	use_reverb = TRUE,
	pref_to_check = /datum/preference/numeric/volume/sound_ambience_volume,
)
	if(isarea(source))
		CRASH("playsound(): source is an area")

	var/turf/turf_source = get_turf(source)
	if(!turf_source || !soundin || !vol || !ispath(pref_to_check))
		return

	//allocate a channel if necessary now so its the same for everyone
	channel = channel || SSsounds.random_available_channel()

	var/sound/sound_to_play = sound(get_sfx(soundin))
	var/maxdistance = SOUND_RANGE + extrarange
	var/source_z = turf_source.z
	var/list/listeners = SSmobs.clients_by_zlevel[source_z].Copy()

	. = list()//output everything that successfully heard the sound

	var/turf/above_turf = GET_TURF_ABOVE(turf_source)
	var/turf/below_turf = GET_TURF_BELOW(turf_source)

	if(ignore_walls)
		if(above_turf && istransparentturf(above_turf))
			listeners += SSmobs.clients_by_zlevel[above_turf.z]

		if(below_turf && istransparentturf(turf_source))
			listeners += SSmobs.clients_by_zlevel[below_turf.z]

	else //these sounds don't carry through walls
		listeners = get_hearers_in_view(maxdistance, turf_source)

		if(above_turf && istransparentturf(above_turf))
			listeners += get_hearers_in_view(maxdistance, above_turf)

		if(below_turf && istransparentturf(turf_source))
			listeners += get_hearers_in_view(maxdistance, below_turf)

	for(var/mob/listening_mob in listeners)
		if(!(get_dist(listening_mob, turf_source) <= maxdistance))
			continue

		var/client_volume_modifier = listening_mob?.client?.prefs?.read_preference(pref_to_check)
		if(!client_volume_modifier)
			continue
		if(client_volume_modifier == 1) // binary on/off prefs get set to volume 100
			client_volume_modifier = 100
		client_volume_modifier = client_volume_modifier / 100

		var/sound_volume_modifier = vol * client_volume_modifier
		listening_mob.playsound_local(turf_source, soundin, sound_volume_modifier, vary, frequency, falloff_exponent, channel, pressure_affected, sound_to_play, maxdistance, falloff_distance, 1, use_reverb)
		. += listening_mob

// Round-local overrides. The original voice stays on the emitter so resetting also restores vendor personalities.
/datum/controller/subsystem/tts
	var/list/station_voice_overrides = list()

/obj
	var/station_voice_group
	var/station_device_voice

/obj/machinery/computer
	station_voice_group = STATION_VOICE_COMPUTERS

/obj/item/modular_computer
	station_voice_group = STATION_VOICE_COMPUTERS

/obj/machinery/announcement_system
	station_voice_group = STATION_VOICE_ANNOUNCEMENTS

/obj/machinery/vending
	station_voice_group = STATION_VOICE_VENDORS

/obj/item/assembly/control/transport
	station_voice_group = STATION_VOICE_TRANSIT

/obj/effect/landmark/transport/nav_beacon/tram
	station_voice_group = STATION_VOICE_TRANSIT

/datum/controller/subsystem/tts/proc/is_public_station_voice(speaker)
	return istext(speaker) && (speaker in available_speakers) && !findtextEx(speaker, TTS_CUSTOM_VOICE_PREFIX, 1, length(TTS_CUSTOM_VOICE_PREFIX) + 1) && !is_custom_voice(speaker)

/obj/proc/station_voice_override()
	if(!SStts)
		return null
	if(station_device_voice && SStts.is_public_station_voice(station_device_voice))
		return station_device_voice
	if(!station_voice_group || !length(SStts.station_voice_overrides))
		return null
	var/group_voice = SStts.station_voice_overrides[station_voice_group]
	if(SStts.is_public_station_voice(group_voice))
		return group_voice
	return null

/obj/base_tts_voice()
	return station_voice_override() || ..()

/datum/controller/subsystem/tts/proc/announcement_voice(authored_voice)
	if(authored_voice && ((authored_voice in available_speakers) || is_custom_voice(authored_voice)))
		return authored_voice
	var/override = station_voice_overrides[STATION_VOICE_ANNOUNCEMENTS]
	if(is_public_station_voice(override))
		return override
	if(computer_voice in available_speakers)
		return computer_voice
	return random_tts_voice()

/// Both the active console login and the operator's current ID must have CentCom command access.
/obj/machinery/computer/communications/proc/can_configure_station_voices(mob/user)
	if(!authenticated || !(ACCESS_CENT_CAPTAIN in authorize_access))
		return FALSE
	if(!ishuman(user) || !is_centcom_level(z) || syndicate || (obj_flags & EMAGGED) || !is_operational || !Adjacent(user))
		return FALSE
	var/mob/living/carbon/human/operator = user
	var/obj/item/card/id/card = operator.get_idcard(hand_first = TRUE)
	return (ACCESS_CENT_CAPTAIN in card?.GetAccess()) && ui_status(user, ui_state(user)) == UI_INTERACTIVE

/proc/can_edit_station_voices(mob/user, obj/machinery/computer/communications/console)
	if(!user?.client)
		return FALSE
	if(console)
		return !QDELETED(console) && console.can_configure_station_voices(user)
	return check_rights_for(user.client, R_ADMIN)

/// One operator's navigation in a console window, also used by the admin verb.
/datum/tgui/station_voices
	var/group
	var/area/selected_area
	var/datum/weakref/device_ref
	COOLDOWN_DECLARE(preview_cooldown)

/datum/tgui/station_voices/proc/selected_device()
	var/obj/machinery/device = device_ref?.resolve()
	if(!QDELETED(device) && isturf(device.loc) && is_station_level(device.z) && get_area(device) == selected_area)
		return device

/datum/tgui/station_voices/proc/voice_data()
	var/obj/machinery/device = selected_device()
	return list(
		"group" = group,
		"area" = selected_area ? REF(selected_area) : null,
		"device" = device ? REF(device) : null,
		"current" = group == STATION_VOICE_DEVICE ? device?.station_device_voice : SStts.station_voice_overrides[group],
		"canPreview" = SStts.is_runtime_enabled() && COOLDOWN_FINISHED(src, preview_cooldown),
	)

/// Build the directory only on a full update of the device page, and send machines for one area.
/datum/controller/subsystem/tts/proc/station_voice_catalog(datum/tgui/station_voices/editor)
	var/list/labels = voice_display_names(available_speakers)
	var/list/voices = list()
	for(var/id in available_speakers)
		if(is_public_station_voice(id))
			voices += list(list("id" = id, "name" = labels?[id] || id))
	var/list/catalog = list("voices" = voices)
	if(editor?.group != STATION_VOICE_DEVICE)
		return catalog
	var/list/areas = list()
	var/list/machines = list()
	for(var/obj/machinery/machine as anything in SSmachines.get_all_machines())
		if(QDELETED(machine) || !isturf(machine.loc) || !is_station_level(machine.z))
			continue
		var/area/location = get_area(machine)
		var/area_id = REF(location)
		if(!areas[area_id])
			areas[area_id] = "[location.lang_localize_name_for_display(location.name)] (Z[machine.z])"
		if(location == editor.selected_area)
			machines[REF(machine)] = "[machine.lang_localize_name_for_display(machine.name)] ([machine.x], [machine.y])"
	catalog["areas"] = areas
	catalog["machines"] = machines
	catalog["area"] = editor.selected_area ? REF(editor.selected_area) : null
	return catalog

/datum/tgui/station_voices/proc/voice_action(list/params)
	var/op = params["operation"]
	if(op == "open" || (group && op == "group"))
		var/new_group = op == "open" ? STATION_VOICE_ANNOUNCEMENTS : params["group"]
		if(!(new_group in list(STATION_VOICE_ANNOUNCEMENTS, STATION_VOICE_COMPUTERS, STATION_VOICE_VENDORS, STATION_VOICE_TRANSIT, STATION_VOICE_DEVICE)))
			return FALSE
		var/refresh_catalog = !group || new_group == STATION_VOICE_DEVICE
		group = new_group
		selected_area = null
		device_ref = null
		if(refresh_catalog)
			send_full_update()
		return TRUE
	if(!group)
		return FALSE
	switch(op)
		if("back")
			group = null
			selected_area = null
			device_ref = null
			return TRUE
		if("area")
			if(group != STATION_VOICE_DEVICE || !istext(params["area"]))
				return FALSE
			var/area/location = locate(params["area"])
			if(!istype(location))
				return FALSE
			selected_area = location
			device_ref = null
			send_full_update()
			return TRUE
		if("device")
			if(group != STATION_VOICE_DEVICE || !selected_area || !istext(params["device"]))
				return FALSE
			var/obj/machinery/machine = locate(params["device"])
			if(!istype(machine) || QDELETED(machine) || !isturf(machine.loc) || !is_station_level(machine.z) || get_area(machine) != selected_area)
				return FALSE
			device_ref = WEAKREF(machine)
			return TRUE
		if("preview", "apply", "reset")
			var/obj/machinery/device = selected_device()
			if(params["group"] != group || (group == STATION_VOICE_DEVICE && (!device || params["device"] != REF(device))))
				return FALSE
			var/speaker = params["speaker"]
			if(op != "reset" && !SStts.is_public_station_voice(speaker))
				return FALSE
			if(op == "preview")
				if(!SStts.is_runtime_enabled() || !COOLDOWN_FINISHED(src, preview_cooldown))
					return FALSE
				COOLDOWN_START(src, preview_cooldown, 1 SECONDS)
				INVOKE_ASYNC(SStts, TYPE_PROC_REF(/datum/controller/subsystem/tts, queue_tts_message), user.client, LANG("datum.7acfc83a63e39383", null), speaker = speaker, local = TRUE, identifier = "cc-preview-[nova_ui_id]-[world.time]")
				return TRUE
			if(op == "reset")
				speaker = null
			if(device)
				device.station_device_voice = speaker
			else if(speaker)
				SStts.station_voice_overrides[group] = speaker
			else
				SStts.station_voice_overrides -= group
			log_admin("[key_name(user)] set station TTS [device ? "[device] ([AREACOORD(device)])" : group] to [speaker || "default"].")
			return TRUE
	return FALSE

/datum/controller/subsystem/tts/ui_state(mob/user)
	return ADMIN_STATE(R_ADMIN)

/datum/controller/subsystem/tts/ui_interact(mob/user, datum/tgui/ui)
	if(!can_edit_station_voices(user, null) || SStgui.try_update_ui(user, src, ui))
		return
	var/datum/tgui/station_voices/editor = new(user, src, "StationVoiceConsole", LANG("datum.65873b1815495c39", null))
	editor.group = STATION_VOICE_ANNOUNCEMENTS
	editor.open()

/datum/controller/subsystem/tts/ui_static_data(mob/user)
	if(can_edit_station_voices(user, null))
		return list("voiceCatalog" = station_voice_catalog(SStgui.get_open_ui(user, src)))

/datum/controller/subsystem/tts/ui_data(mob/user)
	var/datum/tgui/station_voices/editor = SStgui.get_open_ui(user, src)
	if(editor && can_edit_station_voices(user, null))
		return list("voiceEditor" = editor.voice_data())

/datum/controller/subsystem/tts/ui_act(action, list/params, datum/tgui/station_voices/ui, datum/ui_state/state)
	if(..() || action != "stationVoices" || !can_edit_station_voices(ui.user, null) || params["operation"] == "back")
		return FALSE
	return ui.voice_action(params)

ADMIN_VERB(configure_station_voices, R_ADMIN, "设置广播与设备音色", "Set this round's station announcement and device voices.", ADMIN_CATEGORY_MAIN)
	SStts.ui_interact(user.mob)

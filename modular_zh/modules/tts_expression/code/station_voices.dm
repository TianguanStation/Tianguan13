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

/// A physical CentCom console requires the operator's own ID, even if someone left it logged in.
/obj/machinery/computer/communications/proc/can_configure_station_voices(mob/user)
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

/datum/controller/subsystem/tts/proc/select_station_machine(mob/user)
	var/list/by_area = list()
	var/list/used_labels = list()
	for(var/obj/machinery/machine as anything in SSmachines.get_all_machines())
		if(!isturf(machine.loc) || !is_station_level(machine.z))
			continue
		var/area/location = get_area(machine)
		var/area_name = location.lang_localize_name_for_display(location.name)
		var/list/choices = by_area[area_name]
		if(!choices)
			choices = list()
			by_area[area_name] = choices
		var/label = "[machine.lang_localize_name_for_display(machine.name)] ([machine.x], [machine.y], [machine.z])"
		choices[avoid_assoc_duplicate_keys(label, used_labels)] = machine
	var/area_choice = tgui_input_list(user, LANG("datum.8898e19df3ccd483", null), LANG("datum.65873b1815495c39", null), sort_list(by_area.Copy()))
	if(isnull(area_choice))
		return null
	var/list/machines = by_area[area_choice]
	var/device_choice = tgui_input_list(user, LANG("datum.549ff9e799de931c", null), area_choice, sort_list(machines.Copy()))
	return machines[device_choice]

/datum/controller/subsystem/tts/proc/configure_station_voices(mob/user, obj/machinery/computer/communications/console)
	if(!can_edit_station_voices(user, console))
		return
	var/list/groups = list(
		(LANG("datum.80bf10b06fcd38a9", null)) = STATION_VOICE_ANNOUNCEMENTS,
		(LANG("datum.d1360a4be03b9b0d", null)) = STATION_VOICE_COMPUTERS,
		(LANG("datum.055ffc7d27b22c19", null)) = STATION_VOICE_VENDORS,
		(LANG("datum.28abe23f2f9cf5f6", null)) = STATION_VOICE_TRANSIT,
		(LANG("datum.82ac13a93f597f4e", null)) = STATION_VOICE_DEVICE,
	)
	var/label = tgui_input_list(user, LANG("datum.7a2958e6ac7c4400", null), LANG("datum.65873b1815495c39", null), groups)
	if(isnull(label) || !can_edit_station_voices(user, console))
		return
	var/group = groups[label]
	var/obj/machinery/device
	var/current = station_voice_overrides[group]
	if(group == STATION_VOICE_DEVICE)
		device = select_station_machine(user)
		if(QDELETED(device))
			return
		label = "[device.lang_localize_name_for_display(device.name)] ([device.x], [device.y], [device.z])"
		current = device.station_device_voice
	var/reset = LANG("datum.c36860e1972dcd9f", null)
	var/list/voices = list()
	voices[reset] = null
	var/list/labels = voice_display_names(available_speakers)
	for(var/id in available_speakers)
		if(is_public_station_voice(id))
			var/display = labels?[id]
			voices[(display && display != id) ? "[display] ([id])" : id] = id
	var/current_label = current || reset
	var/selected = tgui_input_list(user, LANG("datum.f3e25170b31ca9f4", list(current_label)), label, voices)
	if(isnull(selected) || !(selected in voices))
		return
	var/speaker = voices[selected]
	if(speaker && is_runtime_enabled() && can_edit_station_voices(user, console))
		queue_tts_message(user.client, LANG("datum.7acfc83a63e39383", null), speaker = speaker, local = TRUE, identifier = "cc-preview-[REF(user)]-[world.time]")
	var/apply_label = LANG("datum.0f0219b609992c7c", null)
	if(tgui_alert(user, LANG("datum.e72da9dd888fe2c7", list(selected)), label, list(apply_label, LANG("datum.16251151deca6899", null))) != apply_label)
		return
	if(!can_edit_station_voices(user, console) || (speaker && !is_public_station_voice(speaker)))
		return
	if(group == STATION_VOICE_DEVICE)
		if(QDELETED(device) || !isturf(device.loc) || !is_station_level(device.z))
			return
		device.station_device_voice = speaker
	else if(speaker)
		station_voice_overrides[group] = speaker
	else
		station_voice_overrides -= group
	log_admin("[key_name(user)] set station TTS [label] to [speaker || "default"].")
	to_chat(user, span_notice(LANG("datum.90d7fe87e1e22a97", list(label, selected))))

ADMIN_VERB(configure_station_voices, R_ADMIN, "设置广播与设备音色", "Set this round's station announcement and device voices.", ADMIN_CATEGORY_MAIN)
	SStts.configure_station_voices(user.mob)

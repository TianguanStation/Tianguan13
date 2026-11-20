///Data holder for the announcers that can be used in a game, this can be used to have alternative announcements outside of the default e.g.the intern
/datum/centcom_announcer
	///Roundshift start audio
	var/welcome_sounds = list()
	///Sounds made when announcement is receivedc
	var/alert_sounds = list()
	///Sounds made when command report is received
	var/command_report_sounds = list()
	///Event audio, can be used for specific event announcements and is assoc key - sound. If no sound is found the default is used.area
	var/event_sounds = list()
	///Override this to have a custom message to show instead of the normal priority announcement
	var/custom_alert_message


/datum/centcom_announcer/proc/get_rand_welcome_sound()
	return pick(welcome_sounds)


/datum/centcom_announcer/proc/get_rand_alert_sound()
	return pick(alert_sounds)

/datum/centcom_announcer/proc/get_rand_report_sound()
	return pick(command_report_sounds)

/// Resolve the listener's announcer pack first, including fallbacks for missing events.
/datum/centcom_announcer/proc/announcement_sound(requested_sound, tts_cue)
	var/clip = requested_sound
	var/event_clip = istext(requested_sound) ? event_sounds[requested_sound] : null
	if(event_clip)
		clip = event_clip
	else if(requested_sound == ANNOUNCER_COMMAND_REPORT)
		clip = get_rand_report_sound()
	else if(requested_sound == ANNOUNCER_RANDOM_WELCOME)
		clip = get_rand_welcome_sound()
	else if(!requested_sound || requested_sound == ANNOUNCER_RANDOM_ALERT || (requested_sound in GLOB.announcer_keys))
		clip = get_rand_alert_sound()

	if(islist(clip))
		clip = length(clip) ? pick(clip) : null
	if(tts_cue && tts_sound_is_announcer_speech(clip))
		return tts_cue
	return clip || 'sound/announcer/notice/notice2.ogg'

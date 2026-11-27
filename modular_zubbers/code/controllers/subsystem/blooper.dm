#define BLOOPER_CONFIG_PATH "[global.config.directory]/bloopers"

SUBSYSTEM_DEF(blooper)
	name = "Blooper"
	ss_flags = SS_NO_FIRE | SS_NO_INIT

	var/list/blooper_list

/datum/controller/subsystem/blooper/OnConfigLoad()
	blooper_list = initialize_blooper_datums()

/datum/controller/subsystem/blooper/proc/initialize_blooper_datums()
	var/list/blooper_datums = list()
	var/list/bundled_samples = bundled_character_voice_samples() // ZH EDIT - Bundled character voice audio
	if(!rustg_file_exists("[BLOOPER_CONFIG_PATH]/blooper_config.json"))
		logger.Log(LOG_CATEGORY_DEBUG, "blooper_config.json not found.")
		return blooper_datums
	var/list/blooper_entries = safe_json_decode(rustg_file_read("[BLOOPER_CONFIG_PATH]/blooper_config.json"))
	if(isnull(blooper_entries))
		stack_trace("Blooper config is malformed!")
		return blooper_datums
	for(var/entry in blooper_entries)
		// These fields are required
		if(isnull(entry["name"]) || isnull(entry["id"]) || isnull(entry["files"]) || !length(entry["files"]))
			stack_trace("Blooper config entry was missing required field!")
			continue
		var/datum/blooper/new_blooper = new()
		new_blooper.name = entry["name"]
		new_blooper.id = entry["id"]
		for(var/sample_name as anything in entry["files"])
			var/configured_sample = "[BLOOPER_CONFIG_PATH]/[sample_name]"
			if(fexists(configured_sample))
				new_blooper.soundpath_list += file(configured_sample)
			else if(bundled_samples[sample_name])
				new_blooper.soundpath_list += bundled_samples[sample_name]
		if(!length(new_blooper.soundpath_list))
			qdel(new_blooper)
			continue
		new_blooper.min_pitch = entry["min_pitch"] || BLOOPER_DEFAULT_MINPITCH
		new_blooper.max_pitch = entry["max_pitch"] || BLOOPER_DEFAULT_MAXPITCH
		new_blooper.min_vary = entry["min_vary"] || BLOOPER_DEFAULT_MINVARY
		new_blooper.max_vary = entry["max_vary"] || BLOOPER_DEFAULT_MAXVARY
		new_blooper.min_speed = entry["min_speed"] || BLOOPER_DEFAULT_MINSPEED
		new_blooper.max_speed = entry["max_speed"] || BLOOPER_DEFAULT_MAXSPEED
		blooper_datums[new_blooper.id] = new_blooper
	return blooper_datums

#undef BLOOPER_CONFIG_PATH

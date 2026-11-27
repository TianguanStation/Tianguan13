#define BLOOPER_CONFIG_PATH "[global.config.directory]/bloopers"

SUBSYSTEM_DEF(blooper)
	name = "Blooper"
	ss_flags = SS_NO_FIRE | SS_NO_INIT

	var/list/blooper_list

/datum/controller/subsystem/blooper/OnConfigLoad()
	blooper_list = initialize_blooper_datums()

/datum/controller/subsystem/blooper/proc/initialize_blooper_datums()
	var/list/blooper_datums = list()
	// Resource literals keep the fallback samples available in compiled builds.
	var/static/list/bundled_samples = list(
		"barks/aa_blip.ogg" = 'modular_zzplurt/sound/voice/barks/ace_attorney/aa_blip.ogg',
		"barks/aa_blip_typewriter.ogg" = 'modular_zzplurt/sound/voice/barks/ace_attorney/aa_blip_typewriter.ogg',
		"barks/aa_dd_blip.ogg" = 'modular_zzplurt/sound/voice/barks/ace_attorney/aa_dd_blip.ogg',
		"barks/aa_tgaa_blip.ogg" = 'modular_zzplurt/sound/voice/barks/ace_attorney/aa_tgaa_blip.ogg',
		"barks/ahuh.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/ahuh.ogg',
		"barks/bark2.ogg" = 'modular_skyrat/modules/emotes/sound/voice/bark2.ogg',
		"barks/bleat_bark.ogg" = 'modular_zzplurt/sound/voice/barks/bleat_bark.ogg',
		"barks/cry.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/cry.ogg',
		"barks/eugh.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/eugh.ogg',
		"barks/growl2.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/growl2.ogg',
		"barks/haha.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/haha.ogg',
		"barks/moan1.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/moan1.ogg',
		"barks/moan2.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/moan2.ogg',
		"barks/moan3.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/moan3.ogg',
		"barks/nomi.ogg" = 'modular_zzplurt/sound/voice/barks/nomi.ogg',
		"barks/poyo.ogg" = 'modular_zzplurt/sound/voice/barks/poyo.ogg',
		"barks/raah1.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/raah1.ogg',
		"barks/raah2.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/raah2.ogg',
		"barks/slurp.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/slurp.ogg',
		"barks/zap.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/zap.ogg',
		"creature/xenohiss.ogg" = 'modular_zubbers/code/modules/emotes/sound/voice/xenohiss.ogg',
		"goon/blub.ogg" = 'modular_zzplurt/sound/voice/barks/goon/blub.ogg',
		"goon/bottalk_1.ogg" = 'modular_zzplurt/sound/voice/barks/goon/bottalk_1.ogg',
		"goon/bottalk_2.ogg" = 'modular_zzplurt/sound/voice/barks/goon/bottalk_2.ogg',
		"goon/bottalk_3.ogg" = 'modular_zzplurt/sound/voice/barks/goon/bottalk_3.ogg',
		"goon/bottalk_4.ogg" = 'modular_zzplurt/sound/voice/barks/goon/bottalk_4.ogg',
		"goon/buwoo.ogg" = 'modular_zzplurt/sound/voice/barks/goon/buwoo.ogg',
		"goon/cow.ogg" = 'modular_zzplurt/sound/voice/barks/goon/cow.ogg',
		"goon/lizard.ogg" = 'modular_zzplurt/sound/voice/barks/goon/lizard.ogg',
		"goon/pug.ogg" = 'modular_zzplurt/sound/voice/barks/goon/pug.ogg',
		"goon/pugg.ogg" = 'modular_zzplurt/sound/voice/barks/goon/pugg.ogg',
		"goon/radio.ogg" = 'modular_zzplurt/sound/voice/barks/goon/radio.ogg',
		"goon/radio2.ogg" = 'modular_zzplurt/sound/voice/barks/goon/radio2.ogg',
		"goon/radio_ai.ogg" = 'modular_zzplurt/sound/voice/barks/goon/radio_ai.ogg',
		"goon/roach.ogg" = 'modular_zzplurt/sound/voice/barks/goon/roach.ogg',
		"goon/skelly.ogg" = 'modular_zzplurt/sound/voice/barks/goon/skelly.ogg',
		"goon/speak_1.ogg" = 'modular_zzplurt/sound/voice/barks/goon/speak_1.ogg',
		"goon/speak_2.ogg" = 'modular_zzplurt/sound/voice/barks/goon/speak_2.ogg',
		"goon/speak_3.ogg" = 'modular_zzplurt/sound/voice/barks/goon/speak_3.ogg',
		"goon/speak_4.ogg" = 'modular_zzplurt/sound/voice/barks/goon/speak_4.ogg',
		"kazooie/birdwhistle.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/birdwhistle.ogg',
		"kazooie/birdwhistle2.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/birdwhistle2.ogg',
		"kazooie/caw.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/caw.ogg',
		"kazooie/caw2.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/caw2.ogg',
		"kazooie/caw3.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/caw3.ogg',
		"kazooie/dwoop.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/dwoop.ogg',
		"kazooie/ehh.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/ehh.ogg',
		"kazooie/ehh2.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/ehh2.ogg',
		"kazooie/ehh3.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/ehh3.ogg',
		"kazooie/ehh4.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/ehh4.ogg',
		"kazooie/ehh5.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/ehh5.ogg',
		"kazooie/faucet.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/faucet.ogg',
		"kazooie/faucet2.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/faucet2.ogg',
		"kazooie/hoot.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/hoot.ogg',
		"kazooie/ribbit.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/ribbit.ogg',
		"kazooie/tweet.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/tweet.ogg',
		"kazooie/uhm.ogg" = 'modular_zzplurt/sound/voice/barks/kazooie/uhm.ogg',
		"undertale/voice_alphys.ogg" = 'modular_zzplurt/sound/voice/barks/undertale/voice_alphys.ogg',
		"undertale/voice_asgore.ogg" = 'modular_zzplurt/sound/voice/barks/undertale/voice_asgore.ogg',
		"undertale/voice_flowey_1.ogg" = 'modular_zzplurt/sound/voice/barks/undertale/voice_flowey_1.ogg',
		"undertale/voice_flowey_2.ogg" = 'modular_zzplurt/sound/voice/barks/undertale/voice_flowey_2.ogg',
		"undertale/voice_gaster_1.ogg" = 'modular_zzplurt/sound/voice/barks/undertale/voice_gaster_1.ogg',
		"undertale/voice_metta_1.ogg" = 'modular_zzplurt/sound/voice/barks/undertale/voice_metta_1.ogg',
		"undertale/voice_monster1.ogg" = 'modular_zzplurt/sound/voice/barks/undertale/voice_monster1.ogg',
		"undertale/voice_monster2.ogg" = 'modular_zzplurt/sound/voice/barks/undertale/voice_monster2.ogg',
		"undertale/voice_papyrus.ogg" = 'modular_zzplurt/sound/voice/barks/undertale/voice_papyrus.ogg',
		"undertale/voice_ralsei.ogg" = 'modular_zzplurt/sound/voice/barks/undertale/voice_ralsei.ogg',
		"undertale/voice_sans.ogg" = 'modular_zzplurt/sound/voice/barks/undertale/voice_sans.ogg',
		"undertale/voice_susie.ogg" = 'modular_zzplurt/sound/voice/barks/undertale/voice_susie.ogg',
		"undertale/voice_temmie.ogg" = 'modular_zzplurt/sound/voice/barks/undertale/voice_temmie.ogg',
		"undertale/voice_toriel.ogg" = 'modular_zzplurt/sound/voice/barks/undertale/voice_toriel.ogg',
		"undertale/voice_undyne.ogg" = 'modular_zzplurt/sound/voice/barks/undertale/voice_undyne.ogg',
	)
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

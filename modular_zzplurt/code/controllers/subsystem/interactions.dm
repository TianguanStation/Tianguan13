PROCESSING_SUBSYSTEM_DEF(interactions)
	name = "Interactions"
	ss_flags = SS_BACKGROUND | SS_POST_FIRE_TIMING
	init_order = INIT_ORDER_INTERACTIONS
	wait = INTERACTION_SPEED_MIN
	stat_tag = "ACT"
	var/list/datum/interaction/interactions
	VAR_PROTECTED/list/blacklisted_mobs = list(
		/mob/dead,
		/mob/dview,
		/mob/eye/camera,
		/mob/living/basic/pet,
		/mob/living/basic/cockroach,
		/mob/living/basic/butterfly,
		/mob/living/basic/chick,
		/mob/living/basic/chicken,
		/mob/living/basic/cow,
		/mob/living/basic/crab,
		/mob/living/basic/kiwi,
		/mob/living/basic/parrot,
		/mob/living/basic/sloth,
		/mob/living/basic/goat
	)
	VAR_PROTECTED/initialized_blacklist

/datum/controller/subsystem/processing/interactions/Initialize()
	prepare_interactions()
	prepare_blacklisted_mobs()
	var/extra_info = "<font style='transform: translate(0%, -25%);'>↳</font> Loaded [LAZYLEN(interactions)] interactions!"
	to_chat(world, span_boldannounce(extra_info))
	log_config(extra_info)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/processing/interactions/stat_entry(msg)
	msg += "|🖐:[LAZYLEN(interactions)]|"
	msg += "🚫👨:[LAZYLEN(blacklisted_mobs)]"
	return ..()

/datum/controller/subsystem/processing/interactions/proc/prepare_interactions()
	QDEL_LIST_ASSOC_VAL(interactions)
	QDEL_NULL(interactions)
	interactions = list()
	populate_interaction_instances()

/datum/controller/subsystem/processing/interactions/proc/prepare_blacklisted_mobs()
	blacklisted_mobs = typecacheof(blacklisted_mobs)
	initialized_blacklist = TRUE

/datum/controller/subsystem/processing/interactions/proc/is_blacklisted(mob/living/creature)
	if(!creature || !initialized_blacklist)
		return TRUE
	if(is_type_in_typecache(creature, blacklisted_mobs))
		return TRUE
	return FALSE


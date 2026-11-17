/mob/living/carbon/human
	/// Are we currently in combat focus?
	var/combat_focus = FALSE

/mob/living/carbon/human/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/mob_holder/micro)
	RegisterSignal(src, COMSIG_HUMAN_PREFS_APPLIED, PROC_REF(on_preference_applied))

/mob/living/carbon/human/wash(clean_types)
	. = ..()
	for(var/obj/item/bodypart/body_part as anything in bodyparts)
		if(body_part.written_text)
			body_part.written_text = ""

/mob/living/carbon/human/on_entered(datum/source, mob/living/carbon/human/moving)
	. = ..()
	if(istype(moving) && resting && resolve_intent_name(moving) != "help")
		moving.handle_micro_bump_other(src)

// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
#define BADTOUCH_RETALIATE_CHANCE 5
#define BADTOUCH_RETALIATE_DAMAGE 5
#define BADTOUCH_RETALIATE_KNOCKDOWN 20

/mob/living/carbon/proc/can_touch_retaliate()
	// User must be conscious
	if(src.stat != STABLE)
		// Do nothing
		return FALSE

	// User cannot be handcuffed
	if(src.handcuffed)
		return FALSE

	// User cannot be a pacifist
	if(HAS_TRAIT(src, TRAIT_PACIFISM))
		return FALSE

	// User can retaliate
	return TRUE

/mob/living/carbon/proc/do_touch_retaliate(mob/living/carbon/toucher)
	// Cause toucher to scream
	toucher.emote("scream")
	toucher.add_mood_event(QMOOD_BADTOUCH_VICTIM, /datum/mood_event/badtouch_retaliate/victim_bad)

	// Damage amount to apply
	var/retaliate_damage = BADTOUCH_RETALIATE_DAMAGE
	src.add_mood_event(QMOOD_BADTOUCH_ATTACKER, /datum/mood_event/badtouch_retaliate/attacker_bad)

	// Determine toucher's hand
	var/which_hand = BODY_ZONE_PRECISE_L_HAND
	if(!(toucher.active_hand_index % 2))
		which_hand = BODY_ZONE_PRECISE_R_HAND

	// Apply damage to toucher's hand
	toucher.apply_damage(retaliate_damage, BRUTE, which_hand)

	// Log interaction
	log_combat(src, toucher, "retaliates against", "automatically due to a no-touching trait.")

	// Return success
	return TRUE

// Proc to recreate old Distant quirk
/mob/living/carbon/proc/badtouch_retaliate(mob/living/carbon/toucher)
	// Check for activation chance
	if(!prob(BADTOUCH_RETALIATE_CHANCE))
		// Do nothing!
		return

	// Check if this is allowed
	if(!can_touch_retaliate())
		// Do nothing
		return

	// Attempt to retaliate
	src.do_touch_retaliate(toucher)

	// Play attack sound
	playsound(get_turf(src), 'sound/effects/wounds/crack1.ogg', 50, 1, -1)

	// Display message
	toucher.visible_message(span_warning(LANG("mob.ecf5d747b37bfd3c", list(src, toucher, p_them()))), \
		span_boldwarning(LANG("mob.7d0d10eb3f147d9d", list(src))))

	// Drop toucher's held item
	toucher.dropItemToGround(toucher.get_active_held_item())

	// Knock down toucher
	toucher.Knockdown(BADTOUCH_RETALIATE_KNOCKDOWN)

// Bad Touch retaliate mood events
/datum/mood_event/badtouch_retaliate/attacker_bad
	description = span_danger("Someone got hurt because of me.")
	mood_change = -2
	timeout = 2 MINUTES

/datum/mood_event/badtouch_retaliate/victim_bad
	description = span_danger("I shouldn't touch people without permission.")
	mood_change = -2
	timeout = 2 MINUTES

#undef BADTOUCH_RETALIATE_CHANCE
#undef BADTOUCH_RETALIATE_DAMAGE
#undef BADTOUCH_RETALIATE_KNOCKDOWN

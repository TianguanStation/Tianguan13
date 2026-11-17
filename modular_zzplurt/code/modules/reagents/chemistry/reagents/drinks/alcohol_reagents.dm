// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/reagent/consumable/ethanol/lean
	name = "Lean (Brainrot)"
	description = "The choice drink of space-pop stars, composed of soda, cough syrup and candies."
	color =  "#9109ba"
	boozepwr = 0
	metabolization_rate = 1 * REAGENTS_METABOLISM
	quality = DRINK_VERYGOOD
	taste_description = "cough syrup and space-pop music"

/datum/reagent/consumable/ethanol/lean/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	var/mob/living/carbon/human/H = drinker
	var/message = LANG("datum.2728d7fbb6b43508", null)
	drinker.set_dizzy(50)
	drinker.set_jitter(50)
	drinker.set_drugginess(50)
	switch(current_cycle)
		if(1)
			H.say(message)
		if(80 to 100)
			H.adjust_organ_loss(ORGAN_SLOT_LIVER, 1)
			H.adjust_organ_loss(ORGAN_SLOT_BRAIN, 1) // it's cough syrup what'd you expect?
		if(100 to INFINITY)
			H.adjust_organ_loss(ORGAN_SLOT_LIVER, 2)
			H.adjust_organ_loss(ORGAN_SLOT_BRAIN, 2)
			if(!H.undergoing_cardiac_arrest() && H.can_heartattack() && prob(1))
				H.set_heartattack(TRUE)
				if(H.stat == STABLE)
					H.visible_message(span_userdanger(LANG("datum.a043844a532a0911", list(H, H.p_their(), H.p_their())))) // too much lean :(
	..()

/datum/reagent/consumable/ethanol/mech_rider
	name = "Mech Rider"
	description = "Who would even drink this?"
	boozepwr = 65
	color = rgb(111, 127, 63)
	quality = DRINK_GOOD
	taste_description = "the sweat of a certain Mauler pilot"

/datum/reagent/consumable/ethanol/heart_of_gold
	name = "Heart Of Gold"
	description = "The Captain's Ambrosia. Something about it just feels divine."
	boozepwr = 15
	color = "#fc56e6"
	quality = DRINK_FANTASTIC
	taste_description = "a fruit punch-like blend with a little fruity kick at the back of your throat, with an aftertaste of pineapple."

/datum/reagent/consumable/ethanol/moth_in_chief
	name = "Moth in Chief"
	description = "A simple yet elegant drink, inspires confidence in even the most pessimistic of men. The mantle rests well upon your shoulders."
	boozepwr = 50
	color = "#0919be"
	quality = DRINK_FANTASTIC
	taste_description = "fuzz, warmth and comfort"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

//This drink gives the combined benefits of Stimulants, Regenerative Jelly, and Commander and Chief, and a mood buff similar to Copium; at least to an extent.
/datum/reagent/consumable/ethanol/moth_in_chief/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(drinker.mind && HAS_TRAIT(drinker, TRAIT_ROYAL_METABOLISM))
		drinker.heal_bodypart_damage(2,2,2)
		drinker.adjust_brute_loss(-5, updating_health = FALSE)
		drinker.adjust_oxy_loss(-5, updating_health = FALSE)
		drinker.adjust_fire_loss(-5, updating_health = FALSE)
		drinker.adjust_tox_loss(-5, updating_health = FALSE, forced = TRUE) //Heals Toxin Lovers
		//drinker.adjustRadLoss(-25)
		. = 1
	else
		//Commander and Chief Effects, no need to be captain to receive the effect
		drinker.heal_bodypart_damage(2,2,2)
		drinker.adjust_brute_loss(-3.5, updating_health = FALSE)
		drinker.adjust_oxy_loss(-3.5, updating_health = FALSE)
		drinker.adjust_fire_loss(-3.5, updating_health = FALSE)
		drinker.adjust_tox_loss(-3.5, updating_health = FALSE, forced = TRUE) //Heals Toxin Lovers
		//drinker.adjustRadLoss(-25)

	//Stimulant Effects
	drinker.AdjustAllImmobility(-60, FALSE)
	drinker.AdjustUnconscious(-60, FALSE)
	drinker.adjust_stamina_loss(-20*REAGENTS_EFFECT_MULTIPLIER, updating_stamina = FALSE)

/datum/reagent/consumable/ethanol/ionstorm
	name = "Ion Storm"
	description = "A highly chaotic mixture that looks like it may react violently at any moment, but is surprisingly stable"
	color = "#3fd2ff"
	taste_description = "a scorching taste of strong alcohol and good brew going down your throat, making you feel warm inside"
	ph = 6.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	boozepwr = 30
	quality = DRINK_FANTASTIC

/datum/reagent/consumable/ethanol/ionstorm/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.adjust_brute_loss(-0.5, updating_health = FALSE)
	drinker.adjust_fire_loss(-0.5, updating_health = FALSE)
	if (drinker.reagents.has_reagent(/datum/reagent/medicine/epinephrine))
		drinker.adjust_tox_loss(0.25)
	else
		drinker.adjust_oxy_loss(0.25)

/datum/reagent/consumable/ethanol/midnight_tears
	name = "Midnight Tears"
	description = "A reflection of what your Heart feels a weak call for love.\n-Leo Oxto"
	color = "#005DE9"
	taste_description = "the warm feeling of a hug"

/datum/reagent/consumable/ethanol/midnight_tears/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(ishuman(drinker))
		var/mob/living/carbon/human/H = drinker
		if(!H.dna || !H.dna.species)
			return
		var/obj/item/organ/tail/tail = H.get_organ_slot(ORGAN_SLOT_EXTERNAL_TAIL)
		if(tail?.wag_flags & WAG_ABLE)
			H.emote("wag")

/datum/reagent/consumable/ethanol/midnight_sky
	name = "Midnight Sky"
	description = "An escape from all your troubles, may it help you find love and joy.\n-Leo Oxto"
	color = "#060709"
	taste_description = "a calm taste like the calm night"

/datum/reagent/consumable/ethanol/midnight_sky/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.adjust_brute_loss(-0.5)
	drinker.adjust_fire_loss(-0.5)
	. = TRUE

/datum/reagent/consumable/ethanol/midnight_joy
	name = "Midnight Joy"
	description = "Be sure to spread this feeling, for some lack it in their life, be the reason they have a smile on their face.\n-Leo Oxto"
	color = "#FFF393"
	taste_description = "sweet joy"

/datum/reagent/consumable/ethanol/midnight_joy/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if (prob(7))
		drinker.emote("giggle")

//Donator items
/datum/reagent/consumable/ethanol/gem_grape_juice
	name = "Gem Brand Grape Juice"
	description = "The Gem Emporium's take on grape juice, providing a very healthy alternative with a kick described as 'Energizes you like a short rest!'"
	color = "#290029"
	taste_description = "Cool refreshing grapes with a hint of fruit"
	boozepwr = 15
	quality = DRINK_FANTASTIC
	metabolization_rate = 2 * REAGENTS_METABOLISM //0.4u per second
	ph = 4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_HIGH

/datum/reagent/consumable/ethanol/gem_grape_juice/on_mob_metabolize(mob/living/drinker) //Update this if bastion_bourbon is changed.
	. = ..()
	var/heal_points = 10
	if(drinker.health <= 0)
		heal_points = 20 //heal more if we're in softcrit
	var/need_mob_update
	var/heal_amt = min(volume, heal_points) //only heals 1 point of damage per unit on add, for balance reasons
	need_mob_update = drinker.adjust_brute_loss(-heal_amt, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += drinker.adjust_fire_loss(-heal_amt, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += drinker.adjust_tox_loss(-heal_amt, updating_health = FALSE, required_biotype = affected_biotype)
	need_mob_update += drinker.adjust_oxy_loss(-heal_amt, updating_health = FALSE, required_biotype = affected_biotype)
	// heal stamina loss on first metabolization, but only to a max of 20
	need_mob_update += drinker.adjust_stamina_loss(max(-heal_amt * 5, -20), updating_stamina = FALSE, required_biotype = affected_biotype)
	if(need_mob_update)
		drinker.updatehealth()
	drinker.visible_message(span_warning(LANG("datum.e5f2ba5b87351065", list(drinker))), span_notice(LANG("datum.59cacafbea489818", list(LOWER_TEXT(name)))))
	if(!drinker.stat && heal_points == 20) //brought us out of softcrit
		drinker.visible_message(span_danger(LANG("datum.672c82cc0fb62d86", list(drinker, drinker.p_their()))), span_boldnotice(LANG("datum.2ea7d4d3389e7d59", null)))

/datum/reagent/consumable/ethanol/gem_grape_juice/on_mob_life(mob/living/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(drinker.health > 0)
		var/need_mob_update
		need_mob_update = drinker.adjust_brute_loss(-0.25 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += drinker.adjust_fire_loss(-0.25 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += drinker.adjust_tox_loss(-0.125 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
		need_mob_update += drinker.adjust_oxy_loss(-0.75 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
		need_mob_update += drinker.adjust_stamina_loss(-1.25 * metabolization_ratio * seconds_per_tick, updating_stamina = FALSE, required_biotype = affected_biotype)
		if(need_mob_update)
			return UPDATE_MOB_HEALTH

//Donator items
/datum/reagent/consumable/ethanol/gem_grape_soda
	name = "Gem Brand Grape Soda"
	description = "The Gem Emporium's take on grape juice, providing a very healthy alternative with a kick described as 'Energizes you like a short rest!' Now carbonated!"
	color = "#290029"
	taste_description = "Cool refreshing grapes with a hint of fruit"
	boozepwr = 15
	quality = DRINK_FANTASTIC
	metabolization_rate = 2 * REAGENTS_METABOLISM //0.4u per second
	ph = 4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_HIGH

/datum/reagent/consumable/ethanol/gem_grape_soda/on_mob_metabolize(mob/living/drinker) //Update this if bastion_bourbon is changed.
	. = ..()
	var/heal_points = 10
	if(drinker.health <= 0)
		heal_points = 20 //heal more if we're in softcrit
	var/need_mob_update
	var/heal_amt = min(volume, heal_points) //only heals 1 point of damage per unit on add, for balance reasons
	need_mob_update = drinker.adjust_brute_loss(-heal_amt, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += drinker.adjust_fire_loss(-heal_amt, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += drinker.adjust_tox_loss(-heal_amt, updating_health = FALSE, required_biotype = affected_biotype)
	need_mob_update += drinker.adjust_oxy_loss(-heal_amt, updating_health = FALSE, required_biotype = affected_biotype)
	// heal stamina loss on first metabolization, but only to a max of 20
	need_mob_update += drinker.adjust_stamina_loss(max(-heal_amt * 5, -20), updating_stamina = FALSE, required_biotype = affected_biotype)
	if(need_mob_update)
		drinker.updatehealth()
	drinker.visible_message(span_warning(LANG("datum.e5f2ba5b87351065", list(drinker))), span_notice(LANG("datum.59cacafbea489818", list(LOWER_TEXT(name)))))
	if(!drinker.stat && heal_points == 20) //brought us out of softcrit
		drinker.visible_message(span_danger(LANG("datum.672c82cc0fb62d86", list(drinker, drinker.p_their()))), span_boldnotice(LANG("datum.2ea7d4d3389e7d59", null)))

/datum/reagent/consumable/ethanol/gem_grape_soda/on_mob_life(mob/living/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(drinker.health > 0)
		var/need_mob_update
		need_mob_update = drinker.adjust_brute_loss(-0.25 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += drinker.adjust_fire_loss(-0.25 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += drinker.adjust_tox_loss(-0.125 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
		need_mob_update += drinker.adjust_oxy_loss(-0.75 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
		need_mob_update += drinker.adjust_stamina_loss(-1.25 * metabolization_ratio * seconds_per_tick, updating_stamina = FALSE, required_biotype = affected_biotype)
		if(need_mob_update)
			return UPDATE_MOB_HEALTH

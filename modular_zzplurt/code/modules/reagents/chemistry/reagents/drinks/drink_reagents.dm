//Own
/datum/reagent/consumable/wockyslush
	name = "Wocky Slush"
	description = "That thang bleedin' to the-... ya know I mean?"
	color = "#7b60c4" // rgb(123, 96, 196)
	quality = DRINK_VERYGOOD
	taste_description = "cold rainbows"

/datum/reagent/consumable/wockyslush/on_mob_life(mob/living/carbon/M)
	M.emote(pick("twitch","giggle","stare"))
	M.set_drugginess(75)
	M.apply_status_effect(/datum/status_effect/throat_soothed)
	..()

/datum/reagent/consumable/orange_creamsicle
	name = "Orange Creamsicle (Non-alcoholic)"
	description = "A Summer time drink that can be frozen and eaten or drunk from a glass!"
	color = "#ffb46e" // rgb(255, 180, 110)
	taste_description = "ice cream and orange soda"

// Reagent metabolize: Nuka Cola
/datum/reagent/consumable/nuka_cola/on_mob_metabolize(mob/living/affected_mob)
	. = ..()

	// Send signal for adding reagent
	SEND_SIGNAL(affected_mob, COMSIG_REAGENT_METABOLIZE_NUKACOLA)

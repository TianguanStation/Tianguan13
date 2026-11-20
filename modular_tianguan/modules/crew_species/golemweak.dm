/datum/species
	var/tianguan_stars_only = FALSE

/datum/species/golem/weak
	id = SPECIES_GOLEMWEAK
	tianguan_stars_only = TRUE
	mutantstomach = /obj/item/organ/stomach/golem/weak

/obj/item/organ/stomach/golem/weak
	hunger_modifier = 1

/mob/living/carbon/human/species/golem/weak
	race = /datum/species/golem/weak

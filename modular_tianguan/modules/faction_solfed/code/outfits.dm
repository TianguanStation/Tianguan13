/datum/outfit/solfed
	name = "SolFed Official"
	uniform = /obj/item/clothing/under/solfed/officer
	gloves = /obj/item/clothing/gloves/combat
	shoes = /obj/item/clothing/shoes/jackboots
	accessory = /obj/item/clothing/accessory/nova/solfedribbon
	neck = /obj/item/clothing/neck/mantle/solfed
	back = /obj/item/storage/backpack
	ears = /obj/item/radio/headset/headset_solfed/officials
	l_pocket = /obj/item/restraints/handcuffs
	r_pocket = /obj/item/flashlight/seclite
	id = /obj/item/card/id/advanced/solfed
	r_hand = /obj/item/clipboard
	backpack_contents = list(
		/obj/item/stamp/solfed,
		/obj/item/stamp/denied,
		/obj/item/stamp/granted,
	)
	id_trim = /datum/id_trim/solfed/official

/datum/outfit/solfed/post_equip(mob/living/carbon/human/person, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/radio/Radio = person.ears
	if(istype(Radio))
		Radio.set_frequency(FREQ_TERRAGOV)
		Radio.freqlock = TRUE
	var/obj/item/card/id/ID = person.wear_id
	if(istype(ID))
		ID.registered_name = person.real_name
		ID.update_label()
	..()

/datum/outfit/solfed/lowrank
	name = "SolFed Official (Low Rank)"
	uniform = /obj/item/clothing/under/solfed/officer_lowrnk
	accessory = /obj/item/clothing/accessory/nova/acc_medal/neckpin/solfed/official

/datum/outfit/solfed/civil
	name = "SolFed Official (Civil Services)"
	uniform = /obj/item/clothing/under/solfed/official_civil
	accessory = /obj/item/clothing/accessory/nova/acc_medal/neckpin/solfed/official

/datum/outfit/solfed/social
	name = "SolFed Official (Social Services)"
	uniform = /obj/item/clothing/under/solfed/official_social
	accessory = /obj/item/clothing/accessory/nova/acc_medal/neckpin/solfed/official

/datum/outfit/solfed/grand_espatier
	name = "SolFed Espatier Rifleman (GRAND RESPONSE)"

	uniform = /obj/item/clothing/under/solfed/marines
	head = /obj/item/clothing/head/helmet/solfed/mk2
	mask = /obj/item/clothing/mask/gas/alt
	gloves = /obj/item/clothing/gloves/combat
	suit = /obj/item/clothing/suit/armor/vest/sol/marine/mk2
	shoes = /obj/item/clothing/shoes/jackboots
	belt = /obj/item/storage/belt/military/solfed
	neck = /obj/item/clothing/neck/mantle/solfed
	accessory = null

	back = /obj/item/storage/backpack
	glasses = /obj/item/clothing/glasses/sunglasses/solfed
	ears = /obj/item/radio/headset/headset_solfed/espatier
	l_pocket = /obj/item/tank/internals/emergency_oxygen/double
	r_pocket = /obj/item/flashlight/seclite
	id = /obj/item/card/id/advanced/solfed
	r_hand = /obj/item/gun/ballistic/automatic/sol_rifle
	backpack_contents = list(
		/obj/item/tank/internals/emergency_oxygen/double = 1,
		/obj/item/storage/box/handcuffs = 1,
		/obj/item/storage/box/flashbangs = 1,
		/obj/item/storage/box/nri_flares = 1,
		/obj/item/storage/medkit/frontier/stocked = 1,
	)

	id_trim = /datum/id_trim/solfed/espatier

/datum/outfit/solfed/grand_espatier/engineer
	name = "SolFed Espatier Engineer (GRAND RESPONSE)"
	head = /obj/item/clothing/head/helmet/solfed/mk2/engineer
	belt = /obj/item/storage/belt/utility/full/powertools
	mask = /obj/item/clothing/mask/gas/welding/up
	ears = /obj/item/radio/headset/headset_solfed/espatier/engineer
	backpack_contents = list(
		/obj/item/ammo_box/magazine/c40sol_rifle/standard = 4,
		/obj/item/storage/box/nri_flares = 1,
		/obj/item/storage/box/smart_metal_foam = 1,
		/obj/item/stack/sheet/iron/fifty = 1,
		/obj/item/storage/medkit/frontier/stocked = 1,
	)

/datum/outfit/solfed/grand_espatier/engineer/post_equip(mob/living/carbon/human/person, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/ID = person.wear_id
	ID.assignment = "Solfed Espatier Engineer"
	ID.update_label()
	..()

/datum/outfit/solfed/grand_espatier/corpsman
	name = "SolFed Espatier Corpsman (GRAND RESPONSE)"
	head = /obj/item/clothing/head/helmet/solfed/mk2/corpsman
	ears = /obj/item/radio/headset/headset_solfed/espatier/corpsman
	backpack_contents = list(
		/obj/item/storage/medkit/surgery = 1,
		/obj/item/storage/box/nri_flares = 1,
		/obj/item/storage/medkit/tactical = 1,
	)

/datum/outfit/solfed/grand_espatier/corpsman/post_equip(mob/living/carbon/human/person, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/ID = person.wear_id
	ID.assignment = "Solfed Espatier Corpsman"
	ID.update_label()
	..()

/datum/outfit/solfed/grand_espatier/squadleader
	name = "SolFed Espatier Squad Leader (GRAND RESPONSE)"
	head = /obj/item/clothing/head/helmet/solfed/mk2/squadlead
	ears = /obj/item/radio/headset/headset_solfed/espatier/squadleader

	backpack_contents = list(
		/obj/item/storage/medkit/surgery = 1,
		/obj/item/storage/medkit/tactical_lite = 1,
		/obj/item/ammo_box/magazine/c40sol_rifle/standard = 4,
		/obj/item/storage/box/nri_flares = 1,
		/obj/item/binoculars = 1,
	)

/datum/outfit/solfed/grand_espatier/squadleader/post_equip(mob/living/carbon/human/person, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/ID = person.wear_id
	ID.assignment = "Solfed Espatier Squad Leader"
	ID.update_label()
	..()

/// REGULAR ALERT SOLFED RESPONSE (Used for events/admin shenanagins for lesser threats instead of kill everything)
/datum/outfit/solfed/espatier
	name = "SolFed Espatier Rifleman"

	uniform = /obj/item/clothing/under/solfed/marines
	head = /obj/item/clothing/head/helmet/solfed
	mask = /obj/item/clothing/mask/gas/alt
	gloves = /obj/item/clothing/gloves/combat
	suit = /obj/item/clothing/suit/armor/vest/sol/marine
	shoes = /obj/item/clothing/shoes/jackboots
	belt = /obj/item/storage/belt/military/solfed
	neck = /obj/item/clothing/neck/mantle/solfed
	accessory = null

	back = /obj/item/storage/backpack
	glasses = /obj/item/clothing/glasses/sunglasses/solfed
	ears = /obj/item/radio/headset/headset_solfed/espatier
	l_pocket = /obj/item/tank/internals/emergency_oxygen/double
	r_pocket = /obj/item/flashlight/seclite
	id = /obj/item/card/id/advanced/solfed
	r_hand = /obj/item/gun/ballistic/automatic/sol_rifle
	backpack_contents = list(
		/obj/item/tank/internals/emergency_oxygen/double = 1,
		/obj/item/storage/box/handcuffs = 1,
		/obj/item/storage/box/flashbangs = 1,
		/obj/item/storage/box/nri_flares = 1,
		/obj/item/storage/medkit/frontier/stocked = 1,
	)

	id_trim = /datum/id_trim/solfed/espatier

/datum/outfit/solfed/espatier/engineer
	name = "SolFed Espatier Engineer"
	head = /obj/item/clothing/head/helmet/solfed/engineer
	belt = /obj/item/storage/belt/utility/full/powertools
	mask = /obj/item/clothing/mask/gas/welding/up
	ears = /obj/item/radio/headset/headset_solfed/espatier/engineer
	backpack_contents = list(
		/obj/item/ammo_box/magazine/c40sol_rifle/standard = 4,
		/obj/item/storage/box/nri_flares = 1,
		/obj/item/storage/box/smart_metal_foam = 1,
		/obj/item/stack/sheet/iron/fifty = 1,
		/obj/item/storage/medkit/frontier/stocked = 1,
	)

/datum/outfit/solfed/espatier/engineer/post_equip(mob/living/carbon/human/person, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/ID = person.wear_id
	ID.assignment = "Solfed Espatier Engineer"
	ID.update_label()
	..()

/datum/outfit/solfed/espatier/corpsman
	name = "SolFed Espatier Corpsman"
	head = /obj/item/clothing/head/helmet/solfed/corpsman
	ears = /obj/item/radio/headset/headset_solfed/espatier/corpsman
	backpack_contents = list(
		/obj/item/storage/medkit/surgery = 1,
		/obj/item/storage/box/nri_flares = 1,
		/obj/item/storage/medkit/tactical = 1,
	)

/datum/outfit/solfed/espatier/corpsman/post_equip(mob/living/carbon/human/person, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/ID = person.wear_id
	ID.assignment = "Solfed Espatier Corpsman"
	ID.update_label()
	..()

/datum/outfit/solfed/espatier/squadleader
	name = "SolFed Espatier Squad Leader"
	head = /obj/item/clothing/head/helmet/solfed/squadlead
	ears = /obj/item/radio/headset/headset_solfed/espatier/squadleader

	backpack_contents = list(
		/obj/item/storage/medkit/surgery = 1,
		/obj/item/storage/medkit/tactical_lite = 1,
		/obj/item/ammo_box/magazine/c40sol_rifle/standard = 4,
		/obj/item/storage/box/nri_flares = 1,
		/obj/item/binoculars = 1,
	)

/datum/outfit/solfed/espatier/squadleader/post_equip(mob/living/carbon/human/person, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/ID = person.wear_id
	ID.assignment = "Solfed Espatier Squad Leader"
	ID.update_label()
	..()

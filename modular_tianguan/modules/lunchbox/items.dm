/obj/item/storage/lunchbox/packed
	name = "Lunchbox"
	icon = 'modular_tianguan/modules/lunchbox/lunchbox.dmi'
	icon_state = "nanotrasen"
	desc = "A Spessman's best friend, a beautifully packed lunch."

	inhand_icon_state = "toolbox_default"
	lefthand_file = 'icons/mob/inhands/equipment/toolbox_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/toolbox_righthand.dmi'

	material_flags = NONE
	w_class = WEIGHT_CLASS_NORMAL
	obj_flags = CONDUCTS_ELECTRICITY

	force = 5
	throwforce = 5
	throw_speed = 2
	throw_range = 7
	demolition_mod = 1
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*5)
	attack_verb_continuous = list("bonks")
	attack_verb_simple = list("bonks")
	hitsound = 'sound/items/weapons/smash.ogg'
	drop_sound = 'sound/items/handling/toolbox/toolbox_drop.ogg'
	pickup_sound = 'sound/items/handling/toolbox/toolbox_pickup.ogg'
	wound_bonus = 5
	storage_type = /datum/storage/lunchbox

/datum/storage/lunchbox
	open_sound = 'sound/items/handling/toolbox/toolbox_open.ogg'
	rustle_sound = 'sound/items/handling/toolbox/toolbox_rustle.ogg'

/obj/item/storage/lunchbox/packed/Initialize(mapload)
	. = ..()
	atom_storage.set_holdable(list(
		/obj/item/food,
		/obj/item/reagent_containers/cup,
		/obj/item/paper,
		/obj/item/pen,
	))

/obj/item/storage/lunchbox/packed/nt_gold
	icon_state = "nanotrasen_gold"

/obj/item/storage/lunchbox/packed/syndicate
	icon_state = "syndicate"

/obj/item/storage/lunchbox/packed/interdyne
	icon_state = "interdyne"

/obj/item/storage/lunchbox/packed/solfed
	icon_state = "solfed"

/obj/item/storage/lunchbox/packed/gold
	icon_state = "gold"

/obj/item/storage/lunchbox/packed/light
	icon_state = "blank"

/obj/item/storage/lunchbox/packed/dark
	icon_state = "dark"

/obj/item/storage/lunchbox/packed/space
	icon_state = "space"

/obj/item/storage/lunchbox/packed/hearts
	icon_state = "hearts"

/obj/item/storage/lunchbox/packed/heart
	icon_state = "heart"

/obj/item/storage/lunchbox/packed/heart/monster
	icon_state = "heart_monster"

/obj/item/storage/lunchbox/packed/tvtime
	icon_state = "tvtime"

/obj/item/storage/lunchbox/packed/ally
	icon_state = "ally"

/obj/item/storage/lunchbox/packed/ship
	desc = "A Spessman's best friend: a beautifully packed lunch, on the side depicting a ship moving fast around a planet."
	icon_state = "ship"

/obj/item/storage/lunchbox/packed/ammo
	desc = "A well packed ammo box..."
	icon_state = "ammo"

/obj/item/storage/lunchbox/packed/cyber
	icon_state = "cyber"

/obj/item/storage/lunchbox/packed/cyber/dark
	icon_state = "cyber_dark"

/obj/item/storage/lunchbox/packed/lavaland
	icon_state = "lavaland"

/obj/item/storage/lunchbox/packed/rainy
	icon_state = "rainy"

/obj/item/storage/lunchbox/packed/fire_clock
	desc = "A lunchbox with a flaming clock on it... weird... it seems to have the letter 'L' but the rest is scratched out."
	icon_state = "fire_clock"

/obj/item/reagent_containers/cup/soda_cans/thc
	name = "\improper Orchard Green"
	desc = "The taste of a star in liquid form. Spiked with an orange-flavored THC blend to make the day go by a little easier."
	icon = 'modular_tianguan/modules/lunchbox/orchard_green.dmi'
	icon_state = "lemon-lime"
	list_reagents = list(/datum/reagent/consumable/space_cola = 11, /datum/reagent/consumable/orangejuice = 11, /datum/reagent/drug/thc = 8)
	drink_type = SUGAR | FRUIT | JUNKFOOD

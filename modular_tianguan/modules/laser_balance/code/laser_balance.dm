/obj/item/gun/energy/laser/New(loc, ...)
	if(type == /obj/item/gun/energy/laser || type == /obj/item/gun/energy/laser/carbine)
		selfcharge = TRUE
		charge_delay = 15
		projectile_damage_multiplier *= 0.8
	return ..()

/obj/item/gun/energy/laser/proc/filter_tianguan_laser_recipes(list/recipes)
	// Slapcrafting elements share the recipe list across standard carbines.
	var/static/list/filtered_recipes
	filtered_recipes ||= recipes - /datum/crafting_recipe/laser/hellgun
	return filtered_recipes

/datum/crafting_recipe/laser/hellgun
	abstract_type = /datum/crafting_recipe/laser/hellgun

/datum/supply_pack/goody/hell_single
	contains = null

/obj/item/weaponcrafting/gunkit/hellgun/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_QDEL

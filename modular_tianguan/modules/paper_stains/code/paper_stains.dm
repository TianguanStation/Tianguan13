#define LIST_PAPER_BLOOD_STAIN "paper_blood_stain"
#define LIST_PAPER_DIRT_STAIN "paper_dirt_stain"

/obj/item/paper
	/// Cosmetic stains visible when reading the sheet.
	var/blood_stain = FALSE
	var/dirt_stain = FALSE

/obj/item/paper/crumpled/bloody
	blood_stain = TRUE

/obj/item/paper/crumpled/muddy
	dirt_stain = TRUE

/obj/item/paper/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/turf/open/floor/marked_floor = interacting_with
	if(istype(interacting_with, /obj/effect/decal/cleanable/blood))
		blood_stain = TRUE
	else if(istype(marked_floor))
		var/has_blood = locate(/obj/effect/decal/cleanable/blood) in marked_floor
		var/has_dirt = locate(/obj/effect/decal/cleanable/dirt) in marked_floor
		if(!has_blood && !has_dirt)
			return ..()
		blood_stain = blood_stain || has_blood
		dirt_stain = dirt_stain || has_dirt
	else
		return ..()

	update_static_data()
	balloon_alert(user, "paper stained")
	return ITEM_INTERACT_SUCCESS

/obj/item/paper/proc/copy_cosmetic_stains_to(obj/item/paper/destination)
	destination.blood_stain = blood_stain
	destination.dirt_stain = dirt_stain

/obj/item/paper/proc/paper_stain_data()
	return list(
		LIST_PAPER_BLOOD_STAIN = blood_stain,
		LIST_PAPER_DIRT_STAIN = dirt_stain,
	)

/obj/item/paper/proc/read_paper_stain_data(list/data)
	blood_stain = !!data[LIST_PAPER_BLOOD_STAIN]
	dirt_stain = !!data[LIST_PAPER_DIRT_STAIN]

#undef LIST_PAPER_BLOOD_STAIN
#undef LIST_PAPER_DIRT_STAIN

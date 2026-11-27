/// Shared station ore is available only to matrices in the station or mining areas.
/obj/machinery/brm/proc/can_access_ore_pool(mob/user)
	PRIVATE_PROC(TRUE)

	var/area/matrix_area = get_area(src)
	if(istype(matrix_area, /area/station) || istype(matrix_area, /area/mine))
		return TRUE
	if(user)
		balloon_alert(user, LANG("obj.1cd76a5d176c9ee4", null))
	return FALSE

/obj/structure/closet/crate/necropolis/tendril
	desc = "It's watching you closely."

/obj/structure/closet/crate/necropolis/tendril/PopulateContents()
	new loot_to_spawn(src)
	spawned_loot = TRUE

/datum/orderable_item/mining/skeleton_key
	purchase_path = null

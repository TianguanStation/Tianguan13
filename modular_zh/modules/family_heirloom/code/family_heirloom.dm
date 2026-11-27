/mob/living/carbon/human
	/// The existing heirloom while an appearance change rebuilds the character's quirks.
	var/datum/weakref/heirloom_before_quirk_refresh

/datum/quirk/item_quirk/family_heirloom/remove_from_current_holder(quirk_transfer = FALSE)
	var/mob/living/carbon/human/holder = quirk_holder
	if(istype(holder) && quirk_transfer && !cleanup)
		if(heirloom)
			holder.heirloom_before_quirk_refresh = heirloom
	else if(istype(holder) && !quirk_transfer)
		holder.heirloom_before_quirk_refresh = null
	return ..()

/datum/quirk/item_quirk/family_heirloom/add_to_holder(mob/living/new_holder, quirk_transfer = FALSE, client/client_source, unique = TRUE, announce = TRUE)
	if(!item_giving_paused || !ishuman(new_holder))
		return ..()

	var/mob/living/carbon/human/holder = new_holder
	var/obj/item/bound_item = holder.heirloom_before_quirk_refresh?.resolve()
	var/datum/component/heirloom/binding = bound_item?.GetComponent(/datum/component/heirloom)
	if(binding && binding.owner == holder.mind)
		heirloom = holder.heirloom_before_quirk_refresh
	holder.heirloom_before_quirk_refresh = null

	// A preferences refresh can restore the existing binding without creating a new item.
	. = ..(new_holder, quirk_transfer = TRUE, client_source = client_source, unique = unique, announce = announce)
	if(. && !heirloom)
		mark_action = new /datum/action/mark_family_heirloom(src)
		mark_action.Grant(holder)

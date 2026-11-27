
/datum/quirk
	/// special case logic for quirks that don't quite handle being transferred properly
	var/cleanup = TRUE

/// Remove any quirks that the client's prefs do not have, and apply any new ones
/datum/controller/subsystem/processing/quirks/proc/OverrideQuirks(mob/living/user, client/applied_client, spawn_items = TRUE)
	apply_quirk_overrides(user, applied_client.prefs.all_quirks, applied_client, spawn_items)

/datum/controller/subsystem/processing/quirks/proc/apply_quirk_overrides(mob/living/user, list/required_quirks, client/applied_client, spawn_items = TRUE)
	// A quirk present in both character slots must protect the holder even while being reapplied.
	var/keep_undeath = HAS_TRAIT_FROM(user, TRAIT_NODEATH, TRAIT_UNDEAD) && (/datum/quirk/undead::name in required_quirks)
	if(keep_undeath)
		ADD_TRAIT(user, TRAIT_NODEATH, REF(src))

	var/list/present_quirks = list()
	for(var/datum/quirk/quirk in user.quirks)
		present_quirks[quirk.name] = TRUE
		quirk.cleanup = FALSE
		quirk.remove_from_current_holder(TRUE)

	for(var/quirk_name in required_quirks)
		var/existing_quirk = present_quirks[quirk_name]
		var/quirk_type = quirks[quirk_name]
		var/datum/quirk/quirk = new quirk_type
		if (!spawn_items)
			quirk.set_item_giving_paused(TRUE)
		quirk.add_to_holder(user, existing_quirk, applied_client)
		quirk.set_item_giving_paused(FALSE)
	if(keep_undeath)
		REMOVE_TRAIT(user, TRAIT_NODEATH, REF(src))

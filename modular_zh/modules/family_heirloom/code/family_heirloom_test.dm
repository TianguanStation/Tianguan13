/datum/unit_test/family_heirloom_quirk_refresh/Run()
	var/mob/living/carbon/human/player = allocate(/mob/living/carbon/human/consistent)
	player.mind_initialize()
	var/obj/item/original = allocate(/obj/item/dice/d20)
	var/datum/component/heirloom/binding = original.AddComponent(/datum/component/heirloom, player.mind, "Test")

	var/datum/quirk/item_quirk/family_heirloom/initial_quirk = allocate(/datum/quirk/item_quirk/family_heirloom)
	initial_quirk.add_to_holder(player, quirk_transfer = TRUE)
	initial_quirk.heirloom = WEAKREF(original)
	initial_quirk.cleanup = FALSE
	initial_quirk.remove_from_current_holder(quirk_transfer = TRUE)

	var/datum/quirk/item_quirk/family_heirloom/refreshed = allocate(/datum/quirk/item_quirk/family_heirloom)
	refreshed.set_item_giving_paused(TRUE)
	refreshed.add_to_holder(player)
	refreshed.set_item_giving_paused(FALSE)
	TEST_ASSERT_EQUAL(refreshed.heirloom?.resolve(), original, "A refresh must retain the original item.")
	TEST_ASSERT_EQUAL(original.GetComponent(/datum/component/heirloom), binding, "The original binding must be reused.")
	TEST_ASSERT_NULL(refreshed.mark_action, "A player with a bound heirloom should not need to rebind it.")

	refreshed.cleanup = FALSE
	refreshed.remove_from_current_holder(quirk_transfer = TRUE)
	qdel(original)
	var/datum/quirk/item_quirk/family_heirloom/unbound = allocate(/datum/quirk/item_quirk/family_heirloom)
	unbound.set_item_giving_paused(TRUE)
	unbound.add_to_holder(player)
	TEST_ASSERT_NULL(unbound.heirloom, "A refresh must not spawn a replacement for a destroyed heirloom.")
	TEST_ASSERT_NOTNULL(unbound.mark_action, "A player without an existing heirloom should be able to choose one.")

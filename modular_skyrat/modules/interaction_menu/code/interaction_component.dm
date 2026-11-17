// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md

/datum/component/interactable
	/// A hard reference to the parent
	var/mob/living/self = null 	// SPLURT EDIT - INTERACTIONS - All mobs should be interactable
	/// A list of interactions that the user can engage in.
	var/list/datum/interaction/interactions
	var/interact_last = 0
	var/interact_next = 0

/datum/component/interactable/Initialize(...)
	if(QDELETED(parent))
		qdel(src)
		return

	if(!isliving(parent)) // SPLURT EDIT - INTERACTIONS - All mobs should be interactable
		return COMPONENT_INCOMPATIBLE

	self = parent

	build_interactions_list()

/datum/component/interactable/proc/build_interactions_list()
	interactions = list()
	//SPLURT EDIT CHANGE BEGIN - INTERACTIONS SUBSYSTEM - Changed to use SSinteractions
	if(!SSinteractions)
		return // Can't continue, no subsystem
	for(var/iterating_interaction_id in SSinteractions.interactions)
		var/datum/interaction/interaction = SSinteractions.interactions[iterating_interaction_id]
		interactions.Add(interaction)

/datum/component/interactable/RegisterWithParent()
	RegisterSignal(parent, COMSIG_CLICK_CTRL_SHIFT, PROC_REF(open_interaction_menu))

/datum/component/interactable/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_CLICK_CTRL_SHIFT)

/datum/component/interactable/Destroy(force, silent)
	self = null
	interactions = null
	return ..()

/datum/component/interactable/proc/open_interaction_menu(datum/source, mob/user)
	if(!isliving(user)) // SPLURT EDIT - INTERACTIONS - All mobs should be interactable
		return
	build_interactions_list()
	ui_interact(user)

/datum/component/interactable/proc/can_interact(datum/interaction/interaction, mob/living/target) 	// SPLURT EDIT - INTERACTIONS - All mobs should be interactable
	if(!interaction.allow_act(target, self))
		return FALSE
	if(!interaction.distance_allowed && !target.Adjacent(self))
		if(target.loc != self.loc || isturf(target.loc)) //SPLURT ADDITION - Makes sure you can interact with other people in the same container.
			return FALSE
	if(interaction.category == INTERACTION_CAT_HIDE)
		return FALSE
	if(self == target && interaction.usage == INTERACTION_OTHER)
		return FALSE
	if(self != target && interaction.usage == INTERACTION_SELF)
		return FALSE
	return TRUE

/// UI Control
/datum/component/interactable/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "InteractionPanel")
		ui.open()

/datum/component/interactable/ui_status(mob/user, datum/ui_state/state)
	if(!isliving(user)) // SPLURT EDIT - INTERACTIONS - All mobs should be interactable
		return UI_CLOSE

	return UI_INTERACTIVE // This UI is always interactive as we handle distance flags via can_interact

/datum/component/interactable/ui_data(mob/user)
	var/list/data = list()
	var/list/descriptions = list()
	var/list/categories = list()
	var/list/display_categories = list()
	var/list/colors = list()
	var/datum/component/interactable/user_interaction_component = user.GetComponent(/datum/component/interactable)

	for(var/datum/interaction/interaction in interactions)
		if(!can_interact(interaction, user))
			continue
		if(!categories[interaction.category])
			categories[interaction.category] = list(interaction.name)
		else
			categories[interaction.category] += interaction.name
			var/list/sorted_category = sort_list(categories[interaction.category])
			categories[interaction.category] = sorted_category
		descriptions[interaction.name] = interaction.description
		colors[interaction.name] = interaction.color

	data["descriptions"] = descriptions
	data["colors"] = colors
	for(var/category in categories)
		display_categories += category
	data["categories"] = sort_list(display_categories)
	data["ref_user"] = REF(user)
	data["ref_self"] = REF(self)
	data["self"] = self.name
	data["block_interact"] = user_interaction_component?.interact_next >= world.time
	data["interactions"] = categories
	return data

/**
 *  Takes the organ slot name, along with a target and source, along with the item on the target that the source can potentially interact with.
 *  If the source can't interact with said slot, or there is no item in the first place, it'll set the icon to null to indicate that TGUI should put a placeholder sprite.
 *
 * Arguments:
 * * name - The name of slot to check and return inside the generated list.
 * * target - The mob that's being interacted with.
 * * source - The mob that's interacting.
 * * item - The item that's currently inside said slot. Can be null.
 */
/datum/component/interactable/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	if(!isliving(usr))
		return

	switch(action)
		if("interact")
			var/interaction_id = params["interaction"]
			var/mob/living/source = locate(params["userref"])
			var/mob/living/target = locate(params["selfref"])
			if(!interaction_id || !source || !target)
				return FALSE

			var/datum/interaction/selected_interaction
			for(var/datum/interaction/interaction in interactions)
				if(interaction.name == interaction_id)
					selected_interaction = interaction
					break

			if(!selected_interaction)
				return FALSE

			if(!can_interact(selected_interaction, source))
				return FALSE

			var/datum/component/interactable/interaction_component = source.GetComponent(/datum/component/interactable)
			if(interaction_component?.interact_next >= world.time)
				return FALSE

			selected_interaction.act(source, target)
			if(interaction_component)
				interaction_component.interact_last = world.time
				interaction_component.interact_next = interaction_component.interact_last + INTERACTION_COOLDOWN
			return TRUE

	message_admins("Unhandled interaction '[params["interaction"]]'. Inform coders.")


// THIS IS A TIANGUAN MODULE FILE
// Shared base datum for client-bound admin TGUI panels with active-window registries.

/datum/tianguan_admin_ui
	var/client/holder
	var/interface_name
	var/required_rights = R_ADMIN

/datum/tianguan_admin_ui/New(user)
	if(istype(user, /client))
		holder = user
	else
		var/mob/user_mob = user
		holder = user_mob?.client

/datum/tianguan_admin_ui/Destroy()
	unregister_active_ui()
	clear_client_reference()
	holder = null
	return ..()

/// Returns the global active list holding open instances of this UI type.
/datum/tianguan_admin_ui/proc/get_active_ui_list()
	return null

/// Clears any /client slot reference pointing back to src during Destroy().
/datum/tianguan_admin_ui/proc/clear_client_reference()
	return

/// Called right before opening/updating the TGUI window.
/datum/tianguan_admin_ui/proc/on_ui_open(mob/user)
	return

/datum/tianguan_admin_ui/proc/register_active_ui()
	var/list/active = get_active_ui_list()
	if(islist(active))
		active |= src

/datum/tianguan_admin_ui/proc/unregister_active_ui()
	var/list/active = get_active_ui_list()
	if(islist(active))
		active -= src

/datum/tianguan_admin_ui/ui_state(mob/user)
	return ADMIN_STATE(required_rights)

/datum/tianguan_admin_ui/ui_close(mob/user)
	unregister_active_ui()

/datum/tianguan_admin_ui/ui_interact(mob/user, datum/tgui/ui)
	register_active_ui()
	on_ui_open(user)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, interface_name)
		ui.open()

/// Refreshes every open UI instance in the given active list.
/proc/tianguan_update_ui_list(list/active_uis)
	for(var/datum/ui_datum as anything in active_uis)
		SStgui.update_uis(ui_datum)

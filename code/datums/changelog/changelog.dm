/datum/changelog
	var/static/list/changelog_items = list()

/datum/changelog/ui_state()
	return GLOB.always_state

/datum/changelog/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "BubberChangelog") // BUBBER EDIT CHANGE: Changelog 2: Original: ui = new(user, src, "Changelog")
		ui.open()

/datum/changelog/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(action == "get_month")
		var/date = params["date"]
		if(!istext(date) || !(date in changelog_dates()))
			return
		var/datum/asset/changelog_item/changelog_item = changelog_items[date]
		if (!changelog_item)
			changelog_item = new /datum/asset/changelog_item(date)
			changelog_items[date] = changelog_item
		return ui.send_asset(changelog_item)

// BUBBER EDIT CHANGE BEGIN: Changelog 2
/datum/changelog/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/server_logos)
	)
// BUBBER EDIT CHANGE END: Changelog 2

/datum/changelog/ui_static_data()
	return list("dates" = changelog_dates())

/datum/changelog/proc/changelog_dates()
	var/list/dates = list()
	var/list/files = flist("html/changelogs/archive/") | flist("html/changelogs/bubber_archive/") | flist("html/changelogs/splurt_archive/")
	for(var/filename in sort_list(files))
		if(copytext(filename, -4) == ".yml")
			dates.Insert(1, copytext(filename, 1, -4))
	return dates

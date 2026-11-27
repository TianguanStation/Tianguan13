// The in-game changelog serves the localization and TianGuan archives as separate tabs.
// Entries are compiled with tools/i18n/compile-localization-changelog.py.
//
// Also serves machine translations of upstream's own changelog (tools/i18n/changelog-mt.ts, run at upstream sync):
// one "original text -> translation" table per month, applied by the TGUI changelog to upstream's untouched archive.

#define LOCALIZATION_CHANGELOG_ARCHIVE "html/changelogs/localization/archive/"
#define TIANGUAN_CHANGELOG_ARCHIVE "html/changelogs/tianguan/archive/"
#define UPSTREAM_CHANGELOG_TRANSLATIONS "html/changelogs/localization/upstream/"

/datum/changelog
	/// Archive directories by changelog source
	var/static/list/compiled_changelog_archives = list(
		"localization" = LOCALIZATION_CHANGELOG_ARCHIVE,
		"tianguan" = TIANGUAN_CHANGELOG_ARCHIVE,
	)
	/// Compiled changelog assets already registered, keyed by source and month
	var/static/list/compiled_changelog_items = list()
	/// Upstream changelog translation assets already registered, keyed by month ("YYYY-MM")
	var/static/list/changelog_translation_items = list()

/// Months with a compiled changelog for this source, newest first
/datum/changelog/proc/compiled_changelog_dates(source)
	var/list/dates = list()
	var/archive_dir = compiled_changelog_archives[source]
	if(!archive_dir)
		return dates
	for(var/archive_file in sort_list(flist(archive_dir)))
		if(copytext(archive_file, -4) != ".yml")
			continue
		dates.Insert(1, copytext(archive_file, 1, -4))
	return dates

/// Directory holding the upstream changelog translations for the server locale
/datum/changelog/proc/changelog_translation_dir()
	var/locale = GLOB.i18n_server_locale
	if(!istext(locale) || !length(locale))
		return null
	return UPSTREAM_CHANGELOG_TRANSLATIONS + SANITIZE_FILENAME(locale) + "/"

/// Months of upstream's changelog translated into the server locale, newest first
/datum/changelog/proc/translated_changelog_dates()
	var/list/dates = list()
	var/translation_dir = changelog_translation_dir()
	if(!translation_dir)
		return dates
	for(var/translation_file in sort_list(flist(translation_dir)))
		if(copytext(translation_file, -5) != ".json")
			continue
		dates.Insert(1, copytext(translation_file, 1, -5))
	return dates

/datum/changelog/ui_static_data()
	. = ..()
	.["localization_dates"] = compiled_changelog_dates("localization")
	.["tianguan_dates"] = compiled_changelog_dates("tianguan")
	.["translated_dates"] = translated_changelog_dates()

/datum/changelog/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("get_month")
			// Upstream has already sent the month itself; add its translation when we have one.
			if(!ui || ui.status != UI_INTERACTIVE)
				return
			var/datum/asset/simple/changelog_month/translation_item = get_changelog_translation_item(params["date"])
			if(translation_item)
				ui.send_asset(translation_item)
		if("get_localization_month", "get_tianguan_month")
			if(.)
				return
			var/source = action == "get_tianguan_month" ? "tianguan" : "localization"
			var/datum/asset/simple/changelog_month/changelog_item = get_compiled_changelog_item(source, params["date"])
			if(changelog_item)
				return ui.send_asset(changelog_item)

/// Returns the asset for a listed month in the requested archive, registering it on first use.
/datum/changelog/proc/get_compiled_changelog_item(source, date)
	// The date comes from the client and ends up in a file path, so only accept a listed month.
	if(!istext(date) || !(date in compiled_changelog_dates(source)))
		return null
	var/filename = "[source]-[date].yml"
	var/datum/asset/simple/changelog_month/changelog_item = compiled_changelog_items[filename]
	if(!changelog_item)
		changelog_item = new /datum/asset/simple/changelog_month(filename, file(compiled_changelog_archives[source] + "[date].yml"))
		compiled_changelog_items[filename] = changelog_item
	return changelog_item

/// Returns the translation asset for an upstream changelog month, registering it on first use, or null for anything we don't list.
/datum/changelog/proc/get_changelog_translation_item(date)
	// The date comes from the client and ends up in a file path, so only accept a month we list ourselves.
	if(!istext(date) || !(date in translated_changelog_dates()))
		return null
	var/datum/asset/simple/changelog_month/translation_item = changelog_translation_items[date]
	if(!translation_item)
		translation_item = new /datum/asset/simple/changelog_month("changelog-translation-[date].json", file(changelog_translation_dir() + "[date].json"))
		changelog_translation_items[date] = translation_item
	return translation_item

/// A dynamically registered, single-file month. The SPLURT upstream asset sends three archives.
/datum/asset/simple/changelog_month
	abstract_type = /datum/asset/simple/changelog_month

/datum/asset/simple/changelog_month/New(filename, resource)
	// Each month is cached by its date, outside the type-based asset singleton registry.
	assets = list()
	assets[filename] = resource
	register()

#undef LOCALIZATION_CHANGELOG_ARCHIVE
#undef TIANGUAN_CHANGELOG_ARCHIVE
#undef UPSTREAM_CHANGELOG_TRANSLATIONS

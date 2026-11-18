/datum/asset/changelog_item/add_archives(filename)
	..()
	add_month_file("splurt_[filename]", "html/changelogs/splurt_archive/[filename]")

/datum/techweb_node/hud/New()
	var/list/extra_design_ids = list(
		"nifsoft_storage_concealment",
	)
	LAZYADD(design_ids, extra_design_ids)
	. = ..()

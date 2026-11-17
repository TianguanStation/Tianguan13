
/datum/techweb_node/cyber/cyber_organs_upgraded/New()
	var/list/extra_designs = list(
		"cybernetic_brain_cortical"
	)
	LAZYADD(design_ids, extra_designs)
	. = ..()

/datum/material/bluespace
	tradable = FALSE

/datum/export/material/market/bscrystal
	abstract_type = /datum/export/material/market/bscrystal

/datum/export/material/bscrystal
	cost = 300
	k_elasticity = 0
	message = "of bluespace crystals"
	material_id = /datum/material/bluespace
	export_types = list(
		/obj/item/stack/sheet/bluespace_crystal,
		/obj/item/stack/ore/bluespace_crystal,
	)
	use_shared_exports = FALSE

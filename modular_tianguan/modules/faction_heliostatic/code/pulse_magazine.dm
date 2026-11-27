/obj/item/ammo_box/magazine/pulse
	name = "\improper Žaibas rifle pulse magazine"
	desc = "A restricted-capacity magazine containing pulse energy cells for the Žaibas rifle. Holds three crystalline plasma plugs, each good for fifteen shots. \
			The casing bears a stamped 'SD-3C' mark (Szot Dynamica 3-Plug Civilian) alongside SolFed compliance certifications."
	icon = 'modular_tianguan/modules/faction_heliostatic/assets/modules/modular_weapons/icons/obj/company_and_or_faction_based/szot_dynamica/ammo.dmi'
	icon_state = "zaibas_mag"
	ammo_type = /obj/item/ammo_casing/pulse
	caliber = "pulse"
	max_ammo = 3
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	///Purely flavor short designation that appears in the magazines' notes.
	var/magazine_designation = "'SD-3C'"
	///Lore blurb that appears on examining twice.
	var/lore_blurb = "The 'SD-3C' magazine exists solely because of Carwo Defense Systems' lobbying. While Coalition-designed Žaibas rifles typically use eight-plug military mags (120 pulses total), \
		Carwo pushed SolFed legislators to restrict plug counts — not realizing Szot Dynamica's plasma plugs each hold fifteen pulses. The result? This 'compliant' 3-plug magazine still delivers \
		45 pulses — still outclassing Carwo's own ballistic rifles in sheer volume of fire.<br><br>\
		Coalition armorers mocked the legislation as 'counting fuel cans instead of measuring gas,' while Sakhno Concern quietly released a 'civilian maintenance manual' suggesting users \
		'store plugs in thermally shielded containers' (read: military-grade magazines with the capacity indicators filed off). The included compliance certificate even lists pulse counts as \
		'auxiliary discharge cycles' — a technicality that forced Carwo to admit they'd misunderstood the technology they were trying to ban.<br><br>\
		A tiny etching inside the housing reads: <i>'For optimal performance, consult Xhihao Light Arms catalog page 47.'</i>—\
		a reference to their unmodified eight-plug magazines, conveniently classified as 'industrial capacitors.'"

/obj/item/ammo_box/magazine/pulse/examine_more(mob/user)
	. = ..()
	. += "[lore_blurb]"

/obj/item/ammo_box/magazine/pulse/examine(mob/user)
	. = ..()
	if(length(stored_ammo))
		var/obj/item/ammo_casing/pulse/top_cell = get_round()
		if(istype(top_cell))
			. += span_notice(LANG("obj.e4a5de6c48df0eb1", list(top_cell.remaining_uses, top_cell.max_uses)))

/obj/item/ammo_box/magazine/pulse/add_notes_box()
	var/list/readout = list()
	var/obj/item/ammo_casing/pulse/sample_casing = ammo_type

	// Display magazine capacity info
	readout += LANG("obj.1f5c34bfea588527", list(span_warning(magazine_designation), span_warning("[max_ammo] plasma plugs"), span_warning("[initial(sample_casing.max_uses)] pulses")))
	readout += LANG("obj.b982c99647b82171", list(span_warning("[max_ammo * initial(sample_casing.max_uses)] pulses")))

	// Get actual round info if available
	var/obj/item/ammo_casing/mag_ammo = get_and_shuffle_round()
	if(istype(mag_ammo))
		readout += LANG("obj.65aac1b5abce675a", list(mag_ammo.add_notes_ammo()))

	return readout.Join("\n")

/obj/item/ammo_box/magazine/pulse/ammo_count(countempties = TRUE)
	if(countempties) // If we're counting empty casings too (like for chambering)
		return length(stored_ammo)
	// Otherwise use the original behavior
	var/boolets = 0
	for(var/obj/item/ammo_casing/pulse/bullet in stored_ammo)
		if(bullet.remaining_uses > 0)
			boolets++
	return boolets

/obj/item/ammo_box/magazine/pulse/top_off(load_type, starting=FALSE)
	. = ..(load_type, starting = FALSE)

/obj/item/ammo_box/magazine/pulse/spawns_empty
	start_empty = TRUE

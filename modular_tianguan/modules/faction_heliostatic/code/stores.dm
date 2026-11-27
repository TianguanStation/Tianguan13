/obj/item/disk/design_disk/limbs/lizard
	name = "Lizard Organ Design Disk"
	limb_designs = list(/datum/design/lizard_tail, /datum/design/lizard_tongue)

/obj/item/disk/design_disk/limbs/plasmaman
	name = "Plasmaman Organ Design Disk"
	limb_designs = list(/datum/design/plasmaman_stomach, /datum/design/plasmaman_liver, /datum/design/plasmaman_lungs, /datum/design/plasmaman_tongue)

/obj/item/disk/design_disk/limbs/ethereal
	name = "Ethereal Organ Design Disk"
	limb_designs = list(/datum/design/ethereal_stomach, /datum/design/ethereal_tongue, /datum/design/ethereal_lungs)

/obj/item/melee/baton/security/stun_gun
	name = "\improper Kopřiva stun gun"
	desc = "A compact, remote-sized stun gun for deterring people with. \
		While its voltage and size leave it unable to knock someone down, \
		its best means of use is deterrence or dissuasion - give them a reason to back off, or \
		hit a troublemaker and hope they don't follow."
		// gotta poke some good writers with a stick so they can cobble a better description together
	desc_controls = "Left click to stun, right click to 'harm'."
	icon = 'modular_tianguan/modules/faction_heliostatic/assets/novaya/stun_gun.dmi'
	icon_state = "stun_gun"
	lefthand_file = 'modular_tianguan/modules/faction_heliostatic/assets/novaya/stun_gun_left.dmi'
	righthand_file = 'modular_tianguan/modules/faction_heliostatic/assets/novaya/stun_gun_right.dmi'
	inhand_icon_state = "stun_gun"
	base_icon_state = "stun_gun"
	worn_icon = 'icons/mob/clothing/belt.dmi'
	worn_icon_state = "seclite"
	icon_angle = 0
	force = 10
	w_class = WEIGHT_CLASS_SMALL
	wound_bonus = 0
	attack_verb_continuous = list("thrusts")
	attack_verb_simple = list("thrust")
	throwforce = 0
	force_say_chance = 25
	stamina_damage = 25
	armour_type_against_stun = ENERGY
	knockdown_time = null
	clumsy_knockdown_time = null
	cooldown = 0.7 SECONDS
	light_color = LIGHT_COLOR_ELECTRIC_CYAN
	light_power = 0.25

	throw_stun_chance = 15
	cell_hit_cost = STANDARD_CELL_CHARGE*0.75
	convertible = FALSE
	active_changes_inhand = TRUE

/obj/item/melee/baton/security/stun_gun/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_ZCM)

/obj/item/melee/baton/security/stun_gun/baton_effect(mob/living/target, mob/living/user, list/modifiers, stun_override)
	if(!deductcharge(cell_hit_cost))
		return FALSE
	target.set_jitter_if_lower(5 SECONDS* (HAS_TRAIT(target, TRAIT_BATON_RESISTANCE) ? 0.5 : 1))
	target.set_confusion_if_lower(4 SECONDS* (HAS_TRAIT(target, TRAIT_BATON_RESISTANCE) ? 0.5 : 1))
	target.set_stutter_if_lower(3 SECONDS* (HAS_TRAIT(target, TRAIT_BATON_RESISTANCE) ? 0.5 : 1))
	target.set_eye_blur_if_lower(5 SECONDS* (HAS_TRAIT(target, TRAIT_BATON_RESISTANCE) ? 0.5 : 1))
	var/armour_block = target.run_armor_check(null, armour_type_against_stun, null, null, stun_armour_penetration)
	target.apply_damage(stamina_damage, STAMINA, blocked = armour_block)
	SEND_SIGNAL(target, COMSIG_LIVING_MINOR_SHOCK)
	stun_override = FALSE

/obj/item/melee/baton/security/stun_gun/add_deep_lore()
	AddElement(/datum/element/examine_lore, \
		lore_hint = span_notice("You can [EXAMINE_HINT("look closer")] to learn a little more about [src]."), \
		lore = "The 'Kopřiva' is the current flagship model of a stun gun standard-issued to coreworld Zvirdnyn officers \
			- as you would not expect any more than an occasional rare drunkard coming for you around the capital planets. \
			Its newly integrated neural receptors allow for unprecedented level of pacification through pain responses to one's brain, \
			resulting in a conclusion to a confrontation that couldn't even start. \
			The humanity of directly sparking people's CNS is dubious at best; but suspects are yet to fall limp \
			after experiencing its sting, which makes it seem a little more humane than Nanotrasen's up-charged cattle prods." \
	)

/obj/item/melee/baton/security/stun_gun/loaded
	preload_cell_type = /obj/item/stock_parts/power_store/cell/high


/obj/item/melee/baton/security/stun_gun/stun_knife
	name = "makeshift stun knife"
	desc = "A Kopřiva stun gun haphazardly attached to a standard survival knife, making an odd combination of a lethally non-lethal weapon. \
		Not the best for standing your ground, but it's better then nothing!"
	desc_controls = "Left click to stun, right click to slash."
	icon = 'modular_tianguan/modules/faction_heliostatic/assets/novaya/stun_knife.dmi'
	icon_state = "stun_knife"
	lefthand_file = 'modular_tianguan/modules/faction_heliostatic/assets/novaya/stun_knife_left.dmi'
	righthand_file = 'modular_tianguan/modules/faction_heliostatic/assets/novaya/stun_knife_right.dmi'
	inhand_icon_state = "stun_knife"
	base_icon_state = "stun_knife"
	sharpness = SHARP_EDGED
	force = 15
	throwforce = 15
	wound_bonus = 5
	exposed_wound_bonus = 15
	embed_type = /datum/embedding/combat_knife/weak
	tool_behaviour = TOOL_KNIFE
	attack_verb_continuous = list("glances", "slices", "strikes")
	attack_verb_simple = list("slash", "slice", "dice", "cut")
	var/list/alt_continuous = list("stabs", "pierces", "shanks")
	var/list/alt_simple = list("stab", "pierce", "shank")

/obj/item/melee/baton/security/stun_gun/stun_knife/proc/make_stabby()
	AddComponent(/datum/component/alternative_sharpness, SHARP_POINTY, alt_continuous, alt_simple)

/obj/item/melee/baton/security/stun_gun/stun_knife/loaded
	preload_cell_type = /obj/item/stock_parts/power_store/cell/high
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 6)

/datum/crafting_recipe/knife_and_shocky
	name = "Makeshift Stunknife"
	desc = "Cobble together an abomination against both man and god."
	result = /obj/item/melee/baton/security/stun_gun/stun_knife/loaded // Only because crafting it is going to be a bit of a hassle already, and it will absolutely eat the cell your stun gun might've had in it.
	reqs = list(
		/obj/item/knife/combat/survival = 1,
		/obj/item/melee/baton/security/stun_gun = 1,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 10 SECONDS
	category = CAT_WEAPON_MELEE

/obj/machinery/shower/infinite
	has_water_reclaimer = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/shower/infinite, (-16))


/obj/item/ammo_casing/c27_54cesarzowa/rubber
	name = ".27-54 Cesarzowa rubber bullet casing"
	desc = "A purple-bodied caseless cartridge home to a small projectile with a flat rubber tip."
	icon = 'modular_tianguan/modules/faction_heliostatic/assets/novaya/szot_ammo.dmi'

	icon_state = "27-54cesarzowa_rubber"
	projectile_type = /obj/projectile/bullet/c27_54cesarzowa/rubber

/obj/projectile/bullet/c27_54cesarzowa/rubber
	name = ".27-54 Cesarzowa rubber bullet"
	stamina = 18
	damage = 5
	armour_penetration = 0
	weak_against_armour = TRUE
	wound_bonus = -30
	exposed_wound_bonus = -10
	sharpness = NONE

/obj/item/ammo_box/c27_54cesarzowa/rubber
	name = "ammo box (.27-54 Cesarzowa rubber)"
	desc = "A box of .27-54 Cesarzowa rubber pistol rounds, holds twenty four cartridges."
	icon = 'modular_tianguan/modules/faction_heliostatic/assets/novaya/szot_ammo.dmi'

	icon_state = "27-54cesarzowa_box_rubber"

	ammo_type = /obj/item/ammo_casing/c27_54cesarzowa/rubber
	max_ammo = 24

/obj/item/ammo_box/c310_cargo_box/rubber
	name = "ammo box (.310 Strilka rubber)"
	desc = "A box of .310 Strilka rubber rifle rounds, holds ten cartridges."
	icon = 'modular_tianguan/modules/faction_heliostatic/assets/novaya/szot_ammo.dmi'

	icon_state = "310_box_rubber"

	ammo_type = /obj/item/ammo_casing/strilka310/rubber

/obj/item/ammo_casing/strilka310/rubber
	name = ".310 Strilka rubber bullet casing"
	desc = "A .310 rubber bullet casing. Casing is a bit of a fib, there isn't one.\
		<br><br>\
		<i>RUBBER: Less than lethal ammo. Deals both stamina damage and regular damage.</i>"

	icon = 'modular_tianguan/modules/faction_heliostatic/assets/novaya/xhihao_ammo.dmi'
	icon_state = "310-casing-rubber"

	projectile_type = /obj/projectile/bullet/strilka310/rubber
	harmful = FALSE
	custom_materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT)

/obj/projectile/bullet/strilka310/rubber
	name = ".310 rubber bullet"
	damage = 15
	stamina = 35
	ricochets_max = 5
	ricochet_incidence_leeway = 0
	ricochet_chance = 130
	ricochet_decay_damage = 0.7
	shrapnel_type = null
	sharpness = NONE
	embed_data = null

/obj/structure/sign/flag/interdyne
	name = "flag of Interdyne"
	desc = "The corporate flag of Interdyne Pharmaceuticals. It is, essentially, a clean white bedsheet. It's either the best or worst flag you've ever seen."
	icon_state = "flag_coder"
	item_flag = /obj/item/sign/flag/interdyne

/obj/item/sign/flag/interdyne
	name = "folded flag of the Interdyne"
	desc = "The folded flag of Interdyne Pharmaceutics."
	icon_state = "folded_coder"
	sign_path = /obj/structure/sign/flag/interdyne
	special_desc_requirement = EXAMINE_CHECK_JOB
	special_desc_jobs = list(JOB_MIME) // this will probably never happen. but it will amuse someone when it does.
	special_desc = "The folded flag of Interdyne Pharmaceuticals. For some reason, it reminds you of the home of the mimes."

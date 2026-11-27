/obj/item/clothing/suit/costume/samurai/reinforced
	name = "reinforced samurai armor"
	desc = "Heavy armor built from forged plates over a leather lining."
	body_parts_covered = CHEST | GROIN | ARMS
	armor_type = /datum/armor/reinforced_samurai
	resistance_flags = FIRE_PROOF
	slowdown = 0.5

/datum/armor/reinforced_samurai
	melee = 30
	bullet = 15
	laser = 10
	bio = 5
	fire = 50

/datum/crafting_bench_recipe/wearable/plate_armor/samurai
	recipe_name = "reinforced samurai armor"
	recipe_desc = "Heavy armor built from forged plates over a leather lining."
	recipe_requirements = list(
		/obj/item/stack/sheet/leather = 3,
		/obj/item/forging/complete/plate = 2,
	)
	resulting_item = /obj/item/clothing/suit/costume/samurai/reinforced
	time_to_assemble = 5 SECONDS
	relevant_skill_level = SKILL_LEVEL_EXPERT

/obj/structure/reagent_crafting_bench/New(loc, ...)
	if(/datum/crafting_bench_recipe/wearable/plate_armor/plate_vest in allowed_choices)
		allowed_choices = allowed_choices | /datum/crafting_bench_recipe/wearable/plate_armor/samurai
	return ..()

/obj/item/storage/belt/sheath/katana
	storage_type = /datum/storage/katana_sheath/tianguan

/datum/storage/katana_sheath/tianguan/New(atom/parent, max_slots, max_specific_storage, max_total_storage, rustle_sound, remove_rustle_sound)
	. = ..()
	set_holdable(list(/obj/item/katana, /obj/item/melee/forged_reagent_weapon/katana))

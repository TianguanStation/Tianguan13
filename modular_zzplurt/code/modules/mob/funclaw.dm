/mob/living/basic/deathclaw
	name = "deathclaw"
	desc = "A massive, reptilian creature with powerful muscles, razor-sharp claws, and aggression to match."
	icon = 'modular_zzplurt/icons/mob/claws/funclaws.dmi'
	icon_state = "deathclaw"
	icon_living = "deathclaw"
	icon_dead = "deathclaw_dead"
	pixel_x = -16
	gender = MALE
	mob_biotypes = list(MOB_ORGANIC, MOB_BEAST)
	ai_controller = /datum/ai_controller/basic_controller/creature/docile
	speak_emote = list("growls", "roars")
	speed = 1
	see_in_dark = 8
	butcher_results = list(/obj/item/food/meat/slab/ = 4,
							/obj/item/stack/sheet/animalhide = 2,
							/obj/item/stack/sheet/bone = 4)
	attack_verb_continuous = "claws"
	maxHealth = 500
	health = 500
	obj_damage = 60
	armour_penetration = 30
	melee_damage_lower = 56
	melee_damage_upper = 56
	faction = list("deathclaw")
	unsuitable_atmos_damage = 5
	gold_core_spawnable = HOSTILE_SPAWN
/mob/living/basic/deathclaw/Initialize(mapload)
	. = ..()

/mob/living/basic/deathclaw/hostile
	icon_state = "newclaw"
	ai_controller = /datum/ai_controller/basic_controller/simple/simple_hostile

/mob/living/basic/deathclaw/hostile/alphaclaw
	name = "Alpha Deathclaw"
	icon_state = "alphaclaw"
	ai_controller = /datum/ai_controller/basic_controller/simple/simple_hostile_obstacles

/mob/living/basic/deathclaw/hostile/death()
	..()
	gib()

/mob/living/basic/deathclaw/funclaw/
	name = "Docile Deathclaw"
	gold_core_spawnable = FRIENDLY_SPAWN

/mob/living/basic/deathclaw/funclaw/femclaw
	icon_state = "femclaw"
	gender = FEMALE
	name = "Docile Female Deathclaw"
	desc = "A surprisingly docile deathclaw."
	maxHealth = 400
	health = 400
	armour_penetration = 45

/mob/living/basic/deathclaw/funclaw/femclaw/mommyclaw
	icon_state = "mommyclaw"
	desc = "A massive, heavily armored deathclaw matriarch."
	name = "Matriarch Deathclaw"
	maxHealth = 1000
	health = 1000
	obj_damage = 145
	armour_penetration = 30
	melee_damage_lower = 40
	melee_damage_upper = 40

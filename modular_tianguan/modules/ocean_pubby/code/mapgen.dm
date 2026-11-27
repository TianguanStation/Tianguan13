/datum/map_generator/cave_generator/ocean_pubby
	flora_spawn_chance = 13
	// Keep ocean generation mostly open even if upstream cavegen defaults change.
	noise_percent = 75
	ca_steps = 4
	birth_limit = 5
	survival_limit = 3
	room_fill_percent = 45
	feature_spawn_chance = 15
	weighted_open_turf_types = list(/turf/open/water/deep_beach/planet_surface = 100)
	weighted_closed_turf_types = list(/turf/closed/mineral/random/stationside/ocean = 1)
	weighted_flora_spawn_list = list(
		/obj/structure/flora/ocean/seaweed = 10,
		/obj/structure/flora/ocean/longseaweed = 8,
		/obj/structure/flora/ocean/coral = 3,
		/obj/structure/flora/rock/style_random = 1,
	)
	weighted_feature_spawn_list = list(/obj/item/toy/seashell = 100)

/datum/map_generator/cave_generator/ocean_pubby/deep
	flora_spawn_chance = 9
	feature_spawn_chance = 5
	weighted_open_turf_types = list(/turf/open/water/deep_beach/lethal/planet_surface = 100)
	weighted_flora_spawn_list = list(
		/obj/structure/flora/ocean/seaweed = 5,
		/obj/structure/flora/ocean/longseaweed = 8,
		/obj/structure/flora/ocean/coral = 2,
	)

/datum/map_generator/cave_generator/ocean_pubby/shallow
	flora_spawn_chance = 15
	feature_spawn_chance = 10
	weighted_open_turf_types = list(/turf/open/water/beach/planet_surface = 100)
	weighted_flora_spawn_list = list(
		/obj/structure/flora/ocean/seaweed = 11,
		/obj/structure/flora/ocean/longseaweed = 2,
		/obj/structure/flora/ocean/coral = 4,
	)

/datum/map_generator/cave_generator/ocean_pubby/shallow/nofishy
	flora_spawn_chance = 2
	feature_spawn_chance = 2
	weighted_open_turf_types = list(/turf/open/water/beach/planet_surface/nofishy = 100)
	weighted_flora_spawn_list = list(
		/obj/structure/flora/ocean/seaweed = 11,
		/obj/structure/flora/ocean/longseaweed = 2,
		/obj/structure/flora/ocean/coral = 4,
	)

/datum/map_generator/cave_generator/ocean_pubby/shallow/lagoon
	noise_percent = 75
	weighted_flora_spawn_list = list(
		/obj/structure/flora/ocean/seaweed = 10,
		/obj/structure/flora/ocean/longseaweed = 3,
		/obj/structure/flora/ocean/coral = 5,
		/obj/structure/flora/rock/style_random = 5,
	)
	weighted_feature_spawn_list = list(
		/obj/item/toy/seashell = 96,
		/obj/structure/geyser/random = 2,
		/obj/structure/ore_vent/random = 2,
	)

/datum/map_generator/cave_generator/ocean_pubby/shallow/lagoon/hostile_mobs
	mob_spawn_chance = 2
	weighted_mob_spawn_list = list(
		/mob/living/basic/carp/mega = 5,
		/mob/living/basic/carp = 10,
	)

/area/ocean/generated/deep
	area_flags_mapping = FLORA_ALLOWED | CAVES_ALLOWED
	map_generator = /datum/map_generator/cave_generator/ocean_pubby/deep

/area/ocean/generated/shallow
	area_flags_mapping = FLORA_ALLOWED | CAVES_ALLOWED
	map_generator = /datum/map_generator/cave_generator/ocean_pubby/shallow

/area/ocean/generated/shallow/nofishy
	area_flags_mapping = FLORA_ALLOWED | CAVES_ALLOWED
	map_generator = /datum/map_generator/cave_generator/ocean_pubby/shallow/nofishy

/area/ocean/generated/hostile_mobs
	area_flags_mapping = FLORA_ALLOWED | CAVES_ALLOWED | MOB_SPAWN_ALLOWED
	map_generator = /datum/map_generator/cave_generator/ocean_pubby/shallow/lagoon/hostile_mobs

/area/ocean/monestary
	name = "\improper Monastery Isle"

/area/ocean/landingpad
	name = "\improper Landing Pad"

/area/station/solars/ocean
	icon_state = "panels"
	requires_power = FALSE
	area_flags = NONE // Override NO_GRAVITY from parent
	flags_1 = NONE
	static_lighting = FALSE
	base_lighting_alpha = 255
	outdoors = TRUE
	ambience_index = AMBIENCE_ENGI
	airlock_wires = /datum/wires/airlock/engineering
	sound_environment = SOUND_AREA_STANDARD_STATION
	default_gravity = STANDARD_GRAVITY

/area/station/solars/ocean/aisat
	name = "\improper AI Satellite Solars"
	icon_state = "panelsAI"

/area/station/solars/ocean/starboard
	name = "\improper Starboard Solar Array"
	icon_state = "panelsS"

/area/station/solars/ocean/port
	name = "\improper Port Solar Array"
	icon_state = "panelsP"

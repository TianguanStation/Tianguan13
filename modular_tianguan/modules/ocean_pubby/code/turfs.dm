/turf/open/water/deep_beach/planet_surface
	planetary_atmos = TRUE
	space_lit = TRUE
	light_range = 2
	reagent_to_extract = /datum/reagent/water/salt

/turf/open/water/deep_beach/lethal/planet_surface
	planetary_atmos = TRUE
	space_lit = TRUE
	light_range = 2
	color = "#8898ad"
	reagent_to_extract = /datum/reagent/water/salt

/turf/open/water/beach/planet_surface
	planetary_atmos = TRUE
	space_lit = TRUE
	light_range = 2
	reagent_to_extract = /datum/reagent/water/salt

/turf/open/water/beach/planet_surface/nofishy
	desc = "The water's great, but the immediate area seems completely devoid of fish..."
	fishing_datum = null

/turf/open/water/hot_spring/planet_surface
	planetary_atmos = TRUE
	space_lit = TRUE
	light_range = 2
	reagent_to_extract = /datum/reagent/water/salt

/turf/open/misc/ashplanet/wateryrock/planet_surface
	planetary_atmos = TRUE
	space_lit = TRUE
	light_range = 2
	slowdown = 0
	initial_gas_mix = /turf/open/water::initial_gas_mix

/turf/open/floor/iron/safe_planet
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE

/turf/open/floor/iron/smooth_large/safe_planet
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE

/turf/open/floor/iron/terracotta/diagonal/safe_planet
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE

/turf/open/floor/iron/terracotta/herringbone/safe_planet
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE

/turf/open/floor/iron/terracotta/safe_planet
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE

/turf/open/floor/iron/terracotta/small/safe_planet
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE

/turf/open/floor/iron/white/safe_planet
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE

/turf/open/floor/wood/large/safe_planet
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE

/turf/open/misc/beach/coast/corner/nofishy/Initialize(mapload)
	. = ..()
	remove_lazy_fishing()

/turf/open/misc/beach/coast/corner/safe_planet
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE

/turf/open/misc/beach/coast/nofishy/Initialize(mapload)
	. = ..()
	remove_lazy_fishing()

/turf/open/misc/beach/coast/safe_planet
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE

/turf/open/misc/beach/sand/nofishy/Initialize(mapload)
	. = ..()
	remove_lazy_fishing()

/turf/open/floor/wood/safe_planet
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE

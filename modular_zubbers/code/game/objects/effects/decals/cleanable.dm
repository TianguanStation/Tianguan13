/obj/effect/decal/cleanable/cobweb/NeverShouldHaveComeHere(turf/here_turf)
	var/area/cobweb_area = get_area(here_turf)
	return (isgroundlessturf(here_turf) && (istype(cobweb_area, /area/template_noop) || istype(cobweb_area, /area/space))) && ..()

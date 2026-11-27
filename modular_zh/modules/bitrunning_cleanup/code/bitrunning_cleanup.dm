/obj/machinery/quantum_server
	/// The reservation allocated for this run, owned by this server.
	var/datum/turf_reservation/domain_reservation

/obj/machinery/quantum_server/proc/release_domain_reservation()
	if(generated_domain)
		UnregisterSignal(generated_domain, COMSIG_LAZY_TEMPLATE_LOADED)
		generated_domain.reservations -= domain_reservation
	QDEL_NULL(domain_reservation)

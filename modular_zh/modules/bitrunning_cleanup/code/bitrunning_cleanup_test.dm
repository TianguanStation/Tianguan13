/// The cleanup must release the reservation owned by this server on every reset.
/datum/unit_test/bitrunner_domain_reservation_cleanup/Run()
	var/obj/machinery/quantum_server/server = allocate(/obj/machinery/quantum_server)
	var/datum/lazy_template/virtual_domain/domain = locate(/datum/lazy_template/virtual_domain/test_only) in SSbitrunning.all_domains
	TEST_ASSERT_NOTNULL(domain, "The test domain is missing")
	var/datum/turf_reservation/other_reservation = allocate(/datum/turf_reservation)
	domain.reservations += other_reservation

	for(var/run_number in 1 to 2)
		var/datum/turf_reservation/reservation = SSmapping.request_turf_block_reservation(2, 2)
		TEST_ASSERT_NOTNULL(reservation, "Could not reserve the domain area on run [run_number]")
		var/turf/reserved_tile = reservation.reserved_turfs[1]
		domain.reservations += reservation
		server.generated_domain = domain
		server.domain_reservation = reservation

		server.scrub_vdom()

		TEST_ASSERT(QDELETED(reservation), "Run [run_number] left its reservation active")
		TEST_ASSERT(!(reserved_tile in SSmapping.used_turfs), "Run [run_number] left its tiles reserved")
		TEST_ASSERT(!(reservation in domain.reservations), "Run [run_number] kept a stale template reservation")
		TEST_ASSERT(!QDELETED(other_reservation) && (other_reservation in domain.reservations), "Cleanup released a different server's reservation")

	domain.reservations -= other_reservation

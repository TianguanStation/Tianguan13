/// Ensures settings on vdoms are correct
/datum/unit_test/bitrunner_vdom_settings

/datum/unit_test/bitrunner_vdom_settings/Run()
	var/obj/structure/closet/crate/secure/bitrunning/decrypted/cache = allocate(/obj/structure/closet/crate/secure/bitrunning/decrypted)

	for(var/path in subtypesof(/datum/lazy_template/virtual_domain))
		var/datum/lazy_template/virtual_domain/vdom = new path
		TEST_ASSERT_NOTNULL(vdom.key, "[path] should have a key")
		TEST_ASSERT_NOTNULL(vdom.map_name, "[path] should have a map name")

		if(!length(vdom.completion_loot))
			continue

		TEST_ASSERT_EQUAL(cache.spawn_loot(vdom.completion_loot), TRUE, "[path] didn't spawn loot. Completion loot should be an associative list")

/// Loading and scrubbing the same domain twice must release each run's own reservation.
/datum/unit_test/bitrunner_domain_reservation_cleanup/Run()
	var/obj/machinery/quantum_server/server = allocate(/obj/machinery/quantum_server)
	for(var/run_number in 1 to 2)
		TEST_ASSERT(server.load_domain("test_only"), "Could not load the test domain on run [run_number]")
		var/datum/lazy_template/virtual_domain/domain = server.generated_domain
		var/datum/turf_reservation/reservation = server.domain_reservation
		TEST_ASSERT_NOTNULL(reservation, "The server did not record its reservation on run [run_number]")
		TEST_ASSERT(reservation in domain.reservations, "The loaded reservation is missing from the domain")

		server.scrub_vdom()

		TEST_ASSERT(QDELETED(reservation), "Run [run_number] left its reservation active")
		TEST_ASSERT(!(reservation in domain.reservations), "Run [run_number] kept a stale template reservation")

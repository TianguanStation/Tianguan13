/*----- SOLFED VESSEL Shuttle Code -----*/
/datum/map_template/shuttle/ert/solfed
	prefix = "_maps/shuttles/tianguan/"
	suffix = "solfed_general_shuttle"
	name = "EAS(I)-6224 Transport Shuttle"

/obj/machinery/computer/shuttle/solfed
	name = "\improper EAS(I)-6224 control console"
	desc = "Used to control the EAS(I)-6224."
	circuit = /obj/item/circuitboard/computer/solfed
	shuttleId = "solfed_general_shuttle"
	possible_destinations = "solfed_general_custom;solfed_general_home;whiteship_home;syndicate_nw"
	req_access = list(ACCESS_CENT_GENERAL)

/obj/machinery/computer/camera_advanced/shuttle_docker/solfed
	name = "\improper EAS(I)-6224 navigation computer"
	desc = "The navigation console for the EAS(I)-6224."
	shuttleId = "solfed_general_shuttle"
	lock_override = CAMERA_LOCK_STATION
	shuttlePortId = "solfed_general_custom"
	jump_to_ports = list( "whiteship_home" = 1, "syndicate_nw" = 1, )
	view_range = 12
	zlink_range = 1
	move_up_action = /datum/action/innate/camera_multiz_up
	move_down_action = /datum/action/innate/camera_multiz_down

/obj/item/circuitboard/computer/solfed
	name = "EAS(I)-6224 Control Console (Computer Board)"
	build_path = /obj/machinery/computer/shuttle/solfed

/obj/item/gps/computer/space/solfed
	name = "\improper SolFed GPS transponder"
	icon = 'modular_tianguan/modules/faction_solfed/assets/modules/mapping/icons/machinery/gps_computer_x32.dmi'	//needs its own file for pixel size ;-;
	gpstag = "*SF - EAS(I)-6224"
	pixel_y = 0

/*----- End of SOLFED VESSEL Shuttle Code -----*/

/*----- SOLFED INFANTRY VESSEL Shuttle Code -----*/
/datum/map_template/shuttle/ert/solfed/armory
	prefix = "_maps/shuttles/tianguan/"
	suffix = "solfed_armory_shuttle"
	name = "EAS(I)-2271 Transport Shuttle"

/obj/machinery/computer/shuttle/solfed/armory
	name = "\improper EAS(I)-2271 control console"
	desc = "Used to control the EAS(I)-2271."
	circuit = /obj/item/circuitboard/computer/solfed/armory
	shuttleId = "solfed_armory_shuttle"
	possible_destinations = "solfed_armory_custom;whiteship_home"

/obj/machinery/computer/camera_advanced/shuttle_docker/solfed/armory
	name = "\improper EAS(I)-2271 navigation computer"
	desc = "The navigation console for the EAS(I)-2271."
	shuttleId = "solfed_armory_shuttle"
	shuttlePortId = "solfed_armory_custom"

/obj/item/circuitboard/computer/solfed/armory
	name = "EAS(I)-2271 Control Console (Computer Board)"
	build_path = /obj/machinery/computer/shuttle/solfed/armory

/obj/item/gps/computer/space/solfed/armory
	gpstag = "*SF - EAS(I)-2271"
/*----- End of SOLFED INFANTRY VESSEL Shuttle Code -----*/

/*----- SOLFED HOSPITAL VESSEL Shuttle Code -----*/
/datum/map_template/shuttle/ert/solfed/medical
	prefix = "_maps/shuttles/tianguan/"
	suffix = "solfed_medical_shuttle"
	name = "EAS(H)-1457 Medical Transport Shuttle"

/obj/machinery/computer/shuttle/solfed/medical
	name = "\improper EAS(H)-1457 control console"
	desc = "Used to control the EAS(H)-1457."
	circuit = /obj/item/circuitboard/computer/solfed/medical
	shuttleId = "solfed_medical_shuttle"
	possible_destinations = "solfed_medical_shuttle_custom;whiteship_home"

/obj/machinery/computer/camera_advanced/shuttle_docker/solfed/medical
	name = "\improper EAS(H)-1457 navigation computer"
	desc = "The navigation console for the EAS(H)-1457."
	shuttleId = "solfed_medical_shuttle"
	shuttlePortId = "solfed_medical_shuttle_custom"

/obj/item/circuitboard/computer/solfed/medical
	name = "EAS(H)-1457 Control Console (Computer Board)"
	build_path = /obj/machinery/computer/shuttle/solfed/medical

/obj/item/gps/computer/space/solfed/medical
	gpstag = "*SF - EAS(H)-1457"
/*----- End of SOLFED HOSPITAL VESSEL Shuttle Code -----*/

/*----- SOLFED HOSPITAL ASSAULT Shuttle Code -----*/
/datum/map_template/shuttle/ert/solfed/assault
	prefix = "_maps/shuttles/tianguan/"
	suffix = "solfed_assault_shuttle"
	name = "EAS(L)-9921 Assault Transport Shuttle"

/obj/machinery/computer/shuttle/solfed/assault
	name = "\improper EAS(L)-9921 control console"
	desc = "Used to control the EAS(L)-9921."
	circuit = /obj/item/circuitboard/computer/solfed/assault
	shuttleId = "solfed_assault_shuttle"
	possible_destinations = "solfed_assault_shuttle_custom;whiteship_home"

/obj/machinery/computer/camera_advanced/shuttle_docker/solfed/assault
	name = "\improper EAS(L)-9921 navigation computer"
	desc = "The navigation console for the EAS(L)-9921."
	shuttleId = "solfed_assault_shuttle"
	shuttlePortId = "solfed_assault_shuttle_custom"

/obj/item/circuitboard/computer/solfed/assault
	name = "EAS(L)-9921 Control Console (Computer Board)"
	build_path = /obj/machinery/computer/shuttle/solfed/assault

/obj/item/gps/computer/space/solfed/assault
	gpstag = "*SF - EAS(L)-9921"
/*----- End of SOLFED ASSAULT VESSEL Shuttle Code -----*/

/*----- SOLFED OFFICIALS VESSEL Shuttle Code -----*/
/datum/map_template/shuttle/ert/solfed/official
	prefix = "_maps/shuttles/tianguan/"
	suffix = "solfed_official_shuttle"
	name = "SFTS-3329 Transport Shuttle"

/obj/machinery/computer/shuttle/solfed/official
	name = "\improper SFTS-3329 control console"
	desc = "Used to control the SFTS-3329."
	circuit = /obj/item/circuitboard/computer/solfed/official
	shuttleId = "solfed_official_shuttle"
	possible_destinations = "solfed_official_custom;whiteship_home"

/obj/machinery/computer/camera_advanced/shuttle_docker/solfed/official
	name = "\improper SFTS-3329 navigation computer"
	desc = "The navigation console for the SFTS-3329."
	shuttleId = "solfed_official_shuttle"
	shuttlePortId = "solfed_official_custom"

/obj/item/circuitboard/computer/solfed/official
	name = "SFTS-3329 Control Console (Computer Board)"
	build_path = /obj/machinery/computer/shuttle/solfed/official

/obj/item/gps/computer/space/solfed/official
	gpstag = "*SF - SFTS-3329"
/*----- End of OFFICIALS HOSPITAL VESSEL Shuttle Code -----*/

/*----- SOLFED FANCY VESSEL Shuttle Code -----*/
/datum/map_template/shuttle/ert/solfed/fancy
	prefix = "_maps/shuttles/tianguan/"
	suffix = "solfed_fancy_shuttle"
	name = "SFTS-1221 Transport Shuttle."

/obj/machinery/computer/shuttle/solfed/fancy
	name = "\improper SFTS-1221 control console"
	desc = "Used to control the SFTS-1221."
	circuit = /obj/item/circuitboard/computer/solfed/fancy
	shuttleId = "solfed_fancy_shuttle"
	possible_destinations = "solfed_fancy_shuttle_custom;whiteship_home"

/obj/machinery/computer/camera_advanced/shuttle_docker/solfed/fancy
	name = "\improper SFTS-1221 navigation computer"
	desc = "The navigation console for the SFTS-1221."
	shuttleId = "solfed_fancy_shuttle"
	shuttlePortId = "solfed_fancy_shuttle_custom"

/obj/item/circuitboard/computer/solfed/fancy
	name = "SFTS-1221 Control Console (Computer Board)"
	build_path = /obj/machinery/computer/shuttle/solfed/fancy

/obj/item/gps/computer/space/solfed/fancy
	gpstag = "*SF - SFTS-1221"
/*----- End of FANCY VESSEL Shuttle Code -----*/

/*----- SOLFED ENGINEERING VESSEL Shuttle Code -----*/
/datum/map_template/shuttle/ert/solfed/engineer
	prefix = "_maps/shuttles/tianguan/"
	suffix = "solfed_engineer_shuttle"
	name = "EAS(E)-3921 Transport Shuttle."

/obj/machinery/computer/shuttle/solfed/engineer
	name = "\improper EAS(E)-3921 control console"
	desc = "Used to control the EAS(E)-3921"
	circuit = /obj/item/circuitboard/computer/solfed/engineer
	shuttleId = "solfed_engineer_shuttle"
	possible_destinations = "solfed_engineer_shuttle_custom;whiteship_home"

/obj/machinery/computer/camera_advanced/shuttle_docker/solfed/engineer
	name = "\improper EAS(E)-3921 navigation computer"
	desc = "The navigation console for the EAS(E)-3921."
	shuttleId = "solfed_engineer_shuttle"
	shuttlePortId = "solfed_engineer_shuttle_custom"

/obj/item/circuitboard/computer/solfed/engineer
	name = "EAS(E)-3921 Driver Control Console (Computer Board)"
	build_path = /obj/machinery/computer/shuttle/solfed/engineer

/obj/item/gps/computer/space/solfed/engineer
	gpstag = "*SF - EAS(E)-3921"

/// The list of all TianGuan Star players.
GLOBAL_LIST_EMPTY(tianguan_star_list)
GLOBAL_PROTECT(tianguan_star_list)

/datum/player_rank_controller/tianguan_star
	rank_title = "tianguan_star"
	legacy_file_header = "###############################################################################################\n# List for TianGuan Star players! Case is not important for ckey.                            #\n###############################################################################################\n"

/datum/player_rank_controller/tianguan_star/New()
	. = ..()
	legacy_file_path = "[global.config.directory]/tianguan/tianguan_star_players.txt"

/datum/player_rank_controller/tianguan_star/add_player(ckey)
	if(IsAdminAdvancedProcCall())
		return

	ckey = ckey(ckey)
	GLOB.tianguan_star_list[ckey] = TRUE

/datum/player_rank_controller/tianguan_star/remove_player(ckey)
	if(IsAdminAdvancedProcCall())
		return

	GLOB.tianguan_star_list -= ckey

/datum/player_rank_controller/tianguan_star/get_ckeys_for_legacy_save()
	if(IsAdminAdvancedProcCall())
		return

	return GLOB.tianguan_star_list

/datum/player_rank_controller/tianguan_star/should_use_legacy_system()
	return CONFIG_GET(flag/tianguan_star_legacy_system)

/datum/player_rank_controller/tianguan_star/clear_existing_rank_data()
	if(IsAdminAdvancedProcCall())
		return

	GLOB.tianguan_star_list = list()

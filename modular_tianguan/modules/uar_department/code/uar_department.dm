/**
 * 团结联盟（UAR）部门 + 团结联盟审查官（UAR_DEPARTMENT）
 */

#define UAR_DEPARTMENT_COLOR "#8b0000"

/datum/job_department/uar
	department_name = DEPARTMENT_UAR
	department_bitflags = DEPARTMENT_BITFLAG_UAR
	display_order = 11
	ui_color = UAR_DEPARTMENT_COLOR
	nation_prefixes = list("Allian", "Republi", "Union", "Inspectora", "Consul")

/datum/job/uar_inspector
	title = JOB_UAR_INSPECTOR
	description = "代表团结联盟常驻本站，审查站内事务、传达联盟的意见。"
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "团结联盟"
	exp_granted_type = EXP_TYPE_CREW

	minimal_player_age = 14
	exp_requirements = 600
	exp_required_type = EXP_TYPE_CREW
	exp_required_type_department = EXP_TYPE_COMMAND

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_CIV

	outfit = /datum/outfit/job/uar_inspector

	display_order = JOB_DISPLAY_ORDER_UAR_INSPECTOR
	department_for_prefs = /datum/job_department/uar
	departments_list = list(
		/datum/job_department/uar,
	)

	job_flags = STATION_JOB_FLAGS
	config_tag = "UAR_INSPECTOR"
	rpg_title = "Inspector"
	species_whitelist = list(SPECIES_HUMAN = 1)
	tianguan_stars_only = TRUE
	allow_bureaucratic_error = FALSE

/datum/outfit/job/uar_inspector
	name = JOB_UAR_INSPECTOR
	jobtype = /datum/job/uar_inspector

	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/job/uar_inspector
	uniform = /obj/item/clothing/under/suit/black
	shoes = /obj/item/clothing/shoes/laceup
	belt = /obj/item/modular_computer/pda
	ears = /obj/item/radio/headset

/datum/id_trim/job/uar_inspector
	assignment = JOB_UAR_INSPECTOR
	trim_state = "trim_assistant"
	department_color = UAR_DEPARTMENT_COLOR
	subdepartment_color = "#1f3a8a"
	sechud_icon_state = SECHUD_ASSISTANT
	minimal_access = list()
	extra_access = list(
		ACCESS_MAINT_TUNNELS,
	)
	template_access = list(
		ACCESS_CAPTAIN,
		ACCESS_CHANGE_IDS,
		ACCESS_HOP,
	)
	job = /datum/job/uar_inspector

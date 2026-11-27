/datum/ert/solfed
	roles = list(/datum/antagonist/ert/solfed, /datum/antagonist/ert/solfed/social, /datum/antagonist/ert/solfed/civil)
	leader_role = /datum/antagonist/ert/solfed/leader

	notify_players = FALSE
	opendoors = FALSE
	ert_template = /datum/map_template/shuttle/ert/solfed/official

	rename_team = "SolFed Officials"
	teamsize = 5
	code = "FEDERAL"
	mission = "Audit the station, write reports, and look for any violations of Federal regulations."
	polldesc = "a Sol Federation Official"

/datum/ert/solfed/espatier
	roles = list(/datum/antagonist/ert/solfed/espatier, /datum/antagonist/ert/solfed/espatier/corpsman, /datum/antagonist/ert/solfed/espatier/engineer)
	leader_role = /datum/antagonist/ert/solfed/espatier/leader

	ert_template = /datum/map_template/shuttle/ert/solfed

	notify_players = TRUE
	rename_team = "SolFed Espatier Detachment"
	teamsize = 6
	code = "FEDERAL"
	mission = "Rescue survivors, and bring order to chaos. Glory to the Federation."
	polldesc = "a Sol Federation Espatier"


/// A variant of spawning, they spawn with a smaller more assaultlike ship, with no compartments (no medical compartment, engineering, atmos, just what they have on their back)
/datum/ert/solfed/espatier/assault
	ert_template = /datum/map_template/shuttle/ert/solfed/assault

/// Corpsman only spawn
/datum/ert/solfed/espatier/assault/corpsman_only
	roles = list(/datum/antagonist/ert/solfed/espatier/corpsman)
	polldesc = "a Sol Federation Trauma Team"

/// Rifleman only spawn
/datum/ert/solfed/espatier/assault/rifleman_only
	roles = list(/datum/antagonist/ert/solfed/espatier)
	polldesc = "a Sol Federation Rifleman"

/// Engineering only spawn
/datum/ert/solfed/espatier/assault/engineering_only
	roles = list(/datum/antagonist/ert/solfed/espatier/engineer)

/// A variant of spawning, they basically spawn with the mobile garrison/armory.
/datum/ert/solfed/espatier/armory
	ert_template = /datum/map_template/shuttle/ert/solfed/armory

/// Forces the true helljumpers (basically all infantry, no medics)
/datum/ert/solfed/espatier/armory/rifleman_only
	roles = list(/datum/antagonist/ert/solfed/espatier)

/// A variant of spawning, they basically spawn with the mobile Hospital.
/datum/ert/solfed/espatier/medical
	ert_template = /datum/map_template/shuttle/ert/solfed/medical

/// A variant of spawning, they basically spawn with the mobile Engineering Bay.
/datum/ert/solfed/espatier/engineer
	ert_template = /datum/map_template/shuttle/ert/solfed/engineer

/// Forces this shuttle type to be engineering only
/datum/ert/solfed/espatier/engineer/engineering_only
	roles = list(/datum/antagonist/ert/solfed/espatier/engineer)

/// Forces the crew to be oops all corpsmans! (medics/doctors)
/datum/ert/solfed/espatier/medical/corpsman_only
	roles = list(/datum/antagonist/ert/solfed/espatier/corpsman)

/// Solfed Officals shuttle, but more fancy.
/datum/ert/solfed/fancy
	ert_template = /datum/map_template/shuttle/ert/solfed/fancy
/*

GRAND RESPONSE VARIANTS OF ESPATIERS, USE ONLY IF SOMEONE ROYALLY FUCKED UP

*/
/datum/ert/solfed/grand_espatier
	roles = list(/datum/antagonist/ert/solfed/grand_espatier, /datum/antagonist/ert/solfed/grand_espatier/corpsman, /datum/antagonist/ert/solfed/grand_espatier/engineer)
	leader_role = /datum/antagonist/ert/solfed/grand_espatier/leader

	ert_template = /datum/map_template/shuttle/ert/solfed

	notify_players = TRUE
	rename_team = "SolFed Espatier Detachment"
	teamsize = 6
	code = "FEDERAL"
	mission = "Rescue survivors, and bring order to chaos. Glory to the Federation."
	polldesc = "a Sol Federation Grand Response Espatier"


/// A variant of spawning, they spawn with a smaller more assaultlike ship, with no compartments (no medical compartment, engineering, atmos, just what they have on their back)
/datum/ert/solfed/grand_espatier/assault
	ert_template = /datum/map_template/shuttle/ert/solfed/assault

/// Corpsman only spawn
/datum/ert/solfed/grand_espatier/assault/corpsman_only
	roles = list(/datum/antagonist/ert/solfed/grand_espatier/corpsman)
	polldesc = "a Sol Federation Trauma Team"

/// Rifleman only spawn
/datum/ert/solfed/grand_espatier/assault/rifleman_only
	roles = list(/datum/antagonist/ert/solfed/grand_espatier)
	polldesc = "a Sol Federation Rifleman"

/// Engineering only spawn
/datum/ert/solfed/grand_espatier/assault/engineering_only
	roles = list(/datum/antagonist/ert/solfed/grand_espatier/engineer)

/// A variant of spawning, they basically spawn with the mobile garrison/armory.
/datum/ert/solfed/grand_espatier/armory
	ert_template = /datum/map_template/shuttle/ert/solfed/armory

/// Forces the true helljumpers (basically all infantry, no medics)
/datum/ert/solfed/grand_espatier/armory/rifleman_only
	roles = list(/datum/antagonist/ert/solfed/grand_espatier)

/// A variant of spawning, they basically spawn with the mobile Hospital.
/datum/ert/solfed/grand_espatier/medical
	ert_template = /datum/map_template/shuttle/ert/solfed/medical

/// A variant of spawning, they basically spawn with the mobile Engineering Bay.
/datum/ert/solfed/grand_espatier/engineer
	ert_template = /datum/map_template/shuttle/ert/solfed/engineer

/// Forces this shuttle type to be engineering only
/datum/ert/solfed/grand_espatier/engineer/engineering_only
	roles = list(/datum/antagonist/ert/solfed/grand_espatier/engineer)

/// Forces the crew to be oops all corpsmans! (medics/doctors)
/datum/ert/solfed/grand_espatier/medical/corpsman_only
	roles = list(/datum/antagonist/ert/solfed/grand_espatier/corpsman)

/datum/antagonist/ert/solfed
	name = "SolFed Auditor"
	outfit = /datum/outfit/solfed/lowrank
	role = "Auditor"
	suicide_cry = "FOR THE FEDERATION!!!!"

/datum/antagonist/ert/solfed/social
	outfit = /datum/outfit/solfed/social
	role = "Social Worker"

/datum/antagonist/ert/solfed/civil
	outfit = /datum/outfit/solfed/civil
	role = "Civil Services Worker"

/datum/antagonist/ert/solfed/leader
	name = "Lead SolFed Auditor"
	outfit = /datum/outfit/solfed
	role = "Lead Auditor"
	leader = TRUE

/datum/antagonist/ert/solfed/espatier
	name = "SolFed Espatier"
	outfit = /datum/outfit/solfed/espatier
	role = "Rifleman"

/datum/antagonist/ert/solfed/espatier/New()
	. = ..()
	name_source = GLOB.last_names

/datum/antagonist/ert/solfed/espatier/engineer
	name = "SolFed Espatier Engineer"
	outfit = /datum/outfit/solfed/espatier/engineer
	role = "Engineer"

/datum/antagonist/ert/solfed/espatier/corpsman
	name = "SolFed Espatier Corpsman"
	outfit = /datum/outfit/solfed/espatier/corpsman
	role = "Corpsman"

/datum/antagonist/ert/solfed/espatier/leader
	name = "SolFed Espatier Squad Leader"
	outfit = /datum/outfit/solfed/espatier/squadleader
	role = "Squad Leader"
	leader = TRUE

/datum/antagonist/ert/solfed/espatier/greet()
	var/missiondesc =  ""
	missiondesc += "<B><font size=5 color=red>You are NOT a Nanotrasen Employee. You serve the Sol Federation as the [name].</font></B>"
	if(leader) //If Squad Leader
		missiondesc += "<BR><B>Lead your squad to ensure the completion of the mission. Board the shuttle when your team is ready.</B>"
	if(!leader)
		missiondesc += "<BR><B><font size=2 color=yellow>Follow orders given to you by your squad leader.</font></B>"
	missiondesc += "<BR><B>Your Duties</B>:"
	missiondesc += "<BR> <B>1.</B> Contact the Sol Federation Ground Teams and the First Responders via your headset to get the situation from them."
	missiondesc += "<BR> <B>2.</B> Locate Survivors and Assume Control of the station, and prepare to initiate evacuation procedures should the situation call for it."
	missiondesc += "<BR> <B>3.</B> Should all else fail, evacuating the civilians becomes your top priority."
	missiondesc += "<BR> <B>4.</B> Lethal force is authorized, however identify before you shoot and watch who you're shooting, civilian casualties by Federation hands are NOT TOLERATED."

	missiondesc += "<span class='warningplain'><BR><B>Your Mission</B> : [ert_team.mission.explanation_text]</span>"
	to_chat(owner,missiondesc)

/// Grand Response variant
/datum/antagonist/ert/solfed/grand_espatier
	name = "SolFed Grand Response Espatier"
	outfit = /datum/outfit/solfed/grand_espatier
	role = "Rifleman"

/datum/antagonist/ert/solfed/grand_espatier/engineer
	name = "SolFed Espatier Engineer"
	outfit = /datum/outfit/solfed/grand_espatier/engineer
	role = "Engineer"

/datum/antagonist/ert/solfed/grand_espatier/corpsman
	name = "SolFed Espatier Corpsman"
	outfit = /datum/outfit/solfed/grand_espatier/corpsman
	role = "Corpsman"

/datum/antagonist/ert/solfed/grand_espatier/leader
	name = "SolFed Espatier Squad Leader"
	outfit = /datum/outfit/solfed/grand_espatier/squadleader
	role = "Squad Leader"
	leader = TRUE

/datum/antagonist/ert/solfed/grand_espatier/greet()
	var/missiondesc =  ""
	missiondesc += "<B><font size=5 color=red>You are NOT a Nanotrasen Employee. You serve the Sol Federation as the [name].</font></B>"
	if(leader) //If Squad Leader
		missiondesc += "<BR><B>Lead your squad to ensure the completion of the mission. Board the shuttle when your team is ready.</B>"
	if(!leader)
		missiondesc += "<BR><B><font size=2 color=yellow>Follow orders given to you by your squad leader.</font></B>"
	missiondesc += "<BR><B>Your Duties</B>:"
	missiondesc += "<BR> <B>1.</B> Contact the Sol Federation Ground Teams and the First Responders via your headset to get the situation from them."
	missiondesc += "<BR> <B>2.</B> Locate Survivors and Assume Control of the station, and prepare to initiate evacuation procedures should the situation call for it."
	missiondesc += "<BR> <B>3.</B> Should all else fail, evacuating the civilians becomes your top priority."
	missiondesc += "<BR> <B>4.</B> Lethal force is authorized, however identify before you shoot and watch who you're shooting, civilian casualties by Federation hands are NOT TOLERATED."

	missiondesc += "<span class='warningplain'><BR><B>Your Mission</B> : [ert_team.mission.explanation_text]</span>"
	to_chat(owner,missiondesc)

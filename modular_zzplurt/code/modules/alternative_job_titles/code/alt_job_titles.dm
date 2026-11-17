/datum/job/ai/New()
	var/list/extra_titles = list(
		"Automated Station Caretaker",
		"Automated Station Control",
		"Central Station System",
		"Automatic Station Operator",
		"Head of Silicons",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/captain/New()
	var/list/extra_titles = list(
		"Ark Commander",
		"Consul",
		"Senator",
		"Head of Station",
		"Station Director",
		"Station Governor",
		"Station Master",
		"Station Mistress",
		"Station Overseer",
		// "Station Commander",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/chief_engineer/New()
	var/list/extra_titles = list(
		"Construction Coordinator",
		"Head Engineer",
		"Magos Biologis",
		"Magos",
		"Master Architect",
		"Power Plant Director",
		"Head of Supermatter",
		"Project Manager",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/head_of_personnel/New()
	var/list/extra_titles = list(
		"Administratum Primus",
		"Bureaucracy Guarantor",
		"Captain Attachment",
		"Headpat Of Personnel",
		"Head of Service",
		"Human Resources",
		"Personnel Coordinator",
		"Personnel Manager",
		"Personnel Officer",
		"Records Administrator",
		"Staff Administrator",
		"Head of Fursonnel",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/head_of_security/New()
	var/list/extra_titles = list(
		"Big Iron",
		"Cerberus Leader",
		"Commissar",
		"Division Leader",
		"Head of Red Hawk",
		"Primus",
		"The Law",
		"Watch Commander",
		// "Security Commander",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/quartermaster/New()
	var/list/extra_titles = list(
		"Brigadier",
		"Cargonia Chief",
		"Munitorium Primus",
		"Supply Chief",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/research_director/New()
	var/list/extra_titles = list(
		"Lead Developer",
		"Research Manager",
		"Science Administrator",
		"Head of Science",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/chief_medical_officer/New()
	var/list/extra_titles = list(
		"Head of Surgery",
		"Top Doctor",
		"Medical Administrator",
		// "Medical Director",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/bridge_assistant/New()
	var/list/extra_titles = list(
		"Assistant of the Day",
		"Command Freeloader",
		"Command Mascot",
		"Folder Manager",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/atmospheric_technician/New()
	var/list/extra_titles = list(
		"Atmos Plumber",
		"Disposals Technician",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/station_engineer/New()
	var/list/extra_titles = list(
		"Apprentice Engineer",
		"Astromechanic",
		"Hazardous Material Operator",
		"Junior Engineer",
		"Station Architect",
		"Structural Engineer",
		"Structural Technician",
		"Techpriest Enginseer",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/telecomms_specialist/New()
	var/list/extra_titles = list(
		"Communications Technician",
		"Electronics Relay Planner",
		"PDA Service Provider",
		"Systems Reboot Technician",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/assistant/New()
	var/list/extra_titles = list(
		"Bard",
		"Bear Communist",
		"Belly Massager",
		"Blacksmith",
		"Boxer",
		"Clerk",
		"Coffee Runner",
		"Comedic Foil",
		"Emotional Support",
		"Errand Boy",
		"Errand Girl",
		"Freeloader",
		"Greytider",
		"Intern",
		"Receptionist",
		"Registered Company Equipment",
		"Secretary",
		"Service Pred",
		"Service Prey",
		"Slavic Activist",
		"Snack",
		"Wrestler",
		// "Tourist",
		// "Waiter",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/bartender/New()
	var/list/extra_titles = list(
		"Bar Owner",
		"Barmaid",
		"Drinklady",
		"Drinkman",
		"Expediter",
		"Sommelier",
		// "Mixologist",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/janitor/New()
	var/list/extra_titles = list(
		"Cleanliness Technician",
		"Dormitory Cleanup Crew",
		"Liquidator",
		"Mess Manager",
		// "Custodial Technician",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/chaplain/New()
	var/list/extra_titles = list(
		"Abbot",
		"Bishop",
		"Brother",
		"Counselor",
		"Prior",
		"Sister",
		"Techpriest",
		"Tiger Cooperative Disciple",
		// "Monk",
		// "Nun",
		// "Priestess",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/clown/New()
	var/list/extra_titles = list(
		"Chaotic Agent",
		"Performer",
		"Scapegoat",
		"Station Fool",
		"Zeleboba",
		// "Comedian",
		// "Jester",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/cook/New()
	var/list/extra_titles = list(
		"Boss of This Gym",
		"Burger Flipper",
		"Chef de partie",
		"Fast Fooder",
		"Lunch Packer",
		"Microwave Technology Specialist",
		"Poissonier",
		"Pred Prepper",
		"Prey Prepper",
		"Sandwich Technician",
		"Soup Senator",
		"Waffle Co. Specialist",
		// "Baker",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/curator/New()
	var/list/extra_titles = list(
		"Artist",
		"Author",
		"Gossip Coordinator",
		"Tabloid Columnist",
		"Keeper",
		"Nerd",
		"Scholar",
		// "Archaeologist",
		// "Historian",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/botanist/New()
	var/list/extra_titles = list(
		"Plants Breeder",
		"Soiler",
		"Vintner",
		"Weed Plucker",
		// "Beekeeper",
		// "Farmer",
		// "Hydroponicist",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/lawyer/New()
	var/list/extra_titles = list(
		"Attorney",
		"Legal Consultant",
		// "Internal Affairs Agent",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/mime/New()
	var/list/extra_titles = list(
		"Mimic",
		"Pantomime",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/scientist/New()
	var/list/extra_titles = list(
		"Junior Scientist",
		"Nanite Programmer",
		"Research Intern",
		"Researcher",
		"Tetromino Researcher",
		"Toxins Researcher",
		"Xenoarchaeologist",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/roboticist/New()
	var/list/extra_titles = list(
		"Droid Mechanic",
		"Exo-Suit Mechanic",
		"MOD Mechanic",
		"Ripperdoc",
		"Synth Technician",
		"Techpriest Biologis",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/chemist/New()
	var/list/extra_titles = list(
		"Apothecarist",
		"Chemical Plumber",
		"Matter Converter",
		"Organomegaly Healer",
		// "Alchemist",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/coroner/New()
	var/list/extra_titles = list(
		"Autopsy Specialist",
		"Workplace Accident Specialist",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/doctor/New()
	var/list/extra_titles = list(
		"Medical Intern",
		"Medical Resident",
		"Medtech",
		"Physical Examiner",
		// "Physician",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/psychologist/New()
	var/list/extra_titles = list(
		"Hypnosis Expert",
		"Hypnotherapist",
		"Hypnotist",
		"Gaslighter",
		// "Psychiatrist",
		// "Therapist",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/geneticist/New()
	var/list/extra_titles = list(
		"Genetics Researcher",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/paramedic/New()
	var/list/extra_titles = list(
		"Trauma Team",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/virologist/New()
	var/list/extra_titles = list(
		"Biochemist",
		"Microbiologist",
		"Monkey Destroyer",
		"Plague Doctor",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/detective/New()
	var/list/extra_titles = list(
		"Cooperate Auditor",
		"Counterintelligence Agent",
		"Forensic Investigator",
		"RHIB Agent",
		"Van Dorn Agent",
		// "Gumshoe",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/security_officer/New()
	var/list/extra_titles = list(
		"Cerberus",
		"Civil Protection",
		"Enforcement Officer",
		"Enforcer",
		"Exo-Suit Ensign",
		"Guardsman",
		"Police Officer",
		"Probation Officer",
		"Red Hawk Private",
		"Security Agent",
		"Snekurity Officer",
		"Tyranny Lover",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/warden/New()
	var/list/extra_titles = list(
		"Armory Manager",
		"Brig Overwatch",
		"Brig Superintendent",
		"Dungeon Master",
		"Marshal",
		"Prison Administrator",
		"Prison Chief",
		"Red Hawk Sergeant",
		"Security Sergeant",
		"TOC Manager",
		"Voreden",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/bitrunner/New()
	var/list/extra_titles = list(
		"Hacker",
		"Jacker",
		"Power Gamer",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/cargo_technician/New()
	var/list/extra_titles = list(
		"Cryptocurrency Technician",
		"Deliveries Officer",
		"Disposal Technician",
		"Donk Co. Specialist",
		"Logistics Technician",
		"Mailroom Technician",
		"Package Handler",
		// "Mail Man",
		// "Mail Woman",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/shaft_miner/New()
	var/list/extra_titles = list(
		"Digger",
		"Exotic Ore Miner",
		"Hunter",
		"Slayer",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/prisoner/New()
	var/list/extra_titles = list(
		"Captured Syndicate Member",
		"Low Security Prisoner",
		"Medium Security Prisoner",
		// "Maximum Security Prisoner",
		// "Protective Custody Prisoner",
		// "SuperMax Prisoner",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/blueshield/New()
	var/list/extra_titles = list(
		"Bluemaid",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

//Honorifics
/datum/id_trim/job/blueshield/New()
	var/list/extra_honorific = list(
		"Blueshield",
		"Bluemaid",
	)
	LAZYADD(honorifics, extra_honorific)
	. = ..()

/datum/job/nanotrasen_crew_trainer
	alt_titles = list(
		"Nanotrasen Crew Trainer",
		"Nanotrasen Intern",
		"NT Guidance Officer",
		"Cargo Trainer",
		"Engineering Trainer",
		"Medical Trainer",
		"Science Trainer",
		"Security Trainer",
		"Service Trainer",
	)

/proc/get_security_cyborg_alt_titles()
	return list(
		"Security Cyborg",
		"Safeguard Model",
		"Synthetic Auxiliary Officer",
	)

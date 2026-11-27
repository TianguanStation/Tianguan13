/obj/machinery/power/micro_reactor
	icon = 'modular_tianguan/modules/faction_heliostatic/assets/modules/mapping/icons/machinery/reactor.dmi'
	name = "micro reactor"
	desc = "Designed as a self-containing power source for long-haul vessels, the stamp of <font color='#008080'><b>SOAR Industries</b></font> \
		on the top. A steady output once active with plenty of safety features to ensure a meltdown is not possible, \
		having one installed means a steady clean powersource for between 75-125 years."
	icon_state = "reactor0_0"
	base_icon_state = "reactor0"
	density = TRUE
	anchored = TRUE

	var/power_gen = 200 KILO WATTS
	var/active = FALSE
	var/power_output = 1

	interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND

	light_color = LIGHT_COLOR_ELECTRIC_CYAN
	light_on = FALSE

	var/datum/looping_sound/generator/soundloop

/obj/machinery/power/micro_reactor/Initialize(mapload)
	. = ..()
	soundloop = new(src, active)
	connect_to_network()
	AddElement(/datum/element/tool_blocker, TOOL_SCREWDRIVER)
	AddElement(/datum/element/tool_blocker, TOOL_CROWBAR)

/obj/machinery/power/micro_reactor/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/obj/machinery/power/micro_reactor/update_icon_state()
	icon_state = "[base_icon_state]_[active]"
	return ..()

/obj/machinery/power/micro_reactor/attack_hand(mob/user, list/modifiers)
	. = ..()
	TogglePower()

/obj/machinery/power/micro_reactor/attack_robot(mob/user)
	. = ..()
	TogglePower()

/obj/machinery/power/micro_reactor/proc/handleInactive()
	return

/obj/machinery/power/micro_reactor/update_appearance(updates)
	. = ..()
	if(!active)
		set_light(0)
		return
	set_light(2, 3)

/obj/machinery/power/micro_reactor/proc/TogglePower()
	if(active)
		active = FALSE
		set_light_power(0)
		set_light_on(0)
		update_appearance()
		soundloop.stop()
	else
		active = TRUE
		START_PROCESSING(SSmachines, src)
		set_light_power(3)
		set_light_range(2)
		set_light_on(TRUE)
		update_appearance()
		soundloop.start()

/obj/machinery/power/micro_reactor/process()
	if(active)
		if(!anchored)
			TogglePower()
			return
		if(powernet)
			add_avail(power_to_energy(power_gen * power_output))
	else
		handleInactive()

/obj/machinery/power/micro_reactor/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += LANG("obj.e87ba4d7c50d0213", list(!active?"n't":""))

/obj/machinery/power/micro_reactor/bapgm
	name = "B.A.P.G.M."
	desc = "The Basic Automated Power Generation Machine also known as B.A.P.G.M is a reactor designed as a self-containing \
		power source for long-haul vessels however it was built to be auxillary power generation to assure essential systems \
		are online, the stamp of <font color='#008080'><b>SOAR Industries</b></font> \
		on the top. A steady output once active with plenty of safety features to ensure a meltdown is not possible, \
		having one installed means a steady clean powersource for between 75-125 years."
	icon_state = "bapgm_0"
	base_icon_state = "bapgm"
	density = FALSE

	power_gen = 100 KILO WATTS

	interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND

	light_color = LIGHT_COLOR_ELECTRIC_CYAN

/// TianGuan contacts available on the current routing table of a station console.
/obj/machinery/computer/communications/proc/tianguan_associate_destinations()
	var/static/list/station_contacts = list(
		"uar_admin" = "团结联盟地方行政委员会",
		"solar_defense_pact" = "太阳系联邦防御条约",
	)
	var/static/list/rerouted_contacts = list(
		"socialist_republic" = "世界社会主义共和国",
		"syndicate_independent_brigade" = "大辛迪加国第一独立旅",
	)
	if(syndicate)
		return null
	return (obj_flags & EMAGGED) ? rerouted_contacts : station_contacts

/obj/machinery/computer/communications/proc/tianguan_associate_recipient(destination)
	if(!istext(destination))
		return null
	var/list/contacts = tianguan_associate_destinations()
	return contacts?[destination]

/obj/machinery/computer/communications/proc/tianguan_associate_buttons()
	var/list/contacts = tianguan_associate_destinations()
	var/list/contact_buttons = list()
	for(var/contact in contacts)
		contact_buttons += list(list("id" = contact, "name" = contacts[contact]))
	return contact_buttons

/obj/machinery/computer/communications/proc/message_tianguan_associate(message, mob/user, recipient)
	var/request_message = "[recipient]： [message]"
	if(obj_flags & EMAGGED)
		message_syndicate(request_message, user)
	else
		message_centcom(request_message, user)
	to_chat(user, span_notice("已向[recipient]发送消息。"))

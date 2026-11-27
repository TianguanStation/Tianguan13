// Flag artwork by Stalkeros and NovaSector contributors (CC BY-SA 3.0).
// Extracted from modular_nova/modules/aesthetics/flag/icons/flags.dmi at 086f71d6759.
#define FACTION_FLAGS_ICON 'modular_tianguan/modules/faction_flags/icons/faction_flags.dmi'

/obj/structure/sign/flag/sol_federation
	name = "太阳联邦旗帜"
	desc = "太阳联邦的旗帜。"
	icon = FACTION_FLAGS_ICON
	icon_state = "flag_solfed"
	item_flag = /obj/item/sign/flag/sol_federation

/obj/item/sign/flag/sol_federation
	name = "折叠的太阳联邦旗帜"
	desc = "叠好的太阳联邦旗帜，可以挂到墙上。"
	icon = FACTION_FLAGS_ICON
	icon_state = "folded_solfed"
	sign_path = /obj/structure/sign/flag/sol_federation

/obj/structure/sign/flag/heliostatic_coalition
	name = "静日联盟旗帜"
	desc = "静日联盟的旗帜。"
	icon = FACTION_FLAGS_ICON
	icon_state = "flag_hc"
	item_flag = /obj/item/sign/flag/heliostatic_coalition

/obj/item/sign/flag/heliostatic_coalition
	name = "折叠的静日联盟旗帜"
	desc = "叠好的静日联盟旗帜，可以挂到墙上。"
	icon = FACTION_FLAGS_ICON
	icon_state = "folded_hc"
	sign_path = /obj/structure/sign/flag/heliostatic_coalition

/datum/loadout_item/inhand/flag_sol_federation
	name = "折叠的太阳联邦旗帜"
	item_path = /obj/item/sign/flag/sol_federation

/datum/loadout_item/inhand/flag_heliostatic_coalition
	name = "折叠的静日联盟旗帜"
	item_path = /obj/item/sign/flag/heliostatic_coalition

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/flag/sol_federation, 32)
MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/flag/heliostatic_coalition, 32)

#undef FACTION_FLAGS_ICON

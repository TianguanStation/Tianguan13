/datum/techweb_node/fishing_equip_adv
	required_experiments = null
	discount_experiments = list(/datum/experiment/scanning/fish = TECHWEB_TIER_2_POINTS)

/datum/techweb_node/explosives
	required_experiments = null
	discount_experiments = list(/datum/experiment/ordnance/explosive/lowyieldbomb = TECHWEB_TIER_3_POINTS)

/datum/techweb_node/medbay_equip_adv
	required_experiments = null
	discount_experiments = list(/datum/experiment/scanning/reagent/haloperidol = TECHWEB_TIER_3_POINTS)

/datum/techweb_node/mech_combat
	required_experiments = null
	discount_experiments = list(/datum/experiment/scanning/random/mecha_equipped_scan = TECHWEB_TIER_2_POINTS)

/datum/techweb_node/selection
	required_experiments = null
	discount_experiments = list(
		/datum/experiment/scanning/random/plants/wild = TECHWEB_TIER_3_POINTS,
		/datum/experiment/scanning/random/plants/traits = TECHWEB_TIER_3_POINTS,
	)

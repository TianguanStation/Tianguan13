// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/reagent_containers/hypospray/medipen/prospacillin
	name = "Extra height shot"
	desc = "Made to quickly treat individuals catalogued as \"manlets\" and help them reach the station's shelves."
	icon = 'modular_zzplurt/icons/obj/syringe.dmi'
	lefthand_file = 'modular_zzplurt/icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'modular_zzplurt/icons/mob/inhands/equipment/medical_righthand.dmi'
	icon_state = "prospen"
	inhand_icon_state = "prospen"
	base_icon_state = "prospen"
	volume = 30
	amount_per_transfer_from_this = 30
	list_reagents = list(/datum/reagent/growthchem = 30)

/obj/item/reagent_containers/hypospray/medipen/prospacillin/Initialize(mapload)
	. = ..()
	if(prob(50))
		desc = LANG("obj.0ac97209a265caca", null)

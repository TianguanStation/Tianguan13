// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/mod_theme/rim_inspector
	name = "rim-world inspector"
	desc = "A Heliostatic Coalition Internal Affairs-Apadyne joint border patrol suit. Designed for maximum protection in frontier environments where medical support is scarce."
	extended_desc = "An extremely heavily armored MODsuit manufactured by the Heliostatic Coalition for Heliostatic Coalition's border patrol operations. \
		In frontier regions where medical facilities are nonexistent and pirate activity is rampant, the Coalition determined \
		it was more cost-effective to transform patrolmen into walking fortresses than to equip them with complex regenerative systems akin to the ones in Voskhods. \
		The suit features multiple layers of composite armor plating of plasteel/self-repairing ceramics/CNT-weave spall liner, with particular emphasis on frontal protection to withstand \
		everything from pirate small arms (up to and including .60 SAPHEI) to research station-gone-blue artillery fragments. A dense, thick faceplate incorporates a \
		singular mounted camera system behind an ultra-thick piece of tinted plasma glass, allowing officers to survive direct impacts that would \
		compromise conventional visors and not lose their vision. While the psychological burden of frontier duty remains, patrolmen can take solace \
		in knowing their armor can withstand threats that would obliterate anything short of an armored vehicle."
	default_skin = "rim_inspector"
	armor_type = /datum/armor/mod_theme_rim_inspector
	complexity_max = DEFAULT_MAX_COMPLEXITY - 1
	charge_drain = DEFAULT_CHARGE_DRAIN * 1.5
	allowed_suit_storage = list(
		/obj/item/flashlight,
		/obj/item/tank/internals,
		/obj/item/ammo_box,
		/obj/item/ammo_casing,
		/obj/item/restraints/handcuffs,
		/obj/item/assembly/flash,
		/obj/item/melee/baton,
		/obj/item/knife/combat,
		/obj/item/shield/riot,
		/obj/item/gun,
	)
	variants = list(
		"rim_inspector" = list(
			MOD_ICON_OVERRIDE = 'modular_tianguan/modules/faction_heliostatic/assets/modules/novaya_ert/icons/mod.dmi',
			MOD_WORN_ICON_OVERRIDE = 'modular_tianguan/modules/faction_heliostatic/assets/modules/novaya_ert/icons/wornmod.dmi',
			/obj/item/clothing/head/mod = list(
				UNSEALED_LAYER = HEAD_LAYER,
				UNSEALED_CLOTHING = SNUG_FIT,
				SEALED_CLOTHING = THICKMATERIAL|STOPSPRESSUREDAMAGE,
				SEALED_INVISIBILITY =  HIDEFACIALHAIR|HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT,
				SEALED_COVER = HEADCOVERSMOUTH|HEADCOVERSEYES|PEPPERPROOF,
				UNSEALED_MESSAGE = HELMET_UNSEAL_MESSAGE,
				SEALED_MESSAGE = HELMET_SEAL_MESSAGE,
			),
			/obj/item/clothing/suit/mod = list(
				UNSEALED_CLOTHING = THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
				SEALED_INVISIBILITY = HIDEJUMPSUIT|HIDETAIL,
				UNSEALED_MESSAGE = CHESTPLATE_UNSEAL_MESSAGE,
				SEALED_MESSAGE = CHESTPLATE_SEAL_MESSAGE,
			),
			/obj/item/clothing/gloves/mod = list(
				UNSEALED_CLOTHING = THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
				UNSEALED_MESSAGE = GAUNTLET_UNSEAL_MESSAGE,
				SEALED_MESSAGE = GAUNTLET_SEAL_MESSAGE,
			),
			/obj/item/clothing/shoes/mod = list(
				UNSEALED_CLOTHING = THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
				UNSEALED_MESSAGE = BOOT_UNSEAL_MESSAGE,
				SEALED_MESSAGE = BOOT_SEAL_MESSAGE,
			),
		),
	)

/datum/armor/mod_theme_rim_inspector
	melee = 40
	bullet = 50
	laser = 30
	energy = 30
	bomb = 60
	bio = 100
	fire = 75
	acid = 75
	wound = 20

/obj/item/mod/control/pre_equipped/rim_inspector
	theme = /datum/mod_theme/rim_inspector
	applied_modules = list(
		/obj/item/mod/module/storage/large_capacity,
		/obj/item/mod/module/thermal_regulator,
		/obj/item/mod/module/status_readout/operational,
		/obj/item/mod/module/tether,
		/obj/item/mod/module/flashlight,
		/obj/item/mod/module/paper_dispenser,
		/obj/item/mod/module/magnetic_harness
	)
	default_pins = list(
		/obj/item/mod/module/tether,
		/obj/item/mod/module/magboot,
	)

/obj/item/mod/control/pre_equipped/rim_inspector/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_ZCM)

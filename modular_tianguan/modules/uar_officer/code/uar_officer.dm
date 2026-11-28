/**
 * 团结联盟审查官服饰与装备（UAR_OFFICER）
 */

#define UAR_OBJ_ICON     'modular_tianguan/modules/uar_officer/icons/uar_clothing_obj.dmi'
#define UAR_WORN_ICON    'modular_tianguan/modules/uar_officer/icons/uar_worn.dmi'
#define UAR_CARD_ICON    'modular_tianguan/modules/uar_officer/icons/uar_card.dmi'
/// secHUD 图标（职业列表 / 角色旁边那个小图标用的图集；缺了它会去默认 hud.dmi 找同名状态 ⇒ 显示成别的图标）
#define UAR_HUD_ICON     'modular_tianguan/modules/uar_officer/icons/uar_hud.dmi'
#define UAR_FLAG_ICON    'modular_tianguan/modules/uar_officer/icons/uar_flags.dmi'

#define UAR_TIER3_ARMOR /datum/armor/uar_tier3
/datum/armor/uar_tier3
	bullet = 30
	laser = 30
	bomb = 30

#define UAR_GLOVES_ARMOR /datum/armor/uar_gloves
/datum/armor/uar_gloves
	bio = 30
	fire = 50
	acid = 50

// ———————————————————————————————— 制服（防火防酸）
/obj/item/clothing/under/uar_uniform
	name = "团结联盟行政装"
	desc = "标准太空公务员装扮，只为人类设计的款式。"
	icon = UAR_OBJ_ICON
	icon_state = "uar_uniform"
	worn_icon = UAR_WORN_ICON
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	can_adjust = FALSE
	resistance_flags = FIRE_PROOF | ACID_PROOF

// ———————————————————————————————— 公务员帽
/obj/item/clothing/head/uar_cap
	name = "团结联盟公务员帽"
	desc = "是你曾在军中服役的最好证明，国家允许你保留的军帽。下士的军徽在岁月的侵蚀下略有掉色。"
	icon = UAR_OBJ_ICON
	icon_state = "uar_hat"
	worn_icon = UAR_WORN_ICON
	armor_type = UAR_TIER3_ARMOR

// ———————————————————————————————— 礼仪手套
/obj/item/clothing/gloves/uar_gloves
	name = "行政手套"
	desc = "国家配发的礼仪手套，在工作中表现的更绅士。"
	icon = UAR_OBJ_ICON
	icon_state = "uar_gloves"
	worn_icon = UAR_WORN_ICON
	armor_type = UAR_GLOVES_ARMOR
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT

// ———————————————————————————————— 祖国靴
/obj/item/clothing/shoes/uar_boots
	name = "祖国靴"
	desc = "国家配发的制式军靴，鞋跟敲在地板上像在阅兵。"
	icon = UAR_OBJ_ICON
	icon_state = "uar_boots"
	worn_icon = UAR_WORN_ICON
	armor_type = UAR_TIER3_ARMOR
	fastening_type = SHOES_SLIPON
	body_parts_covered = FEET | LEGS

// ———————————————————————————————— 耳机 ×2
/obj/item/radio/headset/heads/uar_inspector
	name = "团结联盟战术耳机"
	desc = "团结联盟配发的战术通讯耳机，频道与纳米传讯顾问同级。"
	icon = UAR_OBJ_ICON
	icon_state = "uar_headset"
	worn_icon = UAR_WORN_ICON
	worn_icon_state = "uar_headset"
	keyslot = new /obj/item/encryptionkey/uar/com
	keyslot2 = new /obj/item/encryptionkey/uar/ccrep

/obj/item/radio/headset/heads/uar_inspector/alt
	name = "团结联盟战术耳机（防闪）"
	desc = "团结联盟配发的战术通讯耳机，耳罩能挡住闪光弹。"
	icon_state = "uar_headset"

/obj/item/radio/headset/heads/uar_inspector/alt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))

// ———————————————————————————————— 行政 PDA
/obj/item/modular_computer/pda/uar_inspector
	name = "团结联盟审查官PDA"
	desc = "团结联盟配发的行政助理机，深红色涂装，背面压着联盟的星徽。"
	greyscale_config = /datum/greyscale_config/tablet
	greyscale_colors = "#8b0000#3a0a0a"
	inserted_disk = /obj/item/disk/computer/command/captain
	inserted_item = /obj/item/pen/red

// ———————————————————————————————— ID 卡 + 卡面徽记 + secHUD
/obj/item/card/id/advanced/uar_admin
	name = "行政ID"
	desc = "UAR政府配备的标准行政ID卡。"
	icon = UAR_CARD_ICON
	icon_state = "card_uar_admin"
	assigned_icon_state = "assigned_uar_admin"
	trim = /datum/id_trim/job/uar_inspector

/datum/id_trim/job/uar_inspector
	assignment = JOB_UAR_INSPECTOR
	trim_icon = UAR_CARD_ICON
	trim_state = "trim_uar_inspector"
	department_color = UAR_DEPARTMENT_COLOR
	subdepartment_color = "#1f3a8a"
	sechud_icon = UAR_HUD_ICON
	sechud_icon_state = "huduar_inspector"
	job = /datum/job/uar_inspector

/datum/id_trim/job/uar_inspector/New()
	. = ..()
	var/datum/job/ntc = SSjob.get_job_type(/datum/job/nanotrasen_consultant)
	if(!ntc)
		log_world("UAR_OFFICER: ⚠ 找不到 /datum/job/nanotrasen_consultant，行政ID 未套用 NTC 权限")
		return
	for(var/trim_path in SSid_access.trim_singletons_by_path)
		var/datum/id_trim/any_trim = SSid_access.trim_singletons_by_path[trim_path]
		if(!istype(any_trim, /datum/id_trim/job))
			continue
		var/datum/id_trim/job/trims = any_trim
		if(trims.job != ntc)
			continue
		minimal_access = trims.minimal_access.Copy()
		extra_access = trims.extra_access.Copy()
		minimal_wildcard_access = trims.minimal_wildcard_access.Copy()
		extra_wildcard_access = trims.extra_wildcard_access.Copy()
		template_access = trims.template_access?.Copy()
		minimal_access += ACCESS_WEAPONS
		refresh_trim_access()
		return
	log_world("UAR_OFFICER: ⚠ 没找到 NTC 的 id_trim 单例，行政ID 未套用 NTC 权限")

// ———————————————————————————————— 两面旗帜（结构态 + 可携带折叠态）
/obj/structure/sign/flag/uar
	name = "团结联盟共和国国旗"
	desc = "团结联盟共和国的国旗。深红底、金黄镶边，中央是联盟的蓝星徽记。"
	icon = UAR_FLAG_ICON
	icon_state = "flag_uar"
	item_flag = /obj/item/sign/flag/uar

/obj/item/sign/flag/uar
	name = "折叠的团结联盟共和国国旗"
	desc = "叠好的团结联盟共和国国旗，插到墙上就会展开。"
	icon = UAR_FLAG_ICON
	icon_state = "folded_uar"
	sign_path = /obj/structure/sign/flag/uar

/obj/structure/sign/flag/wsr
	name = "世界社会主义共和国国旗"
	desc = "世界社会主义共和国的国旗。"
	icon = UAR_FLAG_ICON
	icon_state = "flag_wsr"
	item_flag = /obj/item/sign/flag/wsr

/obj/item/sign/flag/wsr
	name = "折叠的世界社会主义共和国国旗"
	desc = "叠好的世界社会主义共和国国旗，插到墙上就会展开。"
	icon = UAR_FLAG_ICON
	icon_state = "folded_wsr"
	sign_path = /obj/structure/sign/flag/wsr

// ———————————————————————————————— 货舱订购
/datum/supply_pack/companies/general
	group = "★ General"

/datum/supply_pack/companies/general/uar_flag
	name = "团结联盟共和国国旗"
	contains = list(/obj/item/sign/flag/uar)
	cost = CARGO_MINIMUM_COST

/datum/supply_pack/companies/general/wsr_flag
	name = "世界社会主义共和国国旗"
	contains = list(/obj/item/sign/flag/wsr)
	cost = CARGO_MINIMUM_COST

// ———————————————————————————————— 团结联盟印章（可盖在公文上）
#define UAR_STAMP_SPRITE "uar_stamp"

/// 继承上游 `/obj/item/stamp` ⇒ 盖公文那一整套机制照常可用：左键点纸张（读不了字时盲盖）、
/// 右键速盖、`get_writing_implement_details()` 走 `MODE_STAMPING`。
/// 三处贴图分工：
///   · **物品图标** —— 沿用上游红色印章 `stamp-hos`（安保主管那枚，红章体）；
///   · **纸张物品图标上的小印记** —— `add_stamp()` 取 `paper_<icon_state>` = 上游 `paper_stamp-hos`（红色斜矩形）；
///   · **纸面窗口**（TGUI PaperSheet）里的大印记 —— 模块自带的联盟印章图 `icons/stamp_uar.png`
///     （121×54，与上游印章同画布、1:1 原样；试过 2 倍会被判「太大」），
///     走 stamps 精灵表的 `"uar_stamp"` 条目（那一行在 `code/modules/asset_cache/assets/paper.dm`，带 TIANGUAN EDIT 标记）。
/obj/item/stamp/uar
	name = "团结联盟印章"
	desc = "团结联盟在此星区合法授权的凭证。\n章身铭刻——“祖国万岁”"
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "stamp-hos"
	// 与上游安保主管印章同档（洗衣机的染色登记位，本仓对 stamp 没有别的消费点）
	dye_color = DYE_HOS

/// 物品图标和纸张叠图沿用红章，纸面窗口单独使用联盟章图。
/obj/item/stamp/uar/get_writing_implement_details()
	. = ..()
	var/datum/asset/spritesheet/simple/stamps/sheet = get_asset_datum(/datum/asset/spritesheet/simple/stamps)
	.["stamp_class"] = sheet.icon_class_name(UAR_STAMP_SPRITE)

/obj/item/stamp/chameleon/get_writing_implement_details()
	. = ..()
	// 安保主管章和联盟章共用物品图标，按变色龙当前选择区分纸面印记。
	var/datum/action/item_action/chameleon/change/stamp/disguise = locate() in actions
	if(disguise?.active_type == /obj/item/stamp/uar)
		var/datum/asset/spritesheet/simple/stamps/sheet = get_asset_datum(/datum/asset/spritesheet/simple/stamps)
		.["stamp_class"] = sheet.icon_class_name(UAR_STAMP_SPRITE)

/// 静默失败守卫：精灵表缺条目不会报错，只会「纸上盖了、点开纸张窗口一片空白」，所以点名一次。
/obj/item/stamp/uar/Initialize(mapload)
	. = ..()
	var/static/checked = FALSE
	if(checked)
		return
	checked = TRUE
	var/datum/asset/spritesheet/simple/stamps/sheet = get_asset_datum(/datum/asset/spritesheet/simple/stamps)
	if(!sheet || !sheet.assets[UAR_STAMP_SPRITE] || !get_writing_implement_details()["stamp_class"])
		log_world("UAR_OFFICER: ⚠ stamps 精灵表里没有可用的 \"uar_stamp\" 条目（code/modules/asset_cache/assets/paper.dm），纸面窗口里盖不出印章印记")

#undef UAR_STAMP_SPRITE

// ———————————————————————————————— 职业套装
/datum/outfit/job/uar_inspector
	name = JOB_UAR_INSPECTOR
	jobtype = /datum/job/uar_inspector
	implants = list(/obj/item/implant/mindshield)

	id = /obj/item/card/id/advanced/uar_admin
	id_trim = /datum/id_trim/job/uar_inspector
	uniform = /obj/item/clothing/under/uar_uniform
	head = /obj/item/clothing/head/uar_cap
	gloves = /obj/item/clothing/gloves/uar_gloves
	shoes = /obj/item/clothing/shoes/uar_boots
	ears = /obj/item/radio/headset/heads/uar_inspector
	belt = /obj/item/modular_computer/pda/uar_inspector
	backpack_contents = list(
		/obj/item/sign/flag/uar = 1,
		/obj/item/choice_beacon/uar = 1,
		/obj/item/stamp/uar = 1,
	)

// ———————————————————————————————— 指挥售货机（追加到 zzplurt_products & 分类，保留既有商品）
/obj/machinery/vending/wardrobe/cent_wardrobe/Initialize(mapload)
	var/static/list/uar_wardrobe_products = list(
		/obj/item/clothing/under/uar_uniform = 3,
		/obj/item/clothing/head/uar_cap = 3,
		/obj/item/clothing/gloves/uar_gloves = 3,
		/obj/item/clothing/shoes/uar_boots = 3,
	)
	LAZYINITLIST(zzplurt_products)
	zzplurt_products += uar_wardrobe_products
	LAZYINITLIST(zzplurt_product_categories)
	zzplurt_product_categories += list(list(
		"name" = "Union of Allied Republics",
		"icon" = "star",
		"products" = uar_wardrobe_products.Copy(),
	))
	return ..()

// ———————————————————————————————— 武器召唤信标（适配 SPLURT-zh 武器箱路径）
/obj/item/storage/toolbox/guncase/skyrat/pistol/trappiste_small_case/uar_double_pistol
	name = "团结联盟 585 手枪双持组"
	desc = "一只贴着团结联盟封条的小枪箱：两把 .585 Trappiste 手枪、两个备用弹夹与一盒散装弹药。"

/obj/item/storage/toolbox/guncase/skyrat/pistol/trappiste_small_case/uar_double_pistol/PopulateContents()
	..()
	for(var/i in 1 to 2)
		new /obj/item/gun/ballistic/automatic/pistol/trappiste/no_mag(src)
		new /obj/item/ammo_box/magazine/c585trappiste_pistol(src)
	new /obj/item/ammo_box/c585trappiste(src)

/obj/item/storage/toolbox/guncase/skyrat/pistol/trappiste_small_case/uar_revolver
	name = "团结联盟 左轮手枪组"
	desc = "一只贴着团结联盟封条的小枪箱：一把 Takbok 左轮与备用 .585 弹药盒。"

/obj/item/storage/toolbox/guncase/skyrat/pistol/trappiste_small_case/uar_revolver/PopulateContents()
	..()
	new /obj/item/gun/ballistic/revolver/takbok(src)
	for(var/i in 1 to 2)
		new /obj/item/ammo_box/c585trappiste(src)

/obj/item/choice_beacon/uar
	name = "团结联盟武器信标"
	desc = "一次性信标，用来申请一套武器。请在办公室内使用。"
	icon = 'icons/obj/devices/remote.dmi'
	icon_state = "generic_delivery"
	inhand_icon_state = "generic_delivery"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	company_source = "团结联盟"
	company_message = span_bold("补给舱正在降落，请远离落点。")

/obj/item/choice_beacon/uar/generate_display_names()
	var/static/list/selectable_gun_types = list(
		"两把 585 手枪 + 两个弹夹 + 备弹" = /obj/item/storage/toolbox/guncase/skyrat/pistol/trappiste_small_case/uar_double_pistol,
		"一把左轮 + 两盒备用弹药" = /obj/item/storage/toolbox/guncase/skyrat/pistol/trappiste_small_case/uar_revolver,
	)
	return selectable_gun_types

// ———————————————————————————————— 无线电：团结联盟频道（:ua）
/obj/item/encryptionkey/uar
	name = "团结联盟频道加密钥匙"
	desc = "只挂团结联盟频道（:ua）的加密钥匙。"
	channels = list(RADIO_CHANNEL_UAR = 1)
	special_channels = RADIO_SPECIAL_UAR

/obj/item/encryptionkey/uar/com
	name = "团结联盟指挥频道加密钥匙"
	channels = list(RADIO_CHANNEL_UAR = 1, RADIO_CHANNEL_COMMAND = 1)

/obj/item/encryptionkey/uar/ccrep
	name = "团结联盟中央指挥部加密钥匙"
	channels = list(RADIO_CHANNEL_UAR = 1, RADIO_CHANNEL_CENTCOM = 1, RADIO_CHANNEL_SECURITY = 1)

/obj/item/encryptionkey/uar/all_band
	name = "团结联盟全频段加密钥匙"
	desc = "同时接入所有部门频道、AI 私有频道、纳米中央指挥部频道与团结联盟频道（:ua）的加密钥匙。"
	special_channels = RADIO_SPECIAL_CENTCOM | RADIO_SPECIAL_UAR
	channels = list(
		RADIO_CHANNEL_UAR = 1,
		RADIO_CHANNEL_COMMAND = 1,
		RADIO_CHANNEL_SECURITY = 1,
		RADIO_CHANNEL_ENGINEERING = 1,
		RADIO_CHANNEL_SCIENCE = 1,
		RADIO_CHANNEL_MEDICAL = 1,
		RADIO_CHANNEL_SUPPLY = 1,
		RADIO_CHANNEL_SERVICE = 1,
		RADIO_CHANNEL_ENTERTAINMENT = 1,
		RADIO_CHANNEL_AI_PRIVATE = 1,
		RADIO_CHANNEL_CENTCOM = 1,
	)

/obj/item/radio/headset/heads/uar_inspector/all_band
	name = "团结联盟全频段战争耳机"
	desc = "团结联盟制式全频段战争耳机：可收听全部部门频道、AI 私有频道、纳米中央指挥部频道，以及团结联盟频道（:ua）。"
	keyslot = new /obj/item/encryptionkey/uar/all_band
	keyslot2 = null

#undef UAR_OBJ_ICON
#undef UAR_WORN_ICON
#undef UAR_CARD_ICON
#undef UAR_HUD_ICON
#undef UAR_HUD_ICON
#undef UAR_FLAG_ICON
#undef UAR_TIER3_ARMOR
#undef UAR_GLOVES_ARMOR

/**
 * 模块：admin_id_editor —— 管理员「ID 卡编辑器」（从「秘密」面板进入）
 *
 * 想解决的事：管理员要临时造一张特殊身份卡（ERT/联盟/调查员…），原版只能靠 spawn 出来的
 * 模板卡再手改 var，权限还得一个个 add_access。这里给一个面板：挑卡面外观 → 挑印记（id_trim）
 * → 填姓名/职位/介绍 → 勾权限（权限表与人事主管控制台同一份 `SSid_access` 数据）→ 一键生成。
 *
 * 复用而非重写：
 *   · 卡面外观 = `icons/obj/card.dmi` 里既有的 `card_*` 状态（原样拼 icon_state）；
 *   · 印记     = `/datum/id_trim` 全部单例（`SSid_access.trim_singletons_by_path`），
 *                盖章/部门色/职位徽记全部由 `apply_trim_to_card()` 现成的逻辑上；
 *   · 权限     = `SSid_access.all_region_access_tgui`（人事主管控制台用的同一份中文权限表）；
 *   · 默认     = `/datum/id_trim/centcom/ert`（ERT 的权限就是这张 trim 的 access）。
 *
 * 生成的卡是**真正的** `/obj/item/card/id/advanced`，因此银行卡、安检 HUD、门禁全照常。
 */

#define ID_EDITOR_ICON 'icons/obj/card.dmi'
#define ID_EDITOR_DEFAULT_TRIM /datum/id_trim/centcom/ert
/// 面板里展示的权限分区（站内 + 中央；辛迪加/外域不给，避免一勾就把家底全开）
#define ID_EDITOR_ACCESS_REGIONS list(REGION_CENTCOM, REGION_COMMAND, REGION_GENERAL, REGION_SECURITY, REGION_MEDBAY, REGION_RESEARCH, REGION_ENGINEERING, REGION_SUPPLY)

/// 可选卡面：每条 = 一个「图标文件 + 状态」；天关自己的卡（团结联盟行政ID）用自己的 dmi
/proc/tianguan_id_card_appearances()
	var/static/list/appearances = list(
		list("name" = "团结联盟行政ID", "icon" = 'modular_tianguan/modules/uar_officer/icons/uar_card.dmi',
			"state" = "card_uar_admin", "assigned" = "assigned_uar_admin"),
		list("name" = "中央", "icon" = ID_EDITOR_ICON, "state" = "card_centcom"),
		list("name" = "标准灰", "icon" = ID_EDITOR_ICON, "state" = "card_grey"),
		list("name" = "银色", "icon" = ID_EDITOR_ICON, "state" = "card_silver"),
		list("name" = "白金", "icon" = ID_EDITOR_ICON, "state" = "card_platinum"),
		list("name" = "金色", "icon" = ID_EDITOR_ICON, "state" = "card_gold"),
		list("name" = "黑色", "icon" = ID_EDITOR_ICON, "state" = "card_black"),
		list("name" = "烈焰", "icon" = ID_EDITOR_ICON, "state" = "card_flame"),
		list("name" = "彩虹", "icon" = ID_EDITOR_ICON, "state" = "card_rainbow"),
		list("name" = "鲤鱼", "icon" = ID_EDITOR_ICON, "state" = "card_carp"),
		list("name" = "驴登", "icon" = ID_EDITOR_ICON, "state" = "card_donk"),
	)
	return appearances

/datum/id_card_editor
	var/client/holder
	var/card_icon = ID_EDITOR_ICON
	var/card_icon_state = "card_centcom"
	var/assigned_icon_state_override
	var/trim_path = ID_EDITOR_DEFAULT_TRIM
	var/registered_name = "ERT 特工"
	var/assignment = "Emergency Response Team Intern"
	var/desc = "应急响应队身份卡。"
	var/list/access = list()
	/// 预览用的离场卡（不进地图），每次改动重新合成
	var/obj/item/card/id/advanced/preview_card
	var/preview_cache

/datum/id_card_editor/New(client/user)
	holder = user
	reset_to_ert()

/datum/id_card_editor/Destroy()
	QDEL_NULL(preview_card)
	holder = null
	return ..()

/// 回到「ERT 默认」：卡面中央、印记 ERT、权限照抄 ERT 那张 trim
/datum/id_card_editor/proc/reset_to_ert()
	var/datum/id_trim/ert = SSid_access.trim_singletons_by_path[ID_EDITOR_DEFAULT_TRIM]
	trim_path = ID_EDITOR_DEFAULT_TRIM
	card_icon = ID_EDITOR_ICON
	card_icon_state = "card_centcom"
	assigned_icon_state_override = null
	registered_name = "ERT 特工"
	assignment = ert?.assignment || "Emergency Response Team"
	desc = "应急响应队身份卡。"
	access = ert ? ert.access.Copy() : list()
	invalidate_preview()

/datum/id_card_editor/proc/invalidate_preview()
	preview_cache = null

/datum/id_card_editor/proc/trim_singleton()
	return SSid_access.trim_singletons_by_path[trim_path]

/// 预览与生成共用：把面板上的设置写进一张卡
/datum/id_card_editor/proc/apply_to_card(obj/item/card/id/advanced/card)
	card.icon = card_icon
	card.icon_state = card_icon_state
	if(assigned_icon_state_override)
		card.assigned_icon_state = assigned_icon_state_override
	// 先按 trim 铺徽记/部门色（顺带带出 trim 的默认权限），再覆盖成本面板里勾的权限
	if(trim_path)
		SSid_access.apply_trim_to_card(card, trim_path)
	else
		card.trim = null
	card.access = access.Copy()
	card.registered_name = registered_name
	card.assignment = assignment
	card.desc = desc
	card.update_label()
	card.update_appearance()

/datum/id_card_editor/proc/get_preview()
	if(preview_cache)
		return preview_cache
	if(!preview_card)
		preview_card = new /obj/item/card/id/advanced(null)
	apply_to_card(preview_card)
	preview_cache = icon2base64(getFlatIcon(preview_card, no_anim = TRUE))
	return preview_cache

/datum/id_card_editor/ui_state(mob/user)
	return ADMIN_STATE(R_ADMIN)

/datum/id_card_editor/ui_close()
	qdel(src)

/datum/id_card_editor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TianGuanIdCardEditor")
		ui.open()

/datum/id_card_editor/ui_data(mob/user)
	var/list/data = list()

	var/list/appearances = list()
	var/list/palette = tianguan_id_card_appearances()
	for(var/i in 1 to length(palette))
		var/list/entry = palette[i]
		appearances += list(list(
			"index" = i,
			"state" = entry["state"],
			"name" = entry["name"],
			"selected" = (entry["state"] == card_icon_state && entry["icon"] == card_icon),
			"icon" = icon2base64(icon(entry["icon"], entry["state"])),
		))
	data["appearances"] = appearances

	// 印记：按 CentCom / 站点职业 / 其它 三组列，只给名字（徽记看预览卡就够了，省流量）
	var/list/groups = list(
		"CENTCOM" = list("name" = "中央 / ERT", "trims" = list()),
		"JOB" = list("name" = "站点职业", "trims" = list()),
		"OTHER" = list("name" = "其它", "trims" = list()),
	)
	for(var/path in SSid_access.trim_singletons_by_path)
		var/datum/id_trim/trim = SSid_access.trim_singletons_by_path[path]
		if(!trim?.trim_state || !trim.assignment)
			continue
		var/key = findtext("[path]", "/datum/id_trim/centcom") == 1 ? "CENTCOM" : (findtext("[path]", "/datum/id_trim/job/") == 1 ? "JOB" : "OTHER")
		groups[key]["trims"] += list(list("path" = "[path]", "name" = trim.assignment))
	data["trim_groups"] = list(groups["CENTCOM"], groups["JOB"], groups["OTHER"])

	var/list/access_groups = list()
	for(var/region in ID_EDITOR_ACCESS_REGIONS)
		var/list/region_data = SSid_access.all_region_access_tgui[region]
		if(!length(region_data))
			continue
		access_groups += list(list("name" = region, "accesses" = region_data[1]["accesses"]))
	data["access_groups"] = access_groups

	data["card_icon_state"] = card_icon_state
	data["trim_path"] = trim_path ? "[trim_path]" : ""
	data["trim_name"] = trim_singleton()?.assignment
	data["registered_name"] = registered_name
	data["assignment"] = assignment
	data["desc"] = desc
	data["access"] = access
	data["preview"] = get_preview()
	return data

/datum/id_card_editor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("set_appearance")
			var/list/palette = tianguan_id_card_appearances()
			var/index = text2num(params["index"])
			if(!index || index > length(palette))
				return TRUE
			var/list/entry = palette[index]
			card_icon = entry["icon"]
			card_icon_state = entry["state"]
			assigned_icon_state_override = entry["assigned"]
		if("clear_trim")
			trim_path = null
			return TRUE
		if("set_trim")
			var/path = text2path(params["path"])
			if(!path || !SSid_access.trim_singletons_by_path[path])
				return TRUE
			trim_path = path
			var/datum/id_trim/picked = trim_singleton()
			if(picked)
				assignment = picked.assignment || assignment
				access = picked.access.Copy()
		if("set_field")
			var/value = copytext_char(params["value"], 1, 128)
			switch(params["field"])
				if("name")
					registered_name = value
				if("assignment")
					assignment = value
				if("desc")
					desc = copytext_char(params["value"], 1, 512)
		if("toggle_access")
			var/ref = params["ref"]
			if(!ref)
				return TRUE
			if(ref in access)
				access -= ref
			else
				access += ref
		if("clear_access")
			access = list()
		if("reset_ert")
			reset_to_ert()
			return TRUE
		if("generate")
			return generate_card()
		else
			return FALSE
	invalidate_preview()
	return TRUE

/datum/id_card_editor/proc/generate_card()
	if(!holder?.mob)
		return TRUE
	var/turf/target = get_turf(holder.mob)
	var/obj/item/card/id/advanced/card = new(target)
	apply_to_card(card)
	log_admin("[key_name(holder)] 用 ID 卡编辑器生成了一张卡：[registered_name] / [assignment] / [length(access)] 项权限")
	message_admins("[key_name_admin(holder)] 生成了一张自定义 ID 卡（[registered_name] / [assignment]，[length(access)] 项权限）")
	return TRUE

/// 「秘密」面板的挂钩：面板里点按钮 → action = "id_card_editor"
/proc/tianguan_id_editor_ui_act(action, list/params, client/holder)
	if(action != "id_card_editor")
		return FALSE
	if(!check_rights(R_ADMIN, FALSE))
		to_chat(holder, span_warning("ID 卡编辑器需要管理员权限（R_ADMIN）。"))
		log_world("ADMIN_ID_EDITOR: [key_name(holder)] 请求打开面板但缺少 R_ADMIN")
		return TRUE
	log_world("ADMIN_ID_EDITOR: [key_name(holder)] 打开面板")
	var/datum/id_card_editor/editor = new(holder)
	editor.ui_interact(holder.mob)
	return TRUE

#undef ID_EDITOR_ICON
#undef ID_EDITOR_DEFAULT_TRIM
#undef ID_EDITOR_ACCESS_REGIONS

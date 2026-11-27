// THIS IS A TIANGUAN MODULE FILE
// 模块：liquid_siphon —— 轻量化液体虹吸器

/// 范围等级 → 边长（格）
#define SIPHON_RANGE_SIDES list(1, 3, 5, 7)
/// 速率等级 → 单位/秒（每格）
#define SIPHON_RATES list(10, 25, 50, 100)
/// 耗电：每 3 秒 1 kJ（标准电池 10 kJ ⇒ 约 30 秒）
#define SIPHON_JOULES_PER_SECOND (1000 / 3.0)
/// 等级上限（= 四级零件）
#define SIPHON_MAX_TIER 4

/obj/machinery/light_liquid_siphon
	name = "轻量化液体虹吸器"
	desc = "中华联合工业发明，与纳米传讯合作进行便携化改造的设备。其前身是用于海洋世界行星改造工程的特种设备。开启后可快速吸取并消除泄露的液体"
	icon = 'modular_tianguan/modules/liquid_siphon/icons/liquid_siphon.dmi'
	icon_state = "siphon"
	density = TRUE
	anchored = FALSE
	layer = ABOVE_OBJ_LAYER
	use_power = NO_POWER_USE
	max_integrity = 250
	circuit = /obj/item/circuitboard/machine/light_liquid_siphon
	interaction_flags_click = NEED_DEXTERITY
	var/on = FALSE
	var/obj/item/stock_parts/power_store/cell/cell
	var/range_tier = 1
	var/rate_tier = 1
	var/max_range_tier = 1
	var/max_rate_tier = 1

/obj/machinery/light_liquid_siphon/RefreshParts()
	. = ..()
	var/range_total = 0
	var/range_count = 0
	var/bin_total = 0
	var/bin_count = 0
	for(var/datum/stock_part/scanning_module/scanner in component_parts)
		range_total += scanner.tier
		range_count++
	for(var/datum/stock_part/matter_bin/bin in component_parts)
		bin_total += bin.tier
		bin_count++
	max_range_tier = clamp(range_count ? FLOOR(range_total / range_count, 1) : 1, 1, SIPHON_MAX_TIER)
	max_rate_tier = clamp(bin_count ? FLOOR(bin_total / bin_count, 1) : 1, 1, SIPHON_MAX_TIER)
	range_tier = clamp(range_tier, 1, max_range_tier)
	rate_tier = clamp(rate_tier, 1, max_rate_tier)

/obj/machinery/light_liquid_siphon/update_icon_state()
	icon_state = "[initial(icon_state)]_[on]"
	return ..()

/obj/machinery/light_liquid_siphon/examine(mob/user)
	. = ..()
	. += span_notice("当前状态：[on ? "运行中" : "已停止"]。")
	. += span_notice("电量：[cell ? "[round(cell.percent())]%" : "无电池"]。")
	. += span_notice("当前范围 [SIPHON_RANGE_SIDES[range_tier] == 1 ? "仅本格" : "[SIPHON_RANGE_SIDES[range_tier]]×[SIPHON_RANGE_SIDES[range_tier]]"]、速率 [SIPHON_RATES[rate_tier]] 单位/秒。")

/obj/machinery/light_liquid_siphon/process(seconds_per_tick)
	if(!on)
		return
	if(!is_operational)
		turn_off()
		return
	if(!cell || !cell.use(seconds_per_tick * SIPHON_JOULES_PER_SECOND))
		visible_message(span_warning("[src] 的电池耗尽了。"))
		turn_off()
		return
	var/turf/center = get_turf(src)
	if(!center)
		return
	var/side = SIPHON_RANGE_SIDES[range_tier]
	var/radius = max((side - 1) / 2, 0)
	var/per_tile = SIPHON_RATES[rate_tier] * seconds_per_tick
	for(var/turf/target as anything in RANGE_TURFS(radius, center))
		siphon_turf(target, per_tile)

/obj/machinery/light_liquid_siphon/proc/siphon_turf(turf/target, amount)
	if(!target?.liquids || !target.liquids.total_reagents)
		return 0
	var/taken = min(amount, target.liquids.total_reagents)
	if(taken <= 0)
		return 0
	var/datum/reagents/pulled = target.liquids.take_reagents_flat(taken)
	if(!pulled)
		return 0
	. = pulled.total_volume
	qdel(pulled)

/obj/machinery/light_liquid_siphon/proc/turn_on()
	if(on)
		return
	on = TRUE
	START_PROCESSING(SSmachines, src)
	update_appearance()

/obj/machinery/light_liquid_siphon/proc/turn_off()
	if(!on)
		return
	on = FALSE
	STOP_PROCESSING(SSmachines, src)
	update_appearance()

/obj/machinery/light_liquid_siphon/proc/toggle()
	if(on)
		turn_off()
	else
		turn_on()

/obj/machinery/light_liquid_siphon/proc/eject_cell(mob/user)
	if(!cell)
		return FALSE
	var/obj/item/stock_parts/power_store/cell/ejected = cell
	cell = null
	ejected.add_fingerprint(user)
	if(!user || !user.put_in_hands(ejected))
		ejected.forceMove(drop_location())
	update_appearance()
	return TRUE

/obj/machinery/light_liquid_siphon/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	ui_interact(user)

/obj/machinery/light_liquid_siphon/wrench_act(mob/living/user, obj/item/tool)
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/light_liquid_siphon/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/stock_parts/power_store/cell))
		return ..()
	if(cell)
		balloon_alert(user, "已有电池！")
		return ITEM_INTERACT_BLOCKING
	if(!user.transferItemToLoc(tool, src))
		return ITEM_INTERACT_BLOCKING
	cell = tool
	cell.add_fingerprint(user)
	balloon_alert(user, "已装入电池")
	update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/machinery/light_liquid_siphon/Destroy()
	turn_off()
	if(cell)
		QDEL_NULL(cell)
	return ..()

/obj/machinery/light_liquid_siphon/on_deconstruction(disassembled)
	if(cell)
		cell.forceMove(drop_location())
		cell = null
	return ..()

/obj/machinery/light_liquid_siphon/ui_state(mob/user)
	return GLOB.physical_state

/obj/machinery/light_liquid_siphon/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TianGuanLiquidSiphon")
		ui.open()

/obj/machinery/light_liquid_siphon/ui_data(mob/user)
	return list(
		"on" = on,
		"has_cell" = !!cell,
		"cell_name" = cell ? cell.name : null,
		"cell_charge" = cell ? round(cell.percent()) : 0,
		"cell_raw" = cell ? round(cell.charge) : 0,
		"cell_max" = cell ? cell.maxcharge : 0,
		"range_tier" = range_tier,
		"rate_tier" = rate_tier,
		"max_range_tier" = max_range_tier,
		"max_rate_tier" = max_rate_tier,
		"range_sides" = SIPHON_RANGE_SIDES,
		"rates" = SIPHON_RATES,
	)

/obj/machinery/light_liquid_siphon/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("toggle")
			if(on)
				turn_off()
			else if(!cell)
				balloon_alert(usr, "没有电池！")
			else if(!is_operational)
				balloon_alert(usr, "机器无法运行！")
			else
				turn_on()
		if("set_range")
			range_tier = clamp(text2num(params["tier"]) || 1, 1, max_range_tier)
		if("set_rate")
			rate_tier = clamp(text2num(params["tier"]) || 1, 1, max_rate_tier)
		if("eject_cell")
			if(!eject_cell(usr))
				balloon_alert(usr, "没有电池！")
	return TRUE

/obj/item/circuitboard/machine/light_liquid_siphon
	name = "轻量化液体虹吸器电路板"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/light_liquid_siphon
	needs_anchored = FALSE
	req_components = list(
		/datum/stock_part/scanning_module = 3,
		/datum/stock_part/matter_bin = 3,
	)

/datum/design/board/light_liquid_siphon
	name = "轻量化液体虹吸器电路板"
	desc = "用于组装一台轻量化液体虹吸器。"
	build_path = /obj/item/circuitboard/machine/light_liquid_siphon
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ATMOS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/supply_pack/engineering/portasiphon
	name = "轻量化液体虹吸器采购箱"
	desc = "两台轻量化液体虹吸器。中华联合工业出品，开启后可快速吸取并消除地面上的泄漏液体；\
		范围与速率可由零件等级调节，适合处理大面积的液体泄漏事故。"
	cost = CARGO_CRATE_VALUE * 4.5
	access_view = ACCESS_ATMOSPHERICS
	contains = list(/obj/machinery/light_liquid_siphon = 2)
	crate_name = "轻量化液体虹吸器采购箱"
	crate_type = /obj/structure/closet/crate/secure/engineering/atmos

#undef SIPHON_RANGE_SIDES
#undef SIPHON_RATES
#undef SIPHON_JOULES_PER_SECOND
#undef SIPHON_MAX_TIER

/// 生产服漏翻日志（2026-11-03 ~ 11-05，16 局）里几类**整类**缺口的回归门禁，全部按运行期真实形态喂真目录：
///   ① 归一表冲突：`MOD control unit` / `\improper MOD control unit` 译文只差一个空格就被判歧义、两条都删；
///   ② 只剩字符串的「区域名 + 其余」合成名（空气警报负载里的通风口名）；
///   ③ 「数量/已译名 + 短语」前缀（订单清单 `1 Suit Storage Unit`、`食盐 large hypovial`）；
///   ④ 列表记号与多行拼接（指挥部状态摘要的站点特质、站点目标）；
///   ⑤ 空括号尾巴与纯数字前缀的实例名（身份卡、全息芯片）。
/// 每条都配反例，证明规则没有把普通句子劈开。locale 不是 zh-Hans 时跳过（见 i18n_zh_catalog_ready）。
/datum/unit_test/i18n_prod_misses
	var/saved_locale

/datum/unit_test/i18n_prod_misses/Destroy()
	if(!isnull(saved_locale))
		GLOB.i18n_server_locale = saved_locale
	return ..()

/datum/unit_test/i18n_prod_misses/Run()
	saved_locale = GLOB.i18n_server_locale
	if(!i18n_zh_catalog_ready())
		return
	GLOB.i18n_server_locale = LANGUAGE_LOCALE_ZH_HANS
	var/locale = LANGUAGE_LOCALE_ZH_HANS

	// Production round 1332: check the real type table used by examine and spawn search.
	var/obj/item/magazine = allocate(/obj/item/ammo_box/magazine/security/rocket)
	var/localized_magazine = magazine.lang_localize_desc_for_display(magazine.desc)
	TEST_ASSERT(findtext(localized_magazine, "纳米传讯") && !findtext(localized_magazine, "magazine"), "The full inherited description should be localized: [localized_magazine]")
	TEST_ASSERT(findtext(localized_magazine, "弹射"), "The child magazine must keep its own description")
	TEST_ASSERT(findtext(magazine.desc, "Nanotrasen"), "Displaying a description must preserve the original")
	var/cheer_desc = lang_type_display_text(/obj/item/clothing/under/costume/ba_cheerleader, lang_type_desc_keys())
	TEST_ASSERT(findtext(cheer_desc, "纳米传讯") && findtext(cheer_desc, "フレーフレー"), "The uniform should keep its printed Japanese slogan")
	TEST_ASSERT_EQUAL(lang_reverse_phrase_tgui("Destructive Plant Biomatter Scan"), "破坏性植物生物质扫描", "Experiment tag must resolve through the TGUI payload path")
	var/datum/experiment/ordnance/gaseous/plasma/experiment = new
	var/list/progress = experiment.check_progress()
	TEST_ASSERT_EQUAL(progress[1][2], "你必须使用 NT Frontier 应用发表一篇关于等离子体气体弹壳的论文。", "Experiment progress must include the translated experiment name")
	qdel(experiment)
	var/list/disposal_pipes = GLOB.disposal_pipe_recipes["Disposal Pipes"]
	var/datum/pipe_info/disposal/pipe = disposal_pipes[1]
	TEST_ASSERT_EQUAL(pipe.display_name(bent = TRUE), "弯管", "Pipe dispenser must localize the bent variant")
	TEST_ASSERT_EQUAL(pipe.name, "Pipe", "Recipe identity must survive display lookup")

	var/datum/candidate_poll/poll = new("Borer", "Poll question", 30 SECONDS)
	TEST_ASSERT_EQUAL(poll.response_messages[POLL_RESPONSE_SIGNUP], "你已报名担任皮质钻虫！稍后将随机选出一名候选人。", "Localize the response before substituting the role")
	TEST_ASSERT_EQUAL(poll.role, "Borer", "Ghost role preference keys must remain canonical")
	qdel(poll)

	// ① 运行期名字带 \improper 标记字节，只能落到归一表；两条同英文来源的译文只差空白。
	var/mod_name = "\improper MOD control unit"
	var/localized_mod = lang_reverse_text(mod_name)
	TEST_ASSERT(lang_contains_cjk(localized_mod), "归一表冲突（译文只差空白）不应让 MOD control unit 整条回落英文：[localized_mod]")
	TEST_ASSERT(lang_contains_cjk(lang_reverse_text("MOD Control Unit")), "大小写变体同样应落到归一表")

	// ② 区域名 + 其余（只剩字符串）。从本局地图里挑一个能翻、名字是多词的区域。
	var/area/sample_area
	var/localized_area
	for(var/area/candidate as anything in GLOB.areas)
		var/candidate_name = format_text(candidate.name)
		if(!findtext(candidate_name, " ") || findtext(candidate_name, "'"))
			continue
		var/candidate_localized = candidate.lang_localize_name_for_display(candidate.name)
		if(!lang_contains_cjk(candidate_localized))
			continue
		sample_area = candidate
		localized_area = candidate_localized
		break
	if(sample_area)
		var/area_name = format_text(sample_area.name)
		var/vent_name = "[area_name] 全色空气通风口 KULB2"
		var/localized_vent = lang_localize_chain(vent_name, locale, allow_template = TRUE)
		TEST_ASSERT_EQUAL(localized_vent, "[localized_area] 全色空气通风口 KULB2", "空气警报负载里的通风口名应翻区域前缀、保留已译类型名与 id")
		TEST_ASSERT_NULL(lang_reverse_area_prefixed("[area_name] zxqv quietly hums along", locale), "其余部分落不了地时不得把句子劈成半截")
	else
		TEST_NOTICE(src, "本局地图没有可翻的多词区域，跳过区域前缀断言")

	// ③ 前导数量 / 已译名。
	var/localized_order = lang_localize_chain("1 Suit Storage Unit", locale, allow_template = TRUE)
	TEST_ASSERT(findtext(localized_order, "1 ") == 1 && lang_contains_cjk(localized_order), "数量前缀 + 整串命中的短语应落地：[localized_order]")
	var/localized_delta = lang_localize_chain("+3 bluespace crystal", locale, allow_template = TRUE)
	TEST_ASSERT(findtext(localized_delta, "+3 ") == 1 && lang_contains_cjk(localized_delta), "增减前缀应落地：[localized_delta]")
	var/localized_vial = lang_localize_chain("食盐 large hypovial", locale, allow_template = TRUE)
	TEST_ASSERT(findtext(localized_vial, "食盐") == 1 && !findtext(localized_vial, "hypovial"), "已译前缀 + 英文基础名应补译基础名：[localized_vial]")
	TEST_ASSERT_NULL(lang_reverse_serial_prefixed("- zxqv bluespace crystal", locale), "不含数字也不含中文的前导记号不归本条管")

	// ④ 指挥部状态摘要：`<i>特质名</i> - 报告` 切块后的 ` - 报告`，以及 `\n` 拼接的站点目标。
	var/bullet = " - Due to good performance, we've provided your station with luxury escape pods."
	var/localized_bullet = lang_localize_chain(bullet, locale, allow_template = TRUE)
	TEST_ASSERT(lang_contains_cjk(localized_bullet) && !findtext(localized_bullet, "performance"), "列表记号后的整句应落地：[localized_bullet]")
	TEST_ASSERT_NULL(lang_reverse_edge_decorated("-18 zxqv crystal", locale), "负数不是列表记号")
	var/goal = list(
		"The station is located in a zone full of space debris.",
		"We have a prototype shielding system you must deploy to reduce collision-related accidents.",
		"",
		"You can order the satellites and control systems at cargo.",
	).Join("\n")
	var/localized_goal = lang_localize_chain(goal, locale, allow_template = TRUE)
	TEST_ASSERT(!findtext(localized_goal, "space debris") && !findtext(localized_goal, "satellites"), "多行拼接的站点目标应逐行落地：[localized_goal]")
	TEST_ASSERT_EQUAL(length(splittext(localized_goal, "\n")), 4, "逐行落地必须保留换行结构")

	// ⑤ 实例名：空括号尾巴（字符串）与纯数字前缀（atom 显示边界）。
	var/localized_card = lang_localize_chain("silver identification card ()", locale, allow_template = TRUE)
	TEST_ASSERT(lang_contains_cjk(localized_card) && copytext(localized_card, -3) == " ()", "空括号尾巴应翻前半段、保留括号：[localized_card]")
	var/obj/item/holochip/chip = allocate(/obj/item/holochip, null, 500)
	var/localized_chip = chip.lang_localize_name_for_display(chip.name)
	TEST_ASSERT(findtext(localized_chip, "500 ") == 1 && !findtext(localized_chip, "holochip"), "全息芯片名应翻基础名、保留金额：[localized_chip]")

	// 储物袋放入消息：中文模板不得再引用英文介词槽（in/on）。
	var/put_message = LANG("datum.686a163dc1f81437", list("zxqv thing", "in", "zxqv bag"))
	TEST_ASSERT(!findtext(put_message, " in"), "放入消息不应夹带英文介词：[put_message]")

	// 发薪日：bank_card_talk 的事件名实参。
	var/payday = LANG("datum.4cd20f13fbb84ab3", list("Payday", 5, "cr"))
	TEST_ASSERT(!findtext(payday, "Payday"), "发薪事件名应翻译：[payday]")

	// 2026-11-17 SPLURT production: dynamic labels must translate at display time.
	var/list/production_samples = list(
		"Donator only",
		"Tier 1 Donator only",
		"20 melee hits",
		"1.7 shots",
		"Set intent to Help",
		"Tarkon Budget",
		"Interlink Cryogenics",
	)
	for(var/sample in production_samples)
		var/translated = lang_fallback_apply(sample)
		TEST_ASSERT(lang_contains_cjk(translated) && translated != sample, "Production display label must translate: [sample] -> [translated]")

	// Spawn assets use type paths without instantiating tens of thousands of atoms.
	var/atom/spawn_type = /obj/item/screwdriver
	var/canonical_name = spawn_type::name
	var/spawn_label = lang_type_display_text(spawn_type, lang_type_name_keys())
	TEST_ASSERT(lang_contains_cjk(spawn_label), "Spawn menu must get the Chinese name directly from the type table")
	TEST_ASSERT_EQUAL(spawn_type::name, canonical_name, "Localizing a spawn label must preserve its canonical name")
	var/obj/item/screwdriver/spawn_instance = allocate(spawn_type)
	TEST_ASSERT_EQUAL(lang_type_display_text(spawn_instance, lang_type_name_keys()), spawn_label, "Type and instance display lookups must agree")

	// Report fields remain identifiers in memory; only their rendered output changes.
	var/datum/station_trait/report_trait = allocate(/datum/station_trait/bountiful_bounties)
	var/report_name = report_trait.name
	var/report_message = report_trait.report_message
	var/report = report_trait.get_report()
	TEST_ASSERT(!findtext(report, "Bountiful bounties") && !findtext(report, "It seems collectors"), "Station trait report must translate both title and description: [report]")
	TEST_ASSERT_EQUAL(report_trait.name, report_name, "Station trait name must remain canonical")
	TEST_ASSERT_EQUAL(report_trait.report_message, report_message, "Station trait source report must remain canonical")

	// HUD icons can be requested by global atoms before ConfigLoaded sets the locale.
	GLOB.i18n_server_locale = null
	var/early_hud_icon = lang_hud_icon('icons/effects/parallax.dmi')
	GLOB.i18n_server_locale = LANGUAGE_LOCALE_ZH_HANS
	TEST_ASSERT_EQUAL(early_hud_icon, 'icons/effects/parallax.dmi', "Early HUD lookups must retain their source icon before locale initialization")

	TEST_ASSERT_NULL(lang_reverse_counted_label("advanced mode", locale), "Counted label lookup must not translate nonnumeric phrases")
	TEST_ASSERT_NULL(lang_reverse_counted_label("1 unknown weapon", locale), "Unlisted units must stay unchanged")
	TEST_ASSERT_NULL(lang_reverse_counted_label("1.7 shots", DEFAULT_UI_LOCALE), "English display must stay canonical")

	var/atom/movable/screen/buildmode/modeswitch/fill_button = allocate(/atom/movable/screen/buildmode/modeswitch, null, /datum/buildmode_mode/fill)
	TEST_ASSERT_EQUAL(fill_button.lang_localize_name_for_display(fill_button.name), "填充", "Buildmode should display Chinese hover labels")
	TEST_ASSERT_EQUAL(fill_button.name, "fill", "Buildmode keys must remain canonical for mode switching")

	// Scoped job titles, Intern/Off-Duty prefixes, and nested parentheses.
	TEST_ASSERT_EQUAL(lang_localize_job_title("Security Medic", locale), "安保医疗兵", "Scoped job title lookup must bypass identifier exclusion")
	TEST_ASSERT_EQUAL(lang_localize_job_title("Police Officer (Engineering)", locale), "警官 (工程部)", "Job title helper must translate nested department suffix")
	TEST_ASSERT(findtext(lang_localize_job_title("Intern Medical Doctor", locale), "医疗医生") > 0, "Intern prefix must compose with localized job title")
	TEST_ASSERT_EQUAL(lang_localize_job_title("Off-Duty Paramedic", locale), "休假中护理员", "Off-Duty prefix must compose with localized job title")
	TEST_ASSERT_EQUAL(lang_reverse_composed_name("Zxqv (Intern Medical Doctor)", locale), "Zxqv ([lang_localize_job_title("Intern Medical Doctor", locale)])", "Composed name must translate Intern job title inside parens")
	TEST_ASSERT_EQUAL(lang_reverse_composed_name("Karl (Police Officer (Engineering))", locale), "卡尔 (警官 (工程部))", "Composed name must handle nested department parens")
	TEST_ASSERT_EQUAL(lang_reverse_composed_name("Zxqv (Police Officer (Engineering))", locale), "Zxqv (警官 (工程部))", "Composed name must preserve untranslated player name with nested department parens")
	TEST_ASSERT_EQUAL(lang_reverse_composed_name("vat-grown human", locale), "培养槽培育的人类", "vat-grown prefix must translate")
	TEST_ASSERT_EQUAL(lang_reverse_composed_name("decayed jumpsuit", locale), "腐坏的连身衣", "decayed prefix must translate")
	TEST_ASSERT_EQUAL(lang_reverse_composed_name("tattered jumpsuit", locale), "破烂的连身衣", "tattered prefix must translate")
	TEST_ASSERT_EQUAL(lang_reverse_composed_name("paper- 'SSV Dauntless Corporate Report'", locale), "纸张 -《SSV Dauntless Corporate Report》", "Bare paper- title must translate without The prefix")
	TEST_ASSERT_EQUAL(lang_reverse_composed_name("The paper- Zxqv employment contract", locale), "纸张 - Zxqv 的雇佣合同", "Employment contract template must match composed paper name")

	// Template anti-hijacking, <br> splitting, and multi-sentence exact match.
	var/br_record = "Patient's immune system responds violently to soy.<br>Patient demonstrates a low tolerance for alcohol. (Wimp)"
	var/br_loc = lang_localize_chain(br_record, locale, allow_template = TRUE)
	TEST_ASSERT(findtext(br_loc, "<br>"), "Line splitting on <br> must preserve the separator")
	TEST_ASSERT(findtext(br_loc, "患者对酒精耐受度极低。（酒量差）"), "<br> second segment must translate cleanly")
	TEST_ASSERT(!findtext(br_loc, "Patient demonstrates"), "No English tail should survive <br> translation")
	TEST_ASSERT_EQUAL(lang_localize_chain("The round is over! You are now visible to the living.", locale, allow_template = TRUE), "回合结束！你现在对生者可见。", "Exact sentence lookup must outrank generic templates")
	TEST_ASSERT_EQUAL(lang_localize_chain("goody case - purchased by Zxqv", locale, allow_template = TRUE), "零食礼盒 - 购买者：Zxqv", "Purchase template must compose catalog item and buyer")
	var/area/diner_area = get_area(run_loc_floor_bottom_left)
	var/saved_area_name = diner_area?.name
	if(diner_area)
		diner_area.name = "\improper The All-American Diner"
		lang_area_name_index_invalidate()
		TEST_ASSERT_EQUAL(lang_localize_chain("The All-American Diner airlock", locale, allow_template = TRUE), "全美餐厅 气闸", "Area-prefixed lookup must preserve leading The before stripping")
		diner_area.name = saved_area_name
		lang_area_name_index_invalidate()

	// Identity protection on display boundary, char_preview, virtualspeaker, and Title-Case arg fallback.
	var/had_next_page_id = GLOB.i18n_identity_names["Next Page"]
	GLOB.i18n_identity_names["Next Page"] = TRUE
	TEST_ASSERT_EQUAL(lang_localize_display_name("Next Page"), "Next Page", "Registered identity names must never be translated by display fallback")
	TEST_ASSERT_EQUAL(lang_localize_arg("Next Page"), "Next Page", "Registered identity names must never be translated as LANG args")
	if(!had_next_page_id)
		GLOB.i18n_identity_names -= "Next Page"
	var/atom/movable/screen/map_view/char_preview/preview = allocate(/atom/movable/screen/map_view/char_preview)
	preview.name = "Next Page"
	TEST_ASSERT_EQUAL(preview.lang_localize_name_for_display(preview.name), "Next Page", "char_preview must preserve identity names verbatim")
	var/mob/living/carbon/human/speaker_mob = allocate(/mob/living/carbon/human)
	var/had_speaker_id = GLOB.i18n_identity_names["Corsac"]
	speaker_mob.fully_replace_character_name(null, "Corsac")
	var/atom/movable/virtualspeaker/mob_vs = allocate(/atom/movable/virtualspeaker, null, speaker_mob)
	TEST_ASSERT_EQUAL(mob_vs.lang_localize_name_for_display("Corsac"), "Corsac", "Virtualspeaker wrapping a mob must leave character name intact")
	if(!had_speaker_id)
		GLOB.i18n_identity_names -= "Corsac"
	var/obj/item/stock_parts/power_store/cell/high/test_cell = allocate(/obj/item/stock_parts/power_store/cell/high)
	var/atom/movable/virtualspeaker/obj_vs = allocate(/atom/movable/virtualspeaker, null, test_cell)
	TEST_ASSERT(obj_vs.lang_localize_name_for_display("the [initial(test_cell.name)]") != "the [initial(test_cell.name)]", "Virtualspeaker wrapping a non-mob atom must localize display name")

	// Blood decals, dynamic descriptions, arg edge cases, materials, and miss filtering.
	var/obj/effect/decal/cleanable/blood/footprints/fp = allocate(/obj/effect/decal/cleanable/blood/footprints)
	TEST_ASSERT(fp.lang_localize_name_for_display(fp.name) != fp.name, "Footprints blood decal must localize without blood_string")
	var/obj/effect/decal/cleanable/blood/gibs/torso/torso_gibs = allocate(/obj/effect/decal/cleanable/blood/gibs/torso)
	TEST_ASSERT(torso_gibs.lang_localize_name_for_display(torso_gibs.name) != torso_gibs.name, "Torso gibs blood decal must localize")
	var/cell_desc_loc = test_cell.lang_localize_desc_for_display(test_cell.desc)
	TEST_ASSERT(findtext(cell_desc_loc, "额定值为") && !findtext(cell_desc_loc, "This one has a rating of"), "Power cell dynamic rating description must localize")
	var/obj/machinery/portable_atmospherics/canister/nitrogen/n2_can = allocate(/obj/machinery/portable_atmospherics/canister/nitrogen)
	var/can_desc_loc = n2_can.lang_localize_desc_for_display(n2_can.desc)
	TEST_ASSERT(findtext(can_desc_loc, "氮气"), "Gas canister description must localize dynamic gas name and description")
	var/obj/item/food/meat/slab/test_meat = allocate(/obj/item/food/meat/slab)
	var/meat_desc_loc = test_meat.lang_localize_desc_for_display("[initial(test_meat.desc)] It's been grilled.")
	TEST_ASSERT_EQUAL(meat_desc_loc, "一大块肉。 它被烤过。", "Appended grilled sentence on food description must localize")

	TEST_ASSERT_EQUAL(lang_localize_arg("20 melee hits"), "20 次近战攻击", "lang_localize_arg must resolve counted labels")
	TEST_ASSERT_EQUAL(lang_localize_arg("Micro-servo"), "微伺服", "Hyphenated Title-Case item names must resolve via lowercase fallback")
	TEST_ASSERT_EQUAL(lang_localize_arg("100 kJ"), "100 kJ", "Numeric energy values must bypass translation cleanly")
	TEST_ASSERT_EQUAL(lang_localize_arg("<img class='icon' src='pda.png'><b>1</b> <em><em>UnknownTag</em></em>"), "<img class='icon' src='pda.png'><b>1</b> <em><em>UnknownTag</em></em>", "Unbalanced wrapped_arg HTML must not be mis-stripped")
	TEST_ASSERT_EQUAL(lang_material("silver"), "白银", "Scoped material lookup must translate excluded material names")
	TEST_ASSERT(!lang_miss_value_candidate("cr"), "Currency suffix 'cr' must be ignored by miss logger")
	TEST_ASSERT(!lang_miss_value_candidate("null"), "Literal 'null' must be ignored by miss logger")
	TEST_ASSERT(!lang_miss_value_candidate(":h"), "Radio channel token must be ignored by miss logger")
	TEST_ASSERT(!lang_miss_value_candidate("ShiftF"), "Keybind chord token must be ignored by miss logger")
	TEST_ASSERT(lang_miss_value_candidate("Untranslated button"), "Genuine multi-word UI string must still pass miss filter")

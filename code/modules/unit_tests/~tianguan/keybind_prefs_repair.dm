/// 验证天关键位存档修复（modular_tianguan/modules/keybind_prefs_repair）：
/// 值为 null 的键位条目（历史遗留：对没有默认键位的动作点过「Reset to Defaults」）必须被
/// 重置为空 list，且不影响其它条目；修好后的表经过 JSON 往返仍然满足 TGUI 的"值都是数组"假设。
/datum/unit_test/tianguan_keybind_prefs_repair

/datum/unit_test/tianguan_keybind_prefs_repair/Run()
	// BYOND 里 `list[key] = null` 会保留键、只清空值 —— 这里复刻同样的形态
	var/list/key_bindings = list()
	key_bindings["stop_interactions"] = null
	key_bindings["pickup"] = list("E")

	TEST_ASSERT_EQUAL(key_bindings.len, 2, "前置条件：null 值条目应当仍在表里")
	TEST_ASSERT_NULL(key_bindings["stop_interactions"], "前置条件：该条目的值应为 null")

	TEST_ASSERT(sanitize_key_binding_values(key_bindings), "应当报告修复了坏条目")
	TEST_ASSERT(islist(key_bindings["stop_interactions"]), "坏条目应被重置为 list()")
	TEST_ASSERT_EQUAL(key_bindings["stop_interactions"].len, 0, "坏条目重置后应为空列表")
	TEST_ASSERT_EQUAL(key_bindings.len, 2, "修复不应增加或减少条目数量")
	TEST_ASSERT_EQUAL(key_bindings["pickup"][1], "E", "正常条目不应被改动")

	// 幂等：第二次不应再报告改动
	TEST_ASSERT(!sanitize_key_binding_values(key_bindings), "重复修复不应再报告改动")

	// 整体不是 list 时不应崩
	TEST_ASSERT(!sanitize_key_binding_values(null), "null 输入应安全返回 FALSE")

	// 端到端：修好的表 JSON 往返后，客户端拿到的值仍是数组（不再触发 hotkeys.filter 崩溃）
	var/list/roundtrip = json_decode(json_encode(key_bindings))
	TEST_ASSERT(islist(roundtrip["stop_interactions"]), "JSON 往返后该值仍应为数组")

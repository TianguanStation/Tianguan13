/**
 * 把键位表里"值不是 list"的条目就地重置为空 list，返回是否有条目被修复。
 *
 * 背景：`/datum/keybinding` 的 `hotkey_keys` / `classic_keys` 默认是 `null`。玩家在
 * 「设置 → 按键绑定」里对**没有默认键位**的动作（全库唯一一例是 `stop_interactions` /
 * 「Cancel Interactions」）点「Reset to Defaults」时，旧版本会把 `null` 直接写进
 * `preferences.key_bindings`。上游已在 tgstation PR #97937（commit 056833c58）用一行
 * `LAZYINITLIST()` 修掉产生侧，但存量数据没有任何读取侧兜底。
 *
 * BYOND 的 `list[key] = null` 不会删键、只把关联值清空，所以 `(key in list)` 仍为真：
 * `check_keybindings()` 认为该条目"已存在"而跳过，`save_preferences()` 每次登录再原样写回，
 * 脏数据因此永远不会自愈。TGUI 的按键绑定页 `populateSelectedKeybindings()` 把每个值当数组用
 * （`hotkeys.filter(...)`），读到 `null` 就整页崩：
 * `TypeError: Cannot read properties of null (reading 'filter')`。
 *
 * 本 proc 在 `check_keybindings()` 开头调用：修好的值会在该 proc 末尾存档时落盘，玩家不需要
 * 做任何操作，下次登录即恢复。
 */
/proc/sanitize_key_binding_values(list/key_bindings)
	if(!islist(key_bindings))
		return FALSE
	var/repaired = FALSE
	for(var/keybind_name in key_bindings)
		if(islist(key_bindings[keybind_name]))
			continue
		key_bindings[keybind_name] = list()
		repaired = TRUE
	return repaired

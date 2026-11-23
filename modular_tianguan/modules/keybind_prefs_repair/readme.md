https://github.com/TianguanStation/Tianguan13/pull/<!--PR Number-->

## 修复历史键位存档导致「设置 → 按键绑定」整页崩溃

Module ID: `KEYBIND_PREFS_REPAIR`

### Description:

部分玩家的 `preferences.json` 里存在值为 `null` 的键位条目，这类人一打开「设置 → 按键绑定」就整页蓝屏：

```
TypeError: Cannot read properties of null (reading 'filter')
    at KeybindingsPage.populateSelectedKeybindings (KeybindingsPage.tsx:460)
```

游客号正常，因为他们没有存档，键位表全部由 `GLOB.default_hotkeys` 生成。

**成因**：`/datum/keybinding` 的 `hotkey_keys` / `classic_keys` 默认是 `null`（`code/datums/keybinding/_keybindings.dm:2-3`）。对**没有默认键位**的动作点「Reset to Defaults」时，`reset_keybinds_to_defaults()` 会把 `null` 写进 `key_bindings`。上游已在 tgstation PR #97937（commit `056833c58`）用一行 `LAZYINITLIST()` 修掉**产生侧**，但**存量数据没有任何读取侧兜底**：

- BYOND 的 `list[key] = null` 只清空关联值、不删键，`(key in list)` 仍为真；
- 于是 `check_keybindings()` 认为条目"已存在"直接 `continue`，不补默认值；
- `save_preferences()` 每次登录原样回写，脏数据永不自愈；
- 前端 `hotkeys.filter(...)` 没有 null 保护，读到就整页崩。

本模块补上读取侧的两道兜底：

1. **读档后修复**：`check_keybindings()` 开头把非 list 的键位值就地重置为 `list()`，随后该 proc 末尾的 `save_preferences()` 会把干净数据落盘 —— 玩家不需要做任何操作，下次登录即恢复；
2. **下发前兜底**：`get_ui_static_data()` 只把经过 `SANITIZE_LIST()` 的值送给客户端，任何来源（管理员 VV、备份还原、第三方工具改档）的脏数据都不会再触发蓝屏。

### TG Proc/File Changes:

- `code/modules/client/preferences/middleware/keybindings.dm`: `get_ui_static_data()`
- `code/modules/client/preferences_savefile.dm`: `check_keybindings()`
- `tgstation.dme`: 新增本模块 `code/keybind_prefs_repair.dm` 的 include
- `code/modules/unit_tests/_unit_tests.dm`: 在既有 `TIANGUAN EDIT START/END` 块内新增 `~tianguan\keybind_prefs_repair.dm` 的 include

### Modular Overrides:

- N/A

### Defines:

- N/A

### Included files that are not contained in this module:

- `code/modules/client/preferences/middleware/keybindings.dm`、`code/modules/client/preferences_savefile.dm`：这两个 proc 定义在上游核心文件里，模块只能新增 proc、无法覆盖已有 proc，因此按规范加 `TIANGUAN EDIT ADDITION START/END - KEYBIND_PREFS_REPAIR` 标记后原地修改（各 6 行注释+代码，另一处 1 行调用）。
- `code/modules/unit_tests/~tianguan/keybind_prefs_repair.dm`：单测必须放在 `code/modules/unit_tests/` 下（`_unit_tests.dm` 末尾有 `#undef TEST_ASSERT*`，只能在该文件作用域内 include）。

### Credits:

- 诊断与修复：mohu19（天关）
- 成因定位与产生侧修复：tgstation PR #97937 / commit `056833c58`

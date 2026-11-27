https://github.com/TianguanStation/Tianguan13/pull/32

## 团结联盟印章（UAR_OFFICER 模块）

Module ID: `UAR_OFFICER`

### Description:

团结联盟审查官（UAR Inspector）的整套装备与身份件模块：制服/帽子/手套/靴子、耳机、PDA、行政 ID、UAR 与 WSR 国旗、招聘信标、指挥售货机补充，以及**团结联盟印章**（`/obj/item/stamp/uar`，可盖在公文上，审查官开局携带）。

印章继承上游 `/obj/item/stamp`，盖章机制完全沿用上游（左键点纸、右键速盖、`MODE_STAMPING`）。三处外观分工：

| 出现位置 | 用哪张图 | 实现 |
|---|---|---|
| 物品图标（背包 / 地上 / 手持托盘） | 上游 `icons/obj/service/bureaucracy.dmi` 的 `stamp-hos`（安保主管红章） | `icon` / `icon_state` |
| 纸张**物品图标**上的小印记 | 上游 `paper_stamp-hos`（红色斜矩形） | `add_stamp()` 按 `paper_<icon_state>` 取 |
| 纸面**窗口**（TGUI PaperSheet）里的大印记 | 模块自带 `icons/stamp_uar.png`（121×54，与上游印章同画布、1:1） | 覆盖 `get_writing_implement_details()`，`stamp_class = icon_class_name("uar_stamp")` |

### TG Proc/File Changes:

- `code/modules/asset_cache/assets/paper.dm`：`/datum/asset/spritesheet/simple/stamps` 的 `assets` 表新增一条 `"uar_stamp" = 'modular_tianguan/modules/uar_officer/icons/stamp_uar.png'`（带 `TIANGUAN EDIT ADDITION` 标记；只是往列表里追加一项，既有条目未改）。必须动 core 的原因：`assets` 是声明式 var list，模块内追加只能整表重声明，那要把上游约 50 条印章条目全部抄一遍，上游新增印章就漂。

### Modular Overrides:

- `/obj/item/stamp/chameleon/get_writing_implement_details()`：变色龙印章选中团结联盟外观时，纸面窗口使用联盟章图。

### Defines:

- N/A

### Included files that are not contained in this module:

- `code/modules/asset_cache/assets/paper.dm`：纸面窗口大图必须走 stamps 精灵表（见上「TG Proc/File Changes」）。
- `code/modules/paperwork/stamps.dm`：上游 `/obj/item/stamp` 基类与其 `get_writing_implement_details()`。

### Credits:

- 原始实现：天关旧库 TianGuan13（commit `7e53669`「团结联盟印章：审查官开局携带，外观沿用上游红色印章，纸面窗口用联盟印章图」）
- 迁移回本库：mohu19

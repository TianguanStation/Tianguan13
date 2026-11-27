https://github.com/TianguanStation/Tianguan13/pull/33

## ID 卡编辑器（管理员面板）

Module ID: `ADMIN_ID_EDITOR`

### Description:

「秘密」面板（Secrets）里多一个 **ID 卡编辑器**，给管理员临时造身份卡用：

- **外观**：`icons/obj/card.dmi` 里现成的 `card_*` 状态（中央 / 银 / 白金 / 金 / 黑 / 烈焰 / 彩虹 / 鲤鱼 / 驴登 …）
- **印记**：全部 `/datum/id_trim` 单例（中央·ERT 组 / 站点职业组 / 其它组），镜像在卡面上的部门色与职位徽记由 `apply_trim_to_card()` 现成逻辑铺
- **姓名 / 职位 / 介绍**：自由填写
- **权限**：与人事主管控制台同一份 `SSid_access.all_region_access_tgui`（中央 + 站内八个分区），可勾选/清空
- **默认**：`/datum/id_trim/centcom/ert`（开面板即为 ERT 的卡面与权限），一键「恢复 ERT 默认」
- **实时预览**：左侧 32×32 卡面放大 4 倍显示（服务端 `getFlatIcon` + `icon2base64` 合成，含 trim 徽记）
- **一键生成**：在管理员脚下生成真正的 `/obj/item/card/id/advanced`（银行卡、安检 HUD、门禁全照常），并写入 admin log

### TG Proc/File Changes:

- `code/modules/admin/verbs/secrets.dm`：`/datum/secrets_menu/ui_act` 里加一段 `TIANGUAN EDIT` 挂钩，转发 `action = "id_card_editor"` 给本模块的 `tianguan_id_editor_ui_act()`（与既有 `admin_countdown` 挂钩同一套写法）
- `tgui/packages/tgui/interfaces/Secrets.jsx`：`FunForYouTab` 顶部加一个「ID 卡」区块与按钮（`TIANGUAN EDIT` 标记）

### Modular Overrides:

- N/A

### Defines:

- `ID_EDITOR_ICON` / `ID_EDITOR_DEFAULT_TRIM` / `ID_EDITOR_ACCESS_REGIONS`（模块文件内，末尾 `#undef`）

### Included files that are not contained in this module:

- `code/modules/admin/verbs/secrets.dm`：面板入口必须挂在 Secrets 的 `ui_act` 上。
- `tgui/packages/tgui/interfaces/Secrets.jsx`：面板按钮。
- `tgui/packages/tgui/interfaces/TianGuanIdCardEditor.tsx`：TGUI 界面本体（TGUI 只能放这个目录）。

### Credits:

- 功能设计：mohu19
- 实现：Hermes Agent（AI 编码代理）

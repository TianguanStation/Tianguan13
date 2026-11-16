# HUD 图标中文重绘（hud icons i18n）

游戏内 HUD 的大量文字是**烤进 `.dmi` 像素**里的（主题按钮的 PULL/RESIST/THROW、
internals 的 OFF/ON、健康指示的 CRIT./D3AD、径向菜单切片、action 按钮的 MAP 等），
运行时字符串反查够不着，DM 也没有 icon.DrawText 可以运行时贴字。

本工具与 `tools/i18n/lobby-buttons/` 同一思路：**构建期**逐帧检测英文字区、擦底重绘
中文（Fusion Pixel 像素字体），输出 **state 名/帧数/方向完全对齐**的 drop-in `.dmi`
变体到 `modular_zh/modules/i18n/icons/hud/`。运行时由
`modular_zh/modules/i18n/code/hud_icons.dm` 的 `lang_hud_icon()` 在全服中文
（`I18N_SERVER_LOCALE` ≠ en）时把原图路径换成变体；英文 locale 下恒等，源文件不动，
上游合并友好。

## 重新生成

```sh
# 仓库根目录（需 PIL；NixOS: PYTHONDONTWRITEBYTECODE=1 nix-shell -p python3Packages.pillow）
python3 tools/i18n/hud-icons/gen_hud_dmi.py            # 全量生成（共 25 个 .dmi）
python3 tools/i18n/hud-icons/gen_hud_dmi.py --audit    # 全量生成 + 排版/对比度/尺寸审计
python3 tools/i18n/hud-icons/gen_hud_dmi.py --preview  # 生成 + 导出 /tmp/hud_preview.png 目检
python3 tools/i18n/hud-icons/gen_hud_dmi.py --only icons/hud/screen_gen.dmi  # 单文件
```

## labels.json 配置

- `files.<源dmi路径>`：每个源文件一节，`out` 可覆盖输出文件名（默认同 basename）。当前覆盖 25 个 `.dmi`（含 `modular_skyrat/modules/borgs/icons/screen_cyborg.dmi` → `screen_cyborg_borgs.dmi`、`modular_zubbers/icons/hud/radial.dmi` → `radial_zubbers.dmi` 等）。
- `states.<state名>`：`text` 中文字（或 `lines` 多行）；可选：
  - `search`/`rect`：限定文字像素搜索矩形；`maskrect`：按过滤条件全框选中目标区；
  - `mask_color`/`mask_bright`/`mask_red`/`mask_sat`/`mask_wb`/`mask_min_a`/`ignore_ys`：`maskrect` 像素筛选；
  - `fill` 擦底模式：
    - `flat`（可选 `bg`）：平涂底色；`transparent`：清空为透明；`row_mode`：按行众数回填；
    - `template_col`（`ref_x`）：从干净参考列整列复原边框/扫描线；
    - `template_row`（`ref_y`/`even_ref_y`/`ref_pt`/`even_pt`/`top_pt`/`top_y`/`mirror_x28`）：从干净参考行/点复原边框/高光斜边；
    - `scanline_ref`：复原 5 套标准主题顶栏边框与奇偶扫描线；
    - `scanline_hex`（`even_bg`/`odd_bg`）：按指定奇偶扫描线色回填（如 voidwalker）；
    - `cyborg_glare`（`glare_mode`: `panel`/`health`/`health5`/`alert`）：精确复原 CRT 玻璃斜向反光与红黑/绿黑扫描线；
    - `pill_box`（`pill_rect`/`border_pt`/`bg_pt`）：清空原字框并在 `pill_rect` 内重绘等比放大的圆角边框徽章（如 `health6` 危重、`health7` 死亡、`off` 关）；
  - `box`：显式放置盒 `[x0,y0,x1,y1]`；`clip_y: [y0,y1]`：纵向写入裁剪，保护邻接 1px 边框；
  - `pick` / `color` / `fg_pt` / `even_color` / `grad_color`：墨色选取（支持 `#rrggbbaa` 与按帧采样点 `fg_pt`）、`y` 奇偶扫描线暗行色、上下渐变第二色；
  - `outline` / `outline_mode`（`box`/`cross`）/ `auto_halo`：描边/光晕色（`auto_halo` 自动从原图提取前景色与 1px 光晕色）；
  - `shadow` / `shadow_offset` / `shadow_top` / `shadow_bottom`：1px 投影（支持上下边缘双色阴影如 trasenknox）；
  - `sizes`/`size` / `pad`/`maxw`/`maxh`/`dx`/`dy` / `compw`/`comph`/`compmax` / `keep_blue_x`；
  - `button:true`：径向菜单「纯色圆角按钮」专用——保持 `radial.dmi` 半透明/`255` 轮廓与奇偶深色描边，或在 `"outline":false` 时禁用外描边；
  - `keep`：无文字/不处理的 state，跳过且不报 miss；`parts`：一格多段文字。
- `groups` + 文件级 `include`：`human_actions`/`hands_rl`/`zone_rl`/`cyborg_common` 共用配置，避免重复。

## 检测与排版要点

- 底板色按「最大连通分量」判定，并从文字候选中剔除——radial 纯色底被笔画切成的
  碎块、glass 不透明文字配半透明底，都靠它区分「底色」与「字」。
- 半透明晕色与边框保护：对自带 alpha 的光晕色（如 glass、clockwork）采用直接 RGBA 覆写并配合
  `template_col`/`template_row`/`clip_y`，避免擦除边框后填入更小中文导致边框断裂或半透明混合失真。
- CRT/扫描线还原：cyborg/robot/alert 的斜向屏幕反光由 `cyborg_glare` 数学重构，alien/cyborg/voidwalker
  的明暗扫描线由 `even_color` 与 `scanline_hex` 对齐单元格绝对坐标奇偶性逐行还原。
- 径向菜单切片按钮极小（~16px 宽），3 字中文放不下，labels 里用 2 字缩写
  （下一页→翻页、设法力→法力、取奶精→奶精 等）。

## 运行时挂钩点（均带 `ZH EDIT` 注释）

| 位置 | 覆盖 |
| --- | --- |
| `/atom/movable/screen/Initialize` | 类型级字面量 icon（screen_gen 底座、screen_alert、lobby、radial 底图…） |
| `/datum/hud/add_screen_object` | 所有 `ui_icon` 路径（主题 + alien/cyborg/ghost/voidwalker 的 ui_style） |
| `/datum/hud/update_ui_style` | 人类 HUD 换主题（比较/赋值两侧都过注册表） |
| `/datum/hud/reorganize_alerts` | `USER_HUD_STYLE_*` 告警继承主题图标 |
| `/datum/radial_menu/setup_menu` + `extract_image` | 径向菜单底图与全部选项图（`suit_storage_unit`/`cosmetics`/`mirror`/`mail` 改用 `image()`） |
| `/datum/action/apply_button_icon` | action 按钮（minimap MAP、guardian…） |
| `modular_skyrat/.../robot.dm` | `model_select_alternate_icon`（screen_robot.dmi） |
| `/datum/asset/simple/body_zones/register` | TGUI body zones 人形底座（midnight/slimecore `zone_sel`） |
| `/datum/preference/choiced/ui_style/icon_for` | TGUI 偏好设置 HUD 主题预览图标 |
| zone_sel / spacesuit / storage_interface | 杂项散点 |

## 注意

- 变体只做像素替换，**不改行为**；flick/`icon_state` 切换语义不变。
- 上游改了这些 dmi 后重新跑生成器即可；`--preview` 大图用于目检。
- 新增带文字的 HUD dmi：在 `labels.json` 加配置 + 在 `hud_icons.dm` 的
  `zh_hud_icon_variants` 注册一行。
- 检测器按「字母连通分量」工作：装饰图形可能被误判为字母，遇误刷用 `search`
  收窄区域或 `pick:"#hex"` 指定文字颜色；多色/渐变字靠同带扩展整行擦除。

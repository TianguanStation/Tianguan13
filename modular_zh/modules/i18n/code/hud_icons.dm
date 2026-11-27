// i18n: HUD 图标中文变体表与换图助手。
//
// HUD 上不少英文是**烤进 .dmi 像素**的（PULL/RESIST/STOP PULL/CRIT./DEAD/径向切片…），
// 运行时字符串反查够不着，DM 也没有 icon.DrawText 可以在运行期把字贴上去。
// 所以走 lobby 按钮同款方案：构建期 tools/i18n/hud-icons/gen_hud_dmi.py 按
// labels.json 把英文字区擦底、用 Fusion Pixel 像素字体重绘中文，输出 state 名/帧数/
// 方向**完全对齐**的 drop-in 变体到 modular_zh/modules/i18n/icons/hud/。
//
// 运行时只有一个决策点：lang_hud_icon()。全服英文时它是恒等函数（原图原样，
// 调用点可无条件包一层）；非英文时把注册表里的原图路径换成中文变体。locale 是
// 全服级（GLOB.i18n_server_locale），换图不需要按观察者分叉。
//
// 挂钩面刻意收窄在「icon 赋值的少数收口处」，见各处 ZH EDIT：
//   - /atom/movable/screen/Initialize —— 类型级字面量 icon（screen_gen 底座、
//     screen_alert、radial、lobby 按钮、navigate/craft 等）
//   - /datum/hud/add_screen_object —— ui_icon 路径（人类主题 + alien/cyborg/
//     ghost/voidwalker 等 huds 的字面量 ui_style）
//   - /datum/hud/update_ui_style —— 主题换装（比较与赋值两侧都要经它）
//   - /datum/hud/reorganize_alerts —— USER_HUD_STYLE_* 告警的 ui_style 换皮
//   - /datum/radial_menu/setup_menu + extract_image —— 切片底图与全部选项图
//     （suit_storage_unit/cosmetics/mirror/mail 等改为 image() 传参以经 extract_image）
//   - /datum/action/apply_button_icon —— button_icon（minimap「MAP」、guardian 等）
//   - skyrat robot_hands —— model_select_alternate_icon（screen_robot.dmi）
//   - /datum/asset/simple/body_zones/register —— TGUI 体检/瞄准人形底座（midnight/slimecore）
//   - /datum/preference/choiced/ui_style/icon_for —— 偏好设置 HUD 样式预览图标
//
/// 原 .dmi → 中文 drop-in 变体。未在表中的路径一律原样返回，所以换皮肤/未本地化
/// 的 HUD 图不受任何影响。变体 state 名与帧数与原件完全一致，flick/icon_state
/// 切换语义不变。
GLOBAL_LIST_INIT(zh_hud_icon_variants, list(
	'icons/hud/screen_gen.dmi' = 'modular_zh/modules/i18n/icons/hud/screen_gen.dmi',
	'icons/hud/screen_midnight.dmi' = 'modular_zh/modules/i18n/icons/hud/screen_midnight.dmi',
	'icons/hud/screen_retro.dmi' = 'modular_zh/modules/i18n/icons/hud/screen_retro.dmi',
	'icons/hud/screen_operative.dmi' = 'modular_zh/modules/i18n/icons/hud/screen_operative.dmi',
	'icons/hud/screen_trasenknox.dmi' = 'modular_zh/modules/i18n/icons/hud/screen_trasenknox.dmi',
	'icons/hud/screen_plasmafire.dmi' = 'modular_zh/modules/i18n/icons/hud/screen_plasmafire.dmi',
	'icons/hud/screen_slimecore.dmi' = 'modular_zh/modules/i18n/icons/hud/screen_slimecore.dmi',
	'icons/hud/screen_clockwork.dmi' = 'modular_zh/modules/i18n/icons/hud/screen_clockwork.dmi',
	'icons/hud/screen_glass.dmi' = 'modular_zh/modules/i18n/icons/hud/screen_glass.dmi',
	'icons/hud/screen_detective.dmi' = 'modular_zh/modules/i18n/icons/hud/screen_detective.dmi',
	'modular_zubbers/icons/hud/screen_blue98.dmi' = 'modular_zh/modules/i18n/icons/hud/screen_blue98.dmi',
	'icons/hud/screen_alien.dmi' = 'modular_zh/modules/i18n/icons/hud/screen_alien.dmi',
	'icons/hud/screen_cyborg.dmi' = 'modular_zh/modules/i18n/icons/hud/screen_cyborg.dmi',
	'modular_skyrat/master_files/icons/hud/screen_cyborg.dmi' = 'modular_zh/modules/i18n/icons/hud/screen_cyborg_skyrat.dmi',
	'modular_skyrat/modules/borgs/icons/screen_cyborg.dmi' = 'modular_zh/modules/i18n/icons/hud/screen_cyborg_borgs.dmi',
	'modular_zubbers/code/modules/silicons/borgs/sprites/screen_robot.dmi' = 'modular_zh/modules/i18n/icons/hud/screen_robot.dmi',
	'icons/hud/screen_ghost.dmi' = 'modular_zh/modules/i18n/icons/hud/screen_ghost.dmi',
	'icons/hud/screen_voidwalker.dmi' = 'modular_zh/modules/i18n/icons/hud/screen_voidwalker.dmi',
	'icons/hud/radial.dmi' = 'modular_zh/modules/i18n/icons/hud/radial.dmi',
	'icons/hud/radial_pets.dmi' = 'modular_zh/modules/i18n/icons/hud/radial_pets.dmi',
	'icons/hud/radial_coffee.dmi' = 'modular_zh/modules/i18n/icons/hud/radial_coffee.dmi',
	'modular_zubbers/icons/hud/radial.dmi' = 'modular_zh/modules/i18n/icons/hud/radial_zubbers.dmi',
	'icons/hud/guardian.dmi' = 'modular_zh/modules/i18n/icons/hud/guardian.dmi',
	'icons/hud/implants.dmi' = 'modular_zh/modules/i18n/icons/hud/implants.dmi',
	'icons/hud/screen_alert.dmi' = 'modular_zh/modules/i18n/icons/hud/screen_alert.dmi',
	'icons/hud/lobby/character_setup.dmi' = 'modular_zh/modules/i18n/icons/lobby/character_setup.dmi',
	'icons/hud/lobby/join.dmi' = 'modular_zh/modules/i18n/icons/lobby/join.dmi',
	'icons/hud/lobby/observe.dmi' = 'modular_zh/modules/i18n/icons/lobby/observe.dmi',
	'icons/hud/lobby/ready.dmi' = 'modular_zh/modules/i18n/icons/lobby/ready.dmi',
))

/// 全服非英文时把已登记的 HUD 原图换成中文变体；其余情况原样返回。
/// 传入 icon 对象（如 mutable_appearance.icon / 运行期 icon(path)）也安全：
/// assoc 查不到时退化为逐条 `==` 比对兜底。
/proc/lang_hud_icon(icon_file)
	if(isnull(icon_file) || isnull(GLOB.zh_hud_icon_variants) || !GLOB.i18n_server_locale || GLOB.i18n_server_locale == DEFAULT_UI_LOCALE)
		return icon_file
	var/localized = GLOB.zh_hud_icon_variants[icon_file]
	if(!isnull(localized))
		return localized
	for(var/source in GLOB.zh_hud_icon_variants)
		if(icon_file == source)
			return GLOB.zh_hud_icon_variants[source]
	return icon_file

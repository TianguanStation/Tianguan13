// GUIDE_BROWSER - 天关模块：玩家偏好条目（ESC → 游戏偏好设置 → UI 分类）
//
// 语义：默认关闭（FALSE），避免所有玩家左上角都多一个 HUD 图标。
// 开启后立即在左上角显示「指南浏览器」快捷按钮，并在每回合默认保留；
// 未开启的玩家随时可通过 OOC 栏「指南浏览器」或指南窗口顶部按钮打开或钉选。

/datum/preference/toggle/tianguan_guide_button
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "tianguan_show_guide_hud"
	savefile_identifier = PREFERENCE_PLAYER
	default_value = FALSE

/datum/preference/toggle/tianguan_guide_button/apply_to_client_updated(client/client, value)
	if(!client?.ckey)
		return
	GLOB.tianguan_guide_round_hidden -= client.ckey
	GLOB.tianguan_guide_round_forced -= client.ckey
	SStianguan_guide_browser?.ensure_guide_action(client.persistent_client)

// GUIDE_BROWSER - 天关模块：OOC 栏「指南浏览器」入口（替代原先两个冗余的开关按钮指令）

GAME_VERB_DESC(/client, guide_browser, "指南浏览器", "打开服务器维基指南与常用手册目录。", "OOC")
	if(!GLOB.tianguan_guide_ready)
		to_chat(src, span_warning("指南目录尚未加载，请联系管理员检查配置。"))
		return
	tianguan_open_guide_browser(mob || usr)

/// 天关大厅标题界面 —— 左侧边栏布局 + 磨砂玻璃质感（适配 SPLURT-zh）。

GLOBAL_LIST_EMPTY(startup_messages)
// FOR MOR INFO ON HTML CUSTOMISATION, SEE: https://github.com/Skyrat-SS13/Skyrat-tg/pull/4783

#define MAX_STARTUP_MESSAGES 27

/// 侧边栏顶部展示图。按顺序取第一个存在的文件；把 GIF/PNG 丢进模块 icons/ 即可生效。
#define TG_LOBBY_ART_CANDIDATES list( \
	"modular_tianguan/modules/tg_lobby/icons/lobby_art.gif", \
	"modular_tianguan/modules/tg_lobby/icons/lobby_art.png", \
	"modular_skyrat/modules/title_screen/icons/loading_screen.gif", \
)

#define TG_LOBBY_CSS {"
<style type='text/css'>
/* ===================== 天关玻璃板（中性灰） ===================== */
.tg_glass {
	background-color: rgba(52, 52, 52, 0.62);
	background-image:
		linear-gradient(158deg, rgba(255,255,255,0.22) 0%, rgba(255,255,255,0.08) 34%, rgba(255,255,255,0.01) 62%, rgba(0,0,0,0.16) 100%),
		repeating-linear-gradient(112deg, rgba(255,255,255,0.042) 0px, rgba(255,255,255,0.042) 1px, rgba(255,255,255,0) 1px, rgba(255,255,255,0) 4px);
	border: 1px solid rgba(255,255,255,0.26);
	border-radius: 5px;
	box-shadow:
		inset 0 1px 0 rgba(255,255,255,0.34),
		inset 0 -1px 0 rgba(0,0,0,0.40),
		0 4px 18px rgba(0,0,0,0.55);
}

/* ===================== 左侧边栏 ===================== */
.tg_side {
	position: absolute;
	left: 0; top: 0;
	width: 50vmin; height: 100%;
	z-index: 3;
	box-sizing: border-box;
	padding: 1.1vmin;
	text-align: left;
	overflow-y: auto;
	overflow-x: hidden;
	border-radius: 0;
	border-left: none; border-top: none; border-bottom: none;
	background-color: rgba(36, 36, 36, 0.76);
	background-image:
		linear-gradient(to bottom,
			rgba(255,255,255,0.14) 0%,
			rgba(255,255,255,0.05) 12%,
			rgba(255,255,255,0.008) 36%,
			rgba(0,0,0,0.10) 60%,
			rgba(0,0,0,0.26) 84%,
			rgba(0,0,0,0.42) 100%),
		repeating-linear-gradient(112deg, rgba(255,255,255,0.042) 0px, rgba(255,255,255,0.042) 1px, rgba(255,255,255,0) 1px, rgba(255,255,255,0) 4px);
	border-right: 1px solid rgba(255,255,255,0.20);
	box-shadow:
		inset 0 1px 0 rgba(255,255,255,0.24),
		inset 0 -1px 0 rgba(0,0,0,0.60),
		3px 0 20px rgba(0,0,0,0.60);
	transition: left 0.22s ease-out 0.06s;
}

/* ===================== 侧边栏右下：两个外部跳转 ===================== */
.tg_extlinks {
	position: absolute;
	left: 50vmin;
	bottom: 3vmin;
	z-index: 4;
	display: block;
	transition: left 0.14s ease-out;
}
.tg_ext {
	display: block;
	box-sizing: border-box;
	width: 17vmin;
	height: 4.4vmin;
	line-height: 4.4vmin;
	margin-bottom: 0.5vmin;
	padding: 0 0.8vmin;
	text-decoration: none;
	font-family: "Fixedsys", sans-serif;
	font-size: 2.2vmin;
	color: #dcdcdc;
	text-align: left;
	white-space: nowrap;
	overflow: hidden;
	border: 1px solid rgba(255,255,255,0.20);
	border-left: none;
	border-radius: 0 4px 4px 0;
	background-color: rgba(24, 24, 24, 0.86);
	background-image: linear-gradient(to right, rgba(255,255,255,0.10), rgba(255,255,255,0.015));
	box-shadow: inset 0 1px 0 rgba(255,255,255,0.16), 2px 0 12px rgba(0,0,0,0.50);
}
.tg_ext:hover { color: #fff9c4; border-color: rgba(255,255,255,0.34); }
.tg_ext img {
	float: right;
	height: 3vmin;
	width: auto;
	margin-top: 0.7vmin;
	margin-left: 0.5vmin;
}
.tg_ext img.tg_pixel { image-rendering: pixelated; -ms-interpolation-mode: nearest-neighbor; }

@keyframes tg_rainbow {
	0%   { color: #ff5a5a; }
	17%  { color: #ffd75a; }
	33%  { color: #7dff7d; }
	50%  { color: #5ad7ff; }
	67%  { color: #9a8cff; }
	83%  { color: #ff7ad7; }
	100% { color: #ff5a5a; }
}
.tg_ext .tg_rainbow {
	animation: tg_rainbow 4s linear infinite;
	text-shadow: 0 0 5px rgba(255,255,255,0.26), 1px 1px 2px black;
}
.tg_ext:hover .tg_rainbow { animation-duration: 1.5s; }

.tg_dock {
	position: absolute;
	left: 50vmin; top: 0;
	width: 0; height: 100%;
	z-index: 4;
	transition: left 0.14s ease-out;
}

body.tg_collapsed .tg_dock      { left: 0; }
body.tg_collapsed .tg_extlinks  { left: -20vmin; }
body.tg_collapsed .tg_side      { left: -51vmin; }
.tg_handle:after { content: "◀"; }
body.tg_collapsed .tg_handle:after { content: "▶"; }

.tg_handle {
	position: absolute;
	left: 0; top: 50%;
	width: 3.2vmin; height: 13vmin;
	margin-top: -6.5vmin;
	z-index: 4;
	display: block;
	box-sizing: border-box;
	background-color: rgba(20, 20, 20, 0.82);
	background-image: linear-gradient(to right, rgba(255,255,255,0.16), rgba(255,255,255,0.02));
	border: 1px solid rgba(255,255,255,0.22);
	border-left: none;
	border-radius: 0 4px 4px 0;
	box-shadow: inset 0 1px 0 rgba(255,255,255,0.28), 2px 0 10px rgba(0,0,0,0.45);
	color: #cccccc;
	font-family: "Fixedsys", sans-serif;
	font-size: 2.2vmin;
	line-height: 13vmin;
	text-align: center;
	cursor: pointer;
	transition: left 0.22s ease-out;
}
.tg_handle:hover { color: #fff9c4; background-color: rgba(44, 44, 44, 0.90); }

/* 顶部展示图 */
.tg_art {
	position: relative;
	width: 100%; height: 18vmin;
	overflow: hidden;
	box-sizing: border-box;
	margin-bottom: 1.1vmin;
	background-color: rgba(0,0,0,0.35);
	border: 1px solid rgba(255,255,255,0.16);
	border-radius: 4px;
}
.tg_art img {
	position: static;
	display: block;
	width: 100%; height: 100%;
	object-fit: cover;
	image-rendering: pixelated;
	-ms-interpolation-mode: nearest-neighbor;
}

/* 角色卡 */
.tg_card { text-align: center; margin-bottom: 1.1vmin; }
.tg_avatar {
	height: 15vmin; width: auto;
	image-rendering: pixelated;
	-ms-interpolation-mode: nearest-neighbor;
}
.tg_pname {
	font-family: "Fixedsys", sans-serif;
	font-size: 3.3vmin;
	line-height: 3.8vmin;
	color: #eeeeee;
	letter-spacing: 1px;
	text-shadow: 0 0 6px rgba(255,255,255,0.30), 2px 2px 2px black;
}
.tg_pid {
	font-family: "Fixedsys", sans-serif;
	font-size: 2.1vmin;
	line-height: 2.6vmin;
	color: #9a9a9a;
}

/* 偏好摘要 */
.tg_prefs {
	background-color: rgba(255,255,255,0.035);
	background-image: linear-gradient(to bottom, rgba(255,255,255,0.05), rgba(0,0,0,0.06));
	border-top: 1px solid rgba(255,255,255,0.16);
	border-bottom: 1px solid rgba(0,0,0,0.50);
	box-shadow: inset 0 1px 0 rgba(255,255,255,0.06);
	padding: 0.7vmin 0.6vmin;
	margin-bottom: 1.1vmin;
	font-family: "Fixedsys", sans-serif;
	font-size: 2.1vmin;
	line-height: 2.9vmin;
}
.tg_prow { white-space: nowrap; overflow: hidden; }
.tg_prefs .k { color: #8a8a8a; display: inline-block; width: 8vmin; }
.tg_prefs .v { color: #e2e2e2; }

/* 按钮：玻璃片 */
.tg_side .menu_button {
	display: block;
	box-sizing: border-box;
	font-family: "Fixedsys", sans-serif;
	font-weight: lighter;
	text-decoration: none;
	font-size: 2.85vmin;
	line-height: 3.4vmin;
	height: 3.4vmin;
	width: 100%;
	text-align: left;
	color: #dedede;
	padding-left: 1.2vmin;
	letter-spacing: 1px;
	cursor: pointer;
	white-space: nowrap;
	overflow: hidden;
	margin-bottom: 0.35vmin;
	border: 1px solid rgba(255,255,255,0.10);
	border-radius: 3px;
	background-image: linear-gradient(to bottom, rgba(255,255,255,0.09), rgba(255,255,255,0.015));
	text-shadow: 1px 1px 2px black;
}
.tg_side .menu_button:hover {
	padding-left: 0.4vmin;
	color: #fff9c4;
	border-color: rgba(255,255,255,0.30);
	background-image: linear-gradient(to bottom, rgba(255,255,255,0.20), rgba(255,255,255,0.05));
}
.tg_side .menu_button:active { transform: translate(1px, 1px); }
.tg_side .menu_button:hover::before,
.tg_side .menu_button:active::before { width: 2.6vmin; }
.tg_side .menu_button.menu_newpoll { padding-left: 0.4vmin; }
.tg_side .menu_button.menu_newpoll::before,
.tg_side .menu_button.menu_newpoll::after { width: 2.6vmin; }
.tg_side hr {
	height: 1px;
	margin: 0.7vmin 0;
	border: none;
	background-color: rgba(255,255,255,0.16);
	box-shadow: none;
}

/* ===================== 右上通知栏 ===================== */
.container_notice {
	left: auto;
	right: 1.4vmin;
	top: 1.4vmin;
	transform: none;
	text-align: right;
	max-width: 44vmin;
	z-index: 3;
	padding: 0.8vmin 1.1vmin;
	box-sizing: border-box;
}
.tg_nhd {
	font-family: "Fixedsys", sans-serif;
	font-size: 1.9vmin;
	line-height: 2.3vmin;
	color: #a8a8a8;
}
.container_notice .menu_notice {
	margin: 0.25vmin 0 0;
	font-size: 2.2vmin;
	line-height: 2.7vmin;
	text-align: right;
	color: #ff8a80;
	text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.85);
}
</style>
"}

/// 把模块 icons/ 里的图发给客户端，返回可直接放进 <img src> 的短资源名。
/mob/dead/new_player/proc/tg_lobby_ext_icon(rel_path, rsc_name)
	if(!client || !fexists(rel_path))
		return ""
	src << browse_rsc(file(rel_path), rsc_name)
	return rsc_name

/mob/dead/new_player/proc/get_title_html()
	var/dat = SStitle.title_html
	dat += TG_LOBBY_CSS

	if(SSticker.current_state == GAME_STATE_STARTUP)
		dat += {"<img src="loading_screen.gif" class="bg" alt="">"}
		dat += {"<div class="container_terminal" id="terminal"></div>"}
		dat += {"<style>@keyframes tg_load { from { width: 0%; } to { width: 99%; } } #progress { animation: tg_load 150s linear forwards; }</style>"}
		dat += {"<div class="container_progress" id="progress_container"><div class="progress_bar" id="progress"><div class="sub_progress_bar" id="sub_progress"></div></div></div>"}

		dat += {"
		<script language="JavaScript">
			var terminal = document.getElementById("terminal");
			var terminal_lines = \[\];
		"}

		for(var/message in GLOB.startup_messages)
			dat += {"terminal_lines.push(""[replacetext(message, "\"", "\\\"")]"");"}

		dat += {"
			function append_terminal_text(text) {
				if(text) {
					terminal_lines.push(text);
				}
				while(terminal_lines.length > [MAX_STARTUP_MESSAGES]) {
					terminal_lines.shift();
				}

				terminal.innerHTML = terminal_lines.join("");
			}

			append_terminal_text();

			var progress_bar = document.getElementById("progress");
			var sub_progress_bar = document.getElementById("sub_progress");
			var progress_container = document.getElementById("progress_container");
			var progress_started_ms = (new Date()).getTime();
			var progress_total_ms = 150000;
			if(progress_total_ms < 30000)
				progress_total_ms = 30000;

			setInterval(function() {
				var elapsed_ms = (new Date()).getTime() - progress_started_ms;
				var pct = elapsed_ms / progress_total_ms * 100;
				if(pct > 99) pct = 99;
				progress_bar.style.width = "" + pct + "%";
				sub_progress_bar.style.width = "" + Math.min(pct + 6, 99) + "%";
			}, 16.666666667);

			function update_loading_progress(current_time, total_time) {
				var raw = (current_time === undefined || current_time === null) ? "" : String(current_time);
				var s = (total_time === undefined || total_time === null) ? raw : String(total_time);
				if((total_time === undefined || total_time === null) && raw.indexOf("=") !== -1)
					s = raw.split("=")\[1\];
				var got = parseFloat(s);
				if(got > 0 && got < 100000)
					progress_total_ms = got * 100;
			}

			function update_current_character() {}
		</script>
		"}

	else
		dat += {"<img src="loading_screen.gif" class="bg" alt="">"}

		dat += {"<div class="container_notice tg_glass">"}
		dat += {"<div class="tg_nhd">◆ 通知</div>"}
		if(SStitle.current_notice)
			dat += {"<p class="menu_notice">[SStitle.current_notice]</p>"}
		else
			dat += {"<p class="menu_notice" style="color:#7d93a8;font-size:1.9vmin">暂无新通知</p>"}
		dat += "</div>"

		dat += {"<div class="tg_dock">"}
		dat += {"<a class="tg_handle" href='byond://?src=[text_ref(src)];tg_sidebar_toggle=1' title="收起/展开侧边栏"></a>"}
		dat += {"</div>"}

		var/wiki_icon = tg_lobby_ext_icon("modular_tianguan/modules/tg_lobby/icons/wiki.png", "tg_ext_wiki.png")
		var/moneybag_icon = tg_lobby_ext_icon("modular_tianguan/modules/tg_lobby/icons/moneybag.png", "tg_ext_moneybag.png")
		dat += {"<div class="tg_extlinks">"}
		dat += {"<a class="tg_ext" href='byond://?src=[text_ref(src)];tg_ext=wiki' title="天关维基（用系统浏览器打开）">天关wiki<img src="[wiki_icon]" alt=""></a>"}
		dat += {"<a class="tg_ext" href='byond://?src=[text_ref(src)];tg_ext=afdian' title="爱发电 · 支持天关（用系统浏览器打开）"><span class="tg_rainbow">支持我们</span><img class="tg_pixel" src="[moneybag_icon]" alt=""></a>"}
		dat += {"</div>"}

		dat += {"
		<script language="JavaScript">
			var ready_int = 0;
			function set_ready_look(want) {
				var el = document.getElementById("ready");
				if(!el) return;
				var ico = el.getElementsByTagName("span")\[0\];
				if(!ico) return;
				ico.className = want ? "checked" : "unchecked";
				ico.innerHTML = want ? "☑" : "☒";
			}
			function toggle_ready(setReady) {
				if(setReady === 1 || setReady === "1" || setReady === true)
					ready_int = 1;
				else if(setReady === 0 || setReady === "0" || setReady === false)
					ready_int = 0;
				else
					ready_int = ready_int ? 0 : 1;
				set_ready_look(ready_int);
			}
			var antag_int = 0;
			function set_antag_look(want) {
				var el = document.getElementById("be_antag");
				if(!el) return;
				var ico = el.getElementsByTagName("span")\[0\];
				if(!ico) return;
				ico.className = want ? "checked" : "unchecked";
				ico.innerHTML = want ? "☑" : "☒";
			}
			function toggle_antag(setAntag) {
				if(setAntag === 1 || setAntag === "1" || setAntag === true)
					antag_int = 1;
				else if(setAntag === 0 || setAntag === "0" || setAntag === false)
					antag_int = 0;
				else
					antag_int = antag_int ? 0 : 1;
				set_antag_look(antag_int);
			}

			function tg_restore_amp(s) {
				return s ? String(s).split("__TGAMP__").join("&") : "";
			}
			function update_current_character(name) {
				var slot = document.getElementById("character_slot");
				if(slot && name) slot.textContent = tg_restore_amp(name).toUpperCase();
			}

			function append_terminal_text() {}
			function update_loading_progress() {}

			function tg_set_avatar(data) {
				var e = document.getElementById("tg_avatar");
				if(!e || !data) return;
				e.src = "data:image/png;base64," + data.split(" ").join("+");
			}
			function tg_set_prefs(html) {
				var e = document.getElementById("tg_prefs");
				if(e) e.innerHTML = tg_restore_amp(html);
			}
			function tg_set_name(name) {
				var e = document.getElementById("tg_pname");
				if(e) e.textContent = tg_restore_amp(name);
			}
			function tg_set_pid(text) {
				var e = document.getElementById("tg_pid");
				if(e) e.textContent = tg_restore_amp(text);
			}

			function tg_set_collapsed(on) {
				var b = document.body;
				if(!b) return;
				var want = (on === 1 || on === "1" || on === true);
				var cur = b.className ? (" " + b.className + " ") : " ";
				var has = cur.indexOf(" tg_collapsed ") !== -1;
				if(want && !has) {
					b.className = b.className ? (b.className + " tg_collapsed") : "tg_collapsed";
				}
				else if(!want && has) {
					var parts = cur.split(" ");
					var out = "";
					for(var i = 0; i < parts.length; i++) {
						if(parts\[i\] && parts\[i\] !== "tg_collapsed") {
							out = out ? (out + " " + parts\[i\]) : parts\[i\];
						}
					}
					b.className = out;
				}
			}
			tg_set_collapsed("[tg_sidebar_collapsed ? 1 : 0]");
		</script>
		"}

		dat += {"<div class="tg_side tg_glass">"}

		var/art_tag = tg_lobby_art_html()
		if(art_tag)
			dat += {"<div class="tg_art">[art_tag]</div>"}

		dat += tg_lobby_card_html()

		dat += {"<div class="tg_btns">"}
		if(!SSticker || SSticker.current_state <= GAME_STATE_PREGAME)
			dat += {"<a id="ready" class="menu_button" href='byond://?src=[text_ref(src)];toggle_ready=1'>[ready == PLAYER_READY_TO_PLAY ? "<span class='checked'>☑</span> READY" : "<span class='unchecked'>☒</span> READY"]</a>"}
		else
			dat += {"
				<a class="menu_button" href='byond://?src=[text_ref(src)];late_join=1'>JOIN GAME</a>
				<a class="menu_button" href='byond://?src=[text_ref(src)];view_manifest=1'>CREW MANIFEST</a>
			"}
			dat += {"<a class="menu_button" href='byond://?src=[text_ref(src)];character_directory=1'>CHARACTER DIRECTORY</a>"}

		dat += {"<a class="menu_button" href='byond://?src=[text_ref(src)];observe=1'>OBSERVE</a>"}

		dat += {"
			<hr>
			<a class="menu_button" href='byond://?src=[text_ref(src)];character_setup=1'>SETUP CHARACTER (<span id="character_slot">[html_encode(uppertext(client.prefs.read_preference(/datum/preference/name/real_name)))]</span>)</a>
			<a class="menu_button" href='byond://?src=[text_ref(src)];game_options=1'>GAME OPTIONS</a>
			<a id="be_antag" class="menu_button" href='byond://?src=[text_ref(src)];toggle_antag=1'>[client.prefs.read_preference(/datum/preference/toggle/be_antag) ? "<span class='checked'>☑</span> BE ANTAGONIST" : "<span class='unchecked'>☒</span> BE ANTAGONIST"]</a>
			<!-- SPLURT STATION EDIT: Server swap button removed - not needed for single server setup -->
		"}

		if(length(GLOB.lobby_station_traits))
			dat += {"<a class="menu_button" href='byond://?src=[text_ref(src)];job_traits=1'>JOB TRAITS</a>"}

		if(!is_guest_key(src.key))
			dat += playerpolls()

		dat += "</div></div>"

	// Tell the server this page loaded.
	if(!title_screen_is_ready)
		dat += {"
			<script>
				var ready_request = new XMLHttpRequest();
				ready_request.open("GET", "?src=[text_ref(src)];title_is_ready=1", true);
				ready_request.send();
			</script>
		"}

	dat += "</body></html>"

	// ZH EDIT - i18n: 标题界面经 raw browse()（绕过 browser.dm 的 AC 钩子），在此专项本地化菜单文案
	if(GLOB.i18n_server_locale != DEFAULT_UI_LOCALE)
		dat = lang_localize_title_html(dat)

	return dat

/// 侧边栏顶部展示图：按 TG_LOBBY_ART_CANDIDATES 顺序取第一个存在的文件并投递到客户端资源缓存。
/mob/dead/new_player/proc/tg_lobby_art_html()
	if(!client)
		return ""
	for(var/art_path in TG_LOBBY_ART_CANDIDATES)
		if(!fexists(art_path))
			continue
		var/list/parts = splittext(art_path, ".")
		var/ext = length(parts) > 1 ? parts[length(parts)] : "gif"
		var/rsc_name = "tg_lobby_art.[ext]"
		src << browse_rsc(file(art_path), rsc_name)
		return {"<img src="[rsc_name]" alt="">"}
	return ""

/// 标题界面 HTML 的菜单文案本地化（zh-Hans；全服中文时由 get_title_html 调用）。
/proc/lang_localize_title_html(html)
	if(!istext(html))
		return html
	html = replacetext(html, "JOIN GAME", "加入游戏")
	html = replacetext(html, "CREW MANIFEST", "船员名册")
	html = replacetext(html, "CHARACTER DIRECTORY", "角色目录")
	html = replacetext(html, "SETUP CHARACTER", "角色设置")
	html = replacetext(html, "GAME OPTIONS", "游戏选项")
	html = replacetext(html, "BE ANTAGONIST", "扮演反派")
	html = replacetext(html, "JOB TRAITS", "职业特质")
	html = replacetext(html, "LATEJOIN QUEUE", "补位队列")
	html = replacetext(html, "SWAP SERVERS", "切换服务器")
	html = replacetext(html, ">OBSERVE<", ">旁观<")
	html = replacetext(html, " READY<", " 准备就绪<")
	html = replacetext(html, ">POLLS (NEW)<", ">治理中心认证 (新)<")
	html = replacetext(html, ">POLLS<", ">治理中心认证<")
	return html

#undef TG_LOBBY_CSS
#undef TG_LOBBY_ART_CANDIDATES
#undef MAX_STARTUP_MESSAGES

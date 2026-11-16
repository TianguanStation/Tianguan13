#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_hud_dmi.py — HUD dmi 中文重绘生成器（lobby-buttons/gen_dmi.py 的通用化扩展）

原理与原工具一致：把烤进精灵图的英文文字像素擦除（按行采样邻近背景色重建，保住
LCD 扫描线/渐变底），再用仓库内的 Fusion Pixel CJK 字体（OFL-1.1）渲染中文、
取原文字颜色上色调，逐帧重绘。输出为「同 state 名/帧数/方向完全对齐」的
drop-in 变体 dmi，运行时由 lang_hud_icon() 在全服中文时换图，原 .dmi 不动。

用法（仓库根目录）：
    python3 tools/i18n/hud-icons/gen_hud_dmi.py            # 生成全部
    python3 tools/i18n/hud-icons/gen_hud_dmi.py --preview  # 额外输出对照图 /tmp/hud_preview.png
    python3 tools/i18n/hud-icons/gen_hud_dmi.py --only icons/hud/radial.dmi

labels.json 配置说明见 readme.md。
"""
import json, os, struct, sys, zlib
from collections import Counter, deque
from PIL import Image, ImageDraw, ImageFont

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
CONF = os.path.join(os.path.dirname(os.path.abspath(__file__)), "labels.json")
OUT_DIR = "modular_zh/modules/i18n/icons/hud"

FONTS = {
    12: "modular_zh/modules/i18n/fonts/fusion_pixel_12px_zh_hans.ttf",
    10: "modular_zh/modules/i18n/fonts/fusion_pixel_10px_zh_hans.ttf",
    8: "modular_zh/modules/i18n/fonts/fusion_pixel_8px_zh_hans.ttf",
}
_font_cache = {}

def font(px):
    if px not in _font_cache:
        _font_cache[px] = ImageFont.truetype(os.path.join(ROOT, FONTS[px]), px)
    return _font_cache[px]

# ---------- DMI 元数据 ----------

def meta(path):
    d = open(path, "rb").read()
    i = 8
    m = None
    while i < len(d):
        ln = struct.unpack(">I", d[i:i + 4])[0]
        if d[i + 4:i + 8] == b"zTXt":
            _, rest = d[i + 8:i + 8 + ln].split(b"\x00", 1)
            try:
                m = zlib.decompress(rest[1:]).decode("latin1")
            except Exception:
                pass
        i += 12 + ln
    if m is None:
        raise RuntimeError(f"{path}: no zTXt metadata")
    w = h = 0
    st = []
    for L in m.splitlines():
        L = L.strip()
        if L.startswith("width ="):
            w = int(L.split("=")[1])
        elif L.startswith("height ="):
            h = int(L.split("=")[1])
        elif L.startswith("state ="):
            st.append([L.split("=")[1].strip().strip('"'), 1])
        elif L.startswith("frames ="):
            st[-1][1] *= int(L.split("=")[1])
        elif L.startswith("dirs ="):
            st[-1][1] *= int(L.split("=")[1])
    return w, h, st

def ztxt(path):
    """原 dmi 的第一个 zTXt chunk 原始字节（用于重打包保留元数据）"""
    d = open(path, "rb").read()
    i = 8
    while i < len(d):
        ln = struct.unpack(">I", d[i:i + 4])[0]
        if d[i + 4:i + 8] == b"zTXt":
            return d[i:i + 12 + ln]
        i += 12 + ln
    return None

# ---------- 文字检测 ----------

def components(cell, rect):
    """rect 内每个颜色的连通分量。返回 {color: [(x0,y0,x1,y1,[px...]), ...]}"""
    x0, y0, x1, y1 = rect
    px = cell.load()
    seen = set()
    out = {}
    for y in range(y0, y1):
        for x in range(x0, x1):
            if (x, y) in seen:
                continue
            c = px[x, y]
            if c[3] < 100:
                continue
            # flood fill same-color 8-conn
            q = deque([(x, y)])
            seen.add((x, y))
            pts = []
            while q:
                cx, cy = q.popleft()
                pts.append((cx, cy))
                for dx in (-1, 0, 1):
                    for dy in (-1, 0, 1):
                        nx, ny = cx + dx, cy + dy
                        if nx < x0 or nx >= x1 or ny < y0 or ny >= y1 or (nx, ny) in seen:
                            continue
                        nc = px[nx, ny]
                        if nc == c:
                            seen.add((nx, ny))
                            q.append((nx, ny))
            xs = [p[0] for p in pts]
            ys = [p[1] for p in pts]
            out.setdefault(c, []).append((min(xs), min(ys), max(xs), max(ys), pts))
    return out

def letter_comps(cs, maxw=10, maxh=13):
    """筛出像字母笔画的分量：高<=maxh、宽<=maxw、>=3px；
    1px 高的横条必须是 >=2px 宽（LCD 扫描线风格字母由横条构成，如 alien CHEST）；
    排除贴 cell 边缘的细条（边框高光常被画成文字色）"""
    out = []
    for c in cs:
        w = c[2] - c[0]
        h = c[3] - c[1]
        if w > maxw or h > maxh or len(c[4]) < 3:
            continue
        if h < 2 and w < 2:
            continue
        if w <= 1 and (c[0] <= 1 or c[2] >= 30):
            continue
        out.append(c)
    return out

def local_bg_lum(cell, cand):
    """字母分量紧邻外围像素的中位亮度——即文字所在底板的真实背景亮度。
    比 rect 众数色更准：rect 里图标主体会稀释底板色，导致对比度选色失真。"""
    px = cell.load()
    W, H = cell.size
    lums = []
    for cs in cand.values():
        for c in cs:
            x0, y0, x1, y1, _ = c
            for x in range(max(0, x0 - 1), min(W, x1 + 2)):
                for y in (y0 - 1, y1 + 1):
                    if 0 <= y < H:
                        p = px[x, y]
                        if p[3] >= 100:
                            lums.append(_lum(p[:3]))
            for y in range(max(0, y0 - 1), min(H, y1 + 2)):
                for x in (x0 - 1, x1 + 1):
                    if 0 <= x < W:
                        p = px[x, y]
                        if p[3] >= 100:
                            lums.append(_lum(p[:3]))
    if not lums:
        return bg_luminance(cell, (0, 0, W, H))
    lums.sort()
    return lums[len(lums) // 2]

def pick_ink(cand, bg_lum):
    """字形本色：取与局部背景亮度差最大（对比度最高）的候选色；
    对比度相近(差<=15)时取像素多者（避免把图标高光碎块当文字）。"""
    if len(cand) == 1:
        return next(iter(cand))
    items = [(color, sum(len(c[4]) for c in cs)) for color, cs in cand.items()]
    scored = [(abs(_lum(c) - bg_lum), px, c) for c, px in items if px >= 4]
    if not scored:
        scored = [(abs(_lum(c) - bg_lum), px, c) for c, px in items]
    scored.sort(key=lambda t: (-t[0], -t[1]))
    top = scored[0]
    for s in scored[1:]:
        if top[0] - s[0] <= 15 and s[1] > top[1] * 1.5:
            return s[2]
    return top[2]

def bg_luminance(cell, rect):
    """rect 内背景亮度。优先统计全不透明(alpha>=200)像素——radial 等
    半透明叠加文字(alpha~100)会淹没真实底板色；无不透明像素时回退 alpha>=100。"""
    x0, y0, x1, y1 = rect
    for thresh in (200, 100):
        cnt = Counter()
        px = cell.load()
        for y in range(y0, y1):
            for x in range(x0, x1):
                c = px[x, y]
                if c[3] >= thresh:
                    cnt[c[:3]] += 1
        if cnt:
            return _lum(cnt.most_common(1)[0][0])
    return 0

def dominant_bg(cell, rect):
    """rect 内的底板色 RGB = 最大连通分量的颜色。
    底板（按钮面/背景）总是面积最大的色块；用「最大分量」而非「最多像素」
    是因为 radial 的搜索框常被半透明文字淹没像素数，而 glass 的文字是不透明
    小分量、底板是半透明大分量——两种情况都由最大分量正确判定。"""
    comps = components(cell, rect)
    best, bestn = None, 0
    for color, cs in comps.items():
        for c in cs:
            if len(c[4]) > bestn:
                bestn, best = len(c[4]), color[:3]
    return best

def detect(cell, rect, pick=None, compw=10, comph=13):
    """rect 内的文字检测。
    流程：字母形分量 → ink 选色 → focus=ink 分量并集
    → mask=落入 focus+2 的所有分量（收描边/噪点，排除边框角块/图块）
    pick: 'bright' 最亮色 | 'most' 最多像素 | '#rrggbb' 就近色
    返回 (mask, colors, focus, ink) 或 None"""
    comps = components(cell, rect)
    bg_rgb = dominant_bg(cell, rect)
    cand = {}
    for color, cs in comps.items():
        if bg_rgb is not None and color[:3] == bg_rgb:
            continue  # 底板色碎块不是文字（radial 纯色底被笔画切碎的岛屿）
        lc = letter_comps(cs, compw, comph)
        if lc:
            cand[color] = lc
    if not cand:
        return None
    # ink 选色（pick 覆盖）与 mask 收色（cand_all=全部候选）解耦：
    # 描边/渐变等其他色字母分量仍要进 mask 才能擦净
    if isinstance(pick, str) and pick.startswith("#"):
        tgt = tuple(int(pick[i:i + 2], 16) for i in (1, 3, 5))
        ink = min(cand, key=lambda c: (c[0] - tgt[0]) ** 2 + (c[1] - tgt[1]) ** 2 + (c[2] - tgt[2]) ** 2)
    elif pick == "bright":
        ink = max(cand, key=lambda c: c[0] + c[1] + c[2])
    elif pick == "most":
        ink = max(cand, key=lambda c: sum(len(x[4]) for x in cand[c]))
    elif pick == "sat":
        # 最高饱和度（彩色文字在中性背景上最醒目，如 alien 红字）
        ink = max(cand, key=lambda c: (max(c[:3]) - min(c[:3]),
                                       sum(len(x[4]) for x in cand[c])))
    else:
        ink = pick_ink(cand, bg_luminance(cell, rect))
    ics = cand[ink]
    focus = (min(c[0] for c in ics), min(c[1] for c in ics),
             max(c[2] for c in ics), max(c[3] for c in ics))
    # 同带扩展：与 focus 行带（±4px）相交、且横向中心落在 focus±8 内的所有候选
    # 字母分量并入（渐变/多色词的其他色字母也要覆盖，如 COMBO 深浅红、D3AD 白字红描边；
    # 横向约束避免把同一行带上远处的图标碎块误当字母擦掉）
    ext = [c for cs in cand.values() for c in cs
           if (c[1] + c[3]) // 2 >= focus[1] - 4 and (c[1] + c[3]) // 2 <= focus[3] + 4
           and (c[0] + c[2]) // 2 >= focus[0] - 8 and (c[0] + c[2]) // 2 <= focus[2] + 8]
    if ext:
        focus = (min([focus[0]] + [c[0] for c in ext]), min([focus[1]] + [c[1] for c in ext]),
                 max([focus[2]] + [c[2] for c in ext]), max([focus[3]] + [c[3] for c in ext]))
    fx0, fy0, fx1, fy1 = focus[0] - 2, focus[1] - 2, focus[2] + 2, focus[3] + 2
    mask = set()
    colors = Counter()
    for color, cs in comps.items():
        if color not in cand:
            continue
        for c in cs:
            if c[0] >= fx0 and c[1] >= fy0 and c[2] <= fx1 and c[3] <= fy1:
                for p in c[4]:
                    mask.add(p)
                    colors[color] += 1
    if not mask:
        return None
    return mask, colors, focus, ink

# ---------- 擦除与重绘 ----------

def _parse_hex(h):
    """#rrggbb 或 #rrggbbaa 转 RGBA 元组"""
    if len(h) == 9:
        return tuple(int(h[i:i + 2], 16) for i in (1, 3, 5, 7))
    return tuple(int(h[i:i + 2], 16) for i in (1, 3, 5)) + (255,)

def _apply_cell_parity(img, px, py, outline, part):
    """对齐 cell 坐标后处理：
    - radial 描边：偶数 y 行 (22,22,27,alpha)，奇数 y 行 (0,0,0,alpha)
    - even_color：前景笔画按 (py + y) 奇偶行着交替色（扫描线文本如 alien / cyborg / alert）"""
    rad_a = outline[1] if isinstance(outline, tuple) and outline and outline[0] == "radial" else None
    even_col = _parse_hex(part["even_color"]) if part.get("even_color") else None
    if rad_a is None and even_col is None:
        return
    ip = img.load()
    iw, ih = img.size
    fg_m = getattr(img, "_fg_mask", None)
    for yy in range(ih):
        cy = py + yy
        for xx in range(iw):
            r, g, b, a = ip[xx, yy]
            if a == 0:
                continue
            is_fg = bool(fg_m and fg_m[xx, yy])
            if rad_a is not None and not is_fg:
                ip[xx, yy] = (22, 22, 27, rad_a) if cy % 2 == 0 else (0, 0, 0, rad_a)
            elif even_col is not None and is_fg and cy % 2 == 0:
                ip[xx, yy] = even_col

def _render_and_place(cell, lines, box, color, outline, part, bg_ref, audit, warn_extra=None):
    """共用排版辅助：选最大可读字号、居中/偏移、贴边保护并写入 cell"""
    W, H = cell.size
    bx0, by0, bx1, by1 = box
    cx, cy = (bx0 + bx1) // 2, (by0 + by1) // 2
    maxw = part.get("maxw", bx1 - bx0)
    maxh = part.get("maxh", by1 - by0)
    sizes = [part["size"]] if part.get("size") else part.get("sizes") or [12, 10, 8]
    img = used = None
    for sz in sizes:
        cand = render_lines(lines, sz, color, outline, part)
        if cand and cand.width <= maxw and cand.height <= maxh:
            img, used = cand, sz
            break
    warn = warn_extra
    clip_y = part.get("clip_y")
    if img is None:
        img = render_lines(lines, sizes[-1], color, outline, part)
        used = sizes[-1]
        max_allowed_h = (clip_y[1] - clip_y[0] if clip_y else maxh) + 2
        if not (img.width <= W and img.height <= max_allowed_h):
            warn = (warn + " " if warn else "") + f"OVERSIZE({img.width}x{img.height}>{maxw}x{maxh})"
    px = cx - img.width // 2 + part.get("dx", 0)
    py = cy - img.height // 2 + part.get("dy", 0)
    if img.width <= W:
        px = max(0, min(W - img.width, px))
    else:
        px, warn = 0, (warn or "") + " WIDE"
    if img.height <= H:
        if not clip_y:
            py = max(0, min(H - img.height, py))
    else:
        py, warn = 0, (warn or "") + " TALL"
    _apply_cell_parity(img, px, py, outline, part)
    clip_y0, clip_y1 = clip_y if clip_y else (0, H)
    cpx = cell.load()
    ipx = img.load()
    for yy in range(img.height):
        cy_p = py + yy
        if cy_p < clip_y0 or cy_p >= clip_y1 or cy_p < 0 or cy_p >= H:
            continue
        for xx in range(img.width):
            cx_p = px + xx
            if 0 <= cx_p < W:
                p = ipx[xx, yy]
                if p[3] > 0:
                    cpx[cx_p, cy_p] = p
    if audit is not None:
        blum = _lum(bg_ref) if isinstance(bg_ref, tuple) else bg_ref
        ol_rgba = (22, 22, 27, outline[1]) if isinstance(outline, tuple) and outline and outline[0] == "radial" else outline
        ct = max(abs(_lum(color) - blum), abs(_lum(ol_rgba) - blum) if ol_rgba else 0)
        audit.append((part.get("_name", "?"), {
            "src": part.get("_src", "?"),
            "text": "".join(lines), "size": used, "img": (img.width, img.height),
            "box": (bx0, by0, bx1, by1), "pos": (px, py), "cell": (W, H),
            "ink": bg_ref[:3] if isinstance(bg_ref, tuple) else color[:3],
            "inklum": blum, "color": color[:3], "bglum": blum,
            "contrast": ct, "outline": bool(outline), "warn": warn}))

def erase(cell, mask, avoid_dark=False):
    """把 mask 像素替换为水平/垂直邻近非 mask 像素颜色（全行宽搜索，保扫描线与透明底）"""
    px = cell.load()
    W, H = cell.size
    def _ok(c):
        if c[3] != 0 and c[3] < 100:
            return False
        if avoid_dark and c[3] >= 100 and (c[0] + c[1] + c[2]) < 40:
            return False
        return True
    for (x, y) in mask:
        found = None
        for r in range(1, W):
            for nx in (x - r, x + r):
                if 0 <= nx < W and (nx, y) not in mask:
                    c = px[nx, y]
                    if _ok(c):
                        found = c
                        break
            if found:
                break
        if not found:
            for r in range(1, H):
                for ny in (y - r, y + r):
                    if 0 <= ny < H and (x, ny) not in mask:
                        c = px[x, ny]
                        if _ok(c):
                            found = c
                            break
                if found:
                    break
        px[x, y] = found if found else (0, 0, 0, 255)

def _localize_button_transparent(cell, part, rect, W, H, audit=None):
    """透明背景径向按钮（vanilla radial*.dmi / zubbers radial.dmi）：
    rect 内清成全透明（底边保留下邻不透明图标的自然描边），再居中渲染与原字同款描边/alpha 的中文。"""
    px = cell.load()
    rx0, ry0, rx1, ry1 = max(0, rect[0]), max(0, rect[1]), min(W, rect[2]), min(H, rect[3])
    fg_counts = Counter()
    opaque_dark = semi_dark = 0
    xs, ys = [], []
    for y in range(ry0, ry1):
        for x in range(rx0, rx1):
            p = px[x, y]
            if p[3] >= 200 and (p[0] + p[1] + p[2]) > 120:
                fg_counts[p[:3]] += 1
                xs.append(x)
                ys.append(y)
            elif (p[0] + p[1] + p[2]) <= 80 and p[3] > 0:
                if p[3] >= 200:
                    opaque_dark += 1
                elif p[3] >= 20:
                    semi_dark += 1
    if not fg_counts:
        return False
    fg = fg_counts.most_common(1)[0][0]
    color = _parse_hex(part["color"]) if part.get("color") else fg + (255,)
    ol_alpha = 255 if opaque_dark > semi_dark else 100
    bot_y = ry1 - 1
    for y in range(ry0, ry1):
        for x in range(rx0, rx1):
            p = px[x, y]
            if y == bot_y and p[3] < 200 and bot_y + 1 < H:
                if any(px[nx, bot_y + 1][3] >= 200 for nx in range(max(0, x - 1), min(W, x + 2))):
                    continue  # 紧贴下方图标实像素顶部半透明描边不伤及
            px[x, y] = (0, 0, 0, 0)
    ol_opt = part.get("outline")
    if ol_opt is False:
        ol = None
    elif isinstance(ol_opt, str) and ol_opt.startswith("#"):
        ol = _parse_hex(ol_opt)
    else:
        ol = ("radial", ol_alpha)
    lines = part.get("lines") or [part["text"]]
    if "box" in part:
        box = tuple(part["box"])
    else:
        by0 = max(0, min(ys) - 2)
        by1 = min(H, max(max(ys) + 3, ry1))
        box = (rx0, by0, rx1, by1)
    sizes_part = dict(part)
    if "sizes" not in sizes_part and "size" not in sizes_part:
        sizes_part["sizes"] = [10, 8]
    _render_and_place(cell, lines, box, color, ol, sizes_part, 24, audit)
    return True

def localize_button(cell, part, W, H, audit=None):
    """径向菜单按钮处理：自动区分透明底径向图标与实心圆角按钮底板。"""
    rect = part.get("search") or part.get("rect") or (0, 0, W, H)
    px = cell.load()
    rx0, ry0, rx1, ry1 = max(0, rect[0]), max(0, rect[1]), min(W, rect[2]), min(H, rect[3])
    trans_cnt = sum(1 for y in range(ry0, ry1) for x in range(rx0, rx1) if px[x, y][3] < 200)
    opaque_cnt = (ry1 - ry0) * (rx1 - rx0) - trans_cnt
    if part.get("bg") == "transparent" or trans_cnt > opaque_cnt:
        return _localize_button_transparent(cell, part, rect, W, H, audit)
    cnt = Counter()
    for y in range(ry0, ry1):
        for x in range(rx0, rx1):
            p = px[x, y]
            if p[3] >= 200:
                cnt[p[:3]] += 1
    if not cnt:
        return False
    bg = cnt.most_common(1)[0][0]
    xs, ys = [], []
    for y in range(ry0, ry1):
        for x in range(rx0, rx1):
            p = px[x, y]
            if p[3] >= 200 and p[:3] == bg:
                xs.append(x)
                ys.append(y)
    if not xs:
        return False
    fx0, fy0, fx1, fy1 = min(xs), min(ys), max(xs), max(ys)
    mask = set()
    for y in range(fy0, fy1 + 1):
        for x in range(fx0, fx1 + 1):
            p = px[x, y]
            if p[3] >= 100 and p[:3] != bg:
                mask.add((x, y))
    if not mask:
        return False
    bga = bg + (255,)
    for (x, y) in mask:
        px[x, y] = bga
    lines = part.get("lines") or [part["text"]]
    blum = _lum(bg)
    color = _parse_hex(part["color"]) if part.get("color") else ((24, 24, 28, 255) if blum >= 128 else (238, 238, 244, 255))
    pad = part.get("pad", 1)
    box = tuple(part["box"]) if "box" in part else (max(0, fx0 - pad), max(0, fy0 - pad), min(W, fx1 + 1 + pad), min(H, fy1 + 1 + pad))
    sizes_part = dict(part)
    if "sizes" not in sizes_part and "size" not in sizes_part:
        sizes_part["sizes"] = [10, 8]
    _render_and_place(cell, lines, box, color, None, sizes_part, bg, audit)
    return True

def erase_flat(cell, mask, bg_hex=None):
    """把 mask 像素统一填充为指定色或其包围盒内非 mask 像素的众数色。"""
    px = cell.load()
    W, H = cell.size
    if bg_hex:
        fill = _parse_hex(bg_hex)
    else:
        xs = [p[0] for p in mask]
        ys = [p[1] for p in mask]
        x0, x1 = max(0, min(xs) - 2), min(W, max(xs) + 3)
        y0, y1 = max(0, min(ys) - 2), min(H, max(ys) + 3)
        cnt = Counter()
        for yy in range(y0, y1):
            for xx in range(x0, x1):
                if (xx, yy) not in mask:
                    p = px[xx, yy]
                    if p[3] >= 100:
                        cnt[p] += 1
        fill = cnt.most_common(1)[0][0] if cnt else (0, 0, 0, 255)
    for (x, y) in mask:
        px[x, y] = fill

def _mask(text, px_size, stroke=0):
    """把文字渲成二值 alpha mask（白=字形）。stroke>0 时外扩描边一圈。"""
    f = font(px_size)
    lay = Image.new("L", (192, 64), 0)
    d = ImageDraw.Draw(lay)
    if stroke:
        d.text((6, 4), text, font=f, fill=255, stroke_width=stroke, stroke_fill=255)
    else:
        d.text((6, 4), text, font=f, fill=255)
    return lay.point(lambda v: 255 if v > 90 else 0)

def _dilate_cross(fill):
    """4-邻接十字外扩 1px（保留清晰四角）"""
    w, h = fill.size
    fp = fill.load()
    out = Image.new("L", (w, h), 0)
    op = out.load()
    for y in range(h):
        for x in range(w):
            if fp[x, y] or (x > 0 and fp[x - 1, y]) or (x + 1 < w and fp[x + 1, y]) or (y > 0 and fp[x, y - 1]) or (y + 1 < h and fp[x, y + 1]):
                op[x, y] = 255
    return out

def textimg(text, px_size, color, outline=None, part=None):
    """渲染单行文字为 RGBA 小图。支持：
    - outline: None | (r,g,b,a) | ('radial', alpha)
    - part.outline_mode: 'box'(8-邻接) | 'cross'(4-邻接)
    - part.shadow / shadow_top / shadow_bottom: 1px 阴影
    - part.grad_color: 上下半部分双色渐变"""
    part = part or {}
    fill = _mask(text, px_size)
    fw, fh = fill.size
    is_rad = isinstance(outline, tuple) and outline and outline[0] == "radial"
    ol_rgba = (22, 22, 27, outline[1]) if is_rad else outline
    sh_col = _parse_hex(part["shadow"]) if part.get("shadow") else None
    sh_top = _parse_hex(part["shadow_top"]) if part.get("shadow_top") else None
    sh_bot = _parse_hex(part["shadow_bottom"]) if part.get("shadow_bottom") else None
    grad_col = _parse_hex(part["grad_color"]) if part.get("grad_color") else None

    canvas_fill = Image.new("L", (fw + 2, fh + 2), 0)
    canvas_fill.paste(fill, (1, 1))
    cw, ch = canvas_fill.size
    fp = canvas_fill.load()

    layers = Image.new("RGBA", (cw, ch), (0, 0, 0, 0))
    lp = layers.load()
    fg_mask = Image.new("L", (cw, ch), 0)
    fgp = fg_mask.load()

    # 阴影层（画在字身下方）
    if sh_top or sh_bot:
        for y in range(ch):
            for x in range(cw):
                if not fp[x, y]:
                    continue
                if sh_top and y > 0 and not fp[x, y - 1]:
                    lp[x, y - 1] = sh_top
                if sh_bot:
                    for dx, dy in ((1, 0), (0, 1), (1, 1)):
                        nx, ny = x + dx, y + dy
                        if nx < cw and ny < ch and not fp[nx, ny]:
                            lp[nx, ny] = sh_bot
    if sh_col:
        offs = part.get("shadow_offset")
        if offs is None:
            offs = [(1, 0), (0, 1), (1, 1)]
        elif isinstance(offs[0], int):
            offs = [tuple(offs)]
        for y in range(ch):
            for x in range(cw):
                if not fp[x, y]:
                    continue
                for dx, dy in offs:
                    nx, ny = x + dx, y + dy
                    if 0 <= nx < cw and 0 <= ny < ch and not fp[nx, ny]:
                        lp[nx, ny] = sh_col

    # 描边层
    if ol_rgba:
        stroke = _dilate_cross(canvas_fill) if part.get("outline_mode") == "cross" else _mask(text, px_size, 1)
        if part.get("outline_mode") == "cross":
            sp = stroke.load()
        else:
            canvas_stroke = Image.new("L", (cw, ch), 0)
            canvas_stroke.paste(stroke, (1, 1))
            sp = canvas_stroke.load()
        for y in range(ch):
            for x in range(cw):
                if sp[x, y] and not fp[x, y]:
                    lp[x, y] = ol_rgba

    # 前景字身（含可选上下半渐变）
    f_bb = canvas_fill.getbbox()
    if not f_bb:
        return None
    mid_y = (f_bb[1] + f_bb[3]) // 2
    for y in range(ch):
        for x in range(cw):
            if fp[x, y]:
                lp[x, y] = grad_col if (grad_col and y >= mid_y) else color
                fgp[x, y] = 255

    bb = layers.getbbox()
    if not bb:
        return None
    out = layers.crop(bb)
    out._fg_mask = fg_mask.crop(bb).load()
    return out

def render_lines(lines, px_size, color, outline=None, part=None):
    imgs = [textimg(l, px_size, color, outline, part) for l in lines]
    imgs = [i for i in imgs if i]
    if not imgs:
        return None
    w = max(i.width for i in imgs)
    h = sum(i.height for i in imgs) + len(imgs) - 1
    out = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    fg_comb = Image.new("L", (w, h), 0)
    fgp = fg_comb.load()
    y = 0
    for i in imgs:
        ox = (w - i.width) // 2
        out.alpha_composite(i, (ox, y))
        if getattr(i, "_fg_mask", None) is not None:
            for yy in range(i.height):
                for xx in range(i.width):
                    if i._fg_mask[xx, yy]:
                        fgp[ox + xx, y + yy] = 255
        y += i.height + 1
    out._fg_mask = fg_comb.load()
    return out

def _lum(c):
    return (c[0] * 299 + c[1] * 587 + c[2] * 114) // 1000

def _cyborg_glare_px(mode, x, y, orig_px):
    """还原 cyborg / alert 顶左角玻璃反光带（不截断斜角高光）"""
    s = x + y
    if mode == "panel":
        return orig_px[x, y] if s <= 11 else (0, 0, 0, 255)
    if mode == "health":
        if x == 8 and y == 3:
            return (0, 0, 0, 255)
        if s <= 13:
            return (128, 128, 128, 255)
        if s == 14 or (x == 8 and y in (6, 7)):
            return (64, 64, 64, 255)
        return (0, 0, 0, 255)
    if mode == "health5":
        if s <= 15:
            p = orig_px[x, y]
            # 替换斜角高光带中的红字为对应亮度的白红/暗灰反光
            if p[:3] == (255, 0, 0):
                return (255, 128, 128, 255)
            if p[:3] == (186, 0, 0):
                return (101, 64, 64, 255)
            return p
        return (68, 0, 0, 255) if y % 2 == 1 else (50, 0, 0, 255)
    if mode == "alert":
        if s <= 10:
            return (63, 63, 63, 255)
        if s == 11:
            return (47, 47, 47, 255)
        if s == 12:
            return (31, 31, 31, 255)
        return (0, 0, 0, 255)
    return (0, 0, 0, 255)

def localize(cell, spec, W, H, audit=None, meta_name="?", meta_src="?"):
    """cell 就地中文化。spec: labels.json 的单个 state 配置
    audit: 可选 list，追加 (tag, info) 供 --audit 输出"""
    parts = spec.get("parts")
    if parts is None:
        parts = [spec]
    repaints = []
    px = cell.load()
    handled = False
    for raw_part in parts:
        part = {**raw_part, "_name": meta_name, "_src": meta_src}
        if part.get("button"):
            if localize_button(cell, part, W, H, audit):
                handled = True
            continue
    if handled and all(p.get("button") for p in parts):
        return True
    for raw_part in parts:
        part = {**raw_part, "_name": meta_name, "_src": meta_src}
        if part.get("button"):
            continue
        if "maskrect" in part:
            mx0, my0, mx1, my1 = part["maskrect"]
            mc = _parse_hex(part["mask_color"])[:3] if part.get("mask_color") else None
            mb = part.get("mask_bright")
            mr = part.get("mask_red")
            ms = part.get("mask_sat")
            mask_white_or_black = part.get("mask_wb", False)
            min_a = part.get("mask_min_a", 100)
            mask = set()
            colors = Counter()
            xs, ys = [], []
            for yy in range(max(0, my0), min(my1, H)):
                for xx in range(max(0, mx0), min(mx1, W)):
                    p = px[xx, yy]
                    if p[3] < min_a:
                        continue
                    if mc and sum(abs(p[i] - mc[i]) for i in range(3)) >= 40:
                        continue
                    if mb is not None and max(p[:3]) < mb:
                        continue
                    if mr is not None and (p[0] - max(p[1], p[2])) < mr:
                        continue
                    if ms is not None and (max(p[:3]) - min(p[:3])) < ms:
                        continue
                    if mask_white_or_black:
                        if not ((p[0] > 235 and p[1] > 235 and p[2] > 235) or (p[0] + p[1] + p[2] < 20)):
                            continue
                    mask.add((xx, yy))
                    colors[p[:3]] += 1
                    xs.append(xx)
                    ys.append(yy)
            if mask:
                bbox = (min(xs), min(ys), max(xs), max(ys))
                spec_col = part.get("color") or part.get("pick")
                if isinstance(spec_col, str) and spec_col.startswith("#"):
                    ink = tuple(int(spec_col[i:i + 2], 16) for i in (1, 3, 5))
                elif spec_col == "bright":
                    ink = max(colors, key=lambda c: c[0] + c[1] + c[2])
                elif spec_col == "sat":
                    ink = max(colors, key=lambda c: (max(c) - min(c), colors[c]))
                else:
                    ink = max(colors, key=lambda c: colors[c])
                ink = tuple(ink) + (255,)
                repaints.append(((mask, colors, bbox, ink), part))
            continue
        rect = part.get("rect") or part.get("search") or (0, 0, W, H)
        det = detect(cell, rect, part.get("pick"), part.get("compw", 10), part.get("comph", 13))
        if det:
            repaints.append((det, part))
    if not repaints:
        return handled
    orig = cell.copy()
    orig_px = orig.load()
    # 逐 part：按需备份覆盖图形 → 擦除 → 提取字体/描边色 → 渲染 → 居中 → 恢复图形
    for (det, part) in repaints:
        mask, colors, bbox, ink = det
        kept_px = []
        if part.get("keep_blue_x"):
            px = cell.load()
            blue_coords = {(x, y) for y in range(H) for x in range(W)
                           if px[x, y][3] >= 100 and px[x, y][2] > px[x, y][0] + 40 and px[x, y][2] > 100}
            for (bx, by) in blue_coords:
                kept_px.append((bx, by, px[bx, by]))
                for dx, dy in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                    nx, ny = bx + dx, by + dy
                    if 0 <= nx < W and 0 <= ny < H and (nx, ny) not in blue_coords:
                        p = px[nx, ny]
                        if p[3] >= 100 and (p[0] + p[1] + p[2]) < 45:
                            kept_px.append((nx, ny, p))

        fill_mode = part.get("fill")
        if fill_mode == "template_col":
            ref_x = part["ref_x"]
            px = cell.load()
            for (mx, my) in mask:
                px[mx, my] = orig_px[ref_x, my]
        elif fill_mode == "template_row":
            ref_y = part["ref_y"]
            even_ref_y = part.get("even_ref_y")
            ref_x_pt = part.get("ref_pt")  # 可选：指定单一像素坐标作奇偶扫描线样本
            even_pt = part.get("even_pt")
            top_pt = part.get("top_pt")
            top_y = part.get("top_y")
            mirror_x28 = part.get("mirror_x28", False)
            px = cell.load()
            for (mx, my) in mask:
                if mirror_x28 and mx == 28:
                    px[mx, my] = orig_px[3, my]
                elif top_pt and top_y is not None and my == top_y:
                    px[mx, my] = orig_px[top_pt[0], top_pt[1]]
                elif my % 2 == 0 and even_pt:
                    px[mx, my] = orig_px[even_pt[0], even_pt[1]]
                elif my % 2 == 1 and ref_x_pt:
                    px[mx, my] = orig_px[ref_x_pt[0], ref_x_pt[1]]
                elif even_ref_y is not None and my % 2 == 0:
                    px[mx, my] = orig_px[mx, even_ref_y]
                else:
                    px[mx, my] = orig_px[mx, ref_y]
        elif fill_mode == "scanline_ref":
            px = cell.load()
            for (mx, my) in mask:
                if my == 3:
                    px[mx, my] = orig_px[3, 3] if mx in (3, 28) else orig_px[3, 9]
                elif my % 2 == 0:
                    px[mx, my] = orig_px[3, 10] if mx in (3, 28) else orig_px[6, 10]
                else:
                    px[mx, my] = orig_px[3, 9] if mx in (3, 28) else orig_px[4, 11]
        elif fill_mode == "scanline_hex":
            even_c = _parse_hex(part["even_bg"])
            odd_c = _parse_hex(part["odd_bg"])
            px = cell.load()
            for (mx, my) in mask:
                px[mx, my] = even_c if my % 2 == 0 else odd_c
        elif fill_mode == "cyborg_glare":
            gmode = part.get("glare_mode", "health")
            px = cell.load()
            for (mx, my) in mask:
                px[mx, my] = _cyborg_glare_px(gmode, mx, my, orig_px)
        elif fill_mode == "flat":
            erase_flat(cell, mask, part.get("bg"))
        elif fill_mode == "transparent":
            px = cell.load()
            for (mx, my) in mask:
                px[mx, my] = (0, 0, 0, 0)
        elif fill_mode == "row_mode":
            px = cell.load()
            rx0, _, rx1, _ = part.get("maskrect") or (0, 0, W, H)
            rx0, rx1 = max(0, rx0), min(W, rx1)
            by_y = {}
            for (mx, my) in mask:
                by_y.setdefault(my, []).append(mx)
            for my, mxs in by_y.items():
                cnt = Counter(px[xx, my] for xx in range(rx0, rx1)
                              if (xx, my) not in mask and px[xx, my][3] >= 50)
                if not cnt:
                    cnt = Counter(px[xx, my] for xx in range(W)
                                  if (xx, my) not in mask and px[xx, my][3] >= 50)
                fill = cnt.most_common(1)[0][0] if cnt else (0, 0, 0, 255)
                for mx in mxs:
                    px[mx, my] = fill
        elif fill_mode == "pill_box":
            px0, py0, px1, py1 = part["pill_rect"]
            bpt = part["border_pt"]
            bgpt = part["bg_pt"]
            border_c = orig_px[bpt[0], bpt[1]]
            bg_c = orig_px[bgpt[0], bgpt[1]]
            px = cell.load()
            for (mx, my) in mask:
                px[mx, my] = (0, 0, 0, 0)
            for xx in range(px0 + 1, px1 - 1):
                px[xx, py0] = border_c
                px[xx, py1 - 1] = border_c
            for yy in range(py0 + 1, py1 - 1):
                px[px0, yy] = border_c
                px[px1 - 1, yy] = border_c
                for xx in range(px0 + 1, px1 - 1):
                    px[xx, yy] = bg_c
        else:
            pad_bg = (max(0, bbox[0] - 4), max(0, bbox[1] - 4), min(W, bbox[2] + 5), min(H, bbox[3] + 5))
            avoid_dark = bg_luminance(cell, pad_bg) >= 40
            erase(cell, mask, avoid_dark=avoid_dark)

        # 自动提取原字前景色 + 1px 光晕色（用于 5 套标准人类主题统一适配）
        auto_fg = auto_ol = None
        if part.get("auto_halo"):
            even_bg = orig_px[3, 3]
            if fill_mode == "scanline_ref" and even_bg[1] > 200 and even_bg[0] < 100:
                auto_fg = (132, 169, 198, 255)
                auto_ol = (91, 116, 132, 255)
            else:
                border_ys = set(part.get("ignore_ys", ()))
                px_now = cell.load()
                bg_sample_set = {px_now[mx, my] for (mx, my) in mask if my not in border_ys}
                diff_px = [orig_px[mx, my] for (mx, my) in mask
                           if my not in border_ys and orig_px[mx, my][3] >= 100
                           and orig_px[mx, my] not in bg_sample_set]
                if diff_px:
                    auto_fg = max(diff_px, key=lambda c: c[0] + c[1] + c[2])
                    dark_cand = [c for c in diff_px if c[:3] != auto_fg[:3]]
                    auto_ol = min(dark_cand, key=lambda c: _lum(c)) if dark_cand else None

        if part.get("fg_pt"):
            fpt = part["fg_pt"]
            color = orig_px[fpt[0], fpt[1]]
        elif part.get("color"):
            color = _parse_hex(part["color"])
        else:
            color = auto_fg if auto_fg else ink
        lines = part.get("lines") or [part["text"]]
        pad = part.get("pad", 4)
        if "box" in part:
            bx0, by0, bx1, by1 = part["box"]
        else:
            bx0, by0 = max(0, bbox[0] - pad), max(0, bbox[1] - pad)
            bx1, by1 = min(W, bbox[2] + pad + 1), min(H, bbox[3] + pad + 1)
        bg_rgbs = [cell.getpixel((xx, yy))[:3]
                   for yy in range(max(0, by0), min(H, by1))
                   for xx in range(max(0, bx0), min(W, bx1))
                   if cell.getpixel((xx, yy))[3] >= 100]
        if bg_rgbs:
            bg_rgbs.sort(key=_lum)
            bg_rep = bg_rgbs[len(bg_rgbs) // 2]
            bglum = _lum(bg_rep)
        else:
            bg_rep, bglum = (24, 24, 24), 24

        ol = part.get("outline")
        dist_sq = sum((color[i] - bg_rep[i]) ** 2 for i in range(3))
        if ol is False:
            ol = None
        elif isinstance(ol, str) and ol.startswith("#"):
            ol = _parse_hex(ol)
        elif auto_ol is not None and ol is None:
            ol = auto_ol
        elif ol == "auto" or (ol is None and abs(_lum(color) - bglum) < 50 and dist_sq < 110 * 110):
            ol = (14, 14, 18, 255) if bglum >= 128 else (232, 232, 238, 255)
        else:
            ol = None
        _render_and_place(cell, lines, (bx0, by0, bx1, by1), color, ol, part, bg_rep, audit)
        if kept_px:
            px = cell.load()
            for (kx, ky, kp) in kept_px:
                px[kx, ky] = kp
    return True

# ---------- 主流程 ----------

def process(src, cfg, groups, preview_rows, audit=None):
    W, H, st = meta(src)
    sheet = Image.open(src).convert("RGBA")
    cols = sheet.width // W
    states_cfg = {}
    for g in cfg.get("include", []):
        states_cfg.update(groups.get(g, {}))
    states_cfg.update(cfg.get("states", {}))
    idx = 0
    changed = 0
    tried = []
    succeeded = set()
    for name, n in st:
        if name in states_cfg:
            spec = states_cfg[name]
            if spec.get("keep"):
                idx += n
                continue
            if name not in tried:
                tried.append(name)
            for fr in range(n):
                cx = ((idx + fr) % cols) * W
                cy = ((idx + fr) // cols) * H
                cell = sheet.crop((cx, cy, cx + W, cy + H))
                orig = cell.copy()
                ok = localize(cell, spec, W, H, audit, meta_name=name, meta_src=src)
                if fr == 0 or ok:
                    preview_rows.append((src, name, fr, orig, cell, ok))
                if ok:
                    sheet.paste(cell, (cx, cy))
                    changed += 1
                    succeeded.add(name)
        idx += n
    misses = [m for m in tried if m not in succeeded]
    return sheet, changed, misses

def save_dmi(sheet, src, out_path):
    import io
    buf = io.BytesIO()
    sheet.save(buf, "PNG")
    d = buf.getvalue()
    ihdr_end = 8 + 25
    z = ztxt(src)
    out = d[:ihdr_end] + (z if z else b"") + d[ihdr_end:]
    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    open(out_path, "wb").write(out)

def main():
    cfg = json.load(open(CONF, encoding="utf-8"))
    only = None
    preview = "--preview" in sys.argv
    if "--only" in sys.argv:
        only = sys.argv[sys.argv.index("--only") + 1]
    preview_rows = []
    audit = [] if "--audit" in sys.argv else None
    groups = cfg.get("groups", {})
    for src, fcfg in cfg["files"].items():
        if only and src != only:
            continue
        sheet, changed, misses = process(src, fcfg, groups, preview_rows, audit)
        out = os.path.join(ROOT, OUT_DIR, fcfg.get("out") or os.path.basename(src))
        save_dmi(sheet, src, out)
        msg = f"{src} -> {os.path.relpath(out, ROOT)}: {changed} cells repainted"
        if misses:
            msg += f" | NO TEXT FOUND: {misses}"
        print(msg)
    if audit is not None:
        print_audit(audit)
    if preview:
        make_preview(preview_rows)

def print_audit(audit):
    """输出每个重绘 part 的排版信息；标注可疑项：
    TINY(用了最小号仍贴边/过小)、DARK(墨色亮度过低对比差)、CLIP(贴边裁切)"""
    print("\n=== AUDIT ===")
    for name, a in audit:
        flags = []
        if a["warn"]:
            flags.append(a["warn"])
        if a["size"] == 8 and len(a["text"]) > 2:
            flags.append("TINY8")
        if a.get("contrast", 255) < 55:
            flags.append(f"LOWCONTRAST{a['contrast']}")
        W, H = a["cell"]
        if a["pos"][0] <= 0 or a["pos"][1] <= 0 or a["pos"][0] + a["img"][0] >= W or a["pos"][1] + a["img"][1] >= H:
            flags.append("EDGE")
        tag = " <<< " + ",".join(flags) if flags else ""
        print(f"  {a['src'].split('/')[-1]:18s} {name:22s} '{a['text']}' @{a['size']}px img{a['img']} pos{a['pos']} ink{a['color']} bg{a.get('bglum','?')} ct{a.get('contrast','?')}{tag}")

def make_preview(rows):
    font_lbl = ImageFont.load_default(size=11)
    cw, ch, cols, scale = 200, 222, 6, 5
    rows_n = (len(rows) * 2 + cols - 1) // cols
    out = Image.new("RGB", (cols * cw, rows_n * ch), (36, 36, 44))
    dr = ImageDraw.Draw(out)
    i = 0
    for (src, name, fr, orig, new, ok) in rows:
        for tag, im in ((f"{name} f{fr} OLD", orig), (f"{name} f{fr} NEW{' MISS!' if not ok else ''}", new)):
            x = (i % cols) * cw
            y = (i // cols) * ch
            w, h = im.size
            s = min((cw - 8) // w, (ch - 20) // h, scale)
            im2 = im.resize((w * s, h * s), Image.NEAREST)
            out.paste(im2, (x, y), im2)
            dr.text((x + 2, y + h * s + 2), tag, fill=(255, 120, 120) if not ok else (160, 255, 160), font=font_lbl)
            i += 1
    out.save("/tmp/hud_preview.png")
    print(f"preview: /tmp/hud_preview.png ({out.width}x{out.height}, {len(rows)} states)")

if __name__ == "__main__":
    main()

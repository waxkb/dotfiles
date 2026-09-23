#!/usr/bin/env python3
"""Drop-in replacement for `dms dank16 <hex> --foot` (dark mode, DPS).

Ports DankMaterialShell/core/internal/dank16/dank16.go + terminals.go
so foot terminal colors can be generated without the dms dependency.

Usage: dank16.py <primary-hex> [--background BG] [--light] [--contrast dps|wcag] [--wezterm]
"""
import math
import sys

D65 = (0.95047, 1.0, 1.08883)


def hex_to_rgb(h):
    h = h.lstrip("#")
    return (int(h[0:2], 16) / 255.0, int(h[2:4], 16) / 255.0, int(h[4:6], 16) / 255.0)


def rgb_to_hex(r, g, b):
    r = max(0.0, min(1.0, r))
    g = max(0.0, min(1.0, g))
    b = max(0.0, min(1.0, b))
    # NOTE: dank16.go truncates here: int(r*255), not round
    return "#%02x%02x%02x" % (int(r * 255), int(g * 255), int(b * 255))


def rgb_to_hsv(r, g, b):
    mx, mn = max(r, g, b), min(r, g, b)
    d = mx - mn
    if d == 0:
        h = 0.0
    elif mx == r:
        h = (math.fmod((g - b) / d, 6.0)) / 6.0
    elif mx == g:
        h = ((b - r) / d + 2.0) / 6.0
    else:
        h = ((r - g) / d + 4.0) / 6.0
    if h < 0:
        h += 1.0
    s = 0.0 if mx == 0 else d / mx
    return (h, s, mx)


def hsv_to_rgb(h, s, v):
    hh = h * 6.0
    c = v * s
    x = c * (1.0 - abs(math.fmod(hh, 2.0) - 1.0))
    m = v - c
    i = int(hh)
    if i == 0:
        r, g, b = c, x, 0.0
    elif i == 1:
        r, g, b = x, c, 0.0
    elif i == 2:
        r, g, b = 0.0, c, x
    elif i == 3:
        r, g, b = 0.0, x, c
    elif i == 4:
        r, g, b = x, 0.0, c
    else:
        r, g, b = c, 0.0, x
    return (r + m, g + m, b + m)


# --- go-colorful Lab port (exact, D65) ---
def _linearize(v):
    return v / 12.92 if v <= 0.04045 else ((v + 0.055) / 1.055) ** 2.4


def _delinearize(v):
    return 12.92 * v if v <= 0.0031308 else 1.055 * (v ** (1.0 / 2.4)) - 0.055


def _rgb_to_xyz(r, g, b):
    lr, lg, lb = _linearize(r), _linearize(g), _linearize(b)
    x = 0.41239079926595948 * lr + 0.35758433938387796 * lg + 0.18048078840183429 * lb
    y = 0.21263900587151036 * lr + 0.71516867876775593 * lg + 0.072192315360733715 * lb
    z = 0.019330818715591851 * lr + 0.11919477979462599 * lg + 0.95053215224966058 * lb
    return (x, y, z)


def _xyz_to_rgb(x, y, z):
    lr = 3.2409699419045214 * x - 1.5373831775700935 * y - 0.49861076029300328 * z
    lg = -0.96924363628087983 * x + 1.8759675015077207 * y + 0.041555057407175613 * z
    lb = 0.055630079696993609 * x - 0.20397695888897657 * y + 1.0569715142428786 * z
    return (_delinearize(lr), _delinearize(lg), _delinearize(lb))


def _lab_f(t):
    return t ** (1 / 3) if t > (6 / 29) ** 3 else t / 3 * (29 / 6) ** 2 + 4 / 29


def _lab_finv(t):
    return t ** 3 if t > 6 / 29 else 3 * (6 / 29) ** 2 * (t - 4 / 29)


def rgb_to_lab(r, g, b):
    x, y, z = _rgb_to_xyz(r, g, b)
    fy = _lab_f(y / D65[1])
    return (1.16 * fy - 0.16, 5.0 * (_lab_f(x / D65[0]) - fy), 2.0 * (fy - _lab_f(z / D65[2])))


def lab_to_rgb_clamped(l100, a, b):
    # colorful.Lab(l, a, b) takes L in 0..1; dank16 passes L/100
    l = l100 / 100.0
    l2 = (l + 0.16) / 1.16
    x = D65[0] * _lab_finv(l2 + a / 5.0)
    y = D65[1] * _lab_finv(l2)
    z = D65[2] * _lab_finv(l2 - b / 2.0)
    r, g, bl = _xyz_to_rgb(x, y, z)
    r = max(0.0, min(1.0, r))
    g = max(0.0, min(1.0, g))
    bl = max(0.0, min(1.0, bl))
    # RGB255 rounds: uint8(c*255+0.5)
    return "#%02x%02x%02x" % (int(r * 255 + 0.5), int(g * 255 + 0.5), int(bl * 255 + 0.5))


def get_lstar(hexcol):
    l, _, _ = rgb_to_lab(*hex_to_rgb(hexcol))
    return l * 100.0


def delta_phi_star(fg, bg, neg):
    lf, lb = get_lstar(fg), get_lstar(bg)
    lc = abs(lb ** 1.618 - lf ** 1.618) ** 0.618 * 1.414 - 40
    return lc + 5 if neg else lc


def dps_contrast(fg, bg, is_light):
    return delta_phi_star(fg, bg, not is_light)


def ensure_dps_lstar(color, bg, target, is_light):
    if dps_contrast(color, bg, is_light) >= target:
        return color
    l, a, b = rgb_to_lab(*hex_to_rgb(color))
    lf = l * 100.0
    direction = -1.0 if is_light else 1.0
    for _ in range(120):
        lf = max(0.0, min(100.0, lf + direction * 0.5))
        cand = lab_to_rgb_clamped(lf, a, b)
        if dps_contrast(cand, bg, is_light) >= target:
            return cand
    return color


def ensure_dps_bidir(color, bg, target, is_light):
    if dps_contrast(color, bg, is_light) >= target:
        return color
    l, a, b = rgb_to_lab(*hex_to_rgb(color))
    orig = l * 100.0
    dark_r = light_r = None
    dark_l = light_l = orig
    for i in range(120):
        if dark_r is None:
            dl = max(0.0, orig - i * 0.5)
            c = lab_to_rgb_clamped(dl, a, b)
            if dps_contrast(c, bg, is_light) >= target:
                dark_r, dark_l = c, dl
        if light_r is None:
            ll = min(100.0, orig + i * 0.5)
            c = lab_to_rgb_clamped(ll, a, b)
            if dps_contrast(c, bg, is_light) >= target:
                light_r, light_l = c, ll
        if dark_r is not None and light_r is not None:
            break
    if dark_r is not None and light_r is not None:
        return dark_r if abs(dark_l - orig) <= abs(light_l - orig) else light_r
    return dark_r or light_r or color


def wcag_lum(hexcol):
    def lin(c):
        return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4
    r, g, b = hex_to_rgb(hexcol)
    return 0.2126 * lin(r) + 0.7152 * lin(g) + 0.0722 * lin(b)


def wcag_ratio(fg, bg):
    a, b = wcag_lum(fg), wcag_lum(bg)
    return (max(a, b) + 0.05) / (min(a, b) + 0.05)


def ensure_wcag(color, bg, target, is_light):
    if wcag_ratio(color, bg) >= target:
        return color
    h, s, v = rgb_to_hsv(*hex_to_rgb(color))
    for step in range(1, 30):
        d = step * 0.02
        ups = []
        if is_light:
            ups = [max(0, v - d), min(1, v + d)]
        else:
            ups = [min(1, v + d), max(0, v - d)]
        for nv in ups:
            cand = rgb_to_hex(*hsv_to_rgb(h, s, nv))
            if wcag_ratio(cand, bg) >= target:
                return cand
    return color


def blend_hue(base, target, f):
    d = target - base
    if d > 0.5:
        d -= 1.0
    elif d < -0.5:
        d += 1.0
    r = base + d * f
    return r + (1.0 if r < 0 else (-1.0 if r >= 1.0 else 0.0))


def derive_dim(bg, hue, sat, is_light):
    off = -22.0 if is_light else 22.0
    target_l = max(0.0, min(100.0, get_lstar(bg) + off))
    tr, tg, tb = hsv_to_rgb(hue, sat, 0.5)
    _, a, b = rgb_to_lab(tr, tg, tb)
    return lab_to_rgb_clamped(target_l, a, b)


def derive_container(primary, is_light):
    h, s, v = rgb_to_hsv(*hex_to_rgb(primary))
    if is_light:
        return rgb_to_hex(*hsv_to_rgb(h, s * 0.32, min(v * 1.77, 1.0)))
    return rgb_to_hex(*hsv_to_rgb(h, min(s * 1.834, 1.0), v * 0.463))


def generate_palette(primary, background="", container="", is_light=False, use_dps=True):
    base = container or derive_container(primary, is_light)
    hsv = rgb_to_hsv(*hex_to_rgb(base))
    ph = rgb_to_hsv(*hex_to_rgb(primary))

    if use_dps:
        normal, accent = (70.0, 58.0) if is_light else (40.0, 24.5)
    else:
        normal, accent = 4.5, 2.1

    def fix(c, tgt, bidir=False):
        if use_dps:
            return (ensure_dps_bidir if bidir else ensure_dps_lstar)(c, bg, tgt, is_light)
        return ensure_wcag(c, bg, tgt, is_light)

    bg = background or ("#f8f8f8" if is_light else "#1a1a1a")
    pal = [None] * 16
    pal[0] = bg
    base_sat = max(ph[1], 0.5)
    base_val = max(ph[2], 0.5)
    red_h = blend_hue(0.0, ph[0], 0.12)
    grn_h = blend_hue(0.33, ph[0], 0.10)
    yel_h = blend_hue(0.14, ph[0], 0.04)

    def C(h, s, v):
        return rgb_to_hex(*hsv_to_rgb(h, s, v))

    if is_light:
        pal[1] = fix(C(red_h, min(base_sat * 1.2, 1), base_val * 0.95), normal)
        pal[2] = fix(C(grn_h, min(base_sat * 1.3, 1), base_val * 0.75), normal)
        pal[3] = fix(C(yel_h, min(base_sat * 1.5, 1), min(base_val * 1.2, 1)), normal)
        pal[4] = fix(C(ph[0], min(ph[1] * 1.05, 1), min(ph[2] * 1.05, 1)), normal)
        pal[5] = base
        pal[6] = primary
        pal[7] = fix(C(hsv[0], base_sat * 0.08, base_val * 0.28), normal)
        pal[8] = derive_dim(bg, hsv[0], base_sat * 0.05, True)
        pal[9] = fix(C(red_h, min(base_sat, 1), min(base_val * 1.2, 1)), accent, True)
        pal[10] = fix(C(grn_h, min(base_sat * 1.1, 1), min(base_val * 1.1, 1)), accent, True)
        pal[11] = fix(C(yel_h, min(base_sat * 1.4, 1), min(base_val * 1.3, 1)), accent, True)
        pal[12] = fix(C(ph[0], min(ph[1] * 1.1, 1), min(ph[2] * 1.15, 1)), accent, True)
        pal[13] = fix(C(ph[0], ph[1] * 0.7, min(ph[2] * 1.3, 1)), accent, True)
        pal[14] = C(ph[0], ph[1] * 0.5, min(ph[2] * 1.3, 1))
        pal[15] = C(hsv[0], base_sat * 0.04, min(base_val * 1.5, 1))
    else:
        pal[1] = fix(C(red_h, min(base_sat * 1.1, 1), min(base_val * 1.15, 1)), normal)
        pal[2] = fix(C(grn_h, min(base_sat, 1), min(base_val, 1)), normal)
        pal[3] = fix(C(yel_h, min(base_sat * 1.1, 1), min(base_val * 1.25, 1)), normal)
        pal[4] = fix(C(ph[0], min(ph[1] * 1.2, 1), ph[2] * 0.95), normal)
        pal[5] = base
        pal[6] = primary
        pal[7] = fix(C(hsv[0], base_sat * 0.12, min(base_val * 1.05, 1)), normal)
        pal[8] = derive_dim(bg, hsv[0], base_sat * 0.15, False)
        pal[9] = fix(C(red_h, min(base_sat * 0.75, 1), min(base_val * 1.35, 1)), accent, True)
        pal[10] = fix(C(grn_h, min(base_sat * 0.7, 1), min(base_val * 1.2, 1)), accent, True)
        pal[11] = fix(C(yel_h, min(base_sat * 0.7, 1), min(base_val * 1.5, 1)), accent, True)
        pal[12] = fix(C(ph[0], ph[1] * 0.85, min(ph[2] * 1.1, 1)), accent, True)
        pal[13] = C(ph[0], ph[1] * 0.7, min(ph[2] * 1.3, 1))
        pal[14] = C(ph[0], ph[1] * 0.45, min(ph[2] * 1.4, 1))
        pal[15] = fix(C(hsv[0], base_sat * 0.05, min(base_val * 1.45, 1)), normal)
    return pal


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("-")]
    if not args:
        sys.exit("usage: dank16-foot.py <primary-hex> [--background BG] [--light] [--contrast dps|wcag]")
    primary = args[0] if args[0].startswith("#") else "#" + args[0]
    background = ""
    is_light = "--light" in sys.argv
    use_dps = "--contrast" not in sys.argv or "dps" in sys.argv[sys.argv.index("--contrast") + 1] if "--contrast" in sys.argv else True
    if "--background" in sys.argv:
        background = sys.argv[sys.argv.index("--background") + 1]
        background = background if background.startswith("#") else "#" + background
    pal = generate_palette(primary, background, "", is_light, use_dps)
    if "--wezterm" in sys.argv:
        names = ["'%s'" % p for p in pal]
        print("ansi = [%s]" % ", ".join(names[:8]))
        print("brights = [%s]" % ", ".join(names[8:]))
        return
    for i in range(8):
        print(f"regular{i}={pal[i].lstrip('#')}")
    for i in range(8, 16):
        print(f"bright{i - 8}={pal[i].lstrip('#')}")


if __name__ == "__main__":
    main()

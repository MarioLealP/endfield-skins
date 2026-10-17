#!/bin/bash
# endfield-skins' per-user settings (see clockmost-desktop-setup): kitty (theme, tab bar, keys), Claude Code (status
# line + theme), Firefox (userChrome + prefs). Files are linked from /usr/share/endfield-skins, so package updates
# reach them. The KDE colours, SDDM theme and Discord theme are installed but NOT switched on - their skin passes
# aren't done yet.
set -eu
S=/usr/share/endfield-skins

# parts switched off by name in ~/.config/clockmost/setup-off (one per line), e.g. firefox-skin
off() { grep -qsx "$1" "${XDG_CONFIG_HOME:-$HOME/.config}/clockmost/setup-off"; }

# link $2 -> $1; a real file already there is kept as .bak-<date>
link() {
    if [ -e "$2" ] && [ ! -L "$2" ]; then mv "$2" "$2.bak-$(date +%Y%m%d%H%M)"; fi
    mkdir -p "$(dirname "$2")"
    ln -sfn "$1" "$2"
}

# kitty
k="$HOME/.config/kitty"
for f in endfield.conf clockmost.conf tab_bar.py claude-statusline.sh; do link "$S/kitty/$f" "$k/$f"; done
touch "$k/kitty.conf"
for inc in endfield.conf clockmost.conf; do
    grep -qxF "include $inc" "$k/kitty.conf" || printf 'include %s\n' "$inc" >>"$k/kitty.conf"
done
pkill -USR1 -x kitty 2>/dev/null || true   # running kittys reload their config
echo "   kitty: Endfield theme, tab bar, Windows keys"

# Claude Code: the Endfield theme + the status line (only set when you have none of your own)
link "$S/kitty/claude-theme-endfield.json" "$HOME/.claude/themes/endfield.json"
python3 - "$HOME/.claude/settings.json" <<'PY'
import json, os, sys
p = sys.argv[1]
s = json.load(open(p)) if os.path.exists(p) else {}
s.setdefault("statusLine", {"type": "command", "command": "~/.config/kitty/claude-statusline.sh", "padding": 0})
s.setdefault("theme", "custom:endfield")
os.makedirs(os.path.dirname(p), exist_ok=True)
json.dump(s, open(p, "w"), indent=2)
PY
echo "   Claude Code: Endfield theme + status line"

# Firefox: every profile (old and XDG locations) gets the userChrome + our user.js block
if off firefox-skin; then
    echo "   Firefox: skin off (setup-off) - left alone"
    exit 0
fi
n=0
for prefs in "$HOME"/.mozilla/firefox/*/prefs.js "$HOME"/.config/mozilla/firefox/*/prefs.js; do
    [ -e "$prefs" ] || continue
    p=$(dirname "$prefs")
    link "$S/firefox/chrome/userChrome.css" "$p/chrome/userChrome.css"
    touch "$p/user.js"
    sed -i '/^\/\/ >>> endfield-skins/,/^\/\/ <<< endfield-skins/d' "$p/user.js"
    { echo "// >>> endfield-skins (managed by clockmost-desktop-setup - edits inside are replaced)"
      cat "$S/firefox/user.js"
      echo "// <<< endfield-skins"; } >>"$p/user.js"
    n=$((n + 1))
done
if [ "$n" = 0 ]; then
    echo "   Firefox: no profile yet - start Firefox once, close it, run clockmost-desktop-setup again"
else
    echo "   Firefox: $n profile(s) skinned - takes effect at Firefox's next start"
fi

# firefox — Intel Archive light skin (from `ds-firefox-v3.html`)

Real Firefox 157 chrome skin for CachyOS / KDE Plasma 6.8 Wayland. Light "paper" toolbars with the faint
dot grid, `// BROWSER` header strip, black site-identity block in the address bar, vertical tabs styled as
the mission list (active tab = yellow block), bookmarks toolbar with colour favicons,
300px tab sidebar. Colours and sizes are taken hex-for-hex from the approved mockup.

## Files

| file | what it is | where it installs |
|---|---|---|
| `chrome/userChrome.css` | all chrome styling (toolbars, urlbar, bookmarks, vertical tabs) | `<profile>/chrome/userChrome.css` |
| `chrome/userContent.css` | **not provided** — nothing was needed (see "Could not match") | — |

## Install

1. Find your profile: open `about:profiles` in Firefox → "Root Directory" of the profile you use.
   - native Firefox (CachyOS repos): `~/.mozilla/firefox/<xxxx.default-release>/`
   - Flatpak Firefox: `~/.var/app/org.mozilla.firefox/.mozilla/firefox/<xxxx.default-release>/`
2. Inside that profile directory, create a folder `chrome/` and copy `userChrome.css` into it:
   ```
   <profile>/chrome/userChrome.css
   ```
3. Set the prefs in `about:config` (see table below). `toolkit.legacyUserProfileCustomizations.stylesheets`
   is the one that makes Firefox load `chrome/userChrome.css` at all.
4. **Restart Firefox completely** (quit from the hamburger menu → Quit, then reopen). userChrome.css is
   read once at startup — there is no official live-reload; `Ctrl+Shift+R` only reloads the page.

To uninstall: delete `chrome/userChrome.css` and restart.

## about:config prefs

| pref | value | why |
|---|---|---|
| `toolkit.legacyUserProfileCustomizations.stylesheets` | `true` | **required** — load `chrome/userChrome.css` |
| `sidebar.verticalTabs` | `true` | native vertical tabs in the sidebar (the "mission list") |
| `sidebar.revamp` | `true` | the new sidebar that hosts vertical tabs; on by default in 157, listed because `sidebar.verticalTabs` depends on it |
| `browser.toolbars.bookmarks.visibility` | `always` | show the bookmarks toolbar (favicons live there) |

Other prefs used in some setups, **not required** by this skin:
- `sidebar.main.width` — the sidebar width the app remembers (drag the splitter once to whatever looks
  right, or set it to 300). I did **not** find a documented pref name I would trust enough to hardcode
  here; the CSS pins the sidebar at 300px anyway (see live-check notes if you use the collapse button).
- `browser.urlbar.trimURLs` — `true` (default) hides `https://` like the mockup. Leave as-is.

## Fonts needed (install on the system)

| role | font | mockup original | fallback already in the CSS |
|---|---|---|---|
| mono (labels, small print) | **JetBrains Mono** | Consolas | Consolas, Cascadia Mono, ui-monospace |
| body (titles, bookmarks, URL) | **Inter** | Segoe UI | Segoe UI, system-ui |

CachyOS: `pacman -S ttf-jetbrains-mono inter-font` (or your preferred source — no downloads are done by
this order). Without them Firefox falls back to the mockup's originals (Consolas / Segoe UI) where those
exist on the system; on Linux the visual fallback is DejaVu-ish, so install both for the intended look.

## Mapping table (mockup element → real setting)

| mockup (`ds-firefox-v3.html`) | real Firefox |
|---|---|
| `.ffl` pale paper + dot grid ground | background stack on `#navigator-toolbox` and `#sidebar-main` (white highlight ellipse + `rgba(43,45,49,.10)` 1px dots / 22px + `#f1f2f4→#e3e4e8` gradient) |
| `.crumb` "▲▲ FIREFOX 157.0" / "// BROWSER / CLOCKMOST" | `#navigator-toolbox::before` content (two lines, 7px mono + 16px body) — static text |
| `.hr2` thin rule with centre break | `#navigator-toolbox::after` gradient rule (41% / gap / 41%, 1px `#3a3c41`, centre tick) |
| `.addr` address row | `#urlbar` / `#urlbar-background` (40px, `rgba(255,255,255,.75)` fill, `rgba(43,45,49,.35)` border, square) |
| `.addr .nav` back/forward/reload cells | native `#nav-bar` buttons (square, ink icons, disabled at .3 opacity) |
| `.addr .sid` black site-identity block "GITEA" | `#identity-box` (`#2b2d31` block, 700 9px mono caps label); cert errors = crimson `#d91e36` |
| `.addr .u` bold host / grey path | **not matched** (see below) — one ink colour on `#urlbar-input` |
| `.addr .ex .nw2` yellow "2" badge | `.toolbarbutton-badge` (`#FFFA00` on `#111`) |
| `.bms` bookmarks row | `#PersonalToolbar` (12px body ink, square hover wash `rgba(205,207,212,.8)`) |
| `.bms` tiny black square markers | **replaced on purpose**: real favicons in full colour (was greyscale until 2026-10-15 - Mario: "make them colored, instead of grey scale"); folders keep the outlined square |
| `.bms .end` "14 BOOKMARKS · OTHER ›" | `#PersonalToolbar::after` — static "BOOKMARKS · OTHER ›" (CSS cannot count) |
| `.lt` 300px tab sidebar | `#sidebar-main` width pinned to 300px |
| `.dev` dark "SPACE · CLOCKMOST" bar | `#sidebar-main::before` (30px `#17181b` bar, 700 9px mono `#d8d9de`) |
| `.tab` mission rows | `.tabbrowser-tab` rows (translucent white over the dot grid, hairline `rgba(43,45,49,.18)`) |
| `.tab b` title 15px `#5d6068` | `.tab-label` |
| `.tab.sel` yellow block + dots + "V" | `.tabbrowser-tab[selected]` (`#FFFA00` + 7px `rgba(17,17,17,.14)` dots + big V watermark `rgba(17,17,17,.06)`) |
| `.tab.hov` | `.tabbrowser-tab:hover` (`rgba(205,207,212,.8)`) |
| `.tab .gl` grip glyph | the native `.tab-close-button`, styled faint (`#a7aab0` 1.4 stroke) |
| `.newt` "+ NEW TAB / CTRL T" | `#tabs-newtab-button` (dashed `rgba(43,45,49,.3)` border, "NEW TAB" mono caps) |
| `.lfoot` "9 TABS · 2 GROUPS" | `#sidebar-main::after` — static "TABS · SPACES · CTRL 1-3" (CSS cannot count) |
| `.mm` / `.xc` window buttons | `.titlebar-button` 24px squares, `.titlebar-close` 28px dark circle (mock shows a circle) |
| yellow `#FFFA00` = focused | urlbar focused/`[open]` border + outline (house rule: yellow only for active/selected/focused) |

## Could not match (the real app cannot do what the mockup shows)

1. **Bold host / grey path in the address bar** (`.addr .u b` / `span`) — the urlbar is a single editable
   input; userChrome cannot colour parts of its text differently. The whole URL is `#2b2d31` 14px body.
   (Firefox only trims the scheme via `browser.urlbar.trimURLs`.)
2. **Site-identity label text** ("GITEA") — Firefox writes its own label ("Secure", "Connection is secure"…).
   We style the block black with mono caps; the string itself is Firefox's.
3. **Tab subtitle line** (`.tab i`: "git.clockmost.com · 2 min", "playing", "1 high") — vertical tabs show
   title + favicon + close only. There is no subtitle slot in real vertical tabs; not faked with
   `content:` because the URL is not exposed on the tab element.
4. **Live counts in small print** ("9 TABS · 3 SPACES", "14 BOOKMARKS", "2 GROUPS", "S.O.W." bar values) —
   CSS cannot count tabs or bookmarks. The labels exist as static texture strings.
5. **The S.O.W. strip** (`.sow` gradient bar) — no chrome surface maps to it; its text fragments live on
   instead in the sidebar footer. The mockup's separate `hr2` at the top edge has no counterpart (the real
   window has no top edge inside the chrome).
6. **Cyan page-load progress bar** at the top of the content area (`.site .prog`, `#2aa8e0`) — Firefox 157
   has no such progress bar in that position (it uses a tab throbber / urlbar animation).
7. **Downloads panel** (`.dlw`) — not part of this order's list, left unstyled.
8. **Collapsed 64px icon rail** (mock `body.collapsed`) — the mock's collapsed state with tab initials is
   not styled: the real sidebar collapse toggles its own compact mode and the DOM attribute it sets needs a
   live check before it can be targeted. See below.
9. **Big "V" watermark exactness** — approximated with a `::after` on the selected tab's background
   (120px, `rgba(17,17,17,.06)`); the mock places it at `right:30px; top:-24px` of the row — the real
   tab clips differently, so the position is approximate.

## Approximate / needs a live check

No browser was available here — everything is written to the mockup values but never rendered.
When you first run it, check:

1. **Header strip** (`#navigator-toolbox::before`) and the other `::before`/`::after` text strips: some
   XUL containers refuse generated content. If a label is missing, that strip is cosmetic-only — drop a
   note and it can be moved onto another element.
2. **Sidebar width pin** (`#sidebar-main { width/min-width/max-width: 300px }`): if the sidebar collapse
   button stops collapsing (the app sets its own width inline), comment out that block and set the width by
   dragging the splitter once (the app remembers it).
3. **`#tabs-newtab-button` id** — the new-tab button id differs between sidebar modes
   (`#tabs-newtab-button` inside the tab strip vs `#new-tab-button` in the toolbar); both are styled, one
   will match. If the "NEW TAB" text does not appear next to the +, only the dashed frame landed.
4. **Tab row internals** (`.tab-content` padding 12px 40px 12px 16px): vertical tabs wrap their content in
   `.tab-stack`; if titles look cramped or too wide, tweak `.tab-content` padding first.
5. **Selected-tab watermark clip**: needs `overflow:hidden` on `.tab-background`; if the V spills over
   neighbouring rows on your build, delete the `[selected] .tab-background::after` block.
6. **Font rendering**: sizes 7px/8px/9px small print is intentional texture from the mockup — on HiDPI it
   stays tiny. If it disappears entirely, bump the `::before`/`::after` micro sizes by 1–2px.

## Syntax check

CSS was brace/paren-balanced with a local `python3` check (no Firefox or CSS linter available in this
environment). Nothing was rendered; see the live-check list above.


## Live check + rewrite (2026-10-13, VM: Firefox 157.0.1)

The worker draft targeted pre-157 markup and set `fill: none` on every toolbar icon (Firefox icons are fills),
so the nav buttons vanished. `userChrome.css` was rewritten against the real 157 markup (read from omni.ja):
`<moz-urlbar>` + `.urlbar-background` (no `#urlbar-background`), the shield is the new trust icon
`#trust-icon-container`, `#vertical-tabs` / `#tabbrowser-tabs` (forced to the sidebar's width),
`#vertical-tabs-newtab-button`. Window buttons: the native glyphs are hidden and the mock's glyphs drawn as SVG masks
(the close glyph wouldn't recolour); `clip-path: circle()` for the round close.

user.js (profile) - besides the four prefs above:

    user_pref("sidebar.visibility", "always-show");
    user_pref("sidebar.backupState", "{\"launcherWidth\":300,\"launcherExpanded\":true,\"launcherVisible\":true}");
    user_pref("ui.GtkCSDMinimizeButton", 1);  user_pref("ui.GtkCSDMinimizeButtonPosition", 0);
    user_pref("ui.GtkCSDMaximizeButton", 1);  user_pref("ui.GtkCSDMaximizeButtonPosition", 1);
    user_pref("ui.GtkCSDCloseButton", 1);     user_pref("ui.GtkCSDCloseButtonPosition", 2);
    user_pref("general.autoScroll", true);  // Windows-style middle-click autoscroll (Mario 2026-10-14; off by default on Linux)

(Plasma's settings portal publishes no GTK button layout, so Firefox showed close only.)

Can't match (CSS limits): the tab's second line (url · age), bold host / grey path in the URL, live S.O.W. / tab
counts (tabs live in a scroll box counters can't see into), the sidebar tool icons (shadow DOM, no parts - remove
them once via the sidebar's "Customize sidebar"). Favicons are hidden in the tab list (the mock has none).

## Simplified header (Mario 2026-10-13)

"the top is completely mangled ... a lot of space on the right": the `// BROWSER / CLOCKMOST` crumb, the version
line and the `S.O.W. · 9 TABS · 3 SPACES` strip are removed (space-eating; the counts couldn't be real), as are the
mock's fixed 380px side margins. Header = one row (sidebar toggle, back/forward/reload as plain square buttons,
the address bar filling the row - Firefox's default toolbarsprings hidden - action icons, window buttons in the
row) + the bookmarks row + the broken rule underneath. The sidebar's dark "▼ SPACE · CLOCKMOST" strip is removed too
(Mario). Deviates from ds-firefox-v3 on purpose.

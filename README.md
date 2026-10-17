# endfield-skins - the clockmost Endfield app skins
Real config files translated from the approved HTML mockups in ~/ref/mocks/components.
One folder per app. Each has a README.md: what file goes where, what could not be matched.

## Package (pkgs/endfield-skins, `[clockmost]` repo)

`pacman -S endfield-skins`, then `clockmost-desktop-setup` as your user (from clockmost-shell). Status per skin:
- **on** (setup switches it on, files linked from `/usr/share/endfield-skins`, so updates flow in): kitty (theme,
  tab bar, `clockmost.conf` = Windows keys + cursor trail), Claude Code (status line + `custom:endfield` theme - only
  if you have none set), Firefox (userChrome + a managed `user.js` block, every profile).
- **opt out** per user: a line `firefox-skin` in `~/.config/clockmost/setup-off` makes setup leave Firefox alone
  (it doesn't undo a skin already applied).
- **drafts** (installed, not switched on - their skin passes are still to do): KDE colours
  (`/usr/share/color-schemes/EndfieldDark.colors`), SDDM (`/usr/share/sddm/themes/endfield`), Discord
  (`/usr/share/endfield-skins/discord/endfield.theme.css`).

Moved out into their own packages (2026-10-14, with their history): the KWin window frame ->
pkgs/kwin-decoration-endfield, the kitty patch -> pkgs/kitty-clockmost, the Spotify phonograph -> pkgs/phonograph.
`orders/` = the worker orders the drafts were made from (not installed).

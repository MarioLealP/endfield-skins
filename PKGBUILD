# Maintainer: Benylin <lealmariop@gmail.com>
#
# Builds from $startdir (the pkgs/ CI checks out the tagged commit and runs makepkg in place). Data files only.

pkgname=endfield-skins
pkgver=0.1.4
pkgrel=1
pkgdesc="clockmost Endfield app skins: kitty, Firefox, Claude Code status line + theme; KDE colours, SDDM and Discord themes (drafts)"
arch=('any')
url="https://git.clockmost.com/pkgs/${pkgname}"
license=('MIT')
depends=('ttf-jetbrains-mono' 'inter-font' 'python')
optdepends=('kitty-clockmost: the patched kitty the tab bar is drawn for (stock kitty falls back to plain labels)'
            'firefox: the browser skin'
            'git: the branch segment of the Claude Code status line')
options=('!debug')

package() {
  cd "$startdir"
  local s="$pkgdir/usr/share/endfield-skins"
  install -Dm644 -t "$s/kitty" kitty/endfield.conf kitty/clockmost.conf kitty/tab_bar.py kitty/claude-theme-endfield.json
  install -Dm755 kitty/claude-statusline.sh "$s/kitty/claude-statusline.sh"
  install -Dm644 firefox/chrome/userChrome.css "$s/firefox/chrome/userChrome.css"
  install -Dm644 firefox/user.js "$s/firefox/user.js"
  install -Dm644 discord/endfield.theme.css "$s/discord/endfield.theme.css"

  # drafts, installed where their apps look but not switched on (clockmost-desktop-setup leaves them alone)
  install -Dm644 kde/EndfieldDark.colors "$pkgdir/usr/share/color-schemes/EndfieldDark.colors"
  install -Dm644 -t "$pkgdir/usr/share/sddm/themes/endfield" sddm/endfield/*

  install -Dm644 setup.d/40-endfield-skins.sh "$pkgdir/usr/share/clockmost-desktop/setup.d/40-endfield-skins.sh"
  for d in kitty firefox kde sddm discord; do
    install -Dm644 "$d/README.md" "$pkgdir/usr/share/doc/$pkgname/$d.md"
  done
  install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}

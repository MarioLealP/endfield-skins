// clockmost Endfield skin (pkgs/endfield-skins, firefox/user.js) - clockmost-desktop-setup keeps this block in user.js
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("sidebar.revamp", true);
user_pref("sidebar.verticalTabs", true);
user_pref("browser.toolbars.bookmarks.visibility", "always");
user_pref("sidebar.visibility", "always-show");
user_pref("sidebar.main.tools", "");
user_pref("sidebar.backupState", "{\"command\":\"\",\"panelOpen\":false,\"launcherWidth\":300,\"launcherExpanded\":true,\"launcherVisible\":true}");
// window buttons: Plasma's portal publishes no button layout, so Firefox would show close only
user_pref("ui.GtkCSDMinimizeButton", 1);
user_pref("ui.GtkCSDMaximizeButton", 1);
user_pref("ui.GtkCSDCloseButton", 1);
user_pref("ui.GtkCSDMinimizeButtonPosition", 0);
user_pref("ui.GtkCSDMaximizeButtonPosition", 1);
user_pref("ui.GtkCSDCloseButtonPosition", 2);

// Windows-style middle-click autoscroll - Firefox's own (off by default on Linux; Mario 2026-10-14)
user_pref("general.autoScroll", true);

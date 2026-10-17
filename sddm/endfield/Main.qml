/* Endfield — SDDM greeter theme (Qt6, SDDM >= 0.21)
   Skin: ds-lock-v2 ("lock v2") from the clockmost Endfield mockups.
   Colours, sizes and type are taken from ds-lock-v2.html + ds-shell.css;
   the yellow clock plate is IDENTICAL to ds-topbar-v2.html's .clock.
   See sddm/README.md for the mockup -> real setting mapping and the
   "Could not match" list. No glows. Square corners (the mockup is square).
   People avatars = circles. */

import QtQuick
import QtQuick.Controls
import QtQuick.Shapes

Rectangle {
    id: root
    // SDDM sizes the root object to the greeter window; nominal design size here.
    width: 1920
    height: 1080
    color: "#0c0c0d"

    // ---------------------------------------------------------------- palette (ds-shell.css, hex exactly)
    readonly property color ink:      "#f1f1f4"
    readonly property color ink2:     "#c9ccd3"
    readonly property color dim:      "#7d8089"
    readonly property color faint:    "#55575e"
    readonly property color ghost:    "#43454c"
    readonly property color yellow:   "#FFFA00"
    readonly property color cyan:     "#3FD0E8"
    readonly property color magenta:  "#ff1aac"
    readonly property color green:    "#7ddb57"
    readonly property color crimson:  "#d91e36"
    readonly property color plateInk: "#111111"

    // fonts: mono = Consolas-like (JetBrains Mono), body = Segoe-like (Inter)
    readonly property string monoFont: conf("monoFont", "JetBrains Mono")
    readonly property string bodyFont: conf("bodyFont", "Inter")
    readonly property string hostWord: conf("hostName", "CLOCKMOST")

    // theme.conf -> config object (SDDM ThemeConfig). Falls back to defaults.
    function conf(key, def) {
        try {
            if (typeof config !== "undefined" && config) {
                var v = config[key]
                if (v !== undefined && v !== null && String(v).length)
                    return String(v)
            }
        } catch (e) { }
        return def
    }

    // ---------------------------------------------------------------- clock (live)
    property var now: new Date()
    readonly property string hh: Qt.formatDateTime(now, "HH")
    readonly property string mm: Qt.formatDateTime(now, "mm")
    readonly property string ss: Qt.formatDateTime(now, "ss")
    readonly property string dayShort: Qt.formatDateTime(now, "ddd").toUpperCase()
    readonly property string dateLong: Qt.formatDateTime(now, "dd MMM yyyy").toUpperCase()
    readonly property string utcOffset: {
        var mins = -now.getTimezoneOffset()
        var sign = mins < 0 ? "-" : "+"
        mins = Math.abs(mins)
        var h = Math.floor(mins / 60), m = mins % 60
        return "UTC" + sign + h + (m ? ":" + (m < 10 ? "0" : "") + m : "")
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }

    // ---------------------------------------------------------------- login / status
    // The hint slot under the password shows "UNLOCK"; after a failed login it
    // shows "ACCESS DENIED" in crimson (the mockup has no error state).
    property string statusLine: ""

    function doLogin() {
        var u = userBox.currentText
        var s = sessionBox.currentIndex >= 0 ? sessionBox.currentIndex : 0
        sddm.login(u, passwordField.text, s)
    }

    Connections {
        target: sddm
        // signal name needs a live check (see README); harmless if absent
        function onLoginFailed() {
            root.statusLine = "ACCESS DENIED"
            passwordField.text = ""
            passwordField.forceActiveFocus()
        }
    }

    // ---------------------------------------------------------------- keyboard layout ("US" cell)
    // Access to the sddm `keyboard` proxy is guarded: API shape needs a live check.
    property string kbdText: "US"

    function kbdLabel() {
        try {
            if (typeof keyboard === "undefined" || !keyboard)
                return "US"
            var ls = keyboard.layouts
            var i = keyboard.currentLayout
            if (ls === undefined || i === undefined || i < 0 || i >= ls.length)
                return "US"
            var l = ls[i]
            if (l === undefined || l === null)
                return "US"
            if (typeof l === "string")
                return l.toUpperCase()
            var s = l.shortName || l.longName || l.name || l.id
            return s ? String(s).toUpperCase() : "US"
        } catch (e) {
            return "US"
        }
    }

    function kbdNext() {
        try {
            if (typeof keyboard !== "undefined" && keyboard) {
                if (keyboard.switchToNextLayout !== undefined)
                    keyboard.switchToNextLayout()
                else if (keyboard.layouts && keyboard.layouts.length > 1)
                    keyboard.currentLayout = (keyboard.currentLayout + 1) % keyboard.layouts.length
            }
        } catch (e) { }
        kbdText = kbdLabel()
    }

    // avatar initials fallback (mockup shows "BE" for benylin)
    function initials(name, realName) {
        var s = (realName && realName.length) ? realName : name
        var parts = String(s).trim().split(/\s+/)
        if (parts.length >= 2 && parts[0].length && parts[1].length)
            return (parts[0][0] + parts[1][0]).toUpperCase()
        return String(name).substring(0, 2).toUpperCase()
    }

    Component.onCompleted: {
        kbdText = kbdLabel()
        passwordField.forceActiveFocus()
    }

    // ================================================================ GROUND (ds-shell.css .stage)
    // topo floor strip along the bottom + the gradient veil over it.
    // (The .stage's two soft radial glows are omitted — no radial gradient in
    //  stock QtQuick; see README "Could not match".)
    Image {
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height * 0.46
        fillMode: Image.PreserveAspectCrop
        source: "topo-floor.svg"
    }
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.00; color: "#0c0c0d" }
            GradientStop { position: 0.54; color: "#0c0c0d" }
            GradientStop { position: 0.66; color: Qt.rgba(12 / 255, 12 / 255, 13 / 255, 0.86) }
            GradientStop { position: 1.00; color: Qt.rgba(12 / 255, 12 / 255, 13 / 255, 0.74) }
        }
    }

    // ================================================================ THE YELLOW CLOCK PLATE (320x96)
    // IDENTICAL to ds-topbar-v2's .clock (size, place, content) — lock <-> desktop seamless.
    Item {
        id: plate
        width: 320
        height: 96
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top

        // topo lines inside the plate (CSS: filter brightness(0); mix-blend-mode:
        // multiply; opacity .22) — reproduced with the black silhouette copy.
        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            source: "topo-floor-dark.svg"
            opacity: 0.22
        }

        // hatch patch (64x22, top-left) + dot grid (54x30, right:10 bottom:26)
        Canvas {
            id: platePat
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, 320, 96)
                // repeating-linear-gradient(135deg, rgba(17,17,17,.55) 0 2px, transparent 2px 6px)
                ctx.save()
                ctx.beginPath()
                ctx.rect(0, 0, 64, 22)
                ctx.clip()
                ctx.strokeStyle = "rgba(17,17,17,0.55)"
                ctx.lineWidth = 2
                var k = 0.70710678
                for (var c = -120; c < 200; c += 6) {
                    ctx.beginPath()
                    ctx.moveTo(c * k - 120 * k, c * k + 120 * k)
                    ctx.lineTo(c * k + 120 * k, c * k - 120 * k)
                    ctx.stroke()
                }
                ctx.restore()
                // radial-gradient(rgba(17,17,17,.45) 1px, transparent 1.4px) 0 0 / 6px 6px
                ctx.fillStyle = "rgba(17,17,17,0.45)"
                for (var y = 43; y < 70; y += 6) {
                    for (var x = 259; x < 310; x += 6) {
                        ctx.beginPath()
                        ctx.arc(x, y, 1.2, 0, Math.PI * 2)
                        ctx.fill()
                    }
                }
            }
        }

        // .sec — ":37", top-right of the plate
        Text {
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.top: parent.top
            anchors.topMargin: 8
            text: ":" + root.ss
            font.family: root.monoFont
            font.pixelSize: 9
            font.weight: Font.Bold
            font.letterSpacing: 1.44      // .16em @ 9px
            color: root.plateInk
            opacity: 0.6
        }

        // .t — "20:41", the dim colon is opacity .55. Centred like the CSS
        // (padding-left .14em compensates the trailing letter-spacing).
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 2.8   // .14em/2 @ 40px
            anchors.top: parent.top
            anchors.topMargin: 18
            Text {
                text: root.hh
                font.family: root.monoFont
                font.pixelSize: 40
                font.weight: Font.Bold
                font.letterSpacing: 5.6   // .14em @ 40px
                color: root.plateInk
            }
            Text {
                text: ":"
                font.family: root.monoFont
                font.pixelSize: 40
                font.weight: Font.Bold
                font.letterSpacing: 5.6
                color: root.plateInk
                opacity: 0.55
            }
            Text {
                text: root.mm
                font.family: root.monoFont
                font.pixelSize: 40
                font.weight: Font.Bold
                font.letterSpacing: 5.6
                color: root.plateInk
            }
        }

        // .d — "MON <barcode> 12 OCT 2026"
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 1.3   // .26em/2 @ 10px
            anchors.top: parent.top
            anchors.topMargin: 64
            spacing: 10
            Item {
                width: dayShortText.implicitWidth
                height: 13
                Text {
                    id: dayShortText
                    text: root.dayShort
                    anchors.verticalCenter: parent.verticalCenter
                    font.family: root.monoFont
                    font.pixelSize: 10
                    font.weight: Font.Bold
                    font.letterSpacing: 2.6   // .26em @ 10px
                    color: root.plateInk
                }
            }
            Item {
                width: 40
                height: 13
                // .bc barcode: repeating-linear-gradient(90deg, #111 0 2px,
                // transparent 2px 4px, #111 4px 5px, transparent 5px 8px)
                Repeater {
                    model: 5
                    Rectangle { x: index * 8; y: 3; width: 2; height: 7; color: root.plateInk }
                }
                Repeater {
                    model: 5
                    Rectangle { x: index * 8 + 4; y: 3; width: 1; height: 7; color: root.plateInk }
                }
            }
            Item {
                width: dateText.implicitWidth
                height: 13
                Text {
                    id: dateText
                    text: root.dateLong
                    anchors.verticalCenter: parent.verticalCenter
                    font.family: root.monoFont
                    font.pixelSize: 10
                    font.weight: Font.Bold
                    font.letterSpacing: 2.6
                    color: root.plateInk
                }
            }
        }

        // .id — "CLK-0912 · UTC+1" (serial is static print; offset is live)
        Text {
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            text: "CLK-0912 · " + root.utcOffset
            font.family: root.monoFont
            font.pixelSize: 8
            font.weight: Font.Bold
            font.letterSpacing: 1.44   // .18em @ 8px
            color: root.plateInk
            opacity: 0.5
        }
    }

    // .cptb — the ONE tri-band, hanging under the plate (320x5)
    Item {
        width: 320
        height: 5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: plate.bottom
        Rectangle { width: parent.width * 0.333; height: 5; color: root.yellow }
        Rectangle { x: parent.width * 0.333; width: parent.width * 0.333; height: 5; color: root.cyan }
        Rectangle { x: parent.width * 0.666; width: parent.width - parent.width * 0.666; height: 5; color: root.magenta }
    }

    // ================================================================ CORNERS
    // .tl — wordmark + barcode + micro
    Column {
        x: 36
        y: 30
        spacing: 6
        Text {
            text: root.hostWord
            font.family: root.monoFont
            font.pixelSize: 12
            font.weight: Font.Bold
            font.letterSpacing: 3.84   // .32em @ 12px
            color: root.ink
        }
        Row {
            spacing: 8
            Item {
                width: 88
                height: 11
                // house .barcode: 2px bar, 3px gap, 1px bar, 3px gap (pitch 9), 50% ink
                Repeater {
                    model: 10
                    Rectangle { x: index * 9; width: 2; height: 11; color: Qt.rgba(241 / 255, 241 / 255, 244 / 255, 0.5) }
                }
                Repeater {
                    model: 10
                    Rectangle { x: index * 9 + 5; width: 1; height: 11; color: Qt.rgba(241 / 255, 241 / 255, 244 / 255, 0.5) }
                }
            }
            Item {
                width: microTl.implicitWidth
                height: 11
                Text {
                    id: microTl
                    text: "DT-01 · CACHYOS · PLASMA 6.8"
                    anchors.verticalCenter: parent.verticalCenter
                    font.family: root.monoFont
                    font.pixelSize: 9
                    font.letterSpacing: 1.62   // .18em @ 9px
                    color: root.faint
                }
            }
        }
    }

    // .tr — telemetry small print (static texture, per house style; see README)
    Column {
        x: root.width - 36 - 240
        y: 30
        width: 240
        Text {
            width: 240
            horizontalAlignment: Text.AlignRight
            textFormat: Text.StyledText
            text: "TANG <font color=\"#7ddb57\">OK</font> · VAULT <font color=\"#7ddb57\">OK</font>"
            font.family: root.monoFont
            font.pixelSize: 9
            font.letterSpacing: 1.62
            lineHeight: 1.8
            lineHeightMode: Text.ProportionalHeight
            color: root.dim
        }
        Text {
            width: 240
            horizontalAlignment: Text.AlignRight
            text: "ETH 1G · 42MS"
            font.family: root.monoFont
            font.pixelSize: 9
            font.letterSpacing: 1.62
            lineHeight: 1.8
            lineHeightMode: Text.ProportionalHeight
            color: root.dim
        }
        Text {
            width: 240
            horizontalAlignment: Text.AlignRight
            text: "LISBON · 18°C CLEAR"
            font.family: root.monoFont
            font.pixelSize: 9
            font.letterSpacing: 1.62
            lineHeight: 1.8
            lineHeightMode: Text.ProportionalHeight
            color: root.dim
        }
    }

    // .bl — bottom-left small print
    Text {
        x: 36
        y: root.height - 30 - height
        text: "SDDM · TTY1 · LK-2039"
        font.family: root.monoFont
        font.pixelSize: 9
        font.letterSpacing: 1.62
        color: root.ghost
    }

    // .br — keyboard / network / power cells (34x34, gap 8)
    Row {
        x: root.width - 30 - width
        y: root.height - 26 - 34
        spacing: 8

        // keyboard layout
        Rectangle {
            width: 34
            height: 34
            color: "transparent"
            border.color: Qt.rgba(1, 1, 1, 0.18)
            border.width: 1
            Text {
                anchors.centerIn: parent
                text: root.kbdText
                font.family: root.monoFont
                font.pixelSize: 10
                font.weight: Font.Bold
                color: root.ink2
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.kbdNext()
            }
        }

        // ethernet — decorative status cell (the greeter cannot manage
        // NetworkManager; see README)
        Rectangle {
            width: 34
            height: 34
            color: "transparent"
            border.color: Qt.rgba(1, 1, 1, 0.18)
            border.width: 1
            Item {
                anchors.centerIn: parent
                width: 15
                height: 15
                scale: 15 / 24
                transformOrigin: Item.TopLeft
                Shape {
                    width: 24
                    height: 24
                    ShapePath {
                        strokeWidth: 2.2
                        strokeColor: root.ink2
                        fillColor: "transparent"
                        capStyle: ShapePath.FlatCap
                        PathSvg { path: "M4 9h16v10H4z M8 9V5h8v4" }
                    }
                }
            }
        }

        // power off (gated on sddm.canPowerOff)
        Rectangle {
            id: powerCell
            width: 34
            height: 34
            color: "transparent"
            border.color: Qt.rgba(1, 1, 1, 0.18)
            border.width: 1
            opacity: sddm.canPowerOff ? 1 : 0.4
            Item {
                anchors.centerIn: parent
                width: 15
                height: 15
                scale: 15 / 24
                transformOrigin: Item.TopLeft
                Shape {
                    width: 24
                    height: 24
                    ShapePath {
                        strokeWidth: 2.2
                        strokeColor: root.ink2
                        fillColor: "transparent"
                        capStyle: ShapePath.FlatCap
                        PathSvg { path: "M12 3v9 M6.3 7.5a8 8 0 1 0 11.4 0" }
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: sddm.canPowerOff ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: {
                    if (sddm.canPowerOff)
                        sddm.powerOff()
                }
            }
        }
    }

    // ================================================================ HUD — the centred user plate
    Item {
        id: hud
        width: 440
        height: 250
        x: (root.width - width) / 2
        y: root.height * 0.30

        // .av — circle avatar (icon if userModel has one, else initials on yellow)
        // ring: 4px #0b0b0c then 1px rgba(241,241,244,.3) (the mockup's box-shadows)
        Rectangle {
            x: 171
            y: -5
            width: 98
            height: 98
            radius: 49
            color: Qt.rgba(241 / 255, 241 / 255, 244 / 255, 0.3)
        }
        Rectangle {
            x: 172
            y: -4
            width: 96
            height: 96
            radius: 48
            color: "#0b0b0c"
        }
        Item {
            id: avatarHost
            x: 176
            y: 0
            width: 88
            height: 88
            Repeater {
                model: userModel
                delegate: Item {
                    id: avatarCell
                    required property int index
                    required property string name
                    required property string realName
                    required property string icon
                    visible: index === userBox.currentIndex
                    anchors.fill: parent

                    Rectangle {
                        anchors.fill: parent
                        radius: width / 2
                        color: root.yellow
                    }
                    Image {
                        id: avatarImg
                        anchors.fill: parent
                        visible: false
                        source: avatarCell.icon
                        asynchronous: true
                    }
                    Canvas {
                        id: avatarCanvas
                        anchors.fill: parent
                        visible: avatarImg.status === Image.Ready
                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.clearRect(0, 0, 88, 88)
                            ctx.save()
                            ctx.beginPath()
                            ctx.arc(44, 44, 44, 0, Math.PI * 2)
                            ctx.closePath()
                            ctx.clip()
                            if (avatarImg.status === Image.Ready) {
                                // object-fit: cover
                                var iw = avatarImg.sourceSize.width
                                var ih = avatarImg.sourceSize.height
                                if (iw > 0 && ih > 0) {
                                    var s = Math.max(88 / iw, 88 / ih)
                                    var dw = iw * s
                                    var dh = ih * s
                                    ctx.drawImage(avatarImg, (88 - dw) / 2, (88 - dh) / 2, dw, dh)
                                }
                            }
                            ctx.restore()
                        }
                    }
                    Text {
                        anchors.centerIn: parent
                        visible: avatarImg.status !== Image.Ready
                        text: initials(avatarCell.name, avatarCell.realName)
                        font.family: root.monoFont
                        font.pixelSize: 22
                        font.weight: Font.Bold
                        color: root.plateInk
                    }
                }
            }
        }

        // .nm — the user name; flat ComboBox over userModel (see README mapping)
        ComboBox {
            id: userBox
            x: 0
            y: 102
            width: 440
            height: 28
            padding: 0
            model: userModel
            textRole: "name"
            font.family: root.bodyFont
            font.pixelSize: 22
            font.weight: Font.Medium
            background: Item {}
            indicator: Item {}
            contentItem: Text {
                text: userBox.displayText
                font: userBox.font
                color: root.ink
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
            delegate: ItemDelegate {
                required property int index
                required property string name
                width: userBox.width
                height: 30
                padding: 0
                contentItem: Text {
                    text: name
                    font.family: root.bodyFont
                    font.pixelSize: 14
                    color: index === userBox.currentIndex ? root.plateInk : root.ink2
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                background: Rectangle {
                    color: index === userBox.currentIndex ? root.yellow : "#1a1b1f"
                }
            }
            popup: Popup {
                y: userBox.height
                width: userBox.width
                padding: 1
                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight
                    model: userBox.popup.visible ? userBox.delegateModel : null
                    currentIndex: userBox.highlightedIndex
                }
                background: Rectangle {
                    color: "#15161a"
                    border.color: "#33363C"
                    border.width: 1
                }
            }
        }

        // .st — mockup shows "LOCKED 20:39 · 2 MIN AGO"; a greeter has no lock
        // time, so this slot is the session picker (see README mapping)
        ComboBox {
            id: sessionBox
            x: 0
            y: 134
            width: 440
            height: 13
            padding: 0
            model: sessionModel
            textRole: "name"
            font.family: root.monoFont
            font.pixelSize: 9
            font.letterSpacing: 1.8   // .2em @ 9px
            background: Item {}
            indicator: Item {}
            contentItem: Text {
                text: sessionBox.displayText.toUpperCase()
                font: sessionBox.font
                color: root.dim
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
            delegate: ItemDelegate {
                required property int index
                required property string name
                width: sessionBox.width
                height: 22
                padding: 0
                contentItem: Text {
                    text: String(name).toUpperCase()
                    font.family: root.monoFont
                    font.pixelSize: 9
                    font.letterSpacing: 1.8
                    color: index === sessionBox.currentIndex ? root.plateInk : root.ink2
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                background: Rectangle {
                    color: index === sessionBox.currentIndex ? root.yellow : "#1a1b1f"
                }
            }
            popup: Popup {
                y: sessionBox.height
                width: sessionBox.width
                padding: 1
                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight
                    model: sessionBox.popup.visible ? sessionBox.delegateModel : null
                    currentIndex: sessionBox.highlightedIndex
                }
                background: Rectangle {
                    color: "#15161a"
                    border.color: "#33363C"
                    border.width: 1
                }
            }
        }

        // .pw — password field (square corners, yellow ››› prompt, .go button).
        // Flat rgba(10,11,13,.7): the mockup's backdrop blur is not reproducible
        // in stock QtQuick (see README).
        Rectangle {
            x: 0
            y: 169
            width: 440
            height: 48
            color: Qt.rgba(10 / 255, 11 / 255, 13 / 255, 0.7)
            border.color: Qt.rgba(1, 1, 1, 0.22)
            border.width: 1
        }
        Text {
            x: 16
            y: 169
            height: 48
            verticalAlignment: Text.AlignVCenter
            text: "›››"
            font.family: root.monoFont
            font.pixelSize: 14
            font.weight: Font.Bold
            color: root.yellow
        }
        TextField {
            id: passwordField
            x: 58
            y: 169
            width: 322
            height: 48
            leftPadding: 0
            rightPadding: 0
            topPadding: 0
            bottomPadding: 0
            verticalAlignment: TextInput.AlignVCenter
            echoMode: TextInput.Password
            passwordCharacter: "•"
            color: root.ink
            selectionColor: root.yellow
            selectedTextColor: root.plateInk
            font.family: root.monoFont
            font.pixelSize: 22
            font.letterSpacing: 6.6   // .3em @ 22px
            background: Item {}
            onAccepted: root.doLogin()
            onTextEdited: root.statusLine = ""
        }
        Rectangle {
            id: goBtn
            x: 394
            y: 178
            width: 30
            height: 30
            color: root.ink
            Item {
                x: 8
                y: 8
                width: 14
                height: 14
                scale: 14 / 24
                transformOrigin: Item.TopLeft
                Shape {
                    width: 24
                    height: 24
                    ShapePath {
                        strokeWidth: 3
                        strokeColor: root.plateInk
                        fillColor: "transparent"
                        capStyle: ShapePath.FlatCap
                        PathSvg { path: "M5 12h14M13 6l6 6-6 6" }
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.doLogin()
            }
        }

        // .hint — keycap ↵ + "UNLOCK" micro (or the error state in crimson)
        Row {
            spacing: 10
            y: 227
            x: (440 - width) / 2
            Rectangle {
                // house .kbd with .hint's border-radius: 0
                width: 22
                height: 22
                color: Qt.rgba(1, 1, 1, 0.04)
                border.color: Qt.rgba(1, 1, 1, 0.25)
                border.width: 1
                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 1
                    color: Qt.rgba(1, 1, 1, 0.25)
                }
                Text {
                    anchors.centerIn: parent
                    text: "↵"
                    font.family: root.monoFont
                    font.pixelSize: 10
                    font.weight: Font.Bold
                    font.letterSpacing: 0.8   // .08em @ 10px
                    color: root.ink2
                }
            }
            Item {
                width: hintTx.implicitWidth
                height: 22
                Text {
                    id: hintTx
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.statusLine.length ? root.statusLine : "UNLOCK"
                    font.family: root.monoFont
                    font.pixelSize: 9
                    font.letterSpacing: 1.62   // .18em @ 9px
                    color: root.statusLine.length ? root.crimson : root.faint
                }
            }
        }
    }
}

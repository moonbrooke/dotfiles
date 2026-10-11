import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Networking
import Quickshell.Services.SystemTray
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire

// Recreates waybar island-bottom.jsonc:
//   layer top / position bottom / margins L25% R25% T1 B5 (was 300px fixed)
//   left: custom/layout + hyprland/workspaces + hyprland/window
//   right: clock#datetime + pulseaudio + network + tray + battery
//   style.css: TokyoNight, IosevkaTerm Nerd Font Mono bold 14, no rounding.
PanelWindow {
    id: bar

    anchors {
        bottom: true
        left: true
        right: true
    }

    // 25% side margins each -> 50% wide centered island.
    // Waybar original was fixed 300px (~15.6% @1920); user chose 25%.
    margins {
        left: Math.round((bar.screen ? bar.screen.width : 1920) * 0.15)
        right: Math.round((bar.screen ? bar.screen.width : 1920) * 0.15)
        top: 1
        bottom: 5
    }

    aboveWindows: true // layer: top
    exclusiveZone: 34
    implicitHeight: 34
    color: "transparent"

    // Island background. No rounding per request (waybar border-radius: 0).
    Rectangle {
        anchors.fill: parent
        color: theme.black
        radius: 0
    }

    QtObject {
        id: theme

        readonly property color black: "#1a1b26"
        readonly property color red: "#f7768e"
        readonly property color green: "#9ece6a"
        readonly property color yellow: "#e0af68"
        readonly property color blue: "#7aa2f7"
        readonly property color purple: "#bb9af7"
        readonly property color aqua: "#7dcfff"
        readonly property color gray: "#565f89"
        readonly property color white: "#c0caf5"
        readonly property color muted: "#24283b"
    }

    readonly property string barFont: "IosevkaTerm Nerd Font Mono"

    // style.css: padding 5px 10px 7px 10px, bold 14px
    component BarText: Text {
        font.family: bar.barFont
        font.weight: Font.Bold
        font.pixelSize: 14
        color: theme.white
        verticalAlignment: Text.AlignVCenter
        leftPadding: 10
        rightPadding: 10
        topPadding: 5
        bottomPadding: 7
    }

    // custom/layout tooltip only (waybar tooltip:true)
    component Tooltip: PopupWindow {
        id: tip

        property string text: ""
        property Item target: null
        property bool shown: false

        visible: shown
        color: "transparent"
        implicitWidth: tipLabel.implicitWidth + 16
        implicitHeight: tipLabel.implicitHeight + 12

        anchor.window: bar
        anchor.rect.x: {
            if (!tip.target)
                return 0;
            const p = tip.target.mapToItem(null, 0, 0);
            return Math.max(0, Math.min(bar.width - tip.width, p.x + tip.target.width / 2 - tip.width / 2));
        }
        anchor.rect.y: -tip.height - 4

        Rectangle {
            anchors.fill: parent
            radius: 0
            color: theme.muted
            border.color: theme.gray
            border.width: 1
        }

        Text {
            id: tipLabel

            anchors.centerIn: parent
            width: Math.min(implicitWidth, 400)
            wrapMode: Text.WordWrap
            text: tip.text
            font.family: bar.barFont
            font.weight: Font.Bold
            font.pixelSize: 12
            color: theme.white
        }
    }

    // ---- custom/layout ----
    // modules/custom/layout.jsonc: hyprctl getoption general:layout,
    // short 2-letter code as text, second line as tooltip.
    QtObject {
        id: layoutData

        property string short: ""
        property string long: ""
        property bool pending: false

        function parse(text) {
            const lines = String(text).split("\n").map(line => line.trim()).filter(line => line.length > 0);
            layoutData.short = lines.length > 0 ? lines[0].replace(/<[^>]*>/g, "") : "";
            layoutData.long = lines.length > 1 ? lines[1].replace(/<[^>]*>/g, "") : layoutData.short;
        }

        function refresh() {
            if (layoutProc.running) {
                layoutData.pending = true;
                return;
            }
            layoutProc.running = true;
        }
    }

    Process {
        id: layoutProc

        running: true
        command: ["sh", "-c",
            "hyprctl getoption general:layout | sed -n 's/.*str: \\(.*\\)/\\U\\1/p' |"
            + " awk '{n=$0; a=(n==\"DWINDLE\"?\"DW\":n==\"MASTER\"?\"MS\":n==\"SCROLLING\"?\"SC\":n==\"MONOCLE\"?\"MN\":substr(n,1,2));"
            + " printf \"%s\\nCurrent Layout: %s\\n\", a, n}'"]

        stdout: StdioCollector {
            onStreamFinished: {
                layoutData.parse(text);
                if (layoutData.pending) {
                    layoutData.pending = false;
                    layoutData.refresh();
                }
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: layoutData.refresh()
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "activelayout" || event.name === "configreloaded")
                layoutData.refresh();
        }
    }

    // ---- pulseaudio (native Pipewire) ----
    // modules/audio.jsonc: "VOL: {volume}%" / bluetooth "󰂰" / muted "MUTED",
    // scroll-step 5, click toggles mute.
    readonly property var audioSink: Pipewire.defaultAudioSink
    readonly property var audioNode: audioSink ? audioSink.audio : null

    QtObject {
        id: audioState

        // pactl/waybar checks sink name for bluez; pipewire node name carries it too.
        readonly property string sinkName: bar.audioSink ? (bar.audioSink.name || "") : ""
        readonly property string sinkProps: bar.audioSink ? JSON.stringify(bar.audioSink.properties || ({})) : ""
        readonly property bool bluetooth: (sinkName.toLowerCase().indexOf("bluez") !== -1) || (sinkProps.toLowerCase().indexOf("bluez") !== -1)

        readonly property bool ready: Pipewire.ready && bar.audioNode != null
        readonly property bool muted: ready ? bar.audioNode.muted : false
        readonly property int percent: ready ? Math.round(bar.audioNode.volume * 100) : -1

        readonly property string label: !ready ? "VOL: --" : (bluetooth ? "󰂰" : (muted ? "MUTED" : "VOL: " + percent + "%"))

        function toggleMute() {
            if (ready)
                bar.audioNode.muted = !bar.audioNode.muted;
        }

        function stepVolume(up) {
            if (!ready)
                return;
            const next = Math.max(0, Math.min(1, bar.audioNode.volume + (up ? 0.05 : -0.05)));
            bar.audioNode.volume = next;
        }
    }

    // ---- network (native Networking) ----
    // modules/network.jsonc: wifi "NET: {essid}", ethernet "ETH: {ifname}",
    // disconnected "NET: OFF", interval 5 (event-driven here).
    QtObject {
        id: network

        readonly property var device: {
            const devices = Networking.devices.values;
            let wired = null;
            let wireless = null;
            for (let i = 0; i < devices.length; i++) {
                const device = devices[i];
                if (device.state !== ConnectionState.Connected)
                    continue;
                if (device.type === DeviceType.Wired)
                    wired = device;
                else if (!wireless)
                    wireless = device;
            }
            return wired || wireless;
        }

        readonly property string essid: {
            if (!network.device)
                return "";
            const networks = network.device.networks.values;
            for (let i = 0; i < networks.length; i++) {
                if (networks[i].connected)
                    return networks[i].name;
            }
            return "";
        }

        readonly property string label: !network.device ? "NET: OFF"
            : (network.device.type === DeviceType.Wired ? "ETH: " + network.device.name : "NET: " + network.essid)
    }

    Process {
        id: impalaProc
        command: ["sh", "-c", "foot -T floating_impala impala"]
    }

    // ---- battery (native UPower) ----
    // modules/battery.jsonc: icons 20/40/60/80/100%, time " ({H}h{M}m)",
    // charging "󰂄 {cap}% {time}", charging-full "󰂄 {cap}%",
    // full "{icon} {cap}%", normal "{icon} {cap}%{time}".
    QtObject {
        id: battery

        readonly property var device: UPower.displayDevice
        readonly property bool present: device ? device.isPresent : false
        // UPower.percentage arrives 0-1 on this system (upower CLI shows 96%
        // while the property logs 0.96), so normalize both scales.
        readonly property int capacity: {
            if (!device)
                return 0;
            const p = device.percentage;
            const pct = p <= 1 ? p * 100 : p;
            return Math.max(0, Math.min(100, Math.round(pct)));
        }
        readonly property bool charging: device ? device.state === UPowerDeviceState.Charging : false
        readonly property bool full: device ? (device.state === UPowerDeviceState.FullyCharged || battery.capacity >= 99) : false

        readonly property string icon: ["󰁺", "󰁼", "󰁿", "󰂁", "󰁹"][Math.max(0, Math.min(4, Math.floor(capacity / 20)))]

        readonly property double seconds: {
            if (!device)
                return 0;
            return charging ? device.timeToFull : device.timeToEmpty;
        }

        readonly property string time: {
            const s = Math.floor(battery.seconds);
            if (!(s > 0) || s < 60)
                return "";
            return " (" + Math.floor(s / 3600) + "h" + Math.floor(s / 60 % 60) + "m)";
        }

        readonly property string label: !present ? ""
            : (charging ? (battery.capacity >= 99 ? "󰂄 " + capacity + "%" : "󰂄 " + capacity + "%" + time)
                : (full ? icon + " " + capacity + "%" : icon + " " + capacity + "%" + time))
    }

    // ---- hyprland/workspaces ----
    // modules/hyprland/workspaces.jsonc: disable-scroll, all-outputs,
    // persistent 1..6, format <b>{icon}</b> (plain numbers).
    QtObject {
        id: workspaceModel

        readonly property int workspaceCount: 6

        property var entries: {
            const existing = Hyprland.workspaces.values;
            const byId = {};
            for (let i = 0; i < existing.length; i++)
                byId[existing[i].id] = existing[i];

            const entries = [];
            for (let id = 1; id <= workspaceModel.workspaceCount; id++)
                entries.push({ id: id, ws: byId[id] || null, label: String(id) });
            return entries;
        }
    }

    QtObject {
        id: workspaceStyle

        // style.css cascade: visible, focused, urgent, active, :hover, .visible:hover
        function colors(state, hovered) {
            let fg = theme.white;
            let bg = theme.black;
            if (state.windows > 0)
                fg = theme.green;
            if (state.focused) {
                fg = theme.black;
                bg = theme.aqua;
            }
            if (state.urgent) {
                fg = theme.black;
                bg = theme.red;
            }
            if (state.active) {
                fg = theme.black;
                bg = theme.green;
            }
            if (hovered)
                fg = theme.green;
            if (hovered && state.windows > 0) {
                fg = theme.black;
                bg = theme.green;
            }
            return { fg: fg, bg: bg };
        }
    }

    Row {
        id: leftModules
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        Item {
            id: layoutModule
            width: layoutText.width
            height: bar.height

            Rectangle {
                anchors.fill: parent
                color: theme.muted
            }

            BarText {
                id: layoutText
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                bottomPadding: 5
                text: layoutData.short
            }

            MouseArea {
                id: layoutHover
                anchors.fill: parent
                hoverEnabled: true
            }

            Tooltip {
                target: layoutModule
                shown: layoutHover.containsMouse
                text: layoutData.long
            }
        }

        Item {
            id: workspacesModule
            width: workspacesRow.width
            height: bar.height

            Row {
                id: workspacesRow
                height: bar.height

                Repeater {
                    model: workspaceModel.entries

                    Item {
                        id: workspaceButton
                        width: workspaceLabel.width
                        height: bar.height
                        property bool hovered: false

                        readonly property var state: {
                            const ws = modelData.ws;
                            // waybar gives .active and .focused to the focused
                            // monitor's workspace, so a workspace that is only
                            // active on another monitor stays plain/.visible
                            return {
                                active: ws ? ws.focused : false,
                                focused: ws ? ws.focused : false,
                                urgent: ws ? ws.urgent : false,
                                windows: ws ? ws.toplevels.values.length : 0
                            };
                        }

                        readonly property var colors: workspaceStyle.colors(workspaceButton.state, workspaceButton.hovered)

                        Rectangle {
                            anchors.fill: parent
                            color: workspaceButton.colors.bg
                        }

                        Text {
                            id: workspaceLabel
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            leftPadding: 15
                            rightPadding: 15
                            topPadding: 5
                            bottomPadding: 7
                            text: modelData.label
                            color: workspaceButton.colors.fg
                            font.family: bar.barFont
                            font.weight: Font.Bold
                            font.pixelSize: 14
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            acceptedButtons: Qt.LeftButton
                            onEntered: workspaceButton.hovered = true
                            onExited: workspaceButton.hovered = false
                            // hyprland is configured with hypr-lua, so the
                            // classic "workspace 3" request does not parse and
                            // the dispatcher has to be given as lua
                            onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + modelData.id + " })")
                        }
                    }
                }
            }
        }

        Item {
            id: windowModule
            width: windowRow.width
            height: bar.height

            // modules/hyprland/window.jsonc: "[{class}] {title}", max-length 30,
            // rewrite drops the span entirely when {class} is empty
            readonly property var toplevel: ToplevelManager.activeToplevel
            readonly property string prefix: toplevel ? "[" + toplevel.appId + "] " : ""

            readonly property string text: {
                const full = windowModule.prefix + (windowModule.toplevel ? windowModule.toplevel.title : "");
                return full.length > 30 ? full.substring(0, 39) + "…" : full;
            }

            readonly property bool truncatedPrefix: windowModule.text.startsWith(windowModule.prefix)

            Row {
                id: windowRow
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    text: windowModule.truncatedPrefix ? windowModule.prefix : ""
                    color: theme.white
                    font.family: bar.barFont
                    font.weight: Font.Bold
                    font.pixelSize: 14
                }

                Text {
                    text: windowModule.text.substring(windowModule.truncatedPrefix ? windowModule.prefix.length : 0)
                    color: theme.gray
                    font.family: bar.barFont
                    font.weight: Font.Bold
                    font.pixelSize: 14
                }
            }
        }
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Process {
        id: calcurseProc
        command: ["sh", "-c", "foot calcurse"]
    }

    Row {
        id: rightModules
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        // modules/datetime.jsonc is FIRST in modules-right (no center module
        // in island-bottom): "{:%a,%e %b / %I:%M %p}", click foot calcurse.
        Item {
            id: clockModule
            width: clockText.width
            height: bar.height

            BarText {
                id: clockText
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: Qt.formatDateTime(clock.date, "ddd, " + (clock.date.getDate() < 10 ? " " : "") + "d MMM / hh:mm AP")
            }

            MouseArea {
                anchors.fill: parent
                onClicked: calcurseProc.running = true
            }
        }

        Item {
            id: audioModule
            width: audioText.width
            height: bar.height

            BarText {
                id: audioText
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: audioState.label
                color: (audioState.muted || !audioState.ready) ? theme.gray : theme.white
            }

            MouseArea {
                id: audioHover
                anchors.fill: parent
                hoverEnabled: true
                onClicked: audioState.toggleMute()
            }

            WheelHandler {
                enabled: audioHover.containsMouse
                target: null

                onWheel: function(event) {
                    audioState.stepVolume(event.angleDelta.y > 0);
                }
            }
        }

        Item {
            id: networkModule
            width: networkText.width
            height: bar.height

            BarText {
                id: networkText
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: network.label
                color: network.device ? theme.green : theme.red
            }

            MouseArea {
                anchors.fill: parent
                onClicked: impalaProc.running = true
            }
        }

        Item {
            id: trayModule
            // style.css: #tray shares the 5px 10px 7px 10px module padding,
            // so 10px on each side (e.g. tray<->battery gap).
            visible: SystemTray.items.values.length > 0
            width: SystemTray.items.values.length > 0 ? trayRow.width + 20 : 0
            height: bar.height

            Row {
                id: trayRow
                anchors.centerIn: parent
                spacing: 10

                Repeater {
                    model: SystemTray.items

                    Image {
                        id: trayIcon
                        required property var modelData

                        // modules/tray.jsonc: icon-size 11
                        readonly property int iconSize: 11

                        width: iconSize
                        height: iconSize
                        sourceSize: Qt.size(iconSize, iconSize)
                        source: modelData.icon
                        asynchronous: false
                        smooth: true
                        fillMode: Image.PreserveAspectFit

                        MouseArea {
                            id: trayHover
                            anchors.fill: parent
                            hoverEnabled: true
                            acceptedButtons: Qt.LeftButton | Qt.MiddleButton

                            onClicked: function(mouse) {
                                if (mouse.button === Qt.MiddleButton)
                                    trayIcon.modelData.secondaryActivate();
                                else
                                    trayIcon.modelData.activate();
                            }
                        }

                        Tooltip {
                            target: trayIcon
                            shown: trayHover.containsMouse
                            text: {
                                const item = trayIcon.modelData;
                                return [item.tooltipTitle, item.tooltipDescription].filter(part => part).join("\n") || item.title;
                            }
                        }
                    }
                }
            }
        }

        // modules/battery.jsonc: red bg, black fg, padding 0 15px.
        Item {
            id: batteryModule
            visible: battery.present
            width: battery.present ? batteryText.width : 0
            height: bar.height

            Rectangle {
                anchors.fill: parent
                color: theme.red
            }

            BarText {
                id: batteryText
                anchors.centerIn: parent
                leftPadding: 15
                rightPadding: 15
                topPadding: 0
                bottomPadding: 0
                text: battery.label
                color: theme.black
            }
        }
    }
}

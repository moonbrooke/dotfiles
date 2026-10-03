import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Networking
import Quickshell.Services.SystemTray

PanelWindow {
    id: bar

    anchors {
        bottom: true
        left: true
        right: true
    }

    aboveWindows: true
    exclusiveZone: 34
    implicitHeight: 34
    color: theme.black

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

    // #waybar + the shared module padding: 5px 10px 7px 10px
    component BarText: Text {
        font.family: "Monocraft"
        font.weight: Font.Bold
        font.pixelSize: 14
        color: theme.white
        verticalAlignment: Text.AlignVCenter
        leftPadding: 10
        rightPadding: 10
        topPadding: 5
        bottomPadding: 7
    }

    // waybar tooltips (custom/layout, custom/logo, tray)
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
            radius: 4
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
            font.family: "Monocraft"
            font.weight: Font.Bold
            font.pixelSize: 12
            color: theme.white
        }
    }

    // custom/layout
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

    // pulseaudio
    QtObject {
        id: audio

        property string sink: ""
        property int percent: 0
        property bool muted: false

        readonly property bool bluetooth: sink.indexOf("bluez") === 0
        // format-icons headphone/default: "VOL:"; format-bluetooth: glyph
        readonly property string label: audio.bluetooth ? "󰂰" : (audio.muted ? "MUTED" : "VOL: " + audio.percent + "%")
    }

    Process {
        id: audioProc

        running: true
        command: ["sh", "-c",
            "printf '%s|%s\\n' \"$(pactl get-default-sink 2>/dev/null)\" \"$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)\""]

        stdout: StdioCollector {
            onStreamFinished: {
                const parts = String(text).split("|");
                audio.sink = (parts[0] || "").trim();
                const volume = parts[1] || "";
                const match = /([0-9]*\.?[0-9]+)/.exec(volume);
                if (match)
                    audio.percent = Math.round(parseFloat(match[1]) * 100);
                audio.muted = volume.indexOf("[MUTED]") !== -1;
            }
        }
    }

    Process {
        id: audioAction

        command: ["sh", "-c", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle; sleep 0.1"]
        onExited: audioProc.running = true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: if (!audioProc.running) audioProc.running = true
    }

    // network
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

        // format-wifi / format-ethernet / format-disconnected
        readonly property string label: !network.device ? "NET: OFF"
            : (network.device.type === DeviceType.Wired ? "ETH: " + network.device.name : "NET: " + network.essid)
    }

    // battery
    QtObject {
        id: battery

        property bool present: false
        property int capacity: 0
        property string status: ""
        property double current: 0
        property double chargeFull: 0

        readonly property bool charging: battery.status === "Charging"
        readonly property bool full: battery.status === "Full" || battery.capacity >= 100

        // format-icons: 20/40/60/80/100%
        readonly property string icon: ["󰁺", "󰁼", "󰁿", "󰂁", "󰁹"][Math.max(0, Math.min(4, Math.floor(battery.capacity / 20)))]

        // format-time: " ({H}h{M}m)"
        readonly property string time: {
            if (battery.current <= 0 || battery.chargeFull <= 0)
                return "";
            const remaining = (battery.charging ? 100 - battery.capacity : battery.capacity) / 100 * battery.chargeFull;
            const seconds = Math.floor(remaining / battery.current * 3600);
            return seconds < 60 ? "" : " (" + Math.floor(seconds / 3600) + "h" + Math.floor(seconds / 60 % 60) + "m)";
        }

        // format-charging-full / format-charging / format
        readonly property string label: !battery.present ? ""
            : (battery.full ? "󰂄 " + battery.capacity + "%"
                : (battery.charging ? "󰂄 " + battery.capacity + "%" + battery.time
                    : battery.icon + " " + battery.capacity + "%" + battery.time))

        function parse(text) {
            const parts = String(text).split("|");
            battery.present = parts.length > 3 && parts[0] !== "" && !isNaN(parseInt(parts[0]));
            battery.capacity = parseInt(parts[0]) || 0;
            battery.status = parts[1] || "";
            battery.current = parseFloat(parts[2]) || 0;
            battery.chargeFull = parseFloat(parts[3]) || 0;
        }
    }

    Process {
        id: batteryProc

        running: true
        command: ["sh", "-c",
            "b=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -1);"
            + " printf '%s|%s|%s|%s\\n' \"$(cat $b/capacity 2>/dev/null)\" \"$(cat $b/status 2>/dev/null)\""
            + " \"$(cat $b/current_now 2>/dev/null)\" \"$(cat $b/charge_full 2>/dev/null)\""]

        stdout: StdioCollector {
            onStreamFinished: battery.parse(text)
        }
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: if (!batteryProc.running) batteryProc.running = true
    }

    // hyprland/workspaces
    QtObject {
        id: workspaceModel

        // mirrors waybar modules/hyprland/workspaces.jsonc persistent_workspaces
        readonly property int workspaceCount: 6

        // exactly 1..6; dynamic and special workspaces are not shown
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

        // #workspaces button cascade: visible, focused, urgent, active, :hover, .visible:hover
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
                font.pixelSize: 12
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
                text: layoutData.short + "\n" + layoutData.long
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
                            leftPadding: 10
                            rightPadding: 10
                            topPadding: 5
                            bottomPadding: 7
                            text: modelData.label
                            color: workspaceButton.colors.fg
                            font.family: "Monocraft"
                            font.weight: Font.Bold
                            font.pixelSize: 14
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            acceptedButtons: Qt.LeftButton
                            onEntered: workspaceButton.hovered = true
                            onExited: workspaceButton.hovered = false
                            // this hyprland is configured with hypr-lua, so the
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

            // the rewrite rule drops the span entirely when {class} is empty
            readonly property var toplevel: ToplevelManager.activeToplevel
            readonly property string prefix: toplevel ? "[" + toplevel.appId + "] " : ""

            // max-length: 30
            readonly property string text: {
                const full = windowModule.prefix + (windowModule.toplevel ? windowModule.toplevel.title : "");
                return full.length > 30 ? full.substring(0, 29) + "…" : full;
            }

            readonly property bool truncatedPrefix: windowModule.text.startsWith(windowModule.prefix)

            Row {
                id: windowRow
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    text: windowModule.truncatedPrefix ? windowModule.prefix : ""
                    color: theme.white
                    font.family: "Monocraft"
                    font.weight: Font.Bold
                    font.pixelSize: 12
                }

                Text {
                    text: windowModule.text.substring(windowModule.truncatedPrefix ? windowModule.prefix.length : 0)
                    color: theme.gray
                    font.family: "Monocraft"
                    font.weight: Font.Bold
                    font.pixelSize: 12
                }
            }
        }
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Item {
        id: clockModule
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: clockText.width
        height: bar.height

        BarText {
            id: clockText
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            // {:%a, %e %b / %I:%M %p}
            text: Qt.formatDateTime(clock.date, "ddd, " + (clock.date.day < 10 ? " " : "") + "d MMM / hh:mm AP")
        }

        MouseArea {
            anchors.fill: parent
            onClicked: calcurseProc.running = true
        }
    }

    Process {
        id: calcurseProc
        command: ["sh", "-c", "foot calcurse"]
    }

    Row {
        id: rightModules
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        Item {
            id: audioModule
            width: audioText.width
            height: bar.height

            BarText {
                id: audioText
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: audio.label
                color: audio.muted ? theme.gray : theme.white
            }

            MouseArea {
                id: audioHover
                anchors.fill: parent
                hoverEnabled: true
                onClicked: audioAction.running = true
            }

            WheelHandler {
                enabled: audioHover.containsMouse
                target: null

                onWheel: function(event) {
                    audioAction.command = ["sh", "-c",
                        "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%" + (event.angleDelta.y > 0 ? "+" : "-") + "; sleep 0.1"];
                    audioAction.running = true;
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
                onClicked: wlctlProc.running = true
            }
        }

        Process {
            id: wlctlProc
            command: ["sh", "-c", "foot -T floating_wlctl wlctl"]
        }

        Item {
            id: trayModule
            width: trayRow.width
            height: bar.height

            Row {
                id: trayRow
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10

                Repeater {
                    model: SystemTray.items

                    Image {
                        id: trayIcon
                        required property var modelData

                        // waybar modules/tray.jsonc: icon-size 11
                        readonly property int iconSize: 11

                        width: iconSize
                        height: iconSize
                        // with height left implicit the provider is asked for an
                        // invalid size and answers 100x100, so pin sourceSize
                        sourceSize: Qt.size(iconSize, iconSize)
                        source: modelData.icon
                        asynchronous: false
                        smooth: true
                        fillMode: Image.PreserveAspectFit

                        // no context menu: DBusMenu entries are not exposed to
                        // QML in 0.3.1 and QsMenuEntry.display() needs a QMenu
                        // grab that quickshell's windows cannot provide
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
                font.pixelSize: 14
                text: battery.label
                color: theme.black
            }
        }
    }
}

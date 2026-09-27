import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.UPower

PanelWindow {
    id: bar
    anchors {
        top: true
        left: true
        right: true
    }
    height: 30
    
    color: theme.black

    QtObject {
        id: theme
        property color black:  "#1a1b26"
        property color red:    "#f7768e"
        property color green:  "#9ece6a"
        property color yellow: "#e0af68"
        property color blue:   "#7aa2f7"
        property color purple: "#bb9af7"
        property color aqua:   "#7dcfff"
        property color gray:   "#565f89"
        property color white:  "#c0caf5"
    }

    component BarText: Text {
        font.family: "Ricty Nerd Font"
        font.weight: Font.Bold
        font.pixelSize: 16
        color: theme.white
        verticalAlignment: Text.AlignVCenter
        padding: 5
        bottomPadding: 7
    }

    Row {
        id: leftModules
        anchors.left: parent.left
        spacing: 0

        BarText {
            text: "A "
            font.family: "English Football Club Badges"
            color: theme.red
            
            Process {
                id: rofiProcess
                command: ["sh", "-c", "pkill rofi || rofi -modes 'drun' -show drun -display-drun 'Menu' -display-run 'Run' -display-window 'Window' -show-icons -auto-close"]
            }
            MouseArea {
                anchors.fill: parent
                onClicked: rofiProcess.running = true
            }
        }

        Row {
            Repeater {
                model: Hyprland.workspaces
                
                Rectangle {
                    width: 30
                    height: parent.height
                    
                    color: {
                        if (modelData.active) return theme.green;
                        if (modelData.urgent) return theme.red;
                        if (modelData.id === Hyprland.focusedWorkspace?.id) return theme.aqua;
                        return theme.black;
                    }
                    
                    BarText {
                        anchors.centerIn: parent
                        text: modelData.id === 4 ? "SUB" : modelData.id.toString()
                        
                        color: {
                            if (modelData.active || modelData.urgent || modelData.id === Hyprland.focusedWorkspace?.id) return theme.black;
                            if (modelData.windows > 0) return theme.green; // .visible equivalent
                            return theme.white;
                        }
                    }
                }
            }
        }

        BarText {
            text: Hyprland.focusedWindow ? Hyprland.focusedWindow.title : ""
            font.family: "Sarasa Mono CL"
            font.pixelSize: 14
        }
    }

    Row {
        id: rightModules
        anchors.right: parent.right
        spacing: 10

        BarText { text: "RAM: 0.0G/0.0G" }
        BarText { text: "CPU: 0%" }
        BarText { text: "TEMP: 0°" }

        BarText {
            property var bat: null
            property int percentage: bat ? Math.round(bat.percentage * 100) : 100
            
            text: "󰁹 " + percentage + "%"
            
            color: {
                if (percentage <= 15) return theme.yellow; // .critical
                if (percentage <= 30) return theme.red;    // .warning
                return theme.white;
            }
        }

        BarText { text: "VOL 100%" }

        BarText {
            text: "NET: ON"
            color: theme.green
            
            Process {
                id: nmtuiProcess
                command: ["kitty", "--class", "floating_nmtui", "-e", "nmtui"]
            }
            MouseArea {
                anchors.fill: parent
                onClicked: nmtuiProcess.running = true
            }
        }

        SystemClock {
            id: sysClock
            precision: SystemClock.Minutes
        }
        Rectangle {
            height: parent.height
            width: clockText.width + 20
            color: theme.white
            
            BarText {
                id: clockText
                anchors.centerIn: parent
                color: theme.black
                // format: "{:%e %b, %H:%M}"
                text: Qt.formatDateTime(sysClock.date, "d MMM, HH:mm")
            }
        }

        BarText { text: "󰌌 EN" }

        Rectangle {
            height: parent.height
            width: powerText.width + 20
            color: theme.red

            BarText {
                id: powerText
                anchors.centerIn: parent
                color: theme.black
                text: "⏻"
            }
            
            Process {
                id: powerProcess
                command: ["sh", "-c", "~/.config/hypr/scripts/power.sh"]
            }
            MouseArea {
                anchors.fill: parent
                onClicked: powerProcess.running = true
            }
        }
    }
}

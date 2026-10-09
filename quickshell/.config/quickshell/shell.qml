//@ pragma IconTheme Adwaita
import QtQuick
import Quickshell

ShellRoot {
    // island-bottom is shown on every output (waybar default when no `output` is set).
    Variants {
        model: Quickshell.screens

        delegate: Component {
            Loader {
                required property var modelData
                source: "bar-bottom.qml"
                onLoaded: item.screen = modelData
            }
        }
    }
}

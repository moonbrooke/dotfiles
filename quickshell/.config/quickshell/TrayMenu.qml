import QtQuick
import Quickshell

// Dark TokyoNight context menu for tray icons.
// Replaces the white native QMenu (QsMenuAnchor) with a QML PopupWindow
// driven by QsMenuOpener, so it matches the bar theme.
//
// NOTE: submenus are created dynamically with Qt.createComponent instead of
// a static nested TrayMenu, because the QML compiler rejects a component
// that statically instantiates itself ("instantiated recursively").
PopupWindow {
    id: root

    required property var handle
    required property Item anchorTarget
    property var hub: null
    property var parentMenu: null
    property bool isSubmenu: false

    property var openChild: null
    property var menuComponent: null

    anchor.item: anchorTarget
    anchor.edges: isSubmenu ? Edges.Right : Edges.Top
    anchor.gravity: isSubmenu ? Edges.Right : Edges.Top

    visible: false
    color: "transparent"
    implicitWidth: menuBg.implicitWidth
    implicitHeight: menuBg.implicitHeight

    Component.onCompleted: {
        root.menuComponent = Qt.createComponent("TrayMenu.qml");
    }

    function openMenu() {
        if (!root.isSubmenu && root.hub) {
            if (root.hub.current && root.hub.current !== root)
                root.hub.current.closeMenu();
            root.hub.current = root;
        }
        root.visible = true;
    }

    function closeMenu() {
        if (root.openChild) {
            root.openChild.closeMenu();
            root.openChild = null;
        }
        root.visible = false;
        if (!root.isSubmenu && root.hub && root.hub.current === root)
            root.hub.current = null;
    }

    function toggleMenu() {
        if (root.visible)
            root.closeMenu();
        else
            root.openMenu();
    }

    function closeTree() {
        root.closeMenu();
        if (root.parentMenu)
            root.parentMenu.closeTree();
    }

    onVisibleChanged: {
        if (!root.visible && root.openChild) {
            root.openChild.closeMenu();
            root.openChild = null;
        }
    }

    Shortcut {
        sequence: "Escape"
        onActivated: root.closeTree()
    }

    QsMenuOpener {
        id: opener
        menu: root.handle
    }

    Rectangle {
        id: menuBg

        // Mirrors bar-bottom.qml theme (separate file, so hardcoded):
        // muted #24283b bg, gray #565f89 border, white #c0caf5 text.
        color: "#24283b"
        border.color: "#565f89"
        border.width: 1
        radius: 0

        implicitWidth: 232
        implicitHeight: menuColumn.implicitHeight + 2

        Column {
            id: menuColumn
            anchors.centerIn: parent
            width: 230

            Repeater {
                model: opener.children

                Item {
                    id: row
                    required property var modelData
                    width: 230
                    height: modelData.isSeparator ? 9 : 28
                    property bool hovered: false
                    property var subItem: null

                    function openSub() {
                        if (!row.modelData.hasChildren)
                            return;
                        if (!row.subItem) {
                            if (!root.menuComponent)
                                root.menuComponent = Qt.createComponent("TrayMenu.qml");
                            if (!root.menuComponent || root.menuComponent.status !== Component.Ready)
                                return;
                            row.subItem = root.menuComponent.createObject(root, {
                                "handle": row.modelData,
                                "anchorTarget": row,
                                "hub": root.hub,
                                "parentMenu": root,
                                "isSubmenu": true
                            });
                        }
                        if (!row.subItem)
                            return;
                        if (root.openChild && root.openChild !== row.subItem)
                            root.openChild.closeMenu();
                        root.openChild = row.subItem;
                        row.subItem.visible = true;
                    }

                    Rectangle {
                        visible: row.modelData.isSeparator
                        anchors.centerIn: parent
                        width: parent.width - 16
                        height: 1
                        color: "#565f89"
                    }

                    Rectangle {
                        visible: !row.modelData.isSeparator
                        anchors.fill: parent
                        color: (row.hovered && row.modelData.enabled) ? "#565f89" : "transparent"
                    }

                    Row {
                        visible: !row.modelData.isSeparator
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        spacing: 8

                        Item {
                            width: 16
                            height: 16
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                anchors.centerIn: parent
                                visible: row.modelData.checkState === Qt.Checked
                                text: "✓"
                                font.pixelSize: 12
                                font.bold: true
                                color: "#9ece6a"
                            }

                            Image {
                                anchors.centerIn: parent
                                visible: row.modelData.checkState !== Qt.Checked && row.modelData.icon !== ""
                                width: 14
                                height: 14
                                sourceSize: Qt.size(14, 14)
                                source: row.modelData.icon
                                smooth: true
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        Text {
                            width: row.modelData.hasChildren ? 168 : 184
                            anchors.verticalCenter: parent.verticalCenter
                            text: row.modelData.text
                            elide: Text.ElideRight
                            font.family: "IosevkaTerm Nerd Font Mono"
                            font.weight: Font.Bold
                            font.pixelSize: 12
                            color: row.modelData.enabled ? "#c0caf5" : "#565f89"
                        }

                        Text {
                            visible: row.modelData.hasChildren
                            anchors.verticalCenter: parent.verticalCenter
                            text: "▸"
                            font.pixelSize: 12
                            font.bold: true
                            color: row.modelData.enabled ? "#c0caf5" : "#565f89"
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: !row.modelData.isSeparator && row.modelData.enabled

                        onEntered: {
                            row.hovered = true;
                            if (row.modelData.hasChildren) {
                                row.openSub();
                            } else if (root.openChild) {
                                root.openChild.closeMenu();
                                root.openChild = null;
                            }
                        }
                        onExited: row.hovered = false

                        onClicked: {
                            if (row.modelData.hasChildren) {
                                if (row.subItem && row.subItem.visible) {
                                    row.subItem.closeMenu();
                                    root.openChild = null;
                                } else {
                                    row.openSub();
                                }
                            } else {
                                row.modelData.triggered();
                                root.closeTree();
                            }
                        }
                    }
                }
            }
        }
    }
}

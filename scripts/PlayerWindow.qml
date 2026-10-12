import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

import "../modules/gui/qt/style"
import "../modules/gui/qt/widgets/qml"
import "../modules/gui/qt/player/qml"
import "../modules/gui/qt/dialogs/dialogs/qml"

ApplicationWindow {
    id: window
    visible: true
    width: 1280
    height: 720
    minimumWidth: 800
    minimumHeight: 500
    title: "VLC Media Player (Jux Redesign)"
    color: JuxTheme.bgB1

    // State flags
    property bool isQuickSettingsOpen: false
    property bool isAddSubsOpen: false
    property bool isFullSettingsOpen: false

    Item {
        anchors.fill: parent

        // ==================== 1. TOP BAR ====================
        Rectangle {
            id: topBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: JuxTheme.topBarHeight
            color: JuxTheme.bgB1Transparent
            z: 10

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 12

                // Left: Traffic Cone Logo + Menu Button
                Image {
                    width: 22
                    height: 22
                    source: Qt.resolvedUrl("../modules/gui/qt/resources/icons/vlc.svg")
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }

                Rectangle {
                    width: 26
                    height: 26
                    radius: JuxTheme.radiusControl
                    color: menuMouse.containsMouse ? "#2a2a2b" : "transparent"

                    Image {
                        anchors.centerIn: parent
                        width: 18
                        height: 18
                        source: Qt.resolvedUrl("../modules/gui/qt/resources/icons/more.svg")
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }

                    MouseArea {
                        id: menuMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: window.isFullSettingsOpen = !window.isFullSettingsOpen
                    }
                }

                // Show / Folder Breadcrumb
                RowLayout {
                    spacing: 6
                    Image {
                        width: 15
                        height: 15
                        source: Qt.resolvedUrl("../modules/gui/qt/resources/icons/folder.svg")
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }
                    Text {
                        text: "The Wand / S01E05"
                        color: JuxTheme.textSecondary
                        font.family: JuxTheme.fontFamily
                        font.pixelSize: 13
                    }
                }

                // Center Title
                Item { Layout.fillWidth: true }
                Text {
                    text: "The_Wand_S01E05.mp4"
                    color: JuxTheme.textPrimary
                    font.family: JuxTheme.fontFamily
                    font.pixelSize: 13
                    font.bold: true
                }
                Item { Layout.fillWidth: true }

                // Right: Window controls + Fullscreen icon
                RowLayout {
                    spacing: 10

                    Rectangle {
                        width: 26
                        height: 26
                        radius: JuxTheme.radiusControl
                        color: fsMouse.containsMouse ? "#2a2a2b" : "transparent"

                        Image {
                            anchors.centerIn: parent
                            width: 16
                            height: 16
                            source: Qt.resolvedUrl("../modules/gui/qt/resources/icons/fullscreen.svg")
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }

                        MouseArea {
                            id: fsMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (window.visibility === Window.FullScreen)
                                    window.showNormal()
                                else
                                    window.showFullScreen()
                            }
                        }
                    }

                    Image {
                        width: 14
                        height: 14
                        source: Qt.resolvedUrl("../modules/gui/qt/resources/icons/minimize.svg")
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }
                    Image {
                        width: 14
                        height: 14
                        source: Qt.resolvedUrl("../modules/gui/qt/resources/icons/maximize.svg")
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }
                    Image {
                        width: 14
                        height: 14
                        source: Qt.resolvedUrl("../modules/gui/qt/resources/icons/close.svg")
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }
                }
            }
        }

        // ==================== 2. MAIN VIDEO DISPLAY ====================
        Rectangle {
            id: videoCanvas
            anchors.top: topBar.bottom
            anchors.bottom: controlBar.top
            anchors.left: parent.left
            anchors.right: quickSidebar.left
            color: JuxTheme.bgVideo

            // Placeholder media poster / video illustration
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 16

                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: 140
                    height: 140
                    radius: 70
                    color: Qt.rgba(232/255, 133/255, 12/255, 0.15)
                    border.color: JuxTheme.accent
                    border.width: 2

                    Image {
                        anchors.centerIn: parent
                        width: 72
                        height: 72
                        source: Qt.resolvedUrl("../modules/gui/qt/resources/icons/vlc.svg")
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "VLC Media Player (Reimagined)"
                    color: JuxTheme.textPrimary
                    font.family: JuxTheme.fontFamily
                    font.pixelSize: 20
                    font.bold: true
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "VLC Redesign interactive session • Full vector SVG icon suite loaded"
                    color: JuxTheme.textSecondary
                    font.family: JuxTheme.fontFamily
                    font.pixelSize: 13
                }
            }
        }

        // ==================== 3. QUICK SETTINGS SIDEBAR ====================
        JuxQuickSettingsSidebar {
            id: quickSidebar
            anchors.top: topBar.bottom
            anchors.bottom: controlBar.top
            anchors.right: parent.right
            width: window.isQuickSettingsOpen ? 380 : 0
            visible: width > 0
            z: 20

            Behavior on width {
                NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
            }

            onCloseRequested: window.isQuickSettingsOpen = false
        }

        // ==================== 4. SINGLE-ROW CONTROL BAR ====================
        JuxControlBar {
            id: controlBar
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            z: 30

            onToggleQuickSettingsRequested: window.isQuickSettingsOpen = !window.isQuickSettingsOpen
            onSubtitleMenuRequested: window.isAddSubsOpen = true
        }

        // ==================== 5. ADD SUBTITLES MODAL DIALOG ====================
        JuxAddSubtitlesDialog {
            id: addSubsDialog
            visible: window.isAddSubsOpen
            anchors.centerIn: parent
            z: 50
            onClosed: window.isAddSubsOpen = false
        }

        // ==================== 6. FULL SETTINGS REIMAGINED VIEW ====================
        JuxSettingsView {
            id: fullSettingsModal
            visible: window.isFullSettingsOpen
            anchors.centerIn: parent
            width: Math.min(parent.width - 60, 1048)
            height: Math.min(parent.height - 60, 800)
            z: 60
            onCloseRequested: window.isFullSettingsOpen = false
        }
    }
}

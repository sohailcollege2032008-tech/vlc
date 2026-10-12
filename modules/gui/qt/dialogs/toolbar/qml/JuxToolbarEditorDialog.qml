/*****************************************************************************
 * Copyright (C) 2026 VLC Authors & VideoLAN
 *
 * Jux VLC Redesign - Toolbar Customizer Dialog & Player Outline Canvas
 * Matches Figma frames c01-c09 (nodes #2107:5604, #2160:6137, #6587:19923)
 *****************************************************************************/
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../../../style"
import "../../../widgets/qml"

Item {
    id: root

    property string title: "Customize Player"
    property alias topBarDropZone: topBarDropZone
    property alias controlBarDropZone: controlBarDropZone
    property alias toolsModel: toolsRepeater.model
    property bool isModified: false

    signal closed()
    signal saved()

    // 1. Semi-transparent backdrop
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.75)
    }

    // 2. Player Outline Preview behind dialog
    // Top Bar Outline Drop Zone
    Rectangle {
        id: topBarDropZone
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: JuxTheme.topBarHeight
        color: "transparent"
        border.color: Qt.rgba(255, 255, 255, 0.25)
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 12

            // Left tools zone
            Rectangle {
                width: 120
                height: 28
                color: Qt.rgba(255, 255, 255, 0.05)
                border.color: Qt.rgba(255, 255, 255, 0.2)
                radius: JuxTheme.radiusControl

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 8
                    Image { width: 14; height: 14; source: Qt.resolvedUrl("../../../resources/icons/vlc.svg"); fillMode: Image.PreserveAspectFit; smooth: true }
                    Image { width: 12; height: 12; source: Qt.resolvedUrl("../../../resources/icons/more.svg"); fillMode: Image.PreserveAspectFit; smooth: true }
                    Image { width: 12; height: 12; source: Qt.resolvedUrl("../../../resources/icons/folder.svg"); fillMode: Image.PreserveAspectFit; smooth: true }
                    Text { text: "S01"; color: JuxTheme.textSecondary; font.pixelSize: 11 }
                }
            }

            Item { Layout.fillWidth: true }

            // Center Title Drop Zone
            Rectangle {
                width: 180
                height: 28
                color: Qt.rgba(255, 255, 255, 0.05)
                border.color: Qt.rgba(255, 255, 255, 0.2)
                radius: JuxTheme.radiusControl

                Text {
                    anchors.centerIn: parent
                    text: "The_Wand_S01E05.mp4"
                    color: JuxTheme.textSecondary
                    font.pixelSize: 11
                }
            }

            Item { Layout.fillWidth: true }

            // Right Controls Drop Zone
            Rectangle {
                width: 100
                height: 28
                color: Qt.rgba(255, 255, 255, 0.05)
                border.color: Qt.rgba(255, 255, 255, 0.2)
                radius: JuxTheme.radiusControl

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 8
                    Image { width: 11; height: 11; source: Qt.resolvedUrl("../../../resources/icons/fullscreen.svg"); fillMode: Image.PreserveAspectFit; smooth: true }
                    Image { width: 10; height: 10; source: Qt.resolvedUrl("../../../resources/icons/minimize.svg"); fillMode: Image.PreserveAspectFit; smooth: true }
                    Image { width: 10; height: 10; source: Qt.resolvedUrl("../../../resources/icons/maximize.svg"); fillMode: Image.PreserveAspectFit; smooth: true }
                    Image { width: 10; height: 10; source: Qt.resolvedUrl("../../../resources/icons/close.svg"); fillMode: Image.PreserveAspectFit; smooth: true }
                }
            }
        }
    }

    // Bottom Control Bar Drop Zone
    Rectangle {
        id: controlBarDropZone
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: JuxTheme.controlBarHeight
        color: "transparent"
        border.color: Qt.rgba(255, 255, 255, 0.25)
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 14

            Rectangle {
                width: 120
                height: 38
                color: Qt.rgba(255, 255, 255, 0.05)
                border.color: Qt.rgba(255, 255, 255, 0.2)
                radius: JuxTheme.radiusControl

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 10
                    Image { width: 14; height: 14; source: Qt.resolvedUrl("../../../resources/icons/previous.svg"); fillMode: Image.PreserveAspectFit; smooth: true }
                    Image { width: 16; height: 16; source: Qt.resolvedUrl("../../../resources/icons/play.svg"); fillMode: Image.PreserveAspectFit; smooth: true }
                    Image { width: 14; height: 14; source: Qt.resolvedUrl("../../../resources/icons/next.svg"); fillMode: Image.PreserveAspectFit; smooth: true }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 38
                color: Qt.rgba(255, 255, 255, 0.03)
                border.color: Qt.rgba(255, 255, 255, 0.15)
                radius: JuxTheme.radiusControl

                Text {
                    anchors.centerIn: parent
                    text: "Timeline & Progress Drop Zone"
                    color: JuxTheme.textTertiary
                    font.pixelSize: 12
                }
            }

            Rectangle {
                width: 220
                height: 38
                color: Qt.rgba(255, 255, 255, 0.05)
                border.color: Qt.rgba(255, 255, 255, 0.2)
                radius: JuxTheme.radiusControl

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 12
                    Image { width: 14; height: 14; source: Qt.resolvedUrl("../../../resources/icons/volume.svg"); fillMode: Image.PreserveAspectFit; smooth: true }
                    Image { width: 14; height: 14; source: Qt.resolvedUrl("../../../resources/icons/subtitles.svg"); fillMode: Image.PreserveAspectFit; smooth: true }
                    Image { width: 14; height: 14; source: Qt.resolvedUrl("../../../resources/icons/settings.svg"); fillMode: Image.PreserveAspectFit; smooth: true }
                    Image { width: 14; height: 14; source: Qt.resolvedUrl("../../../resources/icons/queue.svg"); fillMode: Image.PreserveAspectFit; smooth: true }
                }
            }
        }
    }

    // 3. Main Center Modal Box
    Rectangle {
        id: modalBox
        anchors.centerIn: parent
        width: Math.min(parent.width - 80, 840)
        height: Math.min(parent.height - 100, 600)
        color: JuxTheme.bgB2
        radius: JuxTheme.radiusModal
        border.color: Qt.rgba(255, 255, 255, 0.1)
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 16

            // Header Row
            RowLayout {
                Layout.fillWidth: true

                ColumnLayout {
                    spacing: 4
                    Text {
                        text: root.title
                        color: JuxTheme.textPrimary
                        font.family: JuxTheme.fontFamily
                        font.pixelSize: 18
                        font.bold: true
                    }
                    Text {
                        text: "Drag items around and out of the box below to re-order them. Drag items into the box to remove them from the player."
                        color: JuxTheme.textSecondary
                        font.family: JuxTheme.fontFamily
                        font.pixelSize: 12
                    }
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    width: 28
                    height: 28
                    radius: JuxTheme.radiusControl
                    color: closeMouse.containsMouse ? "#2b2b2b" : "transparent"

                    Image {
                        anchors.centerIn: parent
                        width: 14
                        height: 14
                        source: Qt.resolvedUrl("../../../resources/icons/close.svg")
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }

                    MouseArea {
                        id: closeMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.closed()
                    }
                }
            }

            // Tools Palette Grid
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                GridLayout {
                    id: toolsGrid
                    columns: 9
                    columnSpacing: 10
                    rowSpacing: 12
                    anchors.fill: parent

                    Repeater {
                        id: toolsRepeater
                        model: [
                            { name: "Playback Speed", icon: "speed" },
                            { name: "Forward 15s", icon: "forward-15" },
                            { name: "Backward 15s", icon: "backward-15" },
                            { name: "Stop", icon: "stop" },
                            { name: "Repeat", icon: "repeat" },
                            { name: "Shuffle", icon: "shuffle" },
                            { name: "Record", icon: "record" },
                            { name: "Snapshot", icon: "snapshot" },
                            { name: "Picture in Picture", icon: "pip" },
                            { name: "Zoom / Search", icon: "search" },
                            { name: "VLC Settings", icon: "settings" },
                            { name: "Go Home", icon: "home" },
                            { name: "Folder Name", icon: "folder" },
                            { name: "Properties", icon: "info" },
                            { name: "Favorite", icon: "favorite" },
                            { name: "Bookmark", icon: "bookmark" },
                            { name: "Playlists", icon: "playlists" },
                            { name: "Recent", icon: "recent" },
                            { name: "Fullscreen", icon: "fullscreen" },
                            { name: "Audio Track", icon: "audio" },
                            { name: "Subtitles", icon: "subtitles" },
                            { name: "Volume", icon: "volume" },
                            { name: "Network", icon: "network" },
                            { name: "Media Queue", icon: "queue" },
                            { name: "Grid View", icon: "grid" },
                            { name: "List View", icon: "list" },
                            { name: "Sort Order", icon: "sort" }
                        ]

                        Rectangle {
                            Layout.preferredWidth: 76
                            Layout.preferredHeight: 76
                            radius: JuxTheme.radiusControl
                            color: toolMouse.containsMouse ? "#242424" : "#1a1a1a"
                            border.color: Qt.rgba(255, 255, 255, 0.15)
                            border.width: 1

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 4

                                Image {
                                    Layout.alignment: Qt.AlignHCenter
                                    width: 22
                                    height: 22
                                    source: Qt.resolvedUrl("../../../resources/icons/" + modelData.icon + ".svg")
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                }

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: modelData.name
                                    color: JuxTheme.textSecondary
                                    font.family: JuxTheme.fontFamily
                                    font.pixelSize: 9
                                    elide: Text.ElideRight
                                    Layout.maximumWidth: 68
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }

                            MouseArea {
                                id: toolMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.isModified = true
                            }
                        }
                    }
                }
            }

            // Bottom Buttons
            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Rectangle {
                    Layout.preferredWidth: 90
                    Layout.preferredHeight: 34
                    radius: JuxTheme.radiusControl
                    color: cancelMouse.containsMouse ? "#2a2a2a" : "#1c1c1c"
                    border.color: Qt.rgba(255, 255, 255, 0.1)

                    Text {
                        anchors.centerIn: parent
                        text: "Cancel"
                        color: JuxTheme.textPrimary
                        font.family: JuxTheme.fontFamily
                        font.pixelSize: 13
                    }

                    MouseArea {
                        id: cancelMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.closed()
                    }
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    Layout.preferredWidth: 90
                    Layout.preferredHeight: 34
                    radius: JuxTheme.radiusControl
                    color: root.isModified ? JuxTheme.accent : "#2b2015"

                    Text {
                        anchors.centerIn: parent
                        text: "Save"
                        color: root.isModified ? "#ffffff" : "#666666"
                        font.family: JuxTheme.fontFamily
                        font.pixelSize: 13
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: root.isModified ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            if (root.isModified) {
                                root.saved()
                                root.closed()
                            }
                        }
                    }
                }
            }
        }
    }
}

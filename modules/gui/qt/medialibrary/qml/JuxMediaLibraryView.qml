/*****************************************************************************
 * Copyright (C) 2026 VLC Authors & VideoLAN
 *
 * Jux VLC Redesign - Full Media Library View
 * Matches Figma frame library.png (node #2107:5604 / media browser)
 *****************************************************************************/
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../../style"
import "../../widgets/qml"

Item {
    id: root

    property alias sideNav: navPane
    property alias mediaGrid: gridView
    property string breadcrumbText: "Videos ▸ Shows ▸ The Wand ▸ S01"
    property int selectedNavIndex: 1

    signal itemPlayed(string title)

    Rectangle {
        anchors.fill: parent
        color: JuxTheme.bgB1
    }

    // Top Bar
    Rectangle {
        id: topBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: JuxTheme.topBarHeight
        color: "#111111"
        z: 10

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 12

            Text {
                text: "▲"
                color: JuxTheme.accent
                font.pixelSize: 18
                font.bold: true
            }

            Text {
                text: "⋯"
                color: JuxTheme.textSecondary
                font.pixelSize: 16
            }

            Item { Layout.fillWidth: true }

            Text {
                text: "VLC Media Player"
                color: JuxTheme.textSecondary
                font.family: JuxTheme.fontFamily
                font.pixelSize: 13
            }

            Item { Layout.fillWidth: true }

            Text { text: "─"; color: JuxTheme.textSecondary; font.pixelSize: 14 }
            Text { text: "▢"; color: JuxTheme.textSecondary; font.pixelSize: 13 }
            Text { text: "✕"; color: JuxTheme.textSecondary; font.pixelSize: 13 }
        }
    }

    // Main Content Split: Sidebar + Media Canvas
    RowLayout {
        anchors.top: topBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 0

        // 1. Left Side Navigation Pane
        Rectangle {
            id: navPane
            Layout.preferredWidth: 180
            Layout.fillHeight: true
            color: "#121212"
            border.color: Qt.rgba(255, 255, 255, 0.05)
            border.width: 1

            property var items: [
                "Home",
                "Videos",
                "Music",
                "Network",
                "Playlists",
                "Recent",
                "+ Add item"
            ]

            property var icons: [
                "🏠",
                "🎬",
                "🎵",
                "📡",
                "📋",
                "🕒",
                "➕"
            ]

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 4

                Repeater {
                    model: navPane.items

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 38
                        radius: JuxTheme.radiusControl
                        color: root.selectedNavIndex === index ? Qt.rgba(232/255, 133/255, 12/255, 0.15)
                                                               : (itemHover.containsMouse ? "#1c1c1c" : "transparent")

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            spacing: 10

                            Text {
                                text: navPane.icons[index]
                                color: root.selectedNavIndex === index ? JuxTheme.accent : JuxTheme.textSecondary
                                font.pixelSize: 13
                            }

                            Text {
                                text: modelData
                                color: root.selectedNavIndex === index ? JuxTheme.accent : JuxTheme.textPrimary
                                font.family: JuxTheme.fontFamily
                                font.pixelSize: 13
                                font.bold: root.selectedNavIndex === index
                            }
                        }

                        MouseArea {
                            id: itemHover
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.selectedNavIndex = index
                        }
                    }
                }

                Item { Layout.fillHeight: true }
            }
        }

        // 2. Right Canvas: Subheader + Media Grid
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // Subheader Bar
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 52
                color: "#141414"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    spacing: 12

                    Text { text: "←"; color: JuxTheme.textSecondary; font.pixelSize: 14 }
                    Text { text: "→"; color: JuxTheme.textSecondary; font.pixelSize: 14 }

                    Text {
                        text: root.breadcrumbText
                        color: JuxTheme.textPrimary
                        font.family: JuxTheme.fontFamily
                        font.pixelSize: 13
                        font.bold: true
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: "15 items"
                        color: JuxTheme.textSecondary
                        font.family: JuxTheme.fontFamily
                        font.pixelSize: 12
                    }

                    Text { text: "↓↑"; color: JuxTheme.textSecondary; font.pixelSize: 14 }
                    Text { text: "㗊"; color: JuxTheme.accent; font.pixelSize: 16 }

                    // Search input pill
                    Rectangle {
                        Layout.preferredWidth: 160
                        Layout.preferredHeight: 30
                        radius: JuxTheme.radiusControl
                        color: "#1e1e1e"
                        border.color: Qt.rgba(255, 255, 255, 0.1)

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            spacing: 6

                            Text { text: "🔍"; color: JuxTheme.textSecondary; font.pixelSize: 11 }
                            Text {
                                text: "Search"
                                color: JuxTheme.textSecondary
                                font.family: JuxTheme.fontFamily
                                font.pixelSize: 12
                            }
                        }
                    }

                    Text { text: "⋯"; color: JuxTheme.textSecondary; font.pixelSize: 14 }
                }
            }

            // Grid of Media Cards
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                GridView {
                    id: gridView
                    anchors.fill: parent
                    anchors.margins: 20
                    cellWidth: 216
                    cellHeight: 160

                    model: [
                        { title: "The_Wand_S01E05.mp4", progress: 0.0 },
                        { title: "The_Wand_S01E06.mp4", progress: 0.0 },
                        { title: "The_Wand_S01E07.mp4", progress: 0.0 },
                        { title: "The_Wand_S01E08.mp4", progress: 0.0 },
                        { title: "The_Wand_S01E09.mp4", progress: 0.0 },
                        { title: "The_Wand_S01E10.mp4", progress: 0.0 },
                        { title: "The_Wand_S01E11.mp4", progress: 0.0 },
                        { title: "The_Wand_S01E12.mp4", progress: 0.0 },
                        { title: "The_Wand_S01E13.mp4", progress: 0.0 },
                        { title: "The_Wand_S01E14.mp4", progress: 0.0 },
                        { title: "The_Wand_S01E15.mp4", progress: 0.0 },
                        { title: "The_Wand_S01E01.mp4", progress: 1.0 },
                        { title: "The_Wand_S01E02.mp4", progress: 1.0 },
                        { title: "The_Wand_S01E03.mp4", progress: 0.8 },
                        { title: "The_Wand_S01E04.mp4", progress: 0.55 }
                    ]

                    delegate: Item {
                        width: 204
                        height: 148

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 8

                            // 16:9 Thumbnail Box
                            Rectangle {
                                Layout.preferredWidth: 204
                                Layout.preferredHeight: 115
                                radius: 8
                                color: cardHover.containsMouse ? "#222222" : "#191919"
                                border.color: cardHover.containsMouse ? JuxTheme.accent : Qt.rgba(255, 255, 255, 0.08)
                                border.width: 1
                                clip: true

                                // Thumbnail center icon / badge
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 36
                                    height: 36
                                    radius: 18
                                    color: Qt.rgba(0, 0, 0, 0.5)

                                    Text {
                                        anchors.centerIn: parent
                                        text: "▶"
                                        color: JuxTheme.textSecondary
                                        font.pixelSize: 14
                                    }
                                }

                                // Watched Progress Indicator Bar
                                Rectangle {
                                    anchors.bottom: parent.bottom
                                    anchors.left: parent.left
                                    height: 4
                                    width: parent.width * modelData.progress
                                    color: JuxTheme.accent
                                    visible: modelData.progress > 0
                                }

                                MouseArea {
                                    id: cardHover
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onDoubleClicked: root.itemPlayed(modelData.title)
                                }
                            }

                            // Title Label
                            Text {
                                Layout.fillWidth: true
                                text: modelData.title
                                color: cardHover.containsMouse ? JuxTheme.accent : JuxTheme.textPrimary
                                font.family: JuxTheme.fontFamily
                                font.pixelSize: 11
                                elide: Text.ElideMiddle
                            }
                        }
                    }
                }
            }
        }
    }
}

/*****************************************************************************
 * Copyright (C) 2026 VLC Authors & VideoLAN
 *
 * Jux VLC Redesign - Settings Reimagined
 * 13 human-friendly categories, live accent colors, human-readable dropdowns,
 * and inline Advanced Options accordion.
 * Direct implementation of Figma frames #999:5047, #3046:9282, #3046:10057
 * and video concepts [17:35 - 18:48].
 *****************************************************************************/
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T

import VLC.MainInterface
import VLC.Style
import VLC.Widgets as Widgets

Rectangle {
    id: root

    implicitWidth: 1048
    implicitHeight: 800
    color: JuxTheme.bgB1
    radius: JuxTheme.radiusDialog
    border.color: Qt.rgba(255, 255, 255, 0.08)
    border.width: 1

    readonly property var categories: [
        { group: "App", name: "General", icon: "settings" },
        { group: "App", name: "Interface", icon: "interface" },
        { group: "App", name: "Privacy", icon: "privacy" },
        { group: "App", name: "Controls", icon: "controls" },
        { group: "Media", name: "Playback", icon: "play" },
        { group: "Media", name: "Video", icon: "videos" },
        { group: "Media", name: "Audio", icon: "audio" },
        { group: "Media", name: "Subtitles", icon: "subtitles" },
        { group: "Media", name: "Library", icon: "folder" },
        { group: "System", name: "Network", icon: "network" },
        { group: "System", name: "Performance", icon: "performance" },
        { group: "System", name: "Recording", icon: "record" },
        { group: "System", name: "Extensions", icon: "extensions" }
    ]

    readonly property var subtitleAutodetectOptions: [
        qsTr("No subtitles"),
        qsTr("Any subtitle file"),
        qsTr("Files containing video name"),
        qsTr("Video name with extra tags"),
        qsTr("Exact match only")
    ]

    property int activeCategoryIndex: 0
    readonly property var activeCategory: categories[activeCategoryIndex]

    function selectAccentColor(hex) {
        JuxTheme.accent = hex
    }

    signal closeRequested()

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // 1. Left Categories Sidebar
        Rectangle {
            Layout.preferredWidth: 220
            Layout.fillHeight: true
            color: "#141416"
            border.color: Qt.rgba(255, 255, 255, 0.05)
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                spacing: 4

                // Search box in categories
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48
                    Layout.margins: 12

                    TextField {
                        anchors.fill: parent
                        placeholderText: qsTr("Search settings...")
                        font.pixelSize: 12
                    }
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: root.categories

                    delegate: Rectangle {
                        width: ListView.view.width - 16
                        height: 38
                        x: 8
                        radius: JuxTheme.radiusControl
                        color: (root.activeCategoryIndex === index) ? "#26262a" : (catMouse.containsMouse ? "#1c1c1f" : "transparent")

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            spacing: 10

                            Image {
                                width: 16
                                height: 16
                                source: Qt.resolvedUrl("../../../resources/icons/" + modelData.icon + ".svg")
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                            }

                            Text {
                                text: modelData.name
                                color: (root.activeCategoryIndex === index) ? JuxTheme.textPrimary : JuxTheme.textSecondary
                                font.pixelSize: 13
                                font.bold: (root.activeCategoryIndex === index)
                                Layout.fillWidth: true
                            }
                        }

                        MouseArea {
                            id: catMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.activeCategoryIndex = index
                        }
                    }
                }
            }
        }

        // 2. Right Settings Content Panel
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // Header: Category Title & Close Button
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 56
                color: "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 24
                    anchors.rightMargin: 20

                    Text {
                        text: root.activeCategory.name + " " + qsTr("Settings")
                        color: JuxTheme.textPrimary
                        font.pixelSize: 18
                        font.bold: true
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        width: 32
                        height: 32
                        radius: JuxTheme.radiusControl
                        color: closeMouse.containsMouse ? "#333333" : "transparent"

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
                            onClicked: root.closeRequested()
                        }
                    }
                }
            }

            // Body ScrollView
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                ColumnLayout {
                    width: parent.width - 48
                    x: 24
                    spacing: 24

                    // SECTION: APPEARANCE (Shown in General)
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 14
                        visible: root.activeCategory.name === "General"

                        Text {
                            text: qsTr("Appearance")
                            color: JuxTheme.textPrimary
                            font.pixelSize: 15
                            font.bold: true
                        }

                        // Theme Selection (Dark / Light / System)
                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: qsTr("Theme")
                                color: JuxTheme.textSecondary
                                Layout.preferredWidth: 150
                            }
                            RowLayout {
                                spacing: 6
                                Button { text: "Dark"; highlighted: true }
                                Button { text: "Light" }
                                Button { text: "System" }
                            }
                        }

                        // Accent Color Palette (9 swatches from Figma)
                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: qsTr("Accent Color")
                                color: JuxTheme.textSecondary
                                Layout.preferredWidth: 150
                            }
                            RowLayout {
                                spacing: 8
                                Repeater {
                                    model: JuxTheme.accents

                                    Rectangle {
                                        width: 26
                                        height: 26
                                        radius: JuxTheme.radiusControl
                                        color: modelData
                                        border.color: (JuxTheme.accent === modelData) ? "#ffffff" : "transparent"
                                        border.width: 2

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: root.selectAccentColor(modelData)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // SECTION: SUBTITLES (Shown in Subtitles)
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 14
                        visible: root.activeCategory.name === "Subtitles"

                        Text {
                            text: qsTr("Autodetection & Matching")
                            color: JuxTheme.textPrimary
                            font.pixelSize: 15
                            font.bold: true
                        }

                        // Human-readable dropdown instead of confusing numbers 0-5
                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: qsTr("Subtitle Autodetection")
                                color: JuxTheme.textSecondary
                                Layout.preferredWidth: 180
                            }
                            ComboBox {
                                Layout.fillWidth: true
                                model: root.subtitleAutodetectOptions
                                currentIndex: 3
                            }
                        }
                    }

                    // Expandable "Advanced Options >" link at bottom of every category
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 36

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: qsTr("Advanced Options ❯")
                            color: advMouse.containsMouse ? JuxTheme.accent : JuxTheme.textSecondary
                            font.pixelSize: 13
                            font.bold: true

                            MouseArea {
                                id: advMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
                    }
                }
            }
        }
    }
}

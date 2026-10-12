import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../../modules/gui/qt/style"

Rectangle {
    id: settingsRoot
    color: "#0d0e13"

    property int activeCategoryIndex: 0
    readonly property var categories: [
        { name: "Interface", icon: "interface" },
        { name: "Playback", icon: "play" },
        { name: "Audio", icon: "audio" },
        { name: "Video", icon: "videos" },
        { name: "Subtitles", icon: "subtitles" },
        { name: "Controls", icon: "controls" },
        { name: "Library", icon: "folder" },
        { name: "Privacy", icon: "privacy" },
        { name: "Network", icon: "network" },
        { name: "Performance", icon: "performance" },
        { name: "Recording", icon: "record" },
        { name: "Extensions", icon: "extensions" }
    ]

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // ==================== LEFT: CATEGORIES SIDEBAR ====================
        Rectangle {
            Layout.preferredWidth: 220
            Layout.fillHeight: true
            color: "#12141c"
            border.color: Qt.rgba(255, 255, 255, 0.06)
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 4

                Text {
                    text: "Settings Categories"
                    color: "#8a8b96"
                    font.family: JuxTheme.fontFamily
                    font.pixelSize: 11
                    font.bold: true
                    Layout.margins: 8
                }

                Repeater {
                    model: settingsRoot.categories

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 34
                        radius: 6
                        color: settingsRoot.activeCategoryIndex === index
                               ? "#1f2230"
                               : (catMouse.containsMouse ? "#181a24" : "transparent")

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            spacing: 10

                            Image {
                                width: 15
                                height: 15
                                source: Qt.resolvedUrl("../../modules/gui/qt/resources/icons/" + modelData.icon + ".svg")
                                fillMode: Image.PreserveAspectFit
                            }

                            Text {
                                text: modelData.name
                                color: settingsRoot.activeCategoryIndex === index ? JuxTheme.accent : "#c0c0c8"
                                font.family: JuxTheme.fontFamily
                                font.pixelSize: 12
                                font.bold: (settingsRoot.activeCategoryIndex === index)
                            }
                        }

                        MouseArea {
                            id: catMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: settingsRoot.activeCategoryIndex = index
                        }
                    }
                }

                Item { Layout.fillHeight: true }
            }
        }

        // ==================== RIGHT: SETTINGS OPTIONS PANEL ====================
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 30
            clip: true

            ColumnLayout {
                width: parent.width
                spacing: 24

                Text {
                    text: settingsRoot.categories[settingsRoot.activeCategoryIndex].name + " Settings"
                    color: "#ffffff"
                    font.family: JuxTheme.fontFamily
                    font.pixelSize: 22
                    font.bold: true
                }

                // 1. Accent Color Switcher
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Text {
                        text: "Theme Accent Palette (Figma Customization)"
                        color: "#ffffff"
                        font.family: JuxTheme.fontFamily
                        font.pixelSize: 13
                        font.bold: true
                    }

                    RowLayout {
                        spacing: 12

                        Repeater {
                            model: [
                                { name: "VLC Orange", color: "#D37918" },
                                { name: "Cyan Render", color: "#00F0FF" },
                                { name: "Emerald Key", color: "#10B981" },
                                { name: "Neon Cobalt", color: "#0066FF" },
                                { name: "Razor Vermilion", color: "#FF3366" }
                            ]

                            Rectangle {
                                width: 36
                                height: 36
                                radius: 18
                                color: modelData.color
                                border.color: JuxTheme.accent === modelData.color ? "#ffffff" : "transparent"
                                border.width: 2

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: JuxTheme.accent = modelData.color
                                }
                            }
                        }
                    }
                }

                // 2. Hardware Acceleration
                RowLayout {
                    Layout.fillWidth: true
                    ColumnLayout {
                        spacing: 2
                        Text { text: "Direct3D11 Hardware Decoding"; color: "#ffffff"; font.pixelSize: 13; font.bold: true }
                        Text { text: "Uses GPU shader pipelines for ultra-low CPU footprint"; color: "#7a7b85"; font.pixelSize: 11 }
                    }
                    Item { Layout.fillWidth: true }
                    Switch { checked: true }
                }

                // 3. Immersive Autohide Controls
                RowLayout {
                    Layout.fillWidth: true
                    ColumnLayout {
                        spacing: 2
                        Text { text: "AutoHide Controls in Fullscreen"; color: "#ffffff"; font.pixelSize: 13; font.bold: true }
                        Text { text: "Hides control bars after 2 seconds of mouse inactivity"; color: "#7a7b85"; font.pixelSize: 11 }
                    }
                    Item { Layout.fillWidth: true }
                    Switch { checked: true }
                }

                // 4. Smart Subtitles Auto-Scan
                RowLayout {
                    Layout.fillWidth: true
                    ColumnLayout {
                        spacing: 2
                        Text { text: "Smart Subtitles Auto-Matcher"; color: "#ffffff"; font.pixelSize: 13; font.bold: true }
                        Text { text: "Automatically parses season/episode tokens and attaches SRT files"; color: "#7a7b85"; font.pixelSize: 11 }
                    }
                    Item { Layout.fillWidth: true }
                    Switch { checked: true }
                }

                // 5. Volume Maximum Limit
                RowLayout {
                    Layout.fillWidth: true
                    ColumnLayout {
                        spacing: 2
                        Text { text: "Enable VLC Volume Boost (Up to 125%)"; color: "#ffffff"; font.pixelSize: 13; font.bold: true }
                        Text { text: "Allows stepping beyond 100% system ceiling using software amplification"; color: "#7a7b85"; font.pixelSize: 11 }
                    }
                    Item { Layout.fillWidth: true }
                    Switch { checked: true }
                }
            }
        }
    }
}

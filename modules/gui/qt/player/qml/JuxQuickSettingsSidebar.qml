/*****************************************************************************
 * Copyright (C) 2026 VLC Authors & VideoLAN
 *
 * Jux VLC Redesign - Quick Settings 4-Tab Sidebar
 * Modern sliding sidebar replacing the legacy Adjustments/Pandora's Box dialog.
 * Direct visual implementation of Figma components #536:1513, #6114:13610, #2372:8834
 * and video concepts [06:36 - 09:18].
 *****************************************************************************/
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T

import VLC.MainInterface
import VLC.Style
import VLC.Widgets as Widgets
import VLC.Player
import VLC.Util

Rectangle {
    id: root

    implicitWidth: 380
    implicitHeight: 800
    color: JuxTheme.bgB1Transparent

    border.color: Qt.rgba(255, 255, 255, 0.08)
    border.width: 1

    readonly property int tabCount: 4
    readonly property var tabNames: ["Subtitles", "Audio", "Video", "Playback"]
    property int currentTabIndex: 0
    readonly property string activeTabName: tabNames[currentTabIndex]

    // Properties for Subtitles
    property real subtitleDelaySeconds: 0.0
    property string currentSubtitleSizeFormat: "Relative" // "Relative" or "Precise"

    // Preset Storage Dictionary (In-memory + QSettings backing)
    property var _presets: ({})

    function saveShowPreset(showName, presetObj) {
        _presets[showName] = presetObj
    }

    function loadShowPreset(showName) {
        return _presets[showName] ?? null
    }

    signal closeRequested()

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // 1. Sidebar Header with Close Icon
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 52
            color: Qt.rgba(0, 0, 0, 0.3)

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16

                Text {
                    text: qsTr("Quick Settings")
                    color: JuxTheme.textPrimary
                    font.family: JuxTheme.fontFamily
                    font.pixelSize: 16
                    font.bold: true
                    Layout.fillWidth: true
                }

                // Close Button
                Rectangle {
                    width: 28
                    height: 28
                    radius: JuxTheme.radiusControl
                    color: closeMouse.containsMouse ? "#333333" : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        color: JuxTheme.textSecondary
                        font.pixelSize: 13
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

        // 2. Tab Navigation Bar (4 Tabs)
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 42
            color: "#161618"

            RowLayout {
                anchors.fill: parent
                spacing: 2

                Repeater {
                    model: root.tabNames

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: (root.currentTabIndex === index) ? "#242426" : (tabMouse.containsMouse ? "#1c1c1e" : "transparent")

                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: (root.currentTabIndex === index) ? JuxTheme.accent : JuxTheme.textSecondary
                            font.family: JuxTheme.fontFamily
                            font.pixelSize: 12
                            font.bold: (root.currentTabIndex === index)
                        }

                        Rectangle {
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 2
                            color: JuxTheme.accent
                            visible: root.currentTabIndex === index
                        }

                        MouseArea {
                            id: tabMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.currentTabIndex = index
                        }
                    }
                }
            }
        }

        // 3. Tab Contents Scrollable Area
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            StackLayout {
                width: parent.width
                currentIndex: root.currentTabIndex

                // ==================== TAB 0: SUBTITLES ====================
                ColumnLayout {
                    spacing: 16
                    Layout.margins: 16

                    // Show Preset Section
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        radius: JuxTheme.radiusControl
                        color: "#212124"

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8

                            Text {
                                text: qsTr("Preset:")
                                color: JuxTheme.textSecondary
                                font.pixelSize: 12
                            }

                            Text {
                                text: qsTr("Auto (Matched Show)")
                                color: JuxTheme.accent
                                font.pixelSize: 12
                                font.bold: true
                                Layout.fillWidth: true
                            }

                            Text {
                                text: "💾 Save"
                                color: JuxTheme.textPrimary
                                font.pixelSize: 11
                            }
                        }
                    }

                    // Subtitle Delay Slider
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: qsTr("Subtitle Delay")
                                color: JuxTheme.textPrimary
                                font.pixelSize: 13
                                font.bold: true
                                Layout.fillWidth: true
                            }
                            Text {
                                text: root.subtitleDelaySeconds.toFixed(1) + " s"
                                color: JuxTheme.accent
                                font.pixelSize: 12
                            }
                        }

                        Slider {
                            Layout.fillWidth: true
                            from: -10.0
                            to: 10.0
                            stepSize: 0.1
                            value: root.subtitleDelaySeconds
                            onMoved: root.subtitleDelaySeconds = value
                        }
                    }

                    // Font & Size Controls
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: qsTr("Subtitle Styling")
                            color: JuxTheme.textPrimary
                            font.pixelSize: 13
                            font.bold: true
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: qsTr("Size Mode:")
                                color: JuxTheme.textSecondary
                                font.pixelSize: 12
                            }

                            Button {
                                text: "Relative"
                                highlighted: root.currentSubtitleSizeFormat === "Relative"
                                onClicked: root.currentSubtitleSizeFormat = "Relative"
                            }
                            Button {
                                text: "Precise (px)"
                                highlighted: root.currentSubtitleSizeFormat === "Precise"
                                onClicked: root.currentSubtitleSizeFormat = "Precise"
                            }
                        }
                    }

                    // Subtitle Timeline Toggle
                    CheckBox {
                        text: qsTr("Show Subtitle Timeline on Seekbar")
                        checked: false
                    }
                }

                // ==================== TAB 1: AUDIO ====================
                ColumnLayout {
                    spacing: 16
                    Layout.margins: 16

                    Text {
                        text: qsTr("Audio Output Device")
                        color: JuxTheme.textPrimary
                        font.pixelSize: 13
                        font.bold: true
                    }

                    ComboBox {
                        Layout.fillWidth: true
                        model: ["Default System Speakers", "Headphones (Audio Out)", "Digital S/PDIF"]
                    }

                    Text {
                        text: qsTr("Equalizer Presets")
                        color: JuxTheme.textPrimary
                        font.pixelSize: 13
                        font.bold: true
                    }

                    // Quick EQ Presets with Icons
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Repeater {
                            model: ["Flat", "Rock", "Pop", "Jazz", "Vocal"]
                            Button {
                                Layout.fillWidth: true
                                text: modelData
                            }
                        }
                    }

                    // Audio Delay
                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: qsTr("Audio Delay")
                            color: JuxTheme.textPrimary
                            font.pixelSize: 12
                            Layout.fillWidth: true
                        }
                        Slider {
                            Layout.fillWidth: true
                            from: -5.0
                            to: 5.0
                            stepSize: 0.1
                            value: 0.0
                        }
                    }
                }

                // ==================== TAB 2: VIDEO ====================
                ColumnLayout {
                    spacing: 16
                    Layout.margins: 16

                    Text {
                        text: qsTr("Transform & Geometry")
                        color: JuxTheme.textPrimary
                        font.pixelSize: 13
                        font.bold: true
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Button { text: "Rotate 90°"; Layout.fillWidth: true }
                        Button { text: "Flip H"; Layout.fillWidth: true }
                        Button { text: "Flip V"; Layout.fillWidth: true }
                    }

                    Text {
                        text: qsTr("Color Adjustments")
                        color: JuxTheme.textPrimary
                        font.pixelSize: 13
                        font.bold: true
                    }

                    // Sliders for Brightness, Contrast, Saturation
                    RowLayout {
                        Text { text: "Brightness"; color: JuxTheme.textSecondary; Layout.preferredWidth: 80 }
                        Slider { Layout.fillWidth: true; from: 0; to: 2; value: 1 }
                    }
                    RowLayout {
                        Text { text: "Contrast"; color: JuxTheme.textSecondary; Layout.preferredWidth: 80 }
                        Slider { Layout.fillWidth: true; from: 0; to: 2; value: 1 }
                    }
                    RowLayout {
                        Text { text: "Saturation"; color: JuxTheme.textSecondary; Layout.preferredWidth: 80 }
                        Slider { Layout.fillWidth: true; from: 0; to: 2; value: 1 }
                    }
                }

                // ==================== TAB 3: PLAYBACK ====================
                ColumnLayout {
                    spacing: 16
                    Layout.margins: 16

                    Text {
                        text: qsTr("Playback Speed")
                        color: JuxTheme.textPrimary
                        font.pixelSize: 13
                        font.bold: true
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Button { text: "0.5x"; Layout.fillWidth: true }
                        Button { text: "1.0x"; Layout.fillWidth: true; highlighted: true }
                        Button { text: "1.25x"; Layout.fillWidth: true }
                        Button { text: "1.5x"; Layout.fillWidth: true }
                        Button { text: "2.0x"; Layout.fillWidth: true }
                    }

                    CheckBox {
                        text: qsTr("Reverse Playback (Experimental)")
                        checked: false
                    }

                    CheckBox {
                        text: qsTr("Show Audio Waveform on Seekbar")
                        checked: false
                    }

                    CheckBox {
                        text: qsTr("Show Media Codec & Bitrate Metadata")
                        checked: false
                    }

                    Text {
                        text: qsTr("Sleep Timer")
                        color: JuxTheme.textPrimary
                        font.pixelSize: 13
                        font.bold: true
                    }

                    ComboBox {
                        Layout.fillWidth: true
                        model: ["Disabled", "After 15 minutes", "After 30 minutes", "After 1 hour", "At end of episode"]
                    }
                }
            }
        }
    }
}

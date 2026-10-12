import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../../modules/gui/qt/style"

Rectangle {
    id: sidebarRoot
    color: "#121318"
    border.color: Qt.rgba(255, 255, 255, 0.08)
    border.width: 1

    property int currentTabIndex: 0
    readonly property var tabs: ["Subtitles", "Audio", "Video", "Playback"]

    property real subDelaySec: 0.0
    property real audioDelaySec: 0.0
    property real brightnessVal: 1.0
    property real contrastVal: 1.0
    property real saturationVal: 1.0
    property real playbackRate: 1.0
    property var scannedSubs: []

    Connections {
        target: VlcEngine
        function onSubtitlesScanned(subs) {
            sidebarRoot.scannedSubs = subs
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // ==================== 1. SIDEBAR HEADER ====================
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 46
            color: "#181920"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 12

                Text {
                    text: "Quick Settings"
                    color: "#ffffff"
                    font.family: JuxTheme.fontFamily
                    font.pixelSize: 15
                    font.bold: true
                    Layout.fillWidth: true
                }

                // Close Button
                Rectangle {
                    width: 26
                    height: 26
                    radius: 13
                    color: closeMouse.containsMouse ? "#282a35" : "transparent"

                    Image {
                        anchors.centerIn: parent
                        width: 12
                        height: 12
                        source: Qt.resolvedUrl("../../modules/gui/qt/resources/icons/close.svg")
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }

                    MouseArea {
                        id: closeMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (typeof MainWindow !== "undefined" && MainWindow)
                                MainWindow.toggleQuickSidebar()
                        }
                    }
                }
            }
        }

        // ==================== 2. TABS BAR ====================
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 38
            color: "#14151b"
            border.color: Qt.rgba(255, 255, 255, 0.06)
            border.width: 1

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Repeater {
                    model: sidebarRoot.tabs

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: sidebarRoot.currentTabIndex === index ? "#1e2029" : (tabM.containsMouse ? "#181a22" : "transparent")

                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: sidebarRoot.currentTabIndex === index ? JuxTheme.accent : "#8b8c94"
                            font.family: JuxTheme.fontFamily
                            font.pixelSize: 11
                            font.bold: (sidebarRoot.currentTabIndex === index)
                        }

                        Rectangle {
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 2
                            color: JuxTheme.accent
                            visible: sidebarRoot.currentTabIndex === index
                        }

                        MouseArea {
                            id: tabM
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: sidebarRoot.currentTabIndex = index
                        }
                    }
                }
            }
        }

        // ==================== 3. TAB CONTENT ====================
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            StackLayout {
                width: parent.width
                currentIndex: sidebarRoot.currentTabIndex

                // ---------- TAB 0: SUBTITLES ----------
                ColumnLayout {
                    spacing: 16
                    Layout.margins: 16

                    // Auto-matched Subtitle Banner
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 38
                        radius: 6
                        color: "#1b1d26"
                        border.color: JuxTheme.accent
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 8

                            Image {
                                width: 14
                                height: 14
                                source: Qt.resolvedUrl("../../modules/gui/qt/resources/icons/subtitles.svg")
                                fillMode: Image.PreserveAspectFit
                            }

                            Text {
                                text: "Smart Auto-Matcher: Active"
                                color: JuxTheme.accent
                                font.family: JuxTheme.fontFamily
                                font.pixelSize: 11
                                font.bold: true
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // Subtitle Delay
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: "Subtitle Sync Delay"
                                color: "#ffffff"
                                font.family: JuxTheme.fontFamily
                                font.pixelSize: 12
                                font.bold: true
                                Layout.fillWidth: true
                            }
                            Text {
                                text: (sidebarRoot.subDelaySec >= 0 ? "+" : "") + sidebarRoot.subDelaySec.toFixed(1) + " s"
                                color: JuxTheme.accent
                                font.family: JuxTheme.fontFamily
                                font.pixelSize: 12
                            }
                        }

                        Slider {
                            Layout.fillWidth: true
                            from: -10.0
                            to: 10.0
                            stepSize: 0.1
                            value: sidebarRoot.subDelaySec
                            onMoved: {
                                sidebarRoot.subDelaySec = value
                                if (typeof VlcEngine !== "undefined" && VlcEngine)
                                    VlcEngine.setSubtitleDelayMs(Math.round(value * 1000))
                            }
                        }
                    }

                    // Available Matched Subtitles List
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: "Available Local Subtitles (" + sidebarRoot.scannedSubs.length + ")"
                            color: "#ffffff"
                            font.family: JuxTheme.fontFamily
                            font.pixelSize: 12
                            font.bold: true
                        }

                        Repeater {
                            model: sidebarRoot.scannedSubs

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 40
                                radius: 6
                                color: modelData.isMatched ? "#212430" : "#161720"
                                border.color: modelData.isMatched ? JuxTheme.accent : Qt.rgba(255, 255, 255, 0.08)
                                border.width: 1

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    spacing: 8

                                    Text {
                                        text: modelData.name
                                        color: "#ffffff"
                                        font.family: JuxTheme.fontFamily
                                        font.pixelSize: 11
                                        elide: Text.ElideMiddle
                                        Layout.fillWidth: true
                                    }

                                    // Apply Button
                                    Rectangle {
                                        width: 52
                                        height: 24
                                        radius: 4
                                        color: JuxTheme.accent

                                        Text {
                                            anchors.centerIn: parent
                                            text: "Apply"
                                            color: "#ffffff"
                                            font.pixelSize: 10
                                            font.bold: true
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                if (typeof VlcEngine !== "undefined" && VlcEngine)
                                                    VlcEngine.applySubtitleFile(modelData.path)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // ---------- TAB 1: AUDIO ----------
                ColumnLayout {
                    spacing: 16
                    Layout.margins: 16

                    // Audio Delay
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: "Audio Track Delay"
                                color: "#ffffff"
                                font.family: JuxTheme.fontFamily
                                font.pixelSize: 12
                                font.bold: true
                                Layout.fillWidth: true
                            }
                            Text {
                                text: (sidebarRoot.audioDelaySec >= 0 ? "+" : "") + sidebarRoot.audioDelaySec.toFixed(1) + " s"
                                color: JuxTheme.accent
                                font.family: JuxTheme.fontFamily
                                font.pixelSize: 12
                            }
                        }

                        Slider {
                            Layout.fillWidth: true
                            from: -5.0
                            to: 5.0
                            stepSize: 0.1
                            value: sidebarRoot.audioDelaySec
                            onMoved: {
                                sidebarRoot.audioDelaySec = value
                                if (typeof VlcEngine !== "undefined" && VlcEngine)
                                    VlcEngine.setAudioDelayMs(Math.round(value * 1000))
                            }
                        }
                    }

                    // Equalizer Presets
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: "10-Band Equalizer Presets"
                            color: "#ffffff"
                            font.family: JuxTheme.fontFamily
                            font.pixelSize: 12
                            font.bold: true
                        }

                        GridLayout {
                            columns: 2
                            Layout.fillWidth: true
                            rowSpacing: 6
                            columnSpacing: 6

                            Repeater {
                                model: ["Flat", "Rock", "Pop", "Jazz", "Live", "Vocal", "Techno", "Classical"]

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 32
                                    radius: 6
                                    color: eqM.containsMouse ? "#282a35" : "#1c1e27"
                                    border.color: Qt.rgba(255, 255, 255, 0.08)
                                    border.width: 1

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData
                                        color: "#ffffff"
                                        font.family: JuxTheme.fontFamily
                                        font.pixelSize: 11
                                    }

                                    MouseArea {
                                        id: eqM
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            if (typeof VlcEngine !== "undefined" && VlcEngine)
                                                VlcEngine.setEqualizerPreset(modelData)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // ---------- TAB 2: VIDEO ----------
                ColumnLayout {
                    spacing: 16
                    Layout.margins: 16

                    Text {
                        text: "Hardware Video Adjustments"
                        color: "#ffffff"
                        font.family: JuxTheme.fontFamily
                        font.pixelSize: 12
                        font.bold: true
                    }

                    // Brightness
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "Brightness"; color: "#a0a0a5"; font.pixelSize: 11; Layout.fillWidth: true }
                            Text { text: sidebarRoot.brightnessVal.toFixed(2); color: JuxTheme.accent; font.pixelSize: 11 }
                        }
                        Slider {
                            Layout.fillWidth: true
                            from: 0.0; to: 2.0; stepSize: 0.05
                            value: sidebarRoot.brightnessVal
                            onMoved: {
                                sidebarRoot.brightnessVal = value
                                if (typeof VlcEngine !== "undefined" && VlcEngine)
                                    VlcEngine.setVideoAdjust(sidebarRoot.brightnessVal, sidebarRoot.contrastVal, sidebarRoot.saturationVal)
                            }
                        }
                    }

                    // Contrast
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "Contrast"; color: "#a0a0a5"; font.pixelSize: 11; Layout.fillWidth: true }
                            Text { text: sidebarRoot.contrastVal.toFixed(2); color: JuxTheme.accent; font.pixelSize: 11 }
                        }
                        Slider {
                            Layout.fillWidth: true
                            from: 0.0; to: 2.0; stepSize: 0.05
                            value: sidebarRoot.contrastVal
                            onMoved: {
                                sidebarRoot.contrastVal = value
                                if (typeof VlcEngine !== "undefined" && VlcEngine)
                                    VlcEngine.setVideoAdjust(sidebarRoot.brightnessVal, sidebarRoot.contrastVal, sidebarRoot.saturationVal)
                            }
                        }
                    }

                    // Saturation
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "Saturation"; color: "#a0a0a5"; font.pixelSize: 11; Layout.fillWidth: true }
                            Text { text: sidebarRoot.saturationVal.toFixed(2); color: JuxTheme.accent; font.pixelSize: 11 }
                        }
                        Slider {
                            Layout.fillWidth: true
                            from: 0.0; to: 2.0; stepSize: 0.05
                            value: sidebarRoot.saturationVal
                            onMoved: {
                                sidebarRoot.saturationVal = value
                                if (typeof VlcEngine !== "undefined" && VlcEngine)
                                    VlcEngine.setVideoAdjust(sidebarRoot.brightnessVal, sidebarRoot.contrastVal, sidebarRoot.saturationVal)
                            }
                        }
                    }
                }

                // ---------- TAB 3: PLAYBACK ----------
                ColumnLayout {
                    spacing: 16
                    Layout.margins: 16

                    Text {
                        text: "Playback Speed Rate"
                        color: "#ffffff"
                        font.family: JuxTheme.fontFamily
                        font.pixelSize: 12
                        font.bold: true
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 6

                        Repeater {
                            model: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0]

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 32
                                radius: 6
                                color: sidebarRoot.playbackRate === modelData ? JuxTheme.accent : (rateM.containsMouse ? "#282a35" : "#1c1e27")

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData + "x"
                                    color: "#ffffff"
                                    font.family: JuxTheme.fontFamily
                                    font.pixelSize: 11
                                    font.bold: (sidebarRoot.playbackRate === modelData)
                                }

                                MouseArea {
                                    id: rateM
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        sidebarRoot.playbackRate = modelData
                                        if (typeof VlcEngine !== "undefined" && VlcEngine)
                                            VlcEngine.setRate(modelData)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

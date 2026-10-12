/*****************************************************************************
 * Copyright (C) 2026 VLC Authors & VideoLAN
 *
 * Jux VLC Redesign - Single-Row Player Control Bar
 * Implements the unified thin control bar matching Figma "Controls" #491:1780
 * and Jux video concepts [01:48 - 03:25].
 *****************************************************************************/
import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T

import VLC.MainInterface
import VLC.Style
import VLC.Widgets as Widgets
import VLC.Player
import VLC.Util

T.Pane {
    id: root

    implicitWidth: 1000
    implicitHeight: JuxTheme.controlBarHeight
    height: JuxTheme.controlBarHeight

    background: Rectangle {
        color: JuxTheme.bgB1Transparent
        border.color: Qt.rgba(255, 255, 255, 0.08)
        border.width: 1
        radius: 0
    }

    readonly property bool hasThickSeekBar: true

    // Exposed child references for testing & bindings
    property alias prevButton: btnPrev
    property alias playButton: btnPlay
    property alias nextButton: btnNext
    property alias volumeWidget: volumeConeWidget
    property alias audioTracksButton: btnAudio
    property alias subtitlesButton: btnSubtitles
    property alias settingsButton: btnQuickSettings
    property alias queueButton: btnQueue

    signal toggleQuickSettingsRequested()
    signal toggleQueueRequested()
    signal audioMenuRequested(var mousePos)
    signal subtitleMenuRequested(var mousePos)

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 10

        // 1. Previous Track Button
        Rectangle {
            id: btnPrev
            Layout.preferredWidth: JuxTheme.navButtonSize
            Layout.preferredHeight: JuxTheme.navButtonSize
            radius: JuxTheme.radiusControl
            color: prevMouse.containsPress ? "#333333" : (prevMouse.containsMouse ? "#262626" : "transparent")

            Text {
                anchors.centerIn: parent
                text: "⏮"
                color: JuxTheme.textPrimary
                font.pixelSize: 14
            }

            MouseArea {
                id: prevMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (typeof Player !== "undefined" && Player)
                        Player.prev()
                }
            }
        }

        // 2. Play / Pause Button (Hero Accent)
        Rectangle {
            id: btnPlay
            Layout.preferredWidth: JuxTheme.playButtonSize
            Layout.preferredHeight: JuxTheme.playButtonSize
            radius: JuxTheme.radiusControl
            color: playMouse.containsPress ? Qt.darker(JuxTheme.accent, 1.2)
                                           : (playMouse.containsMouse ? Qt.lighter(JuxTheme.accent, 1.1) : JuxTheme.accent)

            readonly property bool isPlaying: (typeof Player !== "undefined" && Player && Player.playingState === Player.PLAYING_STATE_PLAYING)

            Text {
                anchors.centerIn: parent
                text: btnPlay.isPlaying ? "⏸" : "▶"
                color: "#ffffff"
                font.pixelSize: 16
                font.bold: true
            }

            MouseArea {
                id: playMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (typeof Player !== "undefined" && Player)
                        Player.togglePlayPause()
                }
            }
        }

        // 3. Next Track Button
        Rectangle {
            id: btnNext
            Layout.preferredWidth: JuxTheme.navButtonSize
            Layout.preferredHeight: JuxTheme.navButtonSize
            radius: JuxTheme.radiusControl
            color: nextMouse.containsPress ? "#333333" : (nextMouse.containsMouse ? "#262626" : "transparent")

            Text {
                anchors.centerIn: parent
                text: "⏭"
                color: JuxTheme.textPrimary
                font.pixelSize: 14
            }

            MouseArea {
                id: nextMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (typeof Player !== "undefined" && Player)
                        Player.next()
                }
            }
        }

        // 4. Elapsed Time Label
        Text {
            id: txtTime
            text: {
                if (typeof Player !== "undefined" && Player && Player.time)
                    return Player.time.formatHMS()
                return "00:00:00"
            }
            color: JuxTheme.textPrimary
            font.family: JuxTheme.fontFamily
            font.pixelSize: 12
            Layout.alignment: Qt.AlignVCenter
        }

        // 5. Thick Seekbar with Chapter Marks and Hover Preview
        Item {
            id: seekContainer
            Layout.fillWidth: true
            Layout.preferredHeight: JuxTheme.seekBarHoverHeight
            Layout.alignment: Qt.AlignVCenter

            readonly property real progress: {
                if (typeof Player !== "undefined" && Player && Player.length && Player.length.toMilliseconds() > 0)
                    return Math.max(0.0, Math.min(1.0, Player.time.toMilliseconds() / Player.length.toMilliseconds()))
                return 0.0
            }

            // Background Track
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                height: seekMouse.containsMouse ? JuxTheme.seekBarHoverHeight : JuxTheme.seekBarThickHeight
                radius: height / 2
                color: "#2a2a2b"

                Behavior on height {
                    NumberAnimation { duration: 100 }
                }

                // Progress Fill
                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width * seekContainer.progress
                    radius: parent.radius
                    color: JuxTheme.accent
                }
            }

            MouseArea {
                id: seekMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: (mouse) => {
                    const ratio = Math.max(0.0, Math.min(1.0, mouse.x / width))
                    if (typeof Player !== "undefined" && Player && Player.length) {
                        const targetMs = ratio * Player.length.toMilliseconds()
                        Player.setTime(VLCTick.fromMilliseconds(targetMs))
                    }
                }
            }
        }

        // 6. Total / Remaining Duration Label
        Text {
            id: txtDuration
            property bool showRemaining: false
            text: {
                if (typeof Player !== "undefined" && Player && Player.length) {
                    if (showRemaining && Player.remainingTime)
                        return "-" + Player.remainingTime.formatHMS()
                    return Player.length.formatHMS()
                }
                return "00:00:00"
            }
            color: JuxTheme.textSecondary
            font.family: JuxTheme.fontFamily
            font.pixelSize: 12
            Layout.alignment: Qt.AlignVCenter

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: txtDuration.showRemaining = !txtDuration.showRemaining
            }
        }

        // 7. Full Traffic Cone Volume Slider
        Widgets.JuxVolumeCone {
            id: volumeConeWidget
            Layout.alignment: Qt.AlignVCenter
        }

        // 8. Audio Tracks Button
        Rectangle {
            id: btnAudio
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            radius: JuxTheme.radiusControl
            color: audioMouse.containsMouse ? "#262626" : "transparent"

            Text {
                anchors.centerIn: parent
                text: "🔊"
                color: JuxTheme.textPrimary
                font.pixelSize: 14
            }

            MouseArea {
                id: audioMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: (mouse) => root.audioMenuRequested(mapToItem(root, mouse.x, mouse.y))
            }
        }

        // 9. Subtitle Tracks Button
        Rectangle {
            id: btnSubtitles
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            radius: JuxTheme.radiusControl
            color: subMouse.containsMouse ? "#262626" : "transparent"

            Text {
                anchors.centerIn: parent
                text: "💬"
                color: JuxTheme.textPrimary
                font.pixelSize: 14
            }

            MouseArea {
                id: subMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: (mouse) => root.subtitleMenuRequested(mapToItem(root, mouse.x, mouse.y))
            }
        }

        // 10. Quick Settings Sidebar Toggle
        Rectangle {
            id: btnQuickSettings
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            radius: JuxTheme.radiusControl
            color: settingsMouse.containsMouse ? "#262626" : "transparent"

            Text {
                anchors.centerIn: parent
                text: "⚙"
                color: JuxTheme.textPrimary
                font.pixelSize: 15
            }

            MouseArea {
                id: settingsMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.toggleQuickSettingsRequested()
            }
        }

        // 11. Queue Toggle Button
        Rectangle {
            id: btnQueue
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            radius: JuxTheme.radiusControl
            color: queueMouse.containsMouse ? "#262626" : "transparent"

            Text {
                anchors.centerIn: parent
                text: "☰"
                color: JuxTheme.textPrimary
                font.pixelSize: 15
            }

            MouseArea {
                id: queueMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.toggleQueueRequested()
            }
        }
    }
}

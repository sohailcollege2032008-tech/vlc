/*****************************************************************************
 * Copyright (C) 2026 VLC Authors & VideoLAN
 *
 * Jux VLC Redesign - Music Player View & Waveform Seekbar
 * Matches Figma frames p05 (#4767:23726) and p06 (#4778:25123)
 *****************************************************************************/
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../../style"
import "../../widgets/qml"

Item {
    id: root

    property string trackTitle: "untangle"
    property string artistName: "juxtopposed"
    property int duration: 100
    property int currentPosition: 10
    property bool isPlaying: true
    property bool isPlaylistOpen: false

    property alias albumArtItem: albumArtBox
    property alias waveformItem: waveformSeekbar

    signal togglePlayPauseRequested()
    signal seekRequested(real ratio)

    Rectangle {
        anchors.fill: parent
        color: JuxTheme.bgB1
    }

    // Blurred / Atmospheric Background Disc
    Rectangle {
        anchors.centerIn: parent
        width: 520
        height: 520
        radius: 260
        color: Qt.rgba(232/255, 133/255, 12/255, 0.04)
        border.color: Qt.rgba(255, 255, 255, 0.05)
        border.width: 1
    }

    // Top Bar
    RowLayout {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: JuxTheme.topBarHeight
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        spacing: 12
        z: 10

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

        Text {
            text: "📁 My Songs"
            color: JuxTheme.textSecondary
            font.family: JuxTheme.fontFamily
            font.pixelSize: 13
        }

        Item { Layout.fillWidth: true }

        Text {
            text: root.trackTitle
            color: JuxTheme.textPrimary
            font.family: JuxTheme.fontFamily
            font.pixelSize: 13
            font.bold: true
        }

        Item { Layout.fillWidth: true }

        Text { text: "─"; color: JuxTheme.textSecondary; font.pixelSize: 14 }
        Text { text: "▢"; color: JuxTheme.textSecondary; font.pixelSize: 13 }
        Text { text: "✕"; color: JuxTheme.textSecondary; font.pixelSize: 13 }
    }

    // Center Content: Album Cover & Track Info
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 24

        Rectangle {
            id: albumArtBox
            Layout.alignment: Qt.AlignHCenter
            width: 340
            height: 340
            radius: 24
            color: "#0a0a0a"
            border.color: Qt.rgba(255, 255, 255, 0.08)
            border.width: 1
            clip: true

            // Elegant guitar / soundhole graphic
            Rectangle {
                anchors.centerIn: parent
                width: 160
                height: 160
                radius: 80
                color: "#111111"
                border.color: Qt.rgba(232/255, 133/255, 12/255, 0.4)
                border.width: 2

                Rectangle {
                    anchors.centerIn: parent
                    width: 130
                    height: 130
                    radius: 65
                    color: "#0a0a0a"
                    border.color: Qt.rgba(255, 255, 255, 0.1)
                }
            }

            // Guitar strings overlay
            Column {
                anchors.centerIn: parent
                spacing: 8
                Repeater {
                    model: 6
                    Rectangle {
                        width: 340
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.12)
                    }
                }
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: root.trackTitle + " - " + root.artistName
            color: JuxTheme.textPrimary
            font.family: JuxTheme.fontFamily
            font.pixelSize: 15
        }
    }

    // Left Sliding Playlist Drawer
    Rectangle {
        id: playlistDrawer
        anchors.top: parent.top
        anchors.bottom: controlBar.top
        anchors.left: parent.left
        width: root.isPlaylistOpen ? 280 : 0
        visible: width > 0
        color: "#141414"
        border.color: Qt.rgba(255, 255, 255, 0.06)
        z: 20

        Behavior on width {
            NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "Songs > My Songs"
                    color: JuxTheme.textPrimary
                    font.family: JuxTheme.fontFamily
                    font.pixelSize: 13
                    font.bold: true
                }
                Item { Layout.fillWidth: true }
                Text { text: "+ Add"; color: JuxTheme.accent; font.pixelSize: 12 }
            }

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: [
                    "untangle - juxtopposed",
                    "moonlight - juxtopposed",
                    "black bird - juxtopposed"
                ]
                delegate: Rectangle {
                    width: parent.width
                    height: 38
                    color: index === 0 ? Qt.rgba(232/255, 133/255, 12/255, 0.15) : "transparent"
                    radius: JuxTheme.radiusControl

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 8
                        Text { text: "🎵"; color: index === 0 ? JuxTheme.accent : JuxTheme.textSecondary; font.pixelSize: 12 }
                        Text { text: modelData; color: index === 0 ? JuxTheme.accent : JuxTheme.textPrimary; font.pixelSize: 12 }
                    }
                }
            }
        }
    }

    // Bottom Control Bar with Waveform Seekbar
    Rectangle {
        id: controlBar
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: JuxTheme.controlBarHeight
        color: JuxTheme.bgB1Transparent
        z: 30

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 12

            // Left transport controls
            RowLayout {
                spacing: 8

                Text { text: "⏮"; color: JuxTheme.textSecondary; font.pixelSize: 14 }
                Text { text: "⟲15"; color: JuxTheme.textSecondary; font.pixelSize: 12 }

                Rectangle {
                    width: 38
                    height: 38
                    radius: JuxTheme.radiusHeroPlay
                    color: JuxTheme.accent

                    Text {
                        anchors.centerIn: parent
                        text: root.isPlaying ? "❚❚" : "▶"
                        color: "#ffffff"
                        font.pixelSize: 14
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.isPlaying = !root.isPlaying
                            root.togglePlayPauseRequested()
                        }
                    }
                }

                Text { text: "⟳15"; color: JuxTheme.textSecondary; font.pixelSize: 12 }
                Text { text: "⏭"; color: JuxTheme.textSecondary; font.pixelSize: 14 }
            }

            Text {
                text: "00:00:10"
                color: JuxTheme.textSecondary
                font.family: JuxTheme.fontFamily
                font.pixelSize: 12
            }

            // Audio Waveform Seekbar
            Item {
                id: waveformSeekbar
                Layout.fillWidth: true
                height: 36
                property int barCount: 64

                Row {
                    anchors.centerIn: parent
                    spacing: 3

                    Repeater {
                        model: waveformSeekbar.barCount

                        Rectangle {
                            width: 3
                            // Pseudo audio waveform heights
                            height: Math.max(6, Math.min(28, (Math.sin(index * 0.4) * 12 + Math.cos(index * 0.7) * 8 + 14)))
                            radius: 1
                            color: (index / waveformSeekbar.barCount <= root.currentPosition / root.duration)
                                   ? JuxTheme.accent
                                   : "#2c2c2c"
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: (mouse) => {
                        var ratio = mouse.x / width
                        root.currentPosition = ratio * root.duration
                        root.seekRequested(ratio)
                    }
                }
            }

            Text {
                text: "00:01:40"
                color: JuxTheme.textSecondary
                font.family: JuxTheme.fontFamily
                font.pixelSize: 12
            }

            // Volume Cone
            JuxVolumeCone {
                Layout.alignment: Qt.AlignVCenter
            }

            // Secondary triggers
            Text { text: "💬"; color: JuxTheme.textSecondary; font.pixelSize: 14 }
            Text { text: "⚙"; color: JuxTheme.textSecondary; font.pixelSize: 14 }

            Rectangle {
                width: 28
                height: 28
                radius: JuxTheme.radiusControl
                color: queueMouse.containsMouse ? "#242424" : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: "☰"
                    color: root.isPlaylistOpen ? JuxTheme.accent : JuxTheme.textSecondary
                    font.pixelSize: 14
                }

                MouseArea {
                    id: queueMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.isPlaylistOpen = !root.isPlaylistOpen
                }
            }
        }
    }
}

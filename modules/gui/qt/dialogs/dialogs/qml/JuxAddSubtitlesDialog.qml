/*****************************************************************************
 * Copyright (C) 2026 VLC Authors & VideoLAN
 *
 * Jux VLC Redesign - Add Subtitles to File/Folder/Playlist Dialog
 * Direct implementation of Figma frames #1911:7545, #3336:11929, #1919:8707
 * and video concepts [06:00 - 06:25].
 *****************************************************************************/
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T

import VLC.MainInterface
import VLC.Style
import VLC.Widgets as Widgets
import VLC.Player

T.Dialog {
    id: root

    implicitWidth: 640
    implicitHeight: 520
    modal: true
    focus: true

    readonly property var targetOptions: ["This File", "This Folder", "This Playlist"]
    readonly property var sourceProviders: ["Local Files", "OpenSubtitles"]

    property int selectedTargetIndex: 1 // Default: This Folder
    property int selectedSourceIndex: 0 // Default: Local Files

    // Auto-matching algorithm for episode pairs
    function autoMatchEpisodes(videos, subs) {
        const results = []
        for (let i = 0; i < videos.length; i++) {
            const v = videos[i]
            // Extract numbers from video filename
            const vMatch = v.match(/(?:s\d+e|ep?|episode\s*)(\d+)/i) || v.match(/(\d+)/)
            const vNum = vMatch ? parseInt(vMatch[1], 10) : (i + 1)

            let matchedSub = ""
            for (let j = 0; j < subs.length; j++) {
                const s = subs[j]
                const sMatch = s.match(/(?:s\d+e|ep?|episode\s*)(\d+)/i) || s.match(/(\d+)/)
                const sNum = sMatch ? parseInt(sMatch[1], 10) : (j + 1)
                if (vNum === sNum) {
                    matchedSub = s
                    break
                }
            }
            results.push({ video: v, sub: matchedSub })
        }
        return results
    }

    background: Rectangle {
        color: JuxTheme.bgB1Transparent
        radius: JuxTheme.radiusDialog
        border.color: Qt.rgba(255, 255, 255, 0.12)
        border.width: 1
    }

    contentItem: ColumnLayout {
        spacing: 16
        anchors.margins: 20

        // Dialog Title
        Text {
            text: qsTr("Add Subtitles")
            color: JuxTheme.textPrimary
            font.family: JuxTheme.fontFamily
            font.pixelSize: 18
            font.bold: true
        }

        // Section 1: Scope Target
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: qsTr("1. Apply Subtitles To:")
                color: JuxTheme.textSecondary
                font.pixelSize: 13
                font.bold: true
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Repeater {
                    model: root.targetOptions

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 38
                        radius: JuxTheme.radiusControl
                        color: (root.selectedTargetIndex === index) ? Qt.rgba(232/255, 133/255, 12/255, 0.2) : "#212124"
                        border.color: (root.selectedTargetIndex === index) ? JuxTheme.accent : Qt.rgba(255, 255, 255, 0.08)
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: (root.selectedTargetIndex === index) ? JuxTheme.accent : JuxTheme.textPrimary
                            font.pixelSize: 12
                            font.bold: (root.selectedTargetIndex === index)
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.selectedTargetIndex = index
                        }
                    }
                }
            }
        }

        // Section 2: Source Provider
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: qsTr("2. Subtitle Source:")
                color: JuxTheme.textSecondary
                font.pixelSize: 13
                font.bold: true
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Repeater {
                    model: root.sourceProviders

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 38
                        radius: JuxTheme.radiusControl
                        color: (root.selectedSourceIndex === index) ? Qt.rgba(232/255, 133/255, 12/255, 0.2) : "#212124"
                        border.color: (root.selectedSourceIndex === index) ? JuxTheme.accent : Qt.rgba(255, 255, 255, 0.08)
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: (root.selectedSourceIndex === index) ? JuxTheme.accent : JuxTheme.textPrimary
                            font.pixelSize: 12
                            font.bold: (root.selectedSourceIndex === index)
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.selectedSourceIndex = index
                        }
                    }
                }
            }
        }

        // Section 3: OpenSubtitles Search Query (when selected)
        ColumnLayout {
            Layout.fillWidth: true
            visible: root.selectedSourceIndex === 1
            spacing: 6

            RowLayout {
                Layout.fillWidth: true
                TextField {
                    placeholderText: qsTr("Search subtitles by movie/show title...")
                    Layout.fillWidth: true
                }
                Button {
                    text: qsTr("Search Online")
                    highlighted: true
                }
            }
        }

        // Section 4: Episode Matching Preview Table
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: JuxTheme.radiusControl
            color: "#18181a"
            border.color: Qt.rgba(255, 255, 255, 0.06)

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12

                Text {
                    text: qsTr("Matched Episodes in Folder:")
                    color: JuxTheme.textSecondary
                    font.pixelSize: 12
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: [
                        { ep: "Episode 01", file: "Show_S01E01.mkv", sub: "Show_S01E01_English.srt" },
                        { ep: "Episode 02", file: "Show_S01E02.mkv", sub: "Show_S01E02_English.srt" },
                        { ep: "Episode 03", file: "Show_S01E03.mkv", sub: "Show_S01E03_English.srt" }
                    ]

                    delegate: RowLayout {
                        width: parent.width
                        height: 32

                        Text { text: modelData.ep; color: JuxTheme.accent; Layout.preferredWidth: 90; font.bold: true }
                        Text { text: modelData.file; color: JuxTheme.textPrimary; Layout.fillWidth: true; elide: Text.ElideRight }
                        Image {
                            width: 12
                            height: 12
                            source: Qt.resolvedUrl("../../../resources/icons/next.svg")
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }
                        Text { text: modelData.sub; color: "#98c379"; Layout.fillWidth: true; elide: Text.ElideRight }
                    }
                }
            }
        }

        // Action Buttons: Cancel and Apply
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight
            spacing: 12

            Button {
                text: qsTr("Cancel")
                onClicked: root.close()
            }

            Button {
                text: qsTr("Apply & Save for Future Episodes")
                highlighted: true
                onClicked: {
                    root.accept()
                }
            }
        }
    }
}

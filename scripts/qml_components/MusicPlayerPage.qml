import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../../modules/gui/qt/style"

Rectangle {
    id: musicRoot
    color: "#0a0b0e"

    property string trackTitle: "The Wand Main Theme"
    property string trackArtist: "Jux Audio Collective"
    property string trackAlbum: "VLC Redesign OST"
    property bool isPlaying: false

    Connections {
        target: VlcEngine
        function onTitleChanged(title) { musicRoot.trackTitle = title }
        function onArtistChanged(artist) { musicRoot.trackArtist = artist.length ? artist : "Unknown Artist" }
        function onAlbumChanged(album) { musicRoot.trackAlbum = album.length ? album : "VLC Audio Session" }
        function onPlayingStateChanged(state) { musicRoot.isPlaying = (state === 3) }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 50

        // ==================== LEFT: VINYL & COVER ART ====================
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            spacing: 24

            Rectangle {
                width: 280
                height: 280
                radius: 140
                color: "#14151e"
                border.color: JuxTheme.accent
                border.width: 3

                // Vinyl Grooves
                Repeater {
                    model: 4
                    Rectangle {
                        anchors.centerIn: parent
                        width: 250 - (index * 45)
                        height: width
                        radius: width / 2
                        color: "transparent"
                        border.color: Qt.rgba(255, 255, 255, 0.05)
                        border.width: 1
                    }
                }

                // Center Label
                Rectangle {
                    anchors.centerIn: parent
                    width: 90
                    height: 90
                    radius: 45
                    color: JuxTheme.accent

                    Image {
                        anchors.centerIn: parent
                        width: 40
                        height: 40
                        source: Qt.resolvedUrl("../../modules/gui/qt/resources/icons/music.svg")
                        fillMode: Image.PreserveAspectFit
                    }
                }
            }

            // Frequency Spectrum Visualizer Bars
            Row {
                Layout.alignment: Qt.AlignHCenter
                spacing: 4

                Repeater {
                    model: 24

                    Rectangle {
                        width: 4
                        height: musicRoot.isPlaying ? (10 + (Math.sin(index + Date.now() / 200) * 18 + 18)) : 6
                        radius: 2
                        color: JuxTheme.accent

                        Behavior on height {
                            NumberAnimation { duration: 80 }
                        }
                    }
                }
            }
        }

        // ==================== RIGHT: TRACK DETAILS & LYRICS ====================
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 16

            Text {
                text: musicRoot.trackTitle
                color: "#ffffff"
                font.family: JuxTheme.fontFamily
                font.pixelSize: 28
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Text {
                text: musicRoot.trackArtist + " • " + musicRoot.trackAlbum
                color: JuxTheme.accent
                font.family: JuxTheme.fontFamily
                font.pixelSize: 14
                font.bold: true
            }

            // Synced Lyrics Box
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 12
                color: "#12141c"
                border.color: Qt.rgba(255, 255, 255, 0.08)
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 12

                    Text {
                        text: "Interactive Synchronized Lyrics"
                        color: "#7e808c"
                        font.pixelSize: 12
                        font.bold: true
                    }

                    Text {
                        text: "♪ Floating in the digital waves of audio spectrum\n♪ High-resolution 320kbps pure stereo acoustics\n♪ Reengineered with native Direct3D & libvlc engine\n♪ Enjoy your personal music collection on VLC Reimagined"
                        color: "#ffffff"
                        font.family: JuxTheme.fontFamily
                        font.pixelSize: 15
                        lineHeight: 1.8
                    }

                    Item { Layout.fillHeight: true }
                }
            }
        }
    }
}

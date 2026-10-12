import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../../modules/gui/qt/style"
import "../../modules/gui/qt/widgets"

Rectangle {
    id: controlBarRoot
    color: "#0e0f13"
    border.color: Qt.rgba(255, 255, 255, 0.08)
    border.width: 1

    property bool isPlaying: false
    property string timeStr: "00:00"
    property string lengthStr: "00:00"
    property real seekPosition: 0.0
    property int currentVolume: 80
    property bool isMuted: false

    Connections {
        target: VlcEngine
        function onPlayingStateChanged(state) {
            controlBarRoot.isPlaying = (state === 3) // 3 = PLAYING
        }
        function onTimeChanged(timeMs, formatted) {
            controlBarRoot.timeStr = formatted
        }
        function onLengthChanged(lengthMs, formatted) {
            controlBarRoot.lengthStr = formatted
        }
        function onPositionChanged(pos) {
            if (!seekMouse.pressed)
                controlBarRoot.seekPosition = pos
        }
        function onVolumeChanged(vol) {
            controlBarRoot.currentVolume = vol
        }
        function onMuteChanged(muted) {
            controlBarRoot.isMuted = muted
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        spacing: 12

        // 1. Previous Track / -10s
        Rectangle {
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            radius: 14
            color: prevMouse.containsPress ? "#28282c" : (prevMouse.containsMouse ? "#1c1c20" : "transparent")

            Image {
                anchors.centerIn: parent
                width: 14
                height: 14
                source: Qt.resolvedUrl("../../modules/gui/qt/resources/icons/previous.svg")
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            MouseArea {
                id: prevMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (typeof VlcEngine !== "undefined" && VlcEngine)
                        VlcEngine.jumpSeconds(-10)
                }
            }
        }

        // 2. HERO PLAY BUTTON (40px, Accent Orange, VideoLAN Cone Style)
        Rectangle {
            id: btnPlay
            Layout.preferredWidth: 38
            Layout.preferredHeight: 38
            radius: 19
            color: playMouse.containsPress ? Qt.darker(JuxTheme.accent, 1.2)
                                           : (playMouse.containsMouse ? Qt.lighter(JuxTheme.accent, 1.1) : JuxTheme.accent)

            Image {
                anchors.centerIn: parent
                width: 18
                height: 18
                source: Qt.resolvedUrl("../../modules/gui/qt/resources/icons/" + (controlBarRoot.isPlaying ? "pause.svg" : "play.svg"))
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            MouseArea {
                id: playMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (typeof VlcEngine !== "undefined" && VlcEngine)
                        VlcEngine.togglePlayPause()
                }
            }
        }

        // 3. Next Track / +10s
        Rectangle {
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            radius: 14
            color: nextMouse.containsPress ? "#28282c" : (nextMouse.containsMouse ? "#1c1c20" : "transparent")

            Image {
                anchors.centerIn: parent
                width: 14
                height: 14
                source: Qt.resolvedUrl("../../modules/gui/qt/resources/icons/next.svg")
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            MouseArea {
                id: nextMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (typeof VlcEngine !== "undefined" && VlcEngine)
                        VlcEngine.jumpSeconds(10)
                }
            }
        }

        // 4. Elapsed Time
        Text {
            text: controlBarRoot.timeStr
            color: "#ffffff"
            font.family: JuxTheme.fontFamily
            font.pixelSize: 12
            font.bold: true
            Layout.preferredWidth: 48
            horizontalAlignment: Text.AlignRight
        }

        // 5. THICK INTERACTIVE SEEKBAR
        Item {
            id: seekContainer
            Layout.fillWidth: true
            Layout.preferredHeight: 24

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                height: seekMouse.containsMouse ? 7 : 4
                radius: height / 2
                color: "#22232a"

                Behavior on height {
                    NumberAnimation { duration: 120 }
                }

                // Buffer / Loaded indicator
                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width * Math.min(1.0, controlBarRoot.seekPosition + 0.15)
                    radius: parent.radius
                    color: Qt.rgba(255, 255, 255, 0.15)
                }

                // Progress Fill
                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width * Math.max(0.0, Math.min(1.0, controlBarRoot.seekPosition))
                    radius: parent.radius
                    color: JuxTheme.accent
                }

                // Scrubber Thumb (Visible on hover)
                Rectangle {
                    width: 12
                    height: 12
                    radius: 6
                    color: "#ffffff"
                    anchors.verticalCenter: parent.verticalCenter
                    x: Math.max(0, (parent.width * controlBarRoot.seekPosition) - 6)
                    visible: seekMouse.containsMouse || seekMouse.pressed
                }
            }

            MouseArea {
                id: seekMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                function updatePos(mouseX) {
                    var ratio = Math.max(0.0, Math.min(1.0, mouseX / width))
                    controlBarRoot.seekPosition = ratio
                    if (typeof VlcEngine !== "undefined" && VlcEngine)
                        VlcEngine.seek(ratio)
                }

                onClicked: (mouse) => updatePos(mouse.x)
                onPositionChanged: (mouse) => {
                    if (pressed)
                        updatePos(mouse.x)
                }
            }
        }

        // 6. Total Duration
        Text {
            text: controlBarRoot.lengthStr
            color: "#8a8b92"
            font.family: JuxTheme.fontFamily
            font.pixelSize: 12
            Layout.preferredWidth: 48
        }

        // 7. VOLUME CONE SLIDER (VLC Traffic Cone Geometry)
        RowLayout {
            spacing: 6

            // Mute Button
            Rectangle {
                width: 24
                height: 24
                radius: 12
                color: muteMouse.containsMouse ? "#202128" : "transparent"

                Image {
                    anchors.centerIn: parent
                    width: 15
                    height: 15
                    source: Qt.resolvedUrl("../../modules/gui/qt/resources/icons/volume.svg")
                    fillMode: Image.PreserveAspectFit
                    opacity: controlBarRoot.isMuted ? 0.4 : 1.0
                    smooth: true
                }

                MouseArea {
                    id: muteMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (typeof VlcEngine !== "undefined" && VlcEngine)
                            VlcEngine.toggleMute()
                    }
                }
            }

            // Volume Stepped Cone Slider
            Rectangle {
                width: 80
                height: 14
                color: "transparent"

                Row {
                    anchors.centerIn: parent
                    spacing: 3

                    Repeater {
                        model: 10 // 10 volume steps: 0% to 100%

                        Rectangle {
                            width: 5
                            height: 4 + (index * 1.0)
                            radius: 1.5
                            color: {
                                var stepVal = (index + 1) * 10
                                if (controlBarRoot.isMuted)
                                    return "#333339"
                                if (controlBarRoot.currentVolume >= stepVal)
                                    return JuxTheme.accent
                                return "#26272e"
                            }

                            MouseArea {
                                anchors.fill: parent
                                anchors.margins: -4
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    var newVol = (index + 1) * 10
                                    controlBarRoot.currentVolume = newVol
                                    if (typeof VlcEngine !== "undefined" && VlcEngine)
                                        VlcEngine.setVolume(newVol)
                                }
                            }
                        }
                    }
                }
            }

            Text {
                text: controlBarRoot.isMuted ? "0%" : controlBarRoot.currentVolume + "%"
                color: "#8a8b92"
                font.family: JuxTheme.fontFamily
                font.pixelSize: 10
                Layout.preferredWidth: 28
            }
        }

        // 8. Audio Track Button
        Rectangle {
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            radius: 14
            color: audioMouse.containsMouse ? "#22232a" : "transparent"

            Image {
                anchors.centerIn: parent
                width: 16
                height: 16
                source: Qt.resolvedUrl("../../modules/gui/qt/resources/icons/audio.svg")
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            MouseArea {
                id: audioMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (typeof MainWindow !== "undefined" && MainWindow)
                        MainWindow.toggleQuickSidebar()
                }
            }
        }

        // 9. Subtitle Track Button
        Rectangle {
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            radius: 14
            color: subMouse.containsMouse ? "#22232a" : "transparent"

            Image {
                anchors.centerIn: parent
                width: 16
                height: 16
                source: Qt.resolvedUrl("../../modules/gui/qt/resources/icons/subtitles.svg")
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            MouseArea {
                id: subMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (typeof MainWindow !== "undefined" && MainWindow)
                        MainWindow.toggleQuickSidebar()
                }
            }
        }

        // 10. Quick Settings Toggle
        Rectangle {
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            radius: 14
            color: qsMouse.containsMouse ? "#22232a" : "transparent"

            Image {
                anchors.centerIn: parent
                width: 16
                height: 16
                source: Qt.resolvedUrl("../../modules/gui/qt/resources/icons/settings.svg")
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            MouseArea {
                id: qsMouse
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

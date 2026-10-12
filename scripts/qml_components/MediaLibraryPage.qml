import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../../modules/gui/qt/style"

Rectangle {
    id: libraryRoot
    color: "#0c0d11"

    property var mediaList: []

    Connections {
        target: VlcEngine
        function onMediaLibraryScanned(items) {
            libraryRoot.mediaList = items
        }
    }

    Component.onCompleted: {
        if (typeof VlcEngine !== "undefined" && VlcEngine)
            VlcEngine.scanMediaFolder("")
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 20

        // ==================== LIBRARY HEADER ====================
        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            ColumnLayout {
                spacing: 4
                Text {
                    text: "Media Library"
                    color: "#ffffff"
                    font.family: JuxTheme.fontFamily
                    font.pixelSize: 22
                    font.bold: true
                }
                Text {
                    text: libraryRoot.mediaList.length + " media files detected • Double click to play"
                    color: "#888992"
                    font.family: JuxTheme.fontFamily
                    font.pixelSize: 12
                }
            }

            Item { Layout.fillWidth: true }

            // Rescan Button
            Rectangle {
                Layout.preferredWidth: 100
                Layout.preferredHeight: 32
                radius: 16
                color: scanMouse.containsMouse ? Qt.lighter(JuxTheme.accent, 1.1) : JuxTheme.accent

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 6
                    Image {
                        width: 14
                        height: 14
                        source: Qt.resolvedUrl("../../modules/gui/qt/resources/icons/recent.svg")
                        fillMode: Image.PreserveAspectFit
                    }
                    Text {
                        text: "Rescan"
                        color: "#ffffff"
                        font.family: JuxTheme.fontFamily
                        font.pixelSize: 12
                        font.bold: true
                    }
                }

                MouseArea {
                    id: scanMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (typeof VlcEngine !== "undefined" && VlcEngine)
                            VlcEngine.scanMediaFolder("")
                    }
                }
            }
        }

        // ==================== MEDIA CARDS GRID ====================
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Flow {
                width: parent.width
                spacing: 16

                Repeater {
                    model: libraryRoot.mediaList

                    Rectangle {
                        width: 260
                        height: 180
                        radius: 8
                        color: cardMouse.containsMouse ? "#1c1e28" : "#14151e"
                        border.color: cardMouse.containsMouse ? JuxTheme.accent : Qt.rgba(255, 255, 255, 0.08)
                        border.width: 1

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 0

                            // Thumbnail Header
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 110
                                radius: 8
                                color: "#101117"

                                Image {
                                    anchors.centerIn: parent
                                    width: 44
                                    height: 44
                                    source: Qt.resolvedUrl("../../modules/gui/qt/resources/icons/" + (modelData.isVideo ? "videos.svg" : "music.svg"))
                                    fillMode: Image.PreserveAspectFit
                                    opacity: 0.6
                                }

                                // Format badge
                                Rectangle {
                                    anchors.top: parent.top
                                    anchors.left: parent.left
                                    anchors.margins: 8
                                    width: 36
                                    height: 18
                                    radius: 4
                                    color: JuxTheme.accent

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.format
                                        color: "#ffffff"
                                        font.pixelSize: 9
                                        font.bold: true
                                    }
                                }

                                // Size badge
                                Rectangle {
                                    anchors.bottom: parent.bottom
                                    anchors.right: parent.right
                                    anchors.margins: 8
                                    width: 48
                                    height: 18
                                    radius: 4
                                    color: "#20212a"

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.size
                                        color: "#a0a0a8"
                                        font.pixelSize: 9
                                    }
                                }

                                // Hover Play Circle
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 40
                                    height: 40
                                    radius: 20
                                    color: JuxTheme.accent
                                    visible: cardMouse.containsMouse

                                    Image {
                                        anchors.centerIn: parent
                                        width: 16
                                        height: 16
                                        source: Qt.resolvedUrl("../../modules/gui/qt/resources/icons/play.svg")
                                        fillMode: Image.PreserveAspectFit
                                    }
                                }
                            }

                            // Card Details
                            ColumnLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.margins: 12
                                spacing: 4

                                Text {
                                    text: modelData.title
                                    color: "#ffffff"
                                    font.family: JuxTheme.fontFamily
                                    font.pixelSize: 13
                                    font.bold: true
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: modelData.filename
                                    color: "#7e808a"
                                    font.family: JuxTheme.fontFamily
                                    font.pixelSize: 11
                                    elide: Text.ElideMiddle
                                    Layout.fillWidth: true
                                }
                            }
                        }

                        MouseArea {
                            id: cardMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onDoubleClicked: {
                                if (typeof VlcEngine !== "undefined" && VlcEngine) {
                                    VlcEngine.openFile(modelData.path)
                                    if (typeof MainWindow !== "undefined" && MainWindow)
                                        MainWindow.switchView(modelData.isVideo ? 0 : 1)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

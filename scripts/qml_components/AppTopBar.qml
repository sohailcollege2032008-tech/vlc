import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../../modules/gui/qt/style"

Rectangle {
    id: topBarRoot
    color: "#111216"
    border.color: Qt.rgba(255, 255, 255, 0.08)
    border.width: 1

    property int activeTabIndex: 0
    property string currentTitle: "The_Wand_S01E05.mp4"

    Connections {
        target: VlcEngine
        function onTitleChanged(title) {
            topBarRoot.currentTitle = title
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        spacing: 14

        // 1. VLC Brand Logo & Name
        RowLayout {
            spacing: 8
            Image {
                width: 20
                height: 20
                source: Qt.resolvedUrl("../../modules/gui/qt/resources/icons/vlc.svg")
                fillMode: Image.PreserveAspectFit
                smooth: true
            }
            Text {
                text: "VLC"
                color: JuxTheme.accent
                font.family: JuxTheme.fontFamily
                font.pixelSize: 14
                font.bold: true
            }
        }

        // Open File Button
        Rectangle {
            Layout.preferredWidth: 90
            Layout.preferredHeight: 26
            radius: 13
            color: openMouse.containsPress ? "#282930" : (openMouse.containsMouse ? "#202127" : "#18191f")
            border.color: Qt.rgba(255, 255, 255, 0.12)
            border.width: 1

            RowLayout {
                anchors.centerIn: parent
                spacing: 5
                Image {
                    width: 12
                    height: 12
                    source: Qt.resolvedUrl("../../modules/gui/qt/resources/icons/folder.svg")
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }
                Text {
                    text: "Open File"
                    color: "#ffffff"
                    font.family: JuxTheme.fontFamily
                    font.pixelSize: 11
                    font.bold: true
                }
            }

            MouseArea {
                id: openMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (typeof MainWindow !== "undefined" && MainWindow)
                        MainWindow.openFileDialog()
                }
            }
        }

        Item { Layout.fillWidth: true }

        // 2. View Switcher Tabs (Video, Music, Library, Settings)
        RowLayout {
            spacing: 4

            Repeater {
                model: [
                    { name: "Video", icon: "videos" },
                    { name: "Music", icon: "music" },
                    { name: "Library", icon: "folder" },
                    { name: "Settings", icon: "settings" }
                ]

                Rectangle {
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: 84
                    radius: 14
                    color: topBarRoot.activeTabIndex === index
                           ? JuxTheme.accent
                           : (tabMouse.containsMouse ? "#202229" : "transparent")

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 6

                        Image {
                            width: 13
                            height: 13
                            source: Qt.resolvedUrl("../../modules/gui/qt/resources/icons/" + modelData.icon + ".svg")
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }

                        Text {
                            text: modelData.name
                            color: topBarRoot.activeTabIndex === index ? "#ffffff" : "#a0a0a5"
                            font.family: JuxTheme.fontFamily
                            font.pixelSize: 11
                            font.bold: (topBarRoot.activeTabIndex === index)
                        }
                    }

                    MouseArea {
                        id: tabMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            topBarRoot.activeTabIndex = index
                            if (typeof MainWindow !== "undefined" && MainWindow)
                                MainWindow.switchView(index)
                        }
                    }
                }
            }
        }

        Item { Layout.fillWidth: true }

        // 3. Current Playing Track Title Badge
        Rectangle {
            Layout.preferredHeight: 26
            Layout.preferredWidth: Math.min(220, titleText.implicitWidth + 24)
            radius: 13
            color: "#18191f"
            border.color: Qt.rgba(255, 255, 255, 0.08)
            border.width: 1

            Text {
                id: titleText
                anchors.centerIn: parent
                text: topBarRoot.currentTitle
                color: "#e0e0e5"
                font.family: JuxTheme.fontFamily
                font.pixelSize: 11
                elide: Text.ElideMiddle
                maximumLineCount: 1
            }
        }

        // 4. Quick Settings Icon Toggle
        Rectangle {
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            radius: 14
            color: qsMouse.containsMouse ? "#252730" : "transparent"

            Image {
                anchors.centerIn: parent
                width: 15
                height: 15
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

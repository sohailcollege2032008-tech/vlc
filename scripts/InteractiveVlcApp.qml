import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

import "../modules/gui/qt/style"
import "../modules/gui/qt/player/qml"
import "../modules/gui/qt/dialogs/toolbar/qml"
import "../modules/gui/qt/medialibrary/qml"
import "../modules/gui/qt/dialogs/dialogs/qml"

Window {
    id: appWindow
    visible: true
    width: 1280
    height: 760
    minimumWidth: 960
    minimumHeight: 600
    title: "VLC Media Player - Reimagined (Jux Redesign)"
    color: "#0a0a0c"

    property int currentViewIndex: 0 // 0: Video Player, 1: Music Player, 2: Media Library, 3: Toolbar Editor

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // ==================== TOP NAVIGATION VIEW SWITCHER ====================
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 38
            color: "#111113"
            border.color: Qt.rgba(255, 255, 255, 0.06)
            border.width: 1
            z: 100

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                spacing: 12

                RowLayout {
                    spacing: 8
                    Image {
                        width: 18
                        height: 18
                        source: Qt.resolvedUrl("../modules/gui/qt/resources/icons/vlc.svg")
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }
                    Text {
                        text: "VLC Reimagined"
                        color: JuxTheme.accent
                        font.family: JuxTheme.fontFamily
                        font.pixelSize: 13
                        font.bold: true
                    }
                }

                Item { Layout.fillWidth: true }

                // Interactive View Tabs
                RowLayout {
                    spacing: 6

                    Repeater {
                        model: [
                            { name: "Video Player", icon: "videos" },
                            { name: "Music Player", icon: "music" },
                            { name: "Media Library", icon: "folder" },
                            { name: "Toolbar Editor", icon: "settings" }
                        ]

                        Rectangle {
                            Layout.preferredHeight: 28
                            Layout.preferredWidth: 120
                            radius: 14
                            color: appWindow.currentViewIndex === index
                                   ? JuxTheme.accent
                                   : (tabMouse.containsMouse ? "#222226" : "#18181a")

                            RowLayout {
                                anchors.centerIn: parent
                                spacing: 6

                                Image {
                                    width: 13
                                    height: 13
                                    source: Qt.resolvedUrl("../modules/gui/qt/resources/icons/" + modelData.icon + ".svg")
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                }

                                Text {
                                    text: modelData.name
                                    color: appWindow.currentViewIndex === index ? "#ffffff" : JuxTheme.textSecondary
                                    font.family: JuxTheme.fontFamily
                                    font.pixelSize: 11
                                    font.bold: appWindow.currentViewIndex === index
                                }
                            }

                            MouseArea {
                                id: tabMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: appWindow.currentViewIndex = index
                            }
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: "Figma UI/UX by Jux • 100% Vector SVGs"
                    color: Qt.rgba(255, 255, 255, 0.4)
                    font.pixelSize: 11
                }
            }
        }

        // ==================== STACK OF REDESIGNED VIEWS ====================
        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: appWindow.currentViewIndex

            // VIEW 0: MAIN VIDEO PLAYER WITH CONTROL BAR & MODALS
            Item {
                id: videoPlayerTab

                property bool isQuickSidebarOpen: false
                property bool isAddSubsOpen: false
                property bool isFullSettingsOpen: false

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0

                    // Top Bar
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: JuxTheme.topBarHeight
                        color: JuxTheme.bgTopBar

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            spacing: 12

                            Image {
                                width: 22
                                height: 22
                                source: Qt.resolvedUrl("../modules/gui/qt/resources/icons/vlc.svg")
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                            }

                            Rectangle {
                                width: 26
                                height: 26
                                radius: JuxTheme.radiusControl
                                color: moreMouse.containsMouse ? "#2a2a2b" : "transparent"

                                Image {
                                    anchors.centerIn: parent
                                    width: 16
                                    height: 16
                                    source: Qt.resolvedUrl("../modules/gui/qt/resources/icons/more.svg")
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                }

                                MouseArea {
                                    id: moreMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: videoPlayerTab.isFullSettingsOpen = !videoPlayerTab.isFullSettingsOpen
                                }
                            }

                            RowLayout {
                                spacing: 6
                                Image {
                                    width: 14
                                    height: 14
                                    source: Qt.resolvedUrl("../modules/gui/qt/resources/icons/folder.svg")
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                }
                                Text {
                                    text: "The Wand / S01E05"
                                    color: JuxTheme.textSecondary
                                    font.family: JuxTheme.fontFamily
                                    font.pixelSize: 13
                                }
                            }

                            Item { Layout.fillWidth: true }

                            Text {
                                text: "The_Wand_S01E05.mp4"
                                color: JuxTheme.textPrimary
                                font.family: JuxTheme.fontFamily
                                font.pixelSize: 13
                                font.bold: true
                            }

                            Item { Layout.fillWidth: true }

                            RowLayout {
                                spacing: 10
                                Image {
                                    width: 15
                                    height: 15
                                    source: Qt.resolvedUrl("../modules/gui/qt/resources/icons/fullscreen.svg")
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                }
                                Image {
                                    width: 13
                                    height: 13
                                    source: Qt.resolvedUrl("../modules/gui/qt/resources/icons/minimize.svg")
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                }
                                Image {
                                    width: 13
                                    height: 13
                                    source: Qt.resolvedUrl("../modules/gui/qt/resources/icons/maximize.svg")
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                }
                                Image {
                                    width: 13
                                    height: 13
                                    source: Qt.resolvedUrl("../modules/gui/qt/resources/icons/close.svg")
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                }
                            }
                        }
                    }

                    // Video Canvas + Quick Sidebar
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Rectangle {
                            anchors.fill: parent
                            anchors.rightMargin: videoPlayerTab.isQuickSidebarOpen ? 380 : 0
                            color: JuxTheme.bgVideo

                            Behavior on anchors.rightMargin {
                                NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                            }

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 16

                                Rectangle {
                                    Layout.alignment: Qt.AlignHCenter
                                    width: 120
                                    height: 120
                                    radius: 60
                                    color: Qt.rgba(232/255, 133/255, 12/255, 0.12)
                                    border.color: JuxTheme.accent
                                    border.width: 2

                                    Image {
                                        anchors.centerIn: parent
                                        width: 64
                                        height: 64
                                        source: Qt.resolvedUrl("../modules/gui/qt/resources/icons/vlc.svg")
                                        fillMode: Image.PreserveAspectFit
                                        smooth: true
                                    }
                                }

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "VLC Media Player (Reimagined)"
                                    color: JuxTheme.textPrimary
                                    font.family: JuxTheme.fontFamily
                                    font.pixelSize: 22
                                    font.bold: true
                                }

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "Click Quick Settings icon in bottom control bar to toggle Quick Settings Sidebar\nClick Subtitles icon to launch smart Auto-matching Dialog\nClick More (...) in top bar to explore Full Settings Reimagined"
                                    color: JuxTheme.textSecondary
                                    font.family: JuxTheme.fontFamily
                                    font.pixelSize: 13
                                    horizontalAlignment: Text.AlignHCenter
                                    lineHeight: 1.4
                                }
                            }
                        }

                        // Quick Settings Sidebar
                        JuxQuickSettingsSidebar {
                            id: quickSidebar
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            width: videoPlayerTab.isQuickSidebarOpen ? 380 : 0
                            visible: width > 0
                            z: 20

                            Behavior on width {
                                NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                            }

                            onCloseRequested: videoPlayerTab.isQuickSidebarOpen = false
                        }
                    }

                    // Bottom Control Bar
                    JuxControlBar {
                        Layout.fillWidth: true
                        z: 30

                        onToggleQuickSettingsRequested: videoPlayerTab.isQuickSidebarOpen = !videoPlayerTab.isQuickSidebarOpen
                        onSubtitleMenuRequested: videoPlayerTab.isAddSubsOpen = true
                    }
                }

                // Add Subtitles Dialog Modal
                JuxAddSubtitlesDialog {
                    id: addSubsModal
                    visible: videoPlayerTab.isAddSubsOpen
                    anchors.centerIn: parent
                    z: 60
                    onClosed: videoPlayerTab.isAddSubsOpen = false
                }

                // Full Settings Reimagined Modal
                JuxSettingsView {
                    id: fullSettingsModal
                    visible: videoPlayerTab.isFullSettingsOpen
                    anchors.centerIn: parent
                    width: Math.min(parent.width - 60, 1048)
                    height: Math.min(parent.height - 60, 800)
                    z: 70
                    onCloseRequested: videoPlayerTab.isFullSettingsOpen = false
                }
            }

            // VIEW 1: MUSIC PLAYER VIEW (JUXX REDESIGN P05/P06)
            Item {
                id: musicPlayerTab
                JuxMusicView {
                    anchors.fill: parent
                    trackTitle: "untangle"
                    artistName: "juxtopposed"
                    duration: 100
                    currentPosition: 25
                    isPlaylistOpen: false
                }
            }

            // VIEW 2: MEDIA LIBRARY (JUXX REDESIGN LIBRARY)
            Item {
                id: mediaLibraryTab
                JuxMediaLibraryView {
                    anchors.fill: parent
                    breadcrumbText: "Videos ▸ Shows ▸ The Wand ▸ S01"
                    selectedNavIndex: 1
                    onItemPlayed: (title) => {
                        appWindow.currentViewIndex = 0
                    }
                }
            }

            // VIEW 3: TOOLBAR CUSTOMIZER / EDITOR (JUXX REDESIGN C01-C09)
            Item {
                id: toolbarEditorTab
                JuxToolbarEditorDialog {
                    anchors.fill: parent
                    isModified: true
                    onSaved: {
                        appWindow.currentViewIndex = 0
                    }
                }
            }
        }
    }
}

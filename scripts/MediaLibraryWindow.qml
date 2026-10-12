import QtQuick
import QtQuick.Window
import "../modules/gui/qt/medialibrary/qml"

Window {
    visible: true
    width: 1280
    height: 720
    color: "#0e0e0e"

    JuxMediaLibraryView {
        anchors.fill: parent
        breadcrumbText: "Videos ▸ Shows ▸ The Wand ▸ S01"
        selectedNavIndex: 1
    }
}

import QtQuick
import QtQuick.Window
import "../modules/gui/qt/player/qml"

Window {
    visible: true
    width: 1280
    height: 720
    color: "#0e0e0e"

    JuxMusicView {
        anchors.fill: parent
        trackTitle: "untangle"
        artistName: "juxtopposed"
        duration: 100
        currentPosition: 25
        isPlaylistOpen: false
    }
}

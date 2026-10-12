import QtQuick
import QtQuick.Window
import "../modules/gui/qt/dialogs/toolbar/qml"

Window {
    visible: true
    width: 1280
    height: 720
    color: "#0e0e0e"

    JuxToolbarEditorDialog {
        anchors.fill: parent
        isModified: true
    }
}

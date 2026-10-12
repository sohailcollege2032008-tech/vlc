import QtQuick
import QtTest

import "../style"
import "../dialogs/toolbar/qml"

TestCase {
    name: "JuxToolbarEditorTests"
    when: windowShown

    Component {
        id: editorComp
        JuxToolbarEditorDialog {
            width: 1280
            height: 720
        }
    }

    function test_toolbar_editor_structure() {
        var editor = createTemporaryObject(editorComp, null)
        verify(editor !== null, "Toolbar editor dialog instantiated")

        // Check modal properties
        compare(editor.title, "Customize Player")
        verify(editor.toolsModel.length >= 30, "Palette has 31 draggable tools")

        // Verify key tools exist
        var toolNames = []
        for (var i = 0; i < editor.toolsModel.length; ++i) {
            toolNames.push(editor.toolsModel[i].name)
        }
        verify(toolNames.indexOf("Spacer") !== -1, "Spacer tool present")
        verify(toolNames.indexOf("Divider") !== -1, "Divider tool present")
        verify(toolNames.indexOf("Playback Speed") !== -1, "Playback Speed tool present")
        verify(toolNames.indexOf("Record") !== -1, "Record tool present")
        verify(toolNames.indexOf("Favorite") !== -1, "Favorite tool present")
        verify(toolNames.indexOf("Bookmark") !== -1, "Bookmark tool present")
    }

    function test_toolbar_drop_zones() {
        var editor = createTemporaryObject(editorComp, null)
        verify(editor.topBarDropZone !== null, "Top bar drop zone exists")
        verify(editor.controlBarDropZone !== null, "Control bar drop zone exists")
    }
}

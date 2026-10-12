import QtQuick
import QtTest

import "../style"
import "../medialibrary/qml"

TestCase {
    name: "JuxMediaLibraryTests"
    when: windowShown

    Component {
        id: libraryComp
        JuxMediaLibraryView {
            width: 1280
            height: 720
        }
    }

    function test_medialibrary_structure() {
        var lib = createTemporaryObject(libraryComp, null)
        verify(lib !== null, "Media library view instantiated")

        // 7-item navigation sidebar
        verify(lib.sideNav !== null, "Side navigation pane exists")
        compare(lib.sideNav.items.length, 7)
        compare(lib.sideNav.items[0], "Home")
        compare(lib.sideNav.items[1], "Videos")
        compare(lib.sideNav.items[2], "Music")
        compare(lib.sideNav.items[3], "Network")
        compare(lib.sideNav.items[4], "Playlists")
        compare(lib.sideNav.items[5], "Recent")
        compare(lib.sideNav.items[6], "+ Add item")

        // Subheader navigation breadcrumb
        verify(lib.breadcrumbText.indexOf("Videos") !== -1, "Breadcrumb contains Videos")

        // Media grid & watched indicator
        verify(lib.mediaGrid !== null, "Media grid exists")
        verify(lib.mediaGrid.count > 0, "Media items displayed in grid")
    }
}

import QtQuick
import QtTest

import "../style"
import "../player/qml"

TestCase {
    name: "JuxMusicPlayerTests"
    when: windowShown

    Component {
        id: musicViewComp
        JuxMusicView {
            width: 1280
            height: 720
            trackTitle: "untangle"
            artistName: "juxtopposed"
            duration: 100
            currentPosition: 10
        }
    }

    function test_music_view_layout() {
        var view = createTemporaryObject(musicViewComp, null)
        verify(view !== null, "Music view instantiated")

        compare(view.trackTitle, "untangle")
        compare(view.artistName, "juxtopposed")

        // Verify album cover properties
        verify(view.albumArtItem !== null, "Album art item exists")
        compare(view.albumArtItem.radius, 24)

        // Verify waveform seekbar
        verify(view.waveformItem !== null, "Waveform seekbar exists")
        verify(view.waveformItem.barCount > 40, "Waveform contains audio bars")
    }
}

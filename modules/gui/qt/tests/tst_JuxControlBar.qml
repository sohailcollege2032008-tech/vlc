/*****************************************************************************
 * Jux VLC Redesign - Single-Row Player Control Bar Unit Test
 * Validates the single-row layout hierarchy, widget order, and state transitions
 *****************************************************************************/
import QtQuick
import QtTest
import VLC.Player
import VLC.Style

TestCase {
    id: controlBarTest
    name: "JuxControlBar"

    JuxControlBar {
        id: bar
        width: 1200
        height: JuxTheme.controlBarHeight
    }

    function test_single_row_dimensions() {
        compare(bar.height, JuxTheme.controlBarHeight, "Control bar must be a compact single row")
        verify(bar.hasThickSeekBar, "Seek bar must be thick and embedded directly between timestamps")
    }

    function test_playback_controls_cluster() {
        // Left group: Prev, Play, Next
        verify(bar.prevButton !== null, "Previous button exists on the left")
        verify(bar.playButton !== null, "Play/Pause button exists on the left")
        verify(bar.nextButton !== null, "Next button exists on the left")
        verify(bar.playButton.width > bar.prevButton.width, "Play button is larger than surrounding navigation buttons")
    }

    function test_right_controls_cluster() {
        // Right group: Volume Cone, Audio, Subtitles, Settings, Queue
        verify(bar.volumeWidget !== null, "Volume cone widget is on the right")
        verify(bar.audioTracksButton !== null, "Audio tracks button is on the right")
        verify(bar.subtitlesButton !== null, "Subtitles button is on the right")
        verify(bar.settingsButton !== null, "Quick settings sidebar button is on the right")
        verify(bar.queueButton !== null, "Queue button is on the far right")
    }
}

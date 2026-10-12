/*****************************************************************************
 * Jux VLC Redesign - Quick Settings 4-Tab Sidebar Unit Test
 * Validates tab switching, slider ranges, preset saving/loading per show
 *****************************************************************************/
import QtQuick
import QtTest
import VLC.Player
import VLC.Style

TestCase {
    id: quickSettingsTest
    name: "JuxQuickSettingsSidebar"

    JuxQuickSettingsSidebar {
        id: sidebar
        width: 380
        height: 800
    }

    function test_four_tabs_exist() {
        compare(sidebar.tabCount, 4, "Sidebar must have exactly 4 tabs: Subtitles, Audio, Video, Playback")
        compare(sidebar.tabNames[0], "Subtitles")
        compare(sidebar.tabNames[1], "Audio")
        compare(sidebar.tabNames[2], "Video")
        compare(sidebar.tabNames[3], "Playback")
    }

    function test_tab_switching() {
        sidebar.currentTabIndex = 1
        compare(sidebar.activeTabName, "Audio", "Switching index changes active tab")
        sidebar.currentTabIndex = 0
        compare(sidebar.activeTabName, "Subtitles", "Returns to Subtitles tab")
    }

    function test_subtitle_delay_slider() {
        sidebar.subtitleDelaySeconds = 1.5
        compare(sidebar.subtitleDelaySeconds, 1.5, "Subtitle delay can be set via slider")
        sidebar.subtitleDelaySeconds = -0.5
        compare(sidebar.subtitleDelaySeconds, -0.5, "Negative subtitle delay supported")
    }

    function test_show_preset_storage() {
        sidebar.saveShowPreset("AttackOnTitan", { delay: 1.2, fontScale: "medium", audioEq: "Rock" })
        const loaded = sidebar.loadShowPreset("AttackOnTitan")
        verify(loaded !== null, "Saved show preset should be retrievable")
        compare(loaded.delay, 1.2, "Show preset delay matches")
        compare(loaded.audioEq, "Rock", "Show preset audio EQ preset matches")
    }
}

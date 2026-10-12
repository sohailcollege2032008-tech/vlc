/*****************************************************************************
 * Jux VLC Redesign - Add Subtitles Dialog Unit Test
 * Tests the 3-target scope (file/folder/playlist), source provider selection,
 * and episode auto-matching heuristics [06:00 - 06:25].
 *****************************************************************************/
import QtQuick
import QtTest
import VLC.Dialogs
import VLC.Style

TestCase {
    id: addSubsTest
    name: "JuxAddSubtitlesDialog"

    JuxAddSubtitlesDialog {
        id: dialog
        width: 600
        height: 500
    }

    function test_scope_targets() {
        compare(dialog.targetOptions.length, 3, "Must have exactly 3 target scopes")
        compare(dialog.targetOptions[0], "This File")
        compare(dialog.targetOptions[1], "This Folder")
        compare(dialog.targetOptions[2], "This Playlist")
    }

    function test_source_providers() {
        compare(dialog.sourceProviders.length, 2, "Must offer Local Computer and OpenSubtitles")
        compare(dialog.sourceProviders[0], "Local Files")
        compare(dialog.sourceProviders[1], "OpenSubtitles")
    }

    function test_automatch_heuristic() {
        // Episode naming matching
        const videoFiles = ["Show_S01E01.mkv", "Show_S01E02.mkv"]
        const subFiles = ["ep1_english.srt", "ep2_english.srt"]
        const matches = dialog.autoMatchEpisodes(videoFiles, subFiles)

        compare(matches.length, 2, "Both episodes must be automatically paired")
        compare(matches[0].sub, "ep1_english.srt")
        compare(matches[1].sub, "ep2_english.srt")
    }
}

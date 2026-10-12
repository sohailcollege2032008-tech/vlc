/*****************************************************************************
 * Jux VLC Redesign - Design Tokens Unit Test
 * Validates the core token hierarchy, color palette, dimensions, and radii
 * extracted from the Figma Community redesign file RJQ32w6ZIKvSgUvtpGKJUx.
 *****************************************************************************/
import QtQuick
import QtTest
import VLC.Style

TestCase {
    id: testRoot
    name: "JuxThemeTokens"

    function test_color_tokens() {
        // Dark backgrounds
        compare(JuxTheme.bgB1, "#0e0e0e", "bgB1 must match Figma Dark/BG/B1")
        compare(JuxTheme.bgPlayer, "#1b1b1b", "bgPlayer must match Figma Player canvas background")
        compare(JuxTheme.bgVideo, "#303030", "bgVideo must match Figma Video frame fill")

        // Accent palette
        compare(JuxTheme.accent, "#e8850c", "Default VLC orange accent color")
        verify(JuxTheme.accents.length >= 9, "Should support at least 9 accent colors from settings frame")
        compare(JuxTheme.accents[0], "#e8850c", "First accent should be VLC orange")
    }

    function test_border_radii() {
        // "rectangular but less sharp" - Jux video [01:28]
        compare(JuxTheme.radiusDialog, 14, "Dialogs and large cards have 14px border radius")
        compare(JuxTheme.radiusMenu, 10, "Popovers and context menus have 10px border radius")
        compare(JuxTheme.radiusControl, 6, "Buttons and badge controls have 6px border radius")
        compare(JuxTheme.radiusToggle, 12, "Toggles have pill radius")
    }

    function test_controlbar_metrics() {
        // Single thin row below video
        verify(JuxTheme.controlBarHeight > 0, "Control bar height must be positive")
        verify(JuxTheme.seekBarThickHeight >= 6, "Seek bar must be significantly thicker than legacy slider [03:18]")
        verify(JuxTheme.playButtonSize > JuxTheme.navButtonSize, "Play button must be larger than next/prev icons [02:10]")
    }
}

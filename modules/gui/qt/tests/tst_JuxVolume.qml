/*****************************************************************************
 * Jux VLC Redesign - Volume Cone Widget Unit Test
 * Validates volume level calculation, mute toggling, and cone geometry rendering
 *****************************************************************************/
import QtQuick
import QtTest
import VLC.Widgets as Widgets
import VLC.Style

TestCase {
    id: volumeTest
    name: "JuxVolumeWidget"

    Widgets.JuxVolumeCone {
        id: cone
        volumeLevel: 0.5
        muted: false
    }

    function test_volume_clamping() {
        cone.volumeLevel = 0.5
        compare(cone.volumePercent, 50, "0.5 volume corresponds to 50%")

        cone.volumeLevel = 1.25
        compare(cone.volumePercent, 125, "Supports VLC audio boost up to 125%")

        cone.volumeLevel = -0.1
        compare(cone.volumePercent, 0, "Negative volume should clamp to 0%")
    }

    function test_mute_toggle() {
        cone.volumeLevel = 0.8
        cone.muted = true
        verify(cone.isMuted, "Muted state must be true")
        compare(cone.effectiveVolumePercent, 0, "Effective volume when muted must be 0")

        cone.muted = false
        compare(cone.effectiveVolumePercent, 80, "Unmuted should restore previous volume")
    }

    function test_cone_geometry() {
        verify(cone.implicitWidth >= 50, "Volume cone should have adequate click/drag width")
        verify(cone.maxConeHeight > cone.minConeHeight, "Cone must slope from narrow min to wide max height")
    }
}

/*****************************************************************************
 * Copyright (C) 2026 VLC Authors & VideoLAN
 *
 * Jux VLC Redesign - Full Traffic Cone Volume Widget
 * Renders the volume slider as an elegant horizontal cone wedge matching
 * Jux Redesign Component #244:184 & video concept [02:55 - 03:08].
 *****************************************************************************/
import QtQuick
import QtQuick.Templates as T
import VLC.Style
import VLC.Player
import VLC.MainInterface

Item {
    id: root

    property real volumeLevel: (typeof Player !== "undefined" && Player) ? Player.volume : 0.5
    property bool muted: (typeof Player !== "undefined" && Player) ? Player.muted : false

    readonly property int volumePercent: Math.round(Math.max(0, volumeLevel) * 100)
    readonly property bool isMuted: muted
    readonly property int effectiveVolumePercent: muted ? 0 : volumePercent

    readonly property int minConeHeight: 3
    readonly property int maxConeHeight: 16

    implicitWidth: 68
    implicitHeight: 24

    signal volumeChangeRequested(real newVol)
    signal muteToggleRequested()

    onVolumeChangeRequested: (newVol) => {
        if (typeof Player !== "undefined" && Player) {
            Player.setVolume(newVol)
            if (Player.muted && newVol > 0)
                Player.setMuted(false)
        } else {
            root.volumeLevel = newVol
        }
    }

    onMuteToggleRequested: {
        if (typeof Player !== "undefined" && Player) {
            Player.setMuted(!Player.muted)
        } else {
            root.muted = !root.muted
        }
    }

    Canvas {
        id: coneCanvas
        anchors.fill: parent
        antialiasing: true

        readonly property real fillRatio: Math.min(1.0, Math.max(0.0, root.effectiveVolumePercent / 100.0))
        readonly property real boostRatio: Math.min(1.0, Math.max(0.0, (root.effectiveVolumePercent - 100) / 25.0))

        onPaint: {
            const ctx = getContext("2d")
            ctx.reset()

            const w = width
            const h = height
            const midY = h / 2.0
            const halfMinH = root.minConeHeight / 2.0
            const halfMaxH = root.maxConeHeight / 2.0

            // 1. Background Track: full cone wedge shape
            ctx.beginPath()
            ctx.moveTo(0, midY - halfMinH)
            ctx.lineTo(w, midY - halfMaxH)
            ctx.lineTo(w, midY + halfMaxH)
            ctx.lineTo(0, midY + halfMinH)
            ctx.closePath()
            ctx.fillStyle = "#2a2a2b"
            ctx.fill()

            if (fillRatio <= 0.0)
                return

            // 2. Active Volume Fill
            const fillW = w * fillRatio
            const curHalfH = halfMinH + (halfMaxH - halfMinH) * fillRatio

            ctx.save()
            ctx.beginPath()
            ctx.rect(0, 0, fillW, h)
            ctx.clip()

            ctx.beginPath()
            ctx.moveTo(0, midY - halfMinH)
            ctx.lineTo(w, midY - halfMaxH)
            ctx.lineTo(w, midY + halfMaxH)
            ctx.lineTo(0, midY + halfMinH)
            ctx.closePath()

            if (root.isMuted) {
                ctx.fillStyle = "#555555"
            } else {
                // Gradient or accent green-amber-orange
                const grad = ctx.createLinearGradient(0, 0, w, 0)
                grad.addColorStop(0.0, "#98c379")
                grad.addColorStop(0.7, "#e8850c")
                grad.addColorStop(1.0, "#e06c75")
                ctx.fillStyle = grad
            }
            ctx.fill()
            ctx.restore()
        }

        Connections {
            target: root
            function onEffectiveVolumePercentChanged() { coneCanvas.requestPaint() }
            function onIsMutedChanged() { coneCanvas.requestPaint() }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        function updateFromMouse(mouse) {
            const ratio = Math.max(0.0, Math.min(1.25, mouse.x / width))
            root.volumeChangeRequested(ratio)
        }

        onPressed: (mouse) => updateFromMouse(mouse)
        onPositionChanged: (mouse) => {
            if (pressed)
                updateFromMouse(mouse)
        }
        onWheel: (wheel) => {
            const step = (wheel.angleDelta.y > 0) ? 0.05 : -0.05
            const nextVol = Math.max(0.0, Math.min(1.25, root.volumeLevel + step))
            root.volumeChangeRequested(nextVol)
        }
    }
}

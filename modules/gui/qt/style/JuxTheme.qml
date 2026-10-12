/*****************************************************************************
 * Copyright (C) 2026 VLC Authors & VideoLAN
 *
 * Jux VLC Redesign - Unified Design System Tokens
 * Extracted directly from Figma "VLC Redesign (Community)" RJQ32w6ZIKvSgUvtpGKJUx
 *****************************************************************************/
pragma Singleton
import QtQuick

QtObject {
    id: root

    // Backgrounds (Figma tokens)
    readonly property color bgB1: "#0e0e0e"
    readonly property color bgB1Transparent: Qt.rgba(14/255, 14/255, 14/255, 0.95)
    readonly property color bgB2: "#141414"
    readonly property color bgA3Transparent: Qt.rgba(25/255, 25/255, 25/255, 0.95)
    readonly property color bgPlayer: "#1b1b1b"
    readonly property color bgVideo: "#303030"
    readonly property color bgCard: "#242424"
    readonly property color bgInput: "#19191a"

    // Text & Foreground
    readonly property color textPrimary: "#ffffff"
    readonly property color textSecondary: "#a0a0a0"
    readonly property color textTertiary: "#777777"
    readonly property color textMuted: "#666666"

    // Accent Colors
    property color accent: "#e8850c" // Default VLC Orange, dynamically customizable
    readonly property var accents: [
        "#e8850c", // VLC Classic Orange
        "#b5432f", // Crimson
        "#9c8a25", // Amber Gold
        "#22862f", // Emerald
        "#1a8fa8", // Cyan / Teal
        "#1f4fa8", // Royal Blue
        "#7a3fcf", // Purple / Violet
        "#c0438f", // Magenta
        "#8a8a8a"  // Monochrome Slate
    ]

    // Border Radii (Figma parameters: "rectangular but less sharp")
    readonly property int radiusDialog: 14
    readonly property int radiusModal: 14
    readonly property int radiusMenu: 10
    readonly property int radiusControl: 6
    readonly property int radiusToggle: 12
    readonly property int radiusCard: 10
    readonly property int radiusHeroPlay: 8
    readonly property int radiusSmall: 4

    // Metric dimensions
    readonly property int controlBarHeight: 48
    readonly property int topBarHeight: 40
    readonly property int seekBarThickHeight: 10
    readonly property int seekBarHoverHeight: 14
    readonly property int playButtonSize: 36
    readonly property int navButtonSize: 28
    readonly property int iconSizeNormal: 20
    readonly property int iconSizeLarge: 24

    // Typography
    readonly property string fontFamily: "Inter"

    // Blur & Shadows
    readonly property real backdropBlurRadius: 25.0
    readonly property color shadowColor: Qt.rgba(0, 0, 0, 0.46)
    readonly property int shadowBlur: 15
    readonly property int shadowOffsetY: 8
}

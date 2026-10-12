/*****************************************************************************
 * Copyright (C) 2026 VLC Authors & VideoLAN
 *
 * Jux VLC Redesign - Vector SVG Icon Component
 * Loads exact vector SVG assets matching Figma sheet k02 (#42:356)
 *****************************************************************************/
import QtQuick

import "../../style"

Item {
    id: root

    property string name: "" // e.g. "play", "pause", "vlc", "settings"
    property real size: 20
    property color color: JuxTheme.textSecondary

    implicitWidth: size
    implicitHeight: size

    readonly property string iconUrl: name ? Qt.resolvedUrl("../../resources/icons/" + name + ".svg") : ""

    Image {
        id: iconImg
        anchors.fill: parent
        source: root.iconUrl
        sourceSize.width: root.size * 2
        sourceSize.height: root.size * 2
        fillMode: Image.PreserveAspectFit
        smooth: true
        mipmap: true
    }
}

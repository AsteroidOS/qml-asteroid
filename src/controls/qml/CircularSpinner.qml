/*
 * Copyright (C) 2017 Florent Revest <revestflo@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.9
import org.asteroid.controls 1.0

PathView {
    property alias showSeparator: separator.visible

    id: pv
    preferredHighlightBegin: 0.5
    preferredHighlightEnd: 0.5
    highlightRangeMode: PathView.StrictlyEnforceRange
    highlightMoveDuration: 0
    clip: true

    delegate: SpinnerDelegate { }

    path: Path {
        startX: pv.width/2; startY: pv.height/2-pv.model*Dims.h(6)
        PathLine { x: pv.width/2; y: pv.height/2+pv.model*Dims.h(6) }
    }

    Rectangle {
        id: separator
        width: 1
        height: parent.height*0.8
        color: "#88FFFFFF"
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        visible: false
    }

    layer.enabled: true
    layer.effect: ShaderEffect {
        fragmentShader: "
        precision mediump float;
        varying highp vec2 qt_TexCoord0;
        uniform sampler2D source;
        void main(void)
        {
            vec4 sourceColor = texture2D(source, qt_TexCoord0);
            float alpha = 1.0;
            if(qt_TexCoord0.y < 0.2)
                alpha = qt_TexCoord0.y*5.0;
            if(qt_TexCoord0.y > 0.8)
                alpha = (1.0-qt_TexCoord0.y)*5.0;
            gl_FragColor = sourceColor * alpha;
        }"
    }
}

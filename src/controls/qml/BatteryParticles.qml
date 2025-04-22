/*
 * Copyright (C) 2025 Timo Könnecke <github.com/eLtMosen>
 *
 * All rights reserved.
 *
 * You may use this file under the terms of BSD license as follows:
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the author nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import QtQuick 2.9
import QtGraphicalEffects 1.15
import org.asteroid.controls 1.0

/*!
    \qmltype BatteryParticles
    \inqmlmodule org.asteroid.controls
    \brief A particle component for battery meter animations with various designs.

    This component renders a single particle for battery meter animations, supporting
    different designs (diamonds, bubbles, logos, flashes). It moves to a target X position,
    scales, fades, and self-destructs after a specified lifetime. Used in battery meter
    visualizations to show charging or low-battery effects.

    Example usage in a battery meter:
    \qml
    import QtQuick 2.9
    import org.asteroid.controls 1.0

    Item {
        id: batteryFill
        width: 100
        height: 20

        function createParticle() {
            var component = Qt.createComponent("org.asteroid.controls.BatteryParticles");
            if (component.status === Component.Ready) {
                var particle = component.createObject(batteryFill, {
                    "x": 10,
                    "y": 5,
                    "targetX": 50,
                    "maxSize": 8,
                    "lifetime": 1200,
                    "isCharging": true,
                    "design": "diamonds"
                });
            }
        }

        Timer {
            interval: 200
            running: true
            repeat: true
            onTriggered: createParticle()
        }
    }
    \endqml
*/
Item {
    id: particleRoot
    width: maxSize
    height: maxSize

    /*!
        \qmlproperty real BatteryParticles::maxSize
        The maximum size of the particle.
    */
    property real maxSize: 10

    /*!
        \qmlproperty real BatteryParticles::targetX
        The target X position for the particle's movement.
    */
    property real targetX: 0

    /*!
        \qmlproperty int BatteryParticles::lifetime
        The duration (in milliseconds) before the particle self-destructs.
    */
    property int lifetime: 1200

    /*!
        \qmlproperty bool BatteryParticles::isCharging
        Whether the battery is charging, affecting particle behavior.
    */
    property bool isCharging: false

    /*!
        \qmlproperty string BatteryParticles::design
        The particle design: "diamonds", "bubbles", "logos", or "flashes".
    */
    property string design: "diamonds"

    /*!
        \qmlproperty rect BatteryParticles::clipBounds
        The bounding rectangle (x, y, width, height) for clipping. Particles are destroyed if they move outside this area.
    */
    property rect clipBounds: Qt.rect(0, 0, 0, 0)

    // Define design-specific properties
    property var designProperties: {
        "diamonds": { initialSize: 0.3, maxSize: 0.9, initialOpacity: 0, maxOpacity: 0.6 },
        "bubbles": { initialSize: 0.3, maxSize: 0.9, initialOpacity: 0, maxOpacity: 0.6 },
        "logos": { initialSize: 0.4, maxSize: 1.2, initialOpacity: 0, maxOpacity: 0.6 },
        "flashes": { initialSize: 0.6, maxSize: 1.4, initialOpacity: 0, maxOpacity: 0.6 }
    }

    // Get design properties with fallback
    function getDesignProp(propName) {
        return (designProperties[design] && designProperties[design][propName])
               ? designProperties[design][propName]
               : designProperties["diamonds"][propName];
    }

    // Check if particle is outside clipBounds and destroy if so
    onXChanged: {
        if (clipBounds.width > 0 && clipBounds.height > 0) {
            if (x < clipBounds.x - maxSize || x > clipBounds.x + clipBounds.width) {
                particleRoot.destroy();
            }
        }
    }

    // Destroy timer to handle particle cleanup
    Timer {
        id: destroyTimer
        interval: lifetime
        running: true
        repeat: false
        onTriggered: particleRoot.destroy()
    }

    // Diamond design
    Rectangle {
        id: diamond
        width: particleRoot.width * particleSize
        height: particleRoot.width * particleSize
        color: "#FFFFFF"
        anchors.centerIn: parent
        rotation: 45
        opacity: particleOpacity
        visible: particleRoot.design === "diamonds"

        property real particleSize: getDesignProp("initialSize")
        property real particleOpacity: getDesignProp("initialOpacity")
    }

    // Bubble design
    Rectangle {
        id: bubble
        width: particleRoot.width * particleSize
        height: particleRoot.width * particleSize
        radius: width / 2
        color: "#FFFFFF"
        anchors.centerIn: parent
        opacity: particleOpacity
        visible: particleRoot.design === "bubbles"

        property real particleSize: getDesignProp("initialSize")
        property real particleOpacity: getDesignProp("initialOpacity")
    }

    // Logo design
    Icon {
        id: logo
        width: particleRoot.width * particleSize
        height: particleRoot.width * particleSize
        name: "logo-asteroidos"
        anchors.centerIn: parent
        opacity: particleOpacity
        visible: particleRoot.design === "logos"

        property real particleSize: getDesignProp("initialSize")
        property real particleOpacity: getDesignProp("initialOpacity")
    }

    // Flash design
    Icon {
        id: flash
        width: particleRoot.width * particleSize
        height: particleRoot.width * particleSize
        name: "ios-flash"
        anchors.centerIn: parent
        opacity: particleOpacity
        visible: particleRoot.design === "flashes"

        property real particleSize: getDesignProp("initialSize")
        property real particleOpacity: getDesignProp("initialOpacity")
    }

    ParallelAnimation {
        id: particleAnimation
        running: true

        // Position animation
        NumberAnimation {
            target: particleRoot
            property: "x"
            to: targetX
            duration: lifetime
            easing.type: Easing.InOutSine
        }

        // Size animation - dynamically determine target based on current design
        SequentialAnimation {
            NumberAnimation {
                target: {
                    switch(particleRoot.design) {
                        case "diamonds": return diamond;
                        case "bubbles": return bubble;
                        case "logos": return logo;
                        case "flashes": return flash;
                        default: return diamond;
                    }
                }
                property: "particleSize"
                from: getDesignProp("initialSize")
                to: getDesignProp("maxSize")
                duration: lifetime / 2
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: {
                    switch(particleRoot.design) {
                        case "diamonds": return diamond;
                        case "bubbles": return bubble;
                        case "logos": return logo;
                        case "flashes": return flash;
                        default: return diamond;
                    }
                }
                property: "particleSize"
                from: getDesignProp("maxSize")
                to: getDesignProp("initialSize")
                duration: lifetime / 2
                easing.type: Easing.InQuad
            }
        }

        // Opacity animation - dynamically determine target based on current design
        SequentialAnimation {
            NumberAnimation {
                target: {
                    switch(particleRoot.design) {
                        case "diamonds": return diamond;
                        case "bubbles": return bubble;
                        case "logos": return logo;
                        case "flashes": return flash;
                        default: return diamond;
                    }
                }
                property: "particleOpacity"
                from: getDesignProp("initialOpacity")
                to: getDesignProp("maxOpacity")
                duration: lifetime / 2
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: {
                    switch(particleRoot.design) {
                        case "diamonds": return diamond;
                        case "bubbles": return bubble;
                        case "logos": return logo;
                        case "flashes": return flash;
                        default: return diamond;
                    }
                }
                property: "particleOpacity"
                from: getDesignProp("maxOpacity")
                to: getDesignProp("initialOpacity")
                duration: lifetime / 2
                easing.type: Easing.InQuad
            }
        }
    }
}

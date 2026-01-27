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
    \qmltype ValueMeter
    \inqmlmodule org.asteroid.controls
    \brief A customizable meter component for displaying a value within a specified range.

    This component displays a rounded rectangular meter with a fill that represents a value
    between a lower and upper bound. It supports animations (wave effect during active state,
    color pulsing at low values), colored fill based on value thresholds, and particle effects
    for visual feedback. Designed for system-wide use in AsteroidOS, it is ideal for battery
    levels, volume, or other ranged values.

    Example usage:
    \qml
    import QtQuick 2.9
    import org.asteroid.controls 1.0

    ValueMeter {
        width: Dims.l(28) * 1.8
        height: Dims.l(8)
        valueLowerBound: 0
        valueUpperBound: 100
        value: 75
        isIncreasing: true
        enableAnimations: true
        particleDesign: "diamonds"
    }
    \endqml
*/
Item {
    id: valueMeter

    /*!
        \qmlproperty real ValueMeter::width
        The width of the meter.
    */
    width: Dims.l(28) * 1.8

    /*!
        \qmlproperty real ValueMeter::height
        The height of the meter.
    */
    height: Dims.l(8)

    /*!
        \qmlproperty real ValueMeter::valueLowerBound
        The lower bound of the value range.
    */
    property real valueLowerBound: 0

    /*!
        \qmlproperty real ValueMeter::valueUpperBound
        The upper bound of the value range.
    */
    property real valueUpperBound: 100

    /*!
        \qmlproperty real ValueMeter::value
        The current value to display, clamped between valueLowerBound and valueUpperBound.
    */
    property real value: 0

    /*!
        \qmlproperty bool ValueMeter::isIncreasing
        Whether the meter is in an increasing state (e.g., charging for battery), enabling wave animation.
    */
    property bool isIncreasing: false

    /*!
        \qmlproperty bool ValueMeter::enableAnimations
        Enables wave and particle animations when true.
    */
    property bool enableAnimations: true

    /*!
        \qmlproperty string ValueMeter::particleDesign
        The design type for particle effects. Options: "diamonds", "bubbles", "logos", "flashes".
        \sa Particle
    */
    property string particleDesign: "diamonds"

    /*!
        \qmlproperty color ValueMeter::fillColor
        The color of the meter's fill. Defaults to a semi-transparent white.
    */
    property color fillColor: Qt.rgba(1, 1, 1, 0.3)

    Rectangle {
        id: outline
        anchors.fill: parent
        color: Qt.rgba(1, 1, 1, 0.2)
        radius: height / 2
    }

    Rectangle {
        id: fill
        height: parent.height
        width: {
            const range = valueUpperBound - valueLowerBound
            const normalizedValue = range > 0 ? (value - valueLowerBound) / range : 0
            const baseWidth = parent.width * normalizedValue
            if (isIncreasing && enableAnimations && fill.isVisible) {
                const waveAmplitude = parent.width * 0.05
                return baseWidth + waveAmplitude * Math.sin(waveTime)
            }
            return baseWidth
        }
        color: fillColor
        anchors.left: parent.left
        opacity: 1.0
        clip: true

        property real waveTime: 0
        property bool isVisible: valueMeter.visible && Qt.application.active

        NumberAnimation on waveTime {
            id: waveAnimation
            running: isIncreasing && enableAnimations && fill.isVisible
            from: 0
            to: 2 * Math.PI
            duration: 1500
            loops: Animation.Infinite
        }

        Item {
            id: particleContainer
            anchors.fill: parent
            visible: enableAnimations

            property int activeParticles: 0
            property int horizontalBand: 0
            property int spawnInterval: isIncreasing ? 200 : 750

            function createParticle() {
                if (!particleContainer.visible || !fill.isVisible || activeParticles >= 16) {
                    return
                }

                const component = Qt.createComponent("qrc:///org/asteroid/controls/qml/Particle.qml")
                if (component.status !== Component.Ready) {
                    return;
                }

                const speed = isIncreasing ? 60 : 20
                const pathLength = isIncreasing ? fill.width / 2 : fill.width
                const lifetime = isIncreasing ? 2500 : 8500
                const maxSize = fill.height / 2
                const minSize = fill.height / 6
                const isLogoOrFlash = particleDesign === "logos" || particleDesign === "flashes"
                const sizeMultiplier = isLogoOrFlash ? 1.3 : 1.0
                const opacity = 0.6

                // Use altering horizontal offsets to ensure particles a certain distance between them.
                const horizontalBand = particleContainer.horizontalBand;
                particleContainer.horizontalBand = (horizontalBand + 1) % 2;

                // Place in one of four columns altering between two depending on begin or end.
                let startX = ((horizontalBand + (isIncreasing ? 0 : 2)) * fill.width / 4);
                startX += Math.random() * (fill.width / 4)

                const endX = isIncreasing ? startX + pathLength : startX - pathLength

                const size = (minSize + Math.random() * (maxSize - minSize)) * sizeMultiplier

                const maxHeight = fill.height - size;
                const verticalBand = Math.floor(Math.random() * 3)
                const startY = (verticalBand * maxHeight / 3) + (Math.random() * maxHeight / 3)


                const particle = component.createObject(particleContainer, {
                    "x": startX,
                    "y": startY,
                    "targetX": endX,
                    "maxSize": size,
                    "lifetime": lifetime,
                    "isIncreasing": isIncreasing,
                    "design": particleDesign,
                    "opacity": opacity,
                    "clipBounds": Qt.rect(0, 0, fill.width, fill.height)
                })

                if (particle !== null) {
                    particle.finished.connect(() => {
                        particle.destroy();
                        activeParticles--;
                    });
                    activeParticles++;
                }
            }

            Timer {
                id: particleTimer
                interval: particleContainer.spawnInterval
                running: fill.width > 0 && enableAnimations && particleContainer.visible && fill.isVisible
                repeat: true
                triggeredOnStart: true
                onTriggered: {
                    particleContainer.createParticle()
                }
            }
        }
    }

    layer.enabled: true
    layer.effect: OpacityMask {
        maskSource: Item {
            width: valueMeter.width
            height: valueMeter.height
            Rectangle { anchors.fill: parent; radius: outline.radius }
        }
    }
}

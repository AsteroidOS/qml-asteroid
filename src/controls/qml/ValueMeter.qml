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
        isActive: true
        enableAnimations: true
        enableColoredFill: false
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
        \qmlproperty bool ValueMeter::enableColoredFill
        Enables colored fill based on value thresholds when true.
    */
    property bool enableColoredFill: false

    /*!
        \qmlproperty string ValueMeter::particleDesign
        The design type for particle effects. Options: "diamonds", "bubbles", "logos", "flashes".
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
            var range = valueUpperBound - valueLowerBound
            var normalizedValue = range > 0 ? (value - valueLowerBound) / range : 0
            var baseWidth = parent.width * Math.min(Math.max(normalizedValue, 0), 1)
            if (isIncreasing && enableAnimations && fill.isVisible) {
                var waveAmplitude = parent.width * 0.05
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

            property int particleCount: 5
            property int activeParticles: 0
            property int nextHorizontalBand: 0
            property int spawnInterval: 300

            Component {
                id: cleanupTimerComponent
                Timer {
                    id: cleanupTimer
                    interval: 0
                    running: true
                    repeat: false
                    onTriggered: {
                        particleContainer.activeParticles--
                    }
                }
            }

            function createParticle() {
                if (!particleContainer.visible || !fill.isVisible || activeParticles >= 16) {
                    return
                }
                var component = Qt.createComponent("qrc:///org/asteroid/controls/qml/Particle.qml")
                if (component.status === Component.Ready) {
                    var speed = isIncreasing ? 60 : 20
                    var pathLength = isIncreasing ? fill.width / 2 : fill.width
                    var lifetime = isIncreasing ? 2500 : 8500
                    particleContainer.spawnInterval = isIncreasing ? 200 : 750
                    var maxSize = fill.height / 2
                    var minSize = fill.height / 6
                    var designType = particleDesign || "diamonds"
                    var isLogoOrFlash = designType === "logos" || designType === "flashes"
                    var sizeMultiplier = isLogoOrFlash ? 1.3 : 1.0
                    var opacity = 0.6

                    var horizontalBand = particleContainer.nextHorizontalBand
                    var startX = isIncreasing ?
                        (horizontalBand === 0 ? Math.random() * (fill.width / 4) : (fill.width / 4) + Math.random() * (fill.width / 4)) :
                        (horizontalBand === 0 ? fill.width / 2 + Math.random() * (fill.width / 4) : (3 * fill.width / 4) + Math.random() * (fill.width / 4))
                    particleContainer.nextHorizontalBand = (horizontalBand + 1) % 2

                    var endX = isIncreasing ? startX + pathLength : startX - pathLength

                    var band = Math.floor(Math.random() * 3)
                    var startY = (band * fill.height / 3) + (Math.random() * fill.height / 3)

                    var size = (minSize + Math.random() * (maxSize - minSize)) * sizeMultiplier

                    var particle = component.createObject(particleContainer, {
                        "x": startX,
                        "y": startY,
                        "targetX": endX,
                        "maxSize": size,
                        "lifetime": lifetime,
                        "isIncreasing": isIncreasing,
                        "design": designType,
                        "opacity": opacity,
                        "clipBounds": Qt.rect(0, 0, fill.width, fill.height)
                    })
                    if (particle !== null) {
                        activeParticles++
                        var cleanupTimer = cleanupTimerComponent.createObject(particleContainer, {
                            "interval": lifetime
                        })
                    }
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

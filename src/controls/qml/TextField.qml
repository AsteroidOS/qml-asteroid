/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Virtual Keyboard module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:GPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.9
import QtQuick.VirtualKeyboard 2.1

/*!
    \qmltype TextField
    \inqmlmodule org.asteroid.controls

    \brief Editable text field.

    The TextField type provides an editable text field which can
    use a virtual keyboard to accept text.  The default 
    virtual keyboard for AsteroidOS is the \l HandWritingKeyboard
    which is used in this example.  In this example, a simple 
    TextField is created in the center of the screen with 
    preview text "sample text".  The preview text is intended to
    convey what kind of input is being asked but the actual value
    of the field once filled in is \l text.

    \qml
    import QtQuick 2.9
    import org.asteroid.controls 1.0

    Item {
        HandWritingKeyboard {
            anchors.fill: parent
        }
        
        TextField {
            width: parent.width * 0.8
            textWidth: parent.width *0.75
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
            previewText: "sample text"
        }
    }
    \endqml

*/
TextBase {
    id: textField

    /*! Text color */
    property alias color: textInput.color
    /*! The input text */
    property alias text: textInput.text
    /*! The input text width */
    property alias textWidth: textInput.width
    /*! Whether to make the field read-only */
    property alias readOnly: textInput.readOnly
    /*! See TextInput::inputMethodHints */
    property alias inputMethodHints: textInput.inputMethodHints
    /*! See TextInput::validator */
    property alias validator: textInput.validator
    /*! See TextInput::echoMode */
    property alias echoMode: textInput.echoMode
    /*! Delay time from when a letter is input to when it is obscured */
    property int passwordMaskDelay: 1000

    editor: textInput

    Flickable {
        id: flickable

        x: 12
        clip: true
        width: parent.width-24
        height: parent.height
        flickableDirection: Flickable.HorizontalFlick
        interactive: contentWidth - 4 > width

        contentWidth: textInput.width+2
        contentHeight: textInput.height
        TextInput {
            id: textInput

            EnterKeyAction.actionId: textField.enterKeyAction
            EnterKeyAction.label: textField.enterKeyText
            EnterKeyAction.enabled: textField.enterKeyEnabled

            y: 6
            focus: true
            color: "#2B2C2E"
            cursorVisible: activeFocus
            passwordCharacter: "\u2022"
            font.pixelSize: textField.fontPixelSize
            selectionColor: Qt.rgba(0.0, 0.0, 0.0, 0.15)
            selectedTextColor: color
            selectByMouse: true
            width: Math.max(flickable.width, implicitWidth)-2

            Binding {
                target: textInput
                property: "passwordMaskDelay"
                value: textField.passwordMaskDelay
                when: textInput.hasOwnProperty("passwordMaskDelay")
            }
        }
    }
}

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
import QtQuick.VirtualKeyboard 2.15

/*!
    \qmltype TextArea
    \inqmlmodule AsteroidControls

    \brief Editable multi-line text field.

    The TextArea provides an editable multiline area which
    can use a virtual keyboard to accept text. The default 
    virtual keyboard for AsteroidOS is the \l HandWritingKeyboard
    which is used in this example.  In this example, a simple 
    \l TextArea is created in the upper left corner of the screen.

    \qml
    import QtQuick 2.9
    import org.asteroid.controls 1.0

    Item {
        HandWritingKeyboard {
            anchors.fill: parent
        }
        TextArea {
            width: parent.width * 0.8
            height: parent.height * 0.8
            anchors.top: parent.top
        }
    }
    \endqml
*/
TextBase {
    id: textArea

    /*! Text color */
    property alias color: textEdit.color
    /*! The input text */
    property alias text: textEdit.text
    /*! The input text width */
    property alias textWidth: textEdit.width
    /*! Whether to make the field read-only */
    property alias readOnly: textEdit.readOnly
    /*! See TextInput::inputMethodHints */
    property alias inputMethodHints: textEdit.inputMethodHints

    editor: textEdit

    Repeater {
        model: Math.floor((parent.height - 30) / editor.cursorRectangle.height)
        Rectangle {
            x: 8
            y: (index+1)*editor.cursorRectangle.height+6
            height: 1; width: textArea.width-24
            color: "#D6D6D6"
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: textEdit.forceActiveFocus()
    }
    TextEdit {
        id: textEdit

        EnterKeyAction.actionId: textArea.enterKeyAction
        EnterKeyAction.label: textArea.enterKeyText
        EnterKeyAction.enabled: textArea.enterKeyEnabled

        y: 6
        focus: true
        color: "#2B2C2E"
        wrapMode: TextEdit.Wrap
        cursorVisible: activeFocus
        height: Math.max(implicitHeight, 60)
        font.pixelSize: textArea.fontPixelSize
        selectionColor: Qt.rgba(1.0, 1.0, 1.0, 0.5)
        selectedTextColor: Qt.rgba(0.0, 0.0, 0.0, 0.8)
        selectByMouse: true
        anchors { left: parent.left; right: parent.right; margins: 12 }
    }
}

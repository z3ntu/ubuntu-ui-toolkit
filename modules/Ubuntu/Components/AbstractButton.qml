/*
 * Copyright 2012 Canonical Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0

/*!
    \qmlabstract AbstractButton
    \inqmlmodule Ubuntu.Components 0.1
    \ingroup ubuntu
    \brief The AbstractButton class defines the behavior of the button.

    \b{This component is under heavy development.}

    This class defines the behavior of the button: it defines the MouseArea
    and the states.
*/
Item {
    id: button

    /*!
      If an action is specified, the button's clicked signal will trigger the action.
      Subclasses of AbstractButton can use other properties of action (for example
      the text and iconSource).
     */
    property Action action

    visible: action ? action.visible : true
    enabled: action ? action.enabled : true

    /*!
       This handler is called when there is a mouse click on the button
       and the button is not disabled. If \l action is defined,
       the action will be triggered.
    */
    signal clicked()

    /*!
      If \l action was set, action.triggered() is automatically called with
      the AbstractButton as parameter.
     */
    onClicked: if (action) action.triggered(button)

    Keys.onEnterPressed: clicked()
    Keys.onReturnPressed: clicked()

    /*!
      This handler is called when there is a long press.
     */
    signal pressAndHold()

    /*!
      True if the user presses a mouse button in the button's mouse area.
     */
    property bool pressed: mouseArea.pressed

    /*!
      True if the mouse cursor hovers over the button's mouse area.
     */
    property bool hovered: __acceptEvents && mouseArea.containsMouse

    /*!
      \internal
      Disable or enable signal emition by default.
      Some classes want to emit the signal by themselves (ListItem.Standard)
     */
    property bool __acceptEvents: true

    /*!
      \internal
      To get the properties of the mouse area in subclasses.
     */
    property alias __mouseArea: mouseArea

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        // if mouseArea is given a new value, disable defaultMouseArea
        // as it might occlude the newly assigned mouse area.
        hoverEnabled: true

        onClicked: {
            if (button.__acceptEvents) {
                button.clicked()
            }
        }
        onPressAndHold: {
            if (button.__acceptEvents) {
                button.pressAndHold()
            }
        }
    }
}

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
import Ubuntu.Components 1.0

/*!
    \qmltype ThinDivider
    \inqmlmodule Ubuntu.Components.ListItems 1.0
    \ingroup ubuntu-listitems
    \brief Narrow line used as a divider between ListItems.

    ListItems will usually include this line at the bottom of the item
    to give a visually pleasing list of items. But a divider line can
    also be inserted manually using this component.
    \b{This component is under heavy development.}

    Examples:
    \qml
        import Ubuntu.Components.ListItems 1.0 as ListItem
        Column {
            width: 250
            ListItem.ThinDivider {} //can be used as header for list
            ListItem.Standard {
                text: "List Item without thin divider line"
                showDivider: false
            }
            ListItem.ThinDivider {} // manually inserted divider line
            ListItem.Standard {
                text: "ListItem with thin divider line"
            }
        }
    \endqml
*/
Rectangle {
    anchors {
        left: (parent) ? parent.left : null
        right: (parent) ? parent.right : null
        leftMargin: units.gu(2)
        rightMargin: units.gu(2)
    }
    height: (visible) ? units.dp(2) : 0
    property bool __lightBackground: ColorUtils.luminance(Theme.palette.normal.background) > 0.85
    gradient: Gradient {
        GradientStop { position: 0.0; color: __lightBackground ? "#26000000" : "#26FFFFFF" }
        GradientStop { position: 0.49; color: __lightBackground ? "#26000000" : "#26FFFFFF" }
        GradientStop { position: 0.5; color: __lightBackground ? "#14FFFFFF" : "#14000000" }
        GradientStop { position: 1.0; color: __lightBackground ? "#14FFFFFF" : "#14000000" }
    }
}

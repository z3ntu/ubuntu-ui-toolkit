/*
 * Copyright 2014 Canonical Ltd.
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

#include "ucunits.h"
#include "uctheme.h"
#include "uclistitem.h"
#include "uclistitem_p.h"
#include "propertychange_p.h"
#include <QtQuick/private/qquickflickable_p.h>

/*
 * The properties are attached to the ListItem's parent item or to its closest
 * Flickable parent, when embedded in ListView or Flickable. There will be only
 * one attached property per Flickable for all embedded child ListItems, enabling
 * in this way the controlling of the interactive flag of the Flickable and all
 * its ascendant Flickables.
 */
UCListItemAttachedPrivate::UCListItemAttachedPrivate(UCListItemAttached *qq)
    : q_ptr(qq)
    , globalDisabled(false)
{
}

UCListItemAttachedPrivate::~UCListItemAttachedPrivate()
{
    // clear property change objects
    Q_Q(UCListItemAttached);
    Q_FOREACH(const Record &record, list) {
        if (record.flickable.data()) {
            QObject::disconnect(record.flickable.data(), &QQuickFlickable::movementStarted,
                                q, &UCListItemAttached::unbindItem);
        }
        // deleting PropertyChange will restore the saved property
        // to its original binding/value
        delete record.interactive;
    }
}

void UCListItemAttachedPrivate::init()
{
    // collect all ascendant flickables
    Q_Q(UCListItemAttached);
    QQuickItem *item = qobject_cast<QQuickItem*>(q->parent());
    if (!item) {
        return;
    }
    while (item) {
        QQuickFlickable *flickable = qobject_cast<QQuickFlickable*>(item);
        if (flickable) {
            Record record;
            record.flickable = flickable;
            record.interactive = new PropertyChange(item, "interactive");
            list.append(record);
            QObject::connect(flickable, &QQuickFlickable::movementStarted,
                             q, &UCListItemAttached::unbindItem);
        }
        item = item->parentItem();
    }
}

UCListItemAttached::UCListItemAttached(QObject *owner)
    : QObject(owner)
    , d_ptr(new UCListItemAttachedPrivate(this))
{
    d_ptr->init();
}

UCListItemAttached::~UCListItemAttached()
{
}

// register item to be rebount
bool UCListItemAttached::listenToRebind(UCListItem *item, bool listen)
{
    // we cannot bind the item until we have an other one bount
    bool result = false;
    Q_D(UCListItemAttached);
    if (listen) {
        if (d->bountItem.isNull() || (d->bountItem == item)) {
            d->bountItem = item;
            result = true;
        }
    } else if (d->bountItem == item) {
        d->bountItem.clear();
        result = true;
    }
    return result;
}

// reports true if any of the ascendant flickables is moving
bool UCListItemAttached::isMoving()
{
    Q_D(UCListItemAttached);
    Q_FOREACH(const UCListItemAttachedPrivate::Record &record, d->list) {
        if (record.flickable && record.flickable->isMoving()) {
            return true;
        }
    }
    return false;
}

// returns true if the given ListItem is bount to listen on moving changes
bool UCListItemAttached::isBountTo(UCListItem *item)
{
    Q_D(UCListItemAttached);
    return d->bountItem == item;
}

/*
 * Disable/enable interactive flag for the ascendant flickables. The item is used
 * to detect whether the sam item is trying to enable the flickables which disabled
 * it before. The enabled/disabled states are not equivalent to the enabled/disabled
 * state of the interactive flag.
 * When disabled, always the last item disabling will be kept as active disabler,
 * and only the active disabler can enable (restore) the interactive flag state.
 */
void UCListItemAttached::disableInteractive(UCListItem *item, bool disable)
{
    Q_D(UCListItemAttached);
    if ((d->globalDisabled && disable) || (!d->globalDisabled && disable)) {
        // disabling or re-disabling
        d->disablerItem = item;
        if (d->globalDisabled == disable) {
            // was already disabled, leave
            return;
        }
        d->globalDisabled = disable;
    } else if (d->globalDisabled && !disable && d->disablerItem == item) {
        // the one disabled it will enable
        d->globalDisabled = disable;
        d->disablerItem.clear();
    } else {
        // none of the above, leave
        return;
    }
    Q_FOREACH(const UCListItemAttachedPrivate::Record &record, d->list) {
        if (disable) {
            PropertyChange::setValue(record.interactive, false);
        } else {
            PropertyChange::restore(record.interactive);
        }
    }
}

void UCListItemAttached::unbindItem()
{
    Q_D(UCListItemAttached);
    if (d->bountItem) {
        // depending on content item's X coordinate, we either rebound or prompt drop
        if (d->bountItem->contentItem()->x() != 0.0) {
            // content is not in origin, rebind
            UCListItemPrivate::get(d->bountItem.data())->_q_rebound();
        } else {
            // do some cleanup
            UCListItemPrivate::get(d->bountItem.data())->promptRebound();
        }
        d->bountItem.clear();
    }
}

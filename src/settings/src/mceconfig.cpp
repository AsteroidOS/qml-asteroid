/*
 * Copyright (C) 2026 - Florent Revest <revestflo@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

#include "mceconfig.h"

#include <QDBusConnection>
#include <QDBusInterface>
#include <QDBusPendingCall>
#include <QDBusPendingCallWatcher>
#include <QDBusPendingReply>
#include <QDBusObjectPath>
#include <QDBusVariant>

static const char *MCE_SERVICE      = "com.nokia.mce";
static const char *MCE_REQUEST_PATH = "/com/nokia/mce/request";
static const char *MCE_REQUEST_IF   = "com.nokia.mce.request";
static const char *MCE_SIGNAL_PATH  = "/com/nokia/mce/signal";
static const char *MCE_SIGNAL_IF    = "com.nokia.mce.signal";

MceConfig::MceConfig(QObject *parent) : QObject(parent)
{
    QDBusConnection::systemBus().connect(
        MCE_SERVICE, MCE_SIGNAL_PATH, MCE_SIGNAL_IF, "config_change_ind",
        this, SLOT(onConfigChangeInd(QDBusObjectPath, QDBusVariant)));
}

void MceConfig::get(const QString &key, std::function<void(const QVariant &)> cb)
{
    QDBusInterface iface(MCE_SERVICE, MCE_REQUEST_PATH, MCE_REQUEST_IF,
                         QDBusConnection::systemBus());
    QDBusPendingCall call = iface.asyncCall("get_config", QVariant::fromValue(QDBusObjectPath(key)));
    auto *watcher = new QDBusPendingCallWatcher(call, this);
    connect(watcher, &QDBusPendingCallWatcher::finished, this,
            [cb](QDBusPendingCallWatcher *w) {
        QDBusPendingReply<QDBusVariant> reply = *w;
        w->deleteLater();
        cb(reply.isError() ? QVariant() : reply.value().variant());
    });
}

void MceConfig::set(const QString &key, const QVariant &value)
{
    QDBusInterface iface(MCE_SERVICE, MCE_REQUEST_PATH, MCE_REQUEST_IF,
                         QDBusConnection::systemBus());
    iface.asyncCall("set_config", QVariant::fromValue(QDBusObjectPath(key)),
                    QVariant::fromValue(QDBusVariant(value)));
}

void MceConfig::onConfigChangeInd(const QDBusObjectPath &key, const QDBusVariant &value)
{
    emit configChanged(key.path(), value.variant());
}

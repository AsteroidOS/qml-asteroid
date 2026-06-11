/*
 * Copyright (C) 2026 - Florent Revest <revestflo@gmail.com>
 * Copyright (C) 2013 Jolla Ltd. <pekka.vuorela@jollamobile.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 */

#include "profilecontrol.h"

#include <QDBusConnection>
#include <QDBusInterface>
#include <QDBusPendingCall>
#include <QDBusPendingCallWatcher>
#include <QDBusPendingReply>

static const char *PROFILED_SERVICE = "com.nokia.profiled";
static const char *PROFILED_PATH    = "/com/nokia/profiled";
static const char *PROFILED_IFACE   = "com.nokia.profiled";

ProfileControl::ProfileControl(QObject *parent) : QObject(parent)
{
    // profiled emits profile_changed(b changed, b active, s profile, a(sss) values)
    QDBusConnection::sessionBus().connect(
        PROFILED_SERVICE, PROFILED_PATH, PROFILED_IFACE, "profile_changed",
        this, SLOT(onProfileChanged(bool, bool, QString)));

    // Seed the current profile asynchronously.
    QDBusInterface iface(PROFILED_SERVICE, PROFILED_PATH, PROFILED_IFACE,
                         QDBusConnection::sessionBus());
    QDBusPendingCall call = iface.asyncCall("get_profile");
    auto *watcher = new QDBusPendingCallWatcher(call, this);
    connect(watcher, &QDBusPendingCallWatcher::finished, this,
            [this](QDBusPendingCallWatcher *w) {
        QDBusPendingReply<QString> reply = *w;
        w->deleteLater();
        if (!reply.isError() && m_profile != reply.value()) {
            m_profile = reply.value();
            emit profileChanged();
        }
    });
}

void ProfileControl::setProfile(const QString &profile)
{
    if (m_profile == profile)
        return;
    // Optimistically update; profile_changed will confirm.
    m_profile = profile;
    emit profileChanged();

    QDBusInterface iface(PROFILED_SERVICE, PROFILED_PATH, PROFILED_IFACE,
                         QDBusConnection::sessionBus());
    iface.asyncCall("set_profile", profile);
}

void ProfileControl::onProfileChanged(bool changed, bool /*active*/, const QString &profile)
{
    if (changed && m_profile != profile) {
        m_profile = profile;
        emit profileChanged();
    }
}

/*
 * Copyright (C) 2026 - Florent Revest <revestflo@gmail.com>
 * Copyright (C) 2013 Jolla Ltd. <pekka.vuorela@jollamobile.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

#include "datetimesettings.h"

#include <QDBusConnection>
#include <QDBusInterface>
#include <QDateTime>
#include <QTimeZone>

static const char *TD_SERVICE = "org.freedesktop.timedate1";
static const char *TD_PATH    = "/org/freedesktop/timedate1";
static const char *TD_IFACE   = "org.freedesktop.timedate1";

DateTimeSettings::DateTimeSettings(QObject *parent) : QObject(parent) {}

void DateTimeSettings::applyEpoch(qint64 secsSinceEpoch)
{
    QDBusInterface iface(TD_SERVICE, TD_PATH, TD_IFACE, QDBusConnection::systemBus());
    // SetTime(usec_utc, relative=false, interactive=false)
    iface.asyncCall("SetTime", qint64(secsSinceEpoch * 1000000LL), false, false);
}

void DateTimeSettings::setTime(int hour, int minute)
{
    QDateTime now = QDateTime::currentDateTime();
    QDateTime target(now.date(), QTime(hour, minute, 0));
    applyEpoch(target.toSecsSinceEpoch());
}

void DateTimeSettings::setDate(const QDate &date)
{
    QDateTime now = QDateTime::currentDateTime();
    QDateTime target(date, now.time());
    applyEpoch(target.toSecsSinceEpoch());
}

void DateTimeSettings::setTimezone(const QString &timezone)
{
    QDBusInterface iface(TD_SERVICE, TD_PATH, TD_IFACE, QDBusConnection::systemBus());
    // SetTimezone(name, interactive=false)
    iface.asyncCall("SetTimezone", timezone, false);
}

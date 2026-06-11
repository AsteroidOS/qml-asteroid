/*
 * Copyright (C) 2026 - Florent Revest <revestflo@gmail.com>
 * Copyright (C) 2013 Jolla Ltd. <pekka.vuorela@jollamobile.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

#include "aboutsettings.h"

#include <QFile>
#include <QTextStream>
#include <QDir>

AboutSettings::AboutSettings(QObject *parent) : QObject(parent) {}

void AboutSettings::ensureOsRelease()
{
    if (m_osReleaseParsed)
        return;
    m_osReleaseParsed = true;

    QFile f("/etc/os-release");
    if (!f.open(QIODevice::ReadOnly | QIODevice::Text))
        return;

    QTextStream in(&f);
    while (!in.atEnd()) {
        const QString line = in.readLine().trimmed();
        const int eq = line.indexOf('=');
        if (eq < 0)
            continue;
        const QString key = line.left(eq);
        QString val = line.mid(eq + 1);
        if (val.startsWith('"') && val.endsWith('"') && val.size() >= 2)
            val = val.mid(1, val.size() - 2);
        if (key == "NAME")
            m_osName = val;
        else if (key == "VERSION_ID" && m_osVersion.isEmpty())
            m_osVersion = val;
        else if (key == "VERSION")
            m_osVersion = val;
    }
}

QString AboutSettings::operatingSystemName()
{
    ensureOsRelease();
    return m_osName;
}

QString AboutSettings::softwareVersion()
{
    ensureOsRelease();
    return m_osVersion;
}

QString AboutSettings::wlanMacAddress()
{
    // First wireless interface's permanent address.
    const QDir net("/sys/class/net");
    for (const QString &iface : net.entryList(QDir::Dirs | QDir::NoDotAndDotDot)) {
        if (!QFile::exists("/sys/class/net/" + iface + "/wireless"))
            continue;
        QFile addr("/sys/class/net/" + iface + "/address");
        if (addr.open(QIODevice::ReadOnly))
            return QString::fromUtf8(addr.readAll()).trimmed().toUpper();
    }
    return QString();
}

QString AboutSettings::serial()
{
    static const QStringList candidates = {
        "/config/serial/serial.txt",
        "/run/config/serial",
        "/sys/firmware/devicetree/base/firmware/android/serialno",
    };
    for (const QString &path : candidates) {
        QFile f(path);
        if (f.exists() && f.open(QIODevice::ReadOnly))
            return QString::fromUtf8(f.readAll()).trimmed();
    }
    return QString();
}

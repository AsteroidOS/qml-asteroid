/*
 * Copyright (C) 2026 - Florent Revest <revestflo@gmail.com>
 * Copyright (C) 2013 - 2019 Jolla Ltd.
 * Copyright (c) 2019 Open Mobile Platform LLC.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 */

#ifndef ABOUTSETTINGS_H
#define ABOUTSETTINGS_H

#include <QObject>
#include <QString>

class AboutSettings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString operatingSystemName READ operatingSystemName CONSTANT)
    Q_PROPERTY(QString softwareVersion     READ softwareVersion     CONSTANT)
    Q_PROPERTY(QString wlanMacAddress      READ wlanMacAddress      CONSTANT)
    Q_PROPERTY(QString serial              READ serial              CONSTANT)

public:
    explicit AboutSettings(QObject *parent = nullptr);

    QString operatingSystemName();
    QString softwareVersion();
    QString wlanMacAddress();
    QString serial();

private:
    void ensureOsRelease();
    QString m_osName;
    QString m_osVersion;
    bool    m_osReleaseParsed = false;
};

#endif // ABOUTSETTINGS_H

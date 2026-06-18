/*
 * Copyright (C) 2026 - Florent Revest <revestflo@gmail.com>
 * Copyright (C) 2013 Jolla Ltd. <pekka.vuorela@jollamobile.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 */

#ifndef DATETIMESETTINGS_H
#define DATETIMESETTINGS_H

#include <QObject>
#include <QDate>

class DateTimeSettings : public QObject
{
    Q_OBJECT
public:
    explicit DateTimeSettings(QObject *parent = nullptr);

    Q_INVOKABLE void setTime(int hour, int minute);
    Q_INVOKABLE void setDate(const QDate &date);
    Q_INVOKABLE void setTimezone(const QString &timezone);
    Q_INVOKABLE QString currentTimezone() const;

private:
    void applyEpoch(qint64 secsSinceEpoch);
};

#endif // DATETIMESETTINGS_H

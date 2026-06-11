/*
 * Copyright (C) 2026 - Florent Revest <revestflo@gmail.com>
 * Copyright (C) 2013 Jolla Ltd. <pekka.vuorela@jollamobile.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 */

#ifndef PROFILECONTROL_H
#define PROFILECONTROL_H

#include <QObject>
#include <QString>

class ProfileControl : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString profile READ profile WRITE setProfile NOTIFY profileChanged)

public:
    explicit ProfileControl(QObject *parent = nullptr);

    QString profile() const { return m_profile; }
    void setProfile(const QString &profile);

signals:
    void profileChanged();

private slots:
    void onProfileChanged(bool changed, bool active, const QString &profile);

private:
    QString m_profile;
};

#endif // PROFILECONTROL_H

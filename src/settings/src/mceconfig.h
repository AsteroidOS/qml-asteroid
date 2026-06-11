/*
 * Copyright (C) 2026 - Florent Revest <revestflo@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

#ifndef MCECONFIG_H
#define MCECONFIG_H

#include <QObject>
#include <QVariant>
#include <QString>
#include <QDBusObjectPath>
#include <QDBusVariant>
#include <functional>

/*
 * Tiny helper around MCE's builtin-gconf config interface
 * (com.nokia.mce, /com/nokia/mce/request, methods get_config/set_config taking
 * the config key as an object path).
 *
 * All reads are async; callers pass a callback. A single instance also
 * subscribes to com.nokia.mce.signal config_change_ind and reports changes.
 */
class MceConfig : public QObject
{
    Q_OBJECT
public:
    explicit MceConfig(QObject *parent = nullptr);

    // Async get; cb is invoked with the value (invalid QVariant on error).
    void get(const QString &key, std::function<void(const QVariant &)> cb);
    // Fire-and-forget set.
    void set(const QString &key, const QVariant &value);

signals:
    // Emitted when MCE reports a config change for any key we care about.
    void configChanged(const QString &key, const QVariant &value);

private slots:
    void onConfigChangeInd(const QDBusObjectPath &key, const QDBusVariant &value);
};

#endif // MCECONFIG_H

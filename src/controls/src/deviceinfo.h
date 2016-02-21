/*
 * Qt Quick Controls Asteroid - User interface components for AsteroidOS
 *
 * Copyright (C) 2015 - Florent Revest <revestflo@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef DEVICEINFO_H
#define DEVICEINFO_H

#include <QObject>
#include <QJSEngine>
#include <QQmlEngine>

class DeviceInfo : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(DeviceInfo)
    Q_PROPERTY(bool hasRoundScreen READ hasRoundScreen CONSTANT)
    DeviceInfo() {}
public:
    static QObject *qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine)
    {
        Q_UNUSED(engine);
        Q_UNUSED(scriptEngine);

        return new DeviceInfo;
    }
    bool hasRoundScreen();
};

#endif // DEVICEINFO_H

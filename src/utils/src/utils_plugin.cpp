/*
 * Copyright (C) 2016 - Florent Revest <revestflo@gmail.com>
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

#include "utils_plugin.h"
#include <QtQml>
#include "bluetoothstatus.h"
#include "deviceinfo.h"

UtilsPlugin::UtilsPlugin(QObject *parent) : QQmlExtensionPlugin(parent)
{
}

void UtilsPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("org.asteroid.utils"));

    qmlRegisterSingletonType<DeviceInfo>(uri, 1,0, "DeviceInfo", &DeviceInfo::qmlInstance);
    qmlRegisterType<BluetoothStatus>(uri, 1, 0, "BluetoothStatus");
}


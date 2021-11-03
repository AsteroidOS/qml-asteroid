/*
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

#include "deviceinfo.h"
#include <QFile>

const char* CONFIG_FILE = "/etc/asteroid/machine.conf";

DeviceInfo::DeviceInfo()
    : m_settings(CONFIG_FILE, QSettings::IniFormat)
{
    QSettings::Status status(m_settings.status());
    if (status == QSettings::FormatError ) {
        qWarning("Configuration file \"%s\" is in wrong format", CONFIG_FILE);
    } else if (status != QSettings::NoError) {
        qWarning("Unable to open \"%s\" configuration file", CONFIG_FILE);
    }
}

bool DeviceInfo::hasRoundScreen()
{
    return m_settings.value("Display/ROUND", false).toBool();
}

double DeviceInfo::borderGestureWidth()
{
    return m_settings.value("Display/BORDER_GESTURE_WIDTH", 0.1).toFloat();
}

int DeviceInfo::flatTireHeight()
{
    return m_settings.value("Display/FLAT_TIRE", 0).toInt();
}

bool DeviceInfo::needsBurnInProtection()
{
    return m_settings.value("Display/NEEDS_BURN_IN_PROTECTION", true).toBool();
}

bool DeviceInfo::hasWlan()
{
    return m_settings.value("Capabilities/HAS_WLAN", false).toBool();
}

bool DeviceInfo::hasSpeaker()
{
    return m_settings.value("Capabilities/HAS_SPEAKER", false).toBool();
}


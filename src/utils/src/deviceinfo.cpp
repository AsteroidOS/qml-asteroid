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

bool DeviceInfo::hasRoundScreen()
{
#ifdef ROUND_SCREEN
    return true;
#else
    return false;
#endif
}

double DeviceInfo::borderGestureWidth()
{
#ifdef BORDER_GESTURE_WIDTH
    return BORDER_GESTURE_WIDTH;
#else
    return 0.1;
#endif
}

int DeviceInfo::flatTireHeight()
{
#ifdef FLAT_TIRE
    return FLAT_TIRE;
#else
    return 0;
#endif
}

bool DeviceInfo::hasWlan()
{
#ifdef HAS_WLAN
    return true;
#else
    return false;
#endif
}

bool DeviceInfo::hasSpeaker()
{
#ifdef HAS_SPEAKER
    return true;
#else
    return false;
#endif
}


/*
 * Copyright (C) 2026 - Florent Revest <revestflo@gmail.com>
 * Copyright (C) 2013 Jolla Ltd. <pekka.vuorela@jollamobile.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

#include "displaysettings.h"
#include "mceconfig.h"

// MCE builtin-gconf config keys
static const QString KeyBrightness    = "/system/osso/dsm/display/display_brightness";
static const QString KeyMaxBrightness = "/system/osso/dsm/display/max_display_brightness_levels";
static const QString KeyLowPowerMode  = "/system/osso/dsm/display/use_low_power_mode";
static const QString KeyAlsEnabled    = "/system/osso/dsm/display/als_enabled";

DisplaySettings::DisplaySettings(QObject *parent) : QObject(parent), m_mce(new MceConfig(this))
{
    // Seed from MCE asynchronously (no blocking on construction).
    m_mce->get(KeyMaxBrightness, [this](const QVariant &v) {
        if (v.isValid() && m_maximumBrightness != v.toInt()) {
            m_maximumBrightness = v.toInt();
            emit maximumBrightnessChanged();
        }
    });
    m_mce->get(KeyBrightness, [this](const QVariant &v) {
        if (v.isValid() && m_brightness != v.toInt()) {
            m_brightness = v.toInt();
            emit brightnessChanged();
        }
    });
    m_mce->get(KeyLowPowerMode, [this](const QVariant &v) {
        if (v.isValid() && m_lowPowerModeEnabled != v.toBool()) {
            m_lowPowerModeEnabled = v.toBool();
            emit lowPowerModeEnabledChanged();
        }
    });
    m_mce->get(KeyAlsEnabled, [this](const QVariant &v) {
        if (v.isValid() && m_ambientLightSensorEnabled != v.toBool()) {
            m_ambientLightSensorEnabled = v.toBool();
            emit ambientLightSensorEnabledChanged();
        }
    });

    // Keep in sync when something else (e.g. MCE itself) changes a key.
    connect(m_mce, &MceConfig::configChanged, this, [this](const QString &key, const QVariant &v) {
        if (key == KeyBrightness && m_brightness != v.toInt()) {
            m_brightness = v.toInt(); emit brightnessChanged();
        } else if (key == KeyMaxBrightness && m_maximumBrightness != v.toInt()) {
            m_maximumBrightness = v.toInt(); emit maximumBrightnessChanged();
        } else if (key == KeyLowPowerMode && m_lowPowerModeEnabled != v.toBool()) {
            m_lowPowerModeEnabled = v.toBool(); emit lowPowerModeEnabledChanged();
        } else if (key == KeyAlsEnabled && m_ambientLightSensorEnabled != v.toBool()) {
            m_ambientLightSensorEnabled = v.toBool(); emit ambientLightSensorEnabledChanged();
        }
    });
}

void DisplaySettings::setBrightness(int value)
{
    if (m_brightness == value)
        return;
    m_brightness = value;
    m_mce->set(KeyBrightness, value);
    emit brightnessChanged();
}

void DisplaySettings::setLowPowerModeEnabled(bool enabled)
{
    if (m_lowPowerModeEnabled == enabled)
        return;
    m_lowPowerModeEnabled = enabled;
    m_mce->set(KeyLowPowerMode, enabled);
    emit lowPowerModeEnabledChanged();
}

void DisplaySettings::setAmbientLightSensorEnabled(bool enabled)
{
    if (m_ambientLightSensorEnabled == enabled)
        return;
    m_ambientLightSensorEnabled = enabled;
    m_mce->set(KeyAlsEnabled, enabled);
    emit ambientLightSensorEnabledChanged();
}

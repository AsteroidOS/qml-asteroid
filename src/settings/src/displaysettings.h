/*
 * Copyright (C) 2026 - Florent Revest <revestflo@gmail.com>
 * Copyright (C) 2013 Jolla Ltd. <pekka.vuorela@jollamobile.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 */

#ifndef DISPLAYSETTINGS_H
#define DISPLAYSETTINGS_H

#include <QObject>

class MceConfig;

class DisplaySettings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int  brightness                 READ brightness                 WRITE setBrightness                 NOTIFY brightnessChanged)
    Q_PROPERTY(int  maximumBrightness          READ maximumBrightness                                              NOTIFY maximumBrightnessChanged)
    Q_PROPERTY(bool lowPowerModeEnabled        READ lowPowerModeEnabled        WRITE setLowPowerModeEnabled        NOTIFY lowPowerModeEnabledChanged)
    Q_PROPERTY(bool ambientLightSensorEnabled  READ ambientLightSensorEnabled  WRITE setAmbientLightSensorEnabled  NOTIFY ambientLightSensorEnabledChanged)

public:
    explicit DisplaySettings(QObject *parent = nullptr);

    int  brightness() const                { return m_brightness; }
    int  maximumBrightness() const         { return m_maximumBrightness; }
    bool lowPowerModeEnabled() const       { return m_lowPowerModeEnabled; }
    bool ambientLightSensorEnabled() const { return m_ambientLightSensorEnabled; }

    void setBrightness(int value);
    void setLowPowerModeEnabled(bool enabled);
    void setAmbientLightSensorEnabled(bool enabled);

signals:
    void brightnessChanged();
    void maximumBrightnessChanged();
    void lowPowerModeEnabledChanged();
    void ambientLightSensorEnabledChanged();

private:
    MceConfig *m_mce;
    int  m_brightness                = 60;
    int  m_maximumBrightness         = 100;
    bool m_lowPowerModeEnabled       = false;
    bool m_ambientLightSensorEnabled = true;
};

#endif // DISPLAYSETTINGS_H

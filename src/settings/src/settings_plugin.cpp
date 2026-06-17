/*
 * Copyright (C) 2026 - Florent Revest <revestflo@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 */

#include "settings_plugin.h"
#include <QtQml>
#include "displaysettings.h"
#include "datetimesettings.h"
#include "aboutsettings.h"
#include "languagemodel.h"

SettingsPlugin::SettingsPlugin(QObject *parent) : QQmlExtensionPlugin(parent)
{
}

void SettingsPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("org.asteroid.settings"));

    qmlRegisterType<DisplaySettings>(uri, 1, 0, "DisplaySettings");
    qmlRegisterType<DateTimeSettings>(uri, 1, 0, "DateTimeSettings");
    qmlRegisterType<AboutSettings>(uri, 1, 0, "AboutSettings");
    qmlRegisterType<LanguageModel>(uri, 1, 0, "LanguageModel");
}

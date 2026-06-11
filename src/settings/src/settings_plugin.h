/*
 * Copyright (C) 2026 - Florent Revest <revestflo@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 */

#ifndef SETTINGSPLUGIN_H
#define SETTINGSPLUGIN_H

#include <QQmlExtensionPlugin>

class SettingsPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    explicit SettingsPlugin(QObject *parent = 0);
    void registerTypes(const char *uri);
};

#endif // SETTINGSPLUGIN_H

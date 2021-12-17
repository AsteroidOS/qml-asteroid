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

#include "controls_plugin.h"
#include <QFontDatabase>
#include <QGuiApplication>
#include <QtQml>
#include "application_p.h"
#include "flatmesh.h"
#include "icon.h"

ControlsPlugin::ControlsPlugin(QObject *parent) : QQmlExtensionPlugin(parent)
{
}

void ControlsPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("org.asteroid.controls"));

    QGuiApplication::setFont(QFont("Noto Sans"));

    qmlRegisterType<Application_p>(uri, 1, 0, "Application_p");
    qmlRegisterType<FlatMesh>(uri, 1, 0, "FlatMesh");
    qmlRegisterType<Icon>(uri, 1, 0, "Icon");
}


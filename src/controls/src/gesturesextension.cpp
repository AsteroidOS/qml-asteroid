/*
 * Copyright (C) 2026 Florent Revest <revestflo@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 */

#include "gesturesextension.h"

#include <QGuiApplication>
#include <QWindow>
#include <qpa/qplatformnativeinterface.h>

GesturesManager::GesturesManager()
    : QWaylandClientExtensionTemplate<GesturesManager>(1)
{
}

GesturesManager *GesturesManager::instance()
{
    static GesturesManager *s_instance = nullptr;
    if (!s_instance) {
        s_instance = new GesturesManager();
        s_instance->initialize();
    }
    return s_instance;
}

GestureSurface::GestureSurface(::wl_surface *surface)
    : QtWayland::zasteroid_gesture_surface_v1(
          GesturesManager::instance()->get_gesture_surface(surface))
{
}

GestureSurface::~GestureSurface()
{
    if (isInitialized())
        destroy();
}

GestureSurface *GestureSurface::forWindow(QWindow *window)
{
    if (!window)
        return nullptr;

    auto *manager = GesturesManager::instance();
    if (!manager->isActive())
        return nullptr;

    auto *native = QGuiApplication::platformNativeInterface();
    if (!native)
        return nullptr;

    auto *surface = static_cast<::wl_surface *>(
        native->nativeResourceForWindow(QByteArrayLiteral("surface"), window));
    if (!surface)
        return nullptr;

    return new GestureSurface(surface);
}

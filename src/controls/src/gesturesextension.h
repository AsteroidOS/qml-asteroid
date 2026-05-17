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

#ifndef GESTURESEXTENSION_H
#define GESTURESEXTENSION_H

#include <QWaylandClientExtensionTemplate>
#include <qwayland-asteroid-gestures-unstable-v1.h>

class QWindow;

class GesturesManager
    : public QWaylandClientExtensionTemplate<GesturesManager>,
      public QtWayland::zasteroid_gestures_manager_v1
{
    Q_OBJECT
public:
    GesturesManager();
    static GesturesManager *instance();
};

class GestureSurface : public QtWayland::zasteroid_gesture_surface_v1
{
public:
    explicit GestureSurface(::wl_surface *surface);
    ~GestureSurface();

    static GestureSurface *forWindow(QWindow *window);
};

#endif // GESTURESEXTENSION_H

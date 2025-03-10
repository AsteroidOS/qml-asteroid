/*
 * Copyright (C) 2022 - Darrel Griët <dgriet@gmail.com>
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

#ifndef FILEINFO_H
#define FILEINFO_H

#include <QObject>
#include <QJSEngine>
#include <QQmlEngine>

class FileInfo : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_ELEMENT
    Q_DISABLE_COPY(FileInfo)
    FileInfo() {}
public:
    static FileInfo *create(QQmlEngine *, QJSEngine *)
    {
        return new FileInfo;
    }
    // TODO: FileInfo(QObject *parent = 0); instead?
    Q_INVOKABLE bool exists(const QString fileName);
};

#endif // FILEINFO_H

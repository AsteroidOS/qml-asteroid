/*
 * Copyright (C) 2016 - Florent Revest <revestflo@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include <QObject>
#include <QMap>
#include <QString>
#include <QVariant>
#include <QStringList>
#include <QDBusObjectPath>
#include <QDBusConnection>
#include <QDBusServiceWatcher>

typedef QMap<QString, QMap<QString, QVariant>> InterfaceList;
Q_DECLARE_METATYPE(InterfaceList)

class BluetoothStatus : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool powered READ getPowered WRITE setPowered NOTIFY poweredChanged)
    Q_PROPERTY(bool connected READ getConnected NOTIFY connectedChanged)

public:
    BluetoothStatus(QObject *parent = 0);
    void setPowered(bool);
    bool getPowered();
    bool getConnected();

public slots:
    void serviceRegistered(const QString& name);
    void serviceUnregistered(const QString& name);
    void InterfacesAdded(QDBusObjectPath, InterfaceList);
    void InterfacesRemoved(QDBusObjectPath, QStringList);
    void PropertiesChanged(QString, QMap<QString, QVariant>, QStringList);

signals:
    void connectedChanged();
    void poweredChanged();

private:
    // Asynchronously fetch the BlueZ object tree and recompute powered/connected
    // from a single GetManagedObjects reply, off the GUI thread.
    void refresh();
    void handleManagedObjects(const class QDBusMessage &reply);

    bool mConnected, mPowered;
    QDBusConnection mBus;
    QDBusServiceWatcher *mWatcher;
};


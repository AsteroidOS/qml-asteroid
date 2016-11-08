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

#include "bluetoothstatus.h"

#include <QDBusServiceWatcher>
#include <QDBusConnection>
#include <QDBusInterface>
#include <QDBusArgument>
#include <QDBusMessage>

BluetoothStatus::BluetoothStatus(QObject *parent) : QObject(parent), mBus(QDBusConnection::systemBus())
{
    mPowered = false;
    mConnected = false;

    mWatcher = new QDBusServiceWatcher("org.bluez", QDBusConnection::systemBus());
    connect(mWatcher, SIGNAL(serviceRegistered(const QString&)), this, SLOT(serviceRegistered(const QString&)));
    connect(mWatcher, SIGNAL(serviceUnregistered(const QString&)), this, SLOT(serviceUnregistered(const QString&)));

    QDBusInterface remoteOm("org.bluez", "/", "org.freedesktop.DBus.ObjectManager", mBus);
    if(remoteOm.isValid())
        serviceRegistered("org.bluez");
    else
        serviceUnregistered("org.bluez");
}

void BluetoothStatus::serviceRegistered(const QString& name)
{
    mBus.connect("org.bluez", "/", "org.freedesktop.DBus.ObjectManager", "InterfacesAdded", this, SLOT(InterfacesAdded(QDBusObjectPath, InterfaceList)));
    mBus.connect("org.bluez", "/", "org.freedesktop.DBus.ObjectManager", "InterfacesRemoved", this, SLOT(InterfacesRemoved(QDBusObjectPath, QStringList)));

    updatePowered();
    updateConnected();
}

void BluetoothStatus::serviceUnregistered(const QString& name)
{
    mPowered = false;
    mConnected = false;
}

void BluetoothStatus::updatePowered()
{
    bool powered = false;
    QDBusInterface remoteOm("org.bluez", "/", "org.freedesktop.DBus.ObjectManager", mBus);

    QDBusMessage result = remoteOm.call("GetManagedObjects");

    const QDBusArgument argument = result.arguments().at(0).value<QDBusArgument>();
    if (argument.currentType() == QDBusArgument::MapType) {
        argument.beginMap();
        while (!argument.atEnd()) {
                QString key;
                InterfaceList value;

                argument.beginMapEntry();
                argument >> key >> value;
                argument.endMapEntry();

                if (value.contains("org.bluez.Adapter1")) {
                     mBus.connect("org.bluez", key, "org.freedesktop.DBus.Properties", "PropertiesChanged", this, SLOT(PropertiesChanged(QString, QMap<QString, QVariant>, QStringList)));
                     QMap<QString, QVariant> properties = value.value("org.bluez.Adapter1");
                     if(properties.contains("Powered"))
                        powered |= properties.value("Powered").toBool();
                }
        }
        argument.endMap();
    }

    if(powered != mPowered) {
        mPowered = powered;
        emit poweredChanged();
    }
}

void BluetoothStatus::updateConnected()
{
    bool connected = false;
    QDBusInterface remoteOm("org.bluez", "/", "org.freedesktop.DBus.ObjectManager", mBus);

    QDBusMessage result = remoteOm.call("GetManagedObjects");

    const QDBusArgument argument = result.arguments().at(0).value<QDBusArgument>();
    if (argument.currentType() == QDBusArgument::MapType) {
        argument.beginMap();
        while (!argument.atEnd()) {
                QString key;
                InterfaceList value;

                argument.beginMapEntry();
                argument >> key >> value;
                argument.endMapEntry();

                if (value.contains("org.bluez.Device1")) {
                     mBus.connect("org.bluez", key, "org.freedesktop.DBus.Properties", "PropertiesChanged", this, SLOT(PropertiesChanged(QString, QMap<QString, QVariant>, QStringList)));
                     QMap<QString, QVariant> properties = value.value("org.bluez.Device1");
                     if(properties.contains("Connected"))
                        connected |= properties.value("Connected").toBool();
                }
        }
        argument.endMap();
    }

    if(connected != mConnected) {
        mConnected = connected;
        emit connectedChanged();
    }
}

void BluetoothStatus::InterfacesAdded(QDBusObjectPath, InterfaceList)
{
    updatePowered();
    updateConnected();
}

void BluetoothStatus::InterfacesRemoved(QDBusObjectPath, QStringList)
{
    updatePowered();
    updateConnected();
}

void BluetoothStatus::PropertiesChanged(QString, QMap<QString, QVariant>, QStringList)
{
    updatePowered();
    updateConnected();
}

bool BluetoothStatus::getPowered()
{
    return mPowered;
}

bool BluetoothStatus::getConnected()
{
    return mConnected;
}

void BluetoothStatus::setPowered(bool powered)
{
    QDBusInterface serviceManager("org.bluez", "/org/bluez/hci0", "org.bluez.Adapter1", mBus);
    serviceManager.setProperty("Powered", powered);
}

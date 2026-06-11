/*
 * Copyright (C) 2026 - Florent Revest <revestflo@gmail.com>
 * Copyright (C) 2013 Jolla Ltd. <pekka.vuorela@jollamobile.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

#include "languagemodel.h"

#include <QDir>
#include <QFile>
#include <QFileInfoList>
#include <QSettings>
#include <QDBusConnection>
#include <QDBusInterface>
#include <algorithm>

static const char *LanguageSupportDirectory = "/usr/share/supported-languages";

LanguageModel::LanguageModel(QObject *parent) : QAbstractListModel(parent)
{
    m_languages = loadSupportedLanguages();
    readCurrentLocale();
}

QList<Language> LanguageModel::loadSupportedLanguages() const
{
    QList<Language> languages;
    const QFileInfoList files = QDir(LanguageSupportDirectory)
                                    .entryInfoList(QStringList("*.conf"), QDir::Files);
    for (const QFileInfo &fi : files) {
        QSettings s(fi.filePath(), QSettings::IniFormat);
        Language l;
        l.name        = s.value("Name").toString();
        l.localeCode  = s.value("LocaleCode").toString();
        l.region      = s.value("Region").toString();
        l.regionLabel = s.value("RegionLabel").toString();
        if (l.name.isEmpty() || l.localeCode.isEmpty())
            continue;
        languages.append(l);
    }
    std::sort(languages.begin(), languages.end(), [](const Language &a, const Language &b) {
        return a.name.localeAwareCompare(b.name) <= 0;
    });
    return languages;
}

void LanguageModel::readCurrentLocale()
{
    QFile f("/etc/locale.conf");
    if (!f.open(QIODevice::ReadOnly | QIODevice::Text))
        return;
    while (!f.atEnd()) {
        const QString line = QString::fromUtf8(f.readLine()).trimmed();
        if (line.startsWith("LANG=")) {
            QString lang = line.mid(5);
            if (lang.startsWith('"') && lang.endsWith('"') && lang.size() >= 2)
                lang = lang.mid(1, lang.size() - 2);
            m_currentIndex = indexForLocale(lang);
            break;
        }
    }
}

int LanguageModel::indexForLocale(const QString &localeCode) const
{
    for (int i = 0; i < m_languages.size(); ++i)
        if (m_languages.at(i).localeCode == localeCode)
            return i;
    return -1;
}

int LanguageModel::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : m_languages.size();
}

QVariant LanguageModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_languages.size())
        return QVariant();
    const Language &l = m_languages.at(index.row());
    switch (role) {
    case NameRole:        return l.name;
    case LocaleRole:      return l.localeCode;
    case RegionRole:      return l.region;
    case RegionLabelRole: return l.regionLabel;
    default:              return QVariant();
    }
}

QHash<int, QByteArray> LanguageModel::roleNames() const
{
    return {
        { NameRole,        "name" },
        { LocaleRole,      "locale" },
        { RegionRole,      "region" },
        { RegionLabelRole, "regionLabel" },
    };
}

QString LanguageModel::languageName(int index) const
{
    return (index < 0 || index >= m_languages.size()) ? QString() : m_languages.at(index).name;
}

QString LanguageModel::locale(int index) const
{
    return (index < 0 || index >= m_languages.size()) ? QString() : m_languages.at(index).localeCode;
}

void LanguageModel::setSystemLocale(const QString &localeCode, LocaleUpdateMode updateMode)
{
    // Apply persistently via systemd-localed (writes /etc/locale.conf).
    QDBusInterface localed("org.freedesktop.locale1", "/org/freedesktop/locale1",
                           "org.freedesktop.locale1", QDBusConnection::systemBus());
    localed.asyncCall("SetLocale", QStringList{ "LANG=" + localeCode }, false /* interactive */);

    const int oldIndex = m_currentIndex;
    m_currentIndex = indexForLocale(localeCode);
    if (m_currentIndex != oldIndex)
        emit currentIndexChanged();

    if (updateMode == UpdateAndReboot) {
        QDBusInterface login1("org.freedesktop.login1", "/org/freedesktop/login1",
                              "org.freedesktop.login1.Manager", QDBusConnection::systemBus());
        login1.asyncCall("Reboot", false);
    } else {
        QDBusInterface lipstick("org.nemomobile.lipstick", "/org/nemomobile/lipstick/localemanager",
                               "org.nemomobile.lipstick", QDBusConnection::systemBus());
        lipstick.asyncCall("selectLocale", localeCode);
    }
}

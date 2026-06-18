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
    QString lang = qEnvironmentVariable("LANG");
    if (lang.isEmpty() || lang == "C" || lang == "POSIX")
        lang = "en";
    m_currentIndex = indexForLocale(lang);
}

// Normalize a locale code to its lowercase base, dropping the ".utf8"/"@mod"
// suffix: "en_GB.utf8" -> "en_gb", "fr.utf8" -> "fr".
static QString localeBase(const QString &code)
{
    QString s = code;
    int cut = s.indexOf('.');
    if (cut >= 0) s = s.left(cut);
    cut = s.indexOf('@');
    if (cut >= 0) s = s.left(cut);
    return s.toLower();
}

// Language part only: "en_gb" -> "en".
static QString langPart(const QString &code)
{
    const QString b = localeBase(code);
    const int us = b.indexOf('_');
    return us >= 0 ? b.left(us) : b;
}

int LanguageModel::indexForLocale(const QString &localeCode) const
{
    const QString wantBase = localeBase(localeCode);
    const QString wantLang = langPart(localeCode);

    // 1. exact (normalized) match on the full base, e.g. en_gb == en_gb
    for (int i = 0; i < m_languages.size(); ++i)
        if (localeBase(m_languages.at(i).localeCode) == wantBase)
            return i;
    // 2. language-only entry with no region, e.g. "fr.utf8" for "fr"
    for (int i = 0; i < m_languages.size(); ++i)
        if (localeBase(m_languages.at(i).localeCode) == wantLang)
            return i;
    // 3. any entry sharing the language, e.g. "en" -> "en_GB.utf8"
    for (int i = 0; i < m_languages.size(); ++i)
        if (langPart(m_languages.at(i).localeCode) == wantLang)
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

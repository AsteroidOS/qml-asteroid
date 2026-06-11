/*
 * Copyright (C) 2026 - Florent Revest <revestflo@gmail.com>
 * Copyright (C) 2013 Jolla Ltd. <pekka.vuorela@jollamobile.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 */

#ifndef LANGUAGEMODEL_H
#define LANGUAGEMODEL_H

#include <QAbstractListModel>
#include <QString>
#include <QList>

struct Language {
    QString name;
    QString localeCode;
    QString region;
    QString regionLabel;
};

class LanguageModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int currentIndex READ currentIndex NOTIFY currentIndexChanged)

public:
    enum Roles { NameRole = Qt::UserRole + 1, LocaleRole, RegionRole, RegionLabelRole };
    Q_ENUM(Roles)

    enum LocaleUpdateMode { UpdateAndReboot, UpdateWithoutReboot };
    Q_ENUM(LocaleUpdateMode)

    explicit LanguageModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    int currentIndex() const { return m_currentIndex; }

    Q_INVOKABLE QString languageName(int index) const;
    Q_INVOKABLE QString locale(int index) const;
    Q_INVOKABLE void setSystemLocale(const QString &localeCode, LocaleUpdateMode updateMode);

signals:
    void currentIndexChanged();

private:
    QList<Language> loadSupportedLanguages() const;
    void readCurrentLocale();
    int indexForLocale(const QString &localeCode) const;

    QList<Language> m_languages;
    int m_currentIndex = -1;
};

#endif // LANGUAGEMODEL_H

/*
 * Qt Quick Controls Asteroid - User interface components for AsteroidOS
 *
 * Copyright (C) 2015 - Florent Revest <revestflo@gmail.com>
 *               2013 - Jolla Ltd.
 *               2011 - Nokia Corporation and/or its subsidiary(-ies).
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

#ifndef THEMEDAEMONCLIENT_H
#define THEMEDAEMONCLIENT_H

#include <QHash>
#include <QPixmap>
#include <QString>

#ifdef HAVE_MLITE
#include <mgconfitem.h>
#endif

class QDir;
/**
 * \brief Allows to request pixmaps from a local themedaemon server.
 *
 * The requested pixmaps are cached so that multiple requests of the
 * same pixmap can be handled fast.
 */
class ThemeDaemonClient : public QObject
{
    Q_OBJECT

public:
    /**
     * \param path   File path where the icons and images are located.
     *               If no file path is provided, the default path defined
     *               by the define THEME_DIR is used.
     * \param parent Parent object.
     */
    ThemeDaemonClient(const QString &testPath = QString(), QObject *parent = 0);
    virtual ~ThemeDaemonClient();

    /**
     * \see MAbstractThemeDaemonClient::requestPixmap()
     */
    virtual QPixmap requestPixmap(const QString &id, const QSize &requestedSize);

    /**
     * Reads the image \a id from the available directories specified
     * by m_imageDirNodes.
     */
    QImage readImage(const QString &id) const;

private:


    void buildHash(const QDir& rootDir, const QStringList& nameFilter);

    /**
     * Cache entry that identifies a pixmap by a string-ID and size.
     */
    struct PixmapIdentifier
    {
        PixmapIdentifier();
        PixmapIdentifier(const QString &imageId, const QSize &size);
        QString imageId;
        QSize size;
        bool operator==(const PixmapIdentifier &other) const;
        bool operator!=(const PixmapIdentifier &other) const;
    };

    struct ImageDirNode
    {
        ImageDirNode(const QString &directory, const QStringList &suffixList);
        QString directory;
        QStringList suffixList;
    };

    QHash<PixmapIdentifier, QPixmap> m_pixmapCache;
    QList<ImageDirNode> m_imageDirNodes;

    QHash<QString, QString> m_filenameHash;

#ifdef HAVE_MLITE
    MGConfItem themeItem;
#endif

    friend uint qHash(const ThemeDaemonClient::PixmapIdentifier &id);
};

#endif


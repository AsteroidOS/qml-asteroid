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

#include "themedaemonclient.h"

#include <QCoreApplication>
#include <QDebug>
#include <QDir>
#include <QSettings>

ThemeDaemonClient::ThemeDaemonClient(const QString &testPath, QObject *parent) :
    QObject(parent),
    m_pixmapCache(),
    m_imageDirNodes()
#ifdef HAVE_MLITE
    , themeItem("/meegotouch/theme/name")
#endif
{
    QStringList themeRoots;
    QString themeRoot = testPath;
    bool testMode = false;

    if (themeRoot.isEmpty())
        themeRoot = qgetenv("M_THEME_DIR");
    else
        testMode = true;

    if (themeRoot.isEmpty()) {
#if defined(THEME_DIR)
        themeRoot = THEME_DIR;
#else
# ifdef Q_OS_WIN
        themeRoot = "c:\\";
# else
        themeRoot = "/usr/share/themes";
# endif
#endif
    }

    if (testMode == false) {
        QString themeName;
# if !defined(THEME_NAME)
#  define THEME_NAME "moka"
# endif
#ifdef HAVE_MLITE
        themeName = themeItem.value(THEME_NAME).toString();
#else
        themeName = QLatin1String(THEME_NAME);
#endif

        // find out the inheritance chain for the new theme
        QString nextTheme = themeName;
        QSet<QString> inheritanceChain;

        while (true) {
            // Determine whether this is an m theme:
            const QString themeIndexFileName = themeRoot + QDir::separator() + nextTheme + QDir::separator() + "index.theme";

            // it needs to be a valid ini file
            const QSettings themeIndexFile(themeIndexFileName, QSettings::IniFormat);
            if (themeIndexFile.status() != QSettings::NoError) {
                qWarning() << Q_FUNC_INFO << "Theme" << themeName << "does not exist! Falling back to " << THEME_NAME;
                break;
            }

            // we need to have X-MeeGoTouch-Metatheme group in index.theme
            if (!themeIndexFile.childGroups().contains(QString("X-MeeGoTouch-Metatheme"))) {
                qWarning() << Q_FUNC_INFO << "Theme" << themeName << " is invalid";
                break;
            }

            inheritanceChain.insert(nextTheme);
            // the paths should be stored in reverse order than in the inheritance chain
            themeRoots.prepend(themeRoot + QDir::separator() + nextTheme + QDir::separator() + QLatin1String("meegotouch"));

            QString parentTheme = themeIndexFile.value("X-MeeGoTouch-Metatheme/X-Inherits", "").toString();

            if (parentTheme.isEmpty()) {
                break;
            }
            nextTheme = parentTheme;

            // check that there are no cyclic dependencies
            if (inheritanceChain.contains(parentTheme)) {
                qFatal("%s: cyclic dependency in theme: %s", Q_FUNC_INFO, themeName.toUtf8().constData());
            }
        }
    } else {
        themeRoots += themeRoot;
    }

    for (int i = 0; i < themeRoots.size(); ++i) {
        if (themeRoots.at(i).endsWith(QDir::separator()))
            themeRoots[i].truncate(themeRoots.at(i).length() - 1);

        buildHash(themeRoots.at(i) + QDir::separator() + "icons", QStringList() << "*.svg" << "*.png" << "*.jpg");
    }

    m_imageDirNodes.append(ImageDirNode("icons" , QStringList() << ".svg" << ".png" << ".jpg"));

}

ThemeDaemonClient::~ThemeDaemonClient()
{
}

QPixmap ThemeDaemonClient::requestPixmap(const QString &id, const QSize &requestedSize)
{
    QPixmap pixmap;

    QSize size = requestedSize;
    if (size.width() < 1) {
        size.rwidth() = 0;
    }
    if (size.height() < 1) {
        size.rheight() = 0;
    }

    const PixmapIdentifier pixmapId(id, size);
    pixmap = m_pixmapCache.value(pixmapId);
    if (pixmap.isNull()) {
        // The pixmap is not cached yet. Decode the image and
        // store it into the cache as pixmap.
        const QImage image = readImage(id);
        if (!image.isNull()) {
            pixmap = QPixmap::fromImage(image);
            if (requestedSize.isValid() && (pixmap.size() != requestedSize)) {
                pixmap = pixmap.scaled(requestedSize);
            }

            m_pixmapCache.insert(pixmapId, pixmap);
        }
    }
    return pixmap;
}

QImage ThemeDaemonClient::readImage(const QString &id) const
{
    if (!id.isEmpty()) {
        foreach (const ImageDirNode &imageDirNode, m_imageDirNodes) {
            foreach (const QString &suffix, imageDirNode.suffixList) {

                QString imageFilePathString = m_filenameHash.value(id + suffix);
                if (!imageFilePathString.isNull()) {
                    imageFilePathString.append(QDir::separator() + id + suffix);

                    QImage image(imageFilePathString);
                    if (!image.isNull()) {
                        return image;
                    }
                }
            }
        }
    }

    return QImage();
}

void ThemeDaemonClient::buildHash(const QDir& rootDir, const QStringList& nameFilter)
{
    // XXX: this code is wildly inefficient, we should be able to do it
    // with a single loop over files & dirs
    QDir rDir = rootDir;
    rDir.setNameFilters(nameFilter);
    QStringList files = rDir.entryList(QDir::Files);
    foreach (const QString &filename, files) {
        m_filenameHash.insert(filename, rootDir.absolutePath());
    }

    QStringList dirList = rootDir.entryList(QDir::AllDirs | QDir::NoDotAndDotDot);
    foreach(const QString &nextDirString, dirList){
        QDir nextDir(rootDir.absolutePath() + QDir::separator() + nextDirString);
        buildHash(nextDir, nameFilter);
    }
}

ThemeDaemonClient::PixmapIdentifier::PixmapIdentifier() :
    imageId(), size()
{
}

ThemeDaemonClient::PixmapIdentifier::PixmapIdentifier(const QString &imageId, const QSize &size) :
    imageId(imageId), size(size)
{
}

bool ThemeDaemonClient::PixmapIdentifier::operator==(const PixmapIdentifier &other) const
{
    return imageId == other.imageId && size == other.size;
}

bool ThemeDaemonClient::PixmapIdentifier::operator!=(const PixmapIdentifier &other) const
{
    return imageId != other.imageId || size != other.size;
}

ThemeDaemonClient::ImageDirNode::ImageDirNode(const QString &directory, const QStringList &suffixList) :
    directory(directory),
    suffixList(suffixList)
{
}

uint qHash(const ThemeDaemonClient::PixmapIdentifier &id)
{
    using ::qHash;

    const uint idHash     = qHash(id.imageId);
    const uint widthHash  = qHash(id.size.width());
    const uint heightHash = qHash(id.size.height());

    // Twiddle the bits a little, taking a cue from Qt's own qHash() overloads
    return idHash ^ (widthHash << 8) ^ (widthHash >> 24) ^ (heightHash << 24) ^ (heightHash >> 8);
}

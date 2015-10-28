#ifndef DELETEME_PLUGIN_H
#define DELETEME_PLUGIN_H

#include <QQmlExtensionPlugin>

class StylesPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri);
};

#endif // DELETEME_PLUGIN_H


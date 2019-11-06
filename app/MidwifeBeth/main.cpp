#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include <QStandardPaths>
#include <QDir>

#include "systemutils.h"
#include "downloader.h"
#include "databaselist.h"
#include "cachedmediasource.h"
#include "cachedimageprovider.h"
#include "rangemodel.h"
#include "datemodel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    //
    //
    //
    QStringList standardLocations = QStandardPaths::standardLocations(QStandardPaths::PicturesLocation);
    qDebug() << "Photo locations";
    for ( auto location : standardLocations ) {
        qDebug() << location;
        QDir dir(location);
        if ( !dir.exists() ) {
            qDebug() << "Creating directory : " << location;
            if (!dir.mkpath(".")){
                qDebug() << "Unable to create directory : " << location;
            }
        }
    }
    //
    // register custom controls
    //
    qmlRegisterType<DatabaseList>("SodaControls", 1, 0, "DatabaseList");
    qmlRegisterType<RangeModel>("SodaControls", 1, 0, "RangeModel");
    qmlRegisterType<DateModel>("SodaControls", 1, 0, "DateModel");
    qmlRegisterType<CachedMediaSource>("SodaControls", 1, 0, "CachedMediaSource");
    //
    // register global objects
    //
    engine.rootContext()->setContextProperty("SystemUtils", SystemUtils::shared());
    engine.rootContext()->setContextProperty("Downloader", Downloader::shared());
    //
    //
    //
    engine.addImageProvider("cached",new CachedImageProvider);
    //
    //
    //
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty()) return -1;

    return app.exec();
}

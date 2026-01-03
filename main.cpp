#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "level_1.h"
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    qmlRegisterType<Level_1>("level_1",1,0,"Level_1");
    engine.loadFromModule("Project_Rectangle_v2", "Main");

    return app.exec();
}

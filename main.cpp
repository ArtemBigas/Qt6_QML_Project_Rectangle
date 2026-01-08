#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>   // <-- обязательно
#include "level_1.h"
void createSetting(QSettings *something){
    //надо распределить настройки по группам
    something->beginGroup("Settings");
    bool groupExists = !something->childKeys().isEmpty()//проверяем наличие ключей
                       ||!something->childGroups().isEmpty();//проверяем наличие групп
    if (!groupExists) {
        // Группа ещё не существовала — сохраняем значения
        something->setValue("volume", 5);
        something->setValue("sensitive", 5);
        something->sync(); // явно записать на диск
    }
    something->endGroup();
}

void loadSetting(QSettings *something){
    something->beginGroup("Settings");
    Settings::volume = something->value("volume", 0).toInt();
    Settings::sensitive = something->value("sensitive", 0).toInt();
    something->endGroup();
}

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
    //начальная настройка
    //createSetting(&Settings::settings);
    //loadSetting(&Settings::settings);
    qmlRegisterType<Settings>("settings",1,0,"Settings");
    qmlRegisterType<Level_1>("level_1",1,0,"Level_1");
    engine.loadFromModule("Project_Rectangle_v2", "Main");

    return app.exec();
}

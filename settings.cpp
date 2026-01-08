#include "settings.h"
#include <QDebug>
Settings::Settings(QObject *parent)
    : QObject{parent}
{
    //надо распределить настройки по группам
    settings.beginGroup("Settings");
    bool groupExists = !settings.childKeys().isEmpty()//проверяем наличие ключей
                       ||!settings.childGroups().isEmpty();//проверяем наличие групп
    if (!groupExists) {
        // Группа ещё не существовала — сохраняем значения
        settings.setValue("volume", 5);
        settings.setValue("sensitive", 5);
        settings.sync(); // явно записать на диск
    }
    //загружаем начальные данные
    Settings::volume = settings.value("volume", 0).toInt();
    Settings::sensitive = settings.value("sensitive", 0).toInt();
    settings.endGroup();
    //настраиваем звук
    m_coinSound.setSource(QUrl("qrc:/qt/qml/Project_Rectangle_v2/music/coin.wav"));
    //настраиваем начальную громкость
    m_coinSound.setVolume(volume/10.0f);//setVolume работает только с float
}

int Settings::volume{};

int Settings::sensitive{};

QSettings Settings::settings("config/settings.ini", QSettings::IniFormat);

QSoundEffect Settings::m_coinSound;

int Settings::getVolume(){return volume;}

int Settings::getSensitive(){return sensitive;}

void Settings::setVolume(int newVolume){
    volume=newVolume;
    settings.beginGroup("Settings");
    settings.setValue("volume", volume);
    settings.sync(); // явно записать на диск
     settings.endGroup();
    m_coinSound.setVolume(volume/10.0f);//setVolume работает только с float
     if (m_coinSound.status() == QSoundEffect::Ready) {
         m_coinSound.play();
     }
}

void Settings::setSensitive(int newSensitive){
    sensitive=newSensitive;
    settings.beginGroup("Settings");
    settings.setValue("sensitive", sensitive);
    settings.sync(); // явно записать на диск
    settings.endGroup();
}

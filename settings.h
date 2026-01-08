#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QSettings>
#include <QSoundEffect>//музыка
class Settings : public QObject
{
    Q_OBJECT
    //получаем громкость и чувствительность от qml и обратно при чтении из settings.ini
    Q_PROPERTY(int volume_qml READ getVolume  WRITE setVolume NOTIFY ChangedVolume)
    Q_PROPERTY(int sensitive_qml READ getSensitive WRITE setSensitive NOTIFY ChangedSensitive)
public:
    explicit Settings(QObject *parent = nullptr);
    int getVolume();
    int getSensitive();
    void setVolume(int newVolume);
    void setSensitive(int newSensitive);
    //чтобы громкость и чувствительность были постоянными всегда, public чтобы была доступна
    static int volume;
    static int sensitive;
    static QSettings settings;
    //музыка
    static QSoundEffect m_coinSound;
signals:
    void ChangedVolume(int);
    void ChangedSensitive(int);
private:

};

#endif // SETTINGS_H

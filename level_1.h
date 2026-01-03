#ifndef LEVEL_1_H
#define LEVEL_1_H

#include <QObject>
#include <QSoundEffect>//музыка
#include <random>
class Level_1 : public QObject
{
    Q_OBJECT
    //отправляем qml значение свойство для объекта(любого)
    Q_PROPERTY(double x_qml READ getX  NOTIFY ChangedX)
    Q_PROPERTY(double y_qml READ getY  NOTIFY ChangedY)
    Q_PROPERTY(int rotation_qml READ getRotation  NOTIFY ChangedRotation)
    Q_PROPERTY(double x_target_qml READ getX_target  NOTIFY ChangedX_target)
    Q_PROPERTY(double y_target_qml READ getY_target  NOTIFY ChangedY_target)
    Q_PROPERTY(int rotation_target_qml READ getRotation_target  NOTIFY ChangedRotation_target)
    Q_PROPERTY(double targets_qml READ getTargets  NOTIFY ChangedTargets)
    Q_PROPERTY(double laps_qml READ getLaps  NOTIFY ChangedLaps)
    //получаем от qml значение свойство для объекта(любого)
    Q_PROPERTY(int height_qml  WRITE setHeight)
    Q_PROPERTY(int width_qml WRITE setWidth)
    Q_PROPERTY(int height_target_qml  WRITE setHeight_target)
    Q_PROPERTY(int width_target_qml WRITE setWidth_target)
    Q_PROPERTY(int fieldHeight_qml  WRITE setFieldHeight)
    Q_PROPERTY(int fieldWidth_qml WRITE setFieldWidth)
public:
    explicit Level_1(QObject *parent = nullptr);
    //устанавливаем объекты окна и квадрата
    int getX() const;//возвращает x
    int getY() const;//возвращает y
    int getRotation() const;//возвращает rotation
    int getX_target() const;//возвращает x
    int getY_target() const;//возвращает y
    int getRotation_target() const;//возвращает rotation
    void setHeight(int newHeight);//меняем height на полученное значение
    void setWidth(int newWidth);//меняем width на полученное значение
    void setHeight_target(int newHeight_target);//меняем height на полученное значение
    void setWidth_target(int newWidth_target);//меняем width на полученное значение
    void setFieldHeight(int newFieldHeight);
    void setFieldWidth(int newFieldWidth);
    int getTargets()const;//возвращаем текущее количество целей
    int getLaps()const;//возвращаем текущее количество кругов
    void increaseX();
    void increaseY();
    void decreaseX();
    void decreaseY();
    //задаем местонахождение квадрата-цели
    void new_place_target();
    //функция для визуальной корректировки квадрата
    void changePosition();
    void changePosition_target();
    //музыка
    void playCoinSound();
    //проверка соприкосновения квадрата и цели
    void checkCollision();
    //функция по выбору сложности
    Q_INVOKABLE void setDifficulty(QString Difficulty);//функция в Popup в Level_1.qml
    //функции нужны для управления ротацией мышью
    Q_INVOKABLE void increaseRotation();
    Q_INVOKABLE void decreaseRotation();
    //вызов остановки таймера из qml
    Q_INVOKABLE void killMyTimer();
    Q_INVOKABLE void startMyTimer();
signals:
    //сигналы для отправки в qml
    void ChangedX(int);
    void ChangedY(int);
    void ChangedRotation(int);
    void ChangedX_target(int);
    void ChangedY_target(int);
    void ChangedRotation_target(int);
    void ChangedLaps(int);
    void ChangedTargets(int);
    void finish(int,QString);//сигнал окончания игры
protected:
    void timerEvent(QTimerEvent*);
private:
     QString m_Difficulty="easy";
    //размер окна
    double x{};
    double y{};
    int rotation{};
    double x_target{};
    double y_target{};
    int rotation_target{};
    //размеры квадрата
    int height{};
    int width{};
    int height_target{};
    int width_target{};
    //игровое поле
    int fieldWidth{};
    int fieldHeight{};
    int timerId;
    //счетчик запуска таймера, чтоб не запускалось сразу несколько,например от multitouch
    bool timerRunning = false;
    int DELAY{};//скорость таймера
    //перечисляемый тип для стороны игрового поля
    enum resource { top, bottom, left, right};
    resource side{top};//по умолчанию квадрат начинает наверху
    bool target_bottom=true;//отслеживаем куда сместить и надо ли смещать цель(вверх/вниз)
    int targets{};//счетчик собранных целей
    int laps{};//счетчик кругов
    bool newRound=true;//надежный счетчик, что круг новый
    //музыка
    QSoundEffect m_coinSound;
    bool SoundLoaded=false;//статус загрузки музыки
    //генератор рандома
    std::mt19937 gen;
    bool start=true;//счетчик старта игры
    int sensitive=0;//коэфициент чувствительности
};

#endif // LEVEL_1_H

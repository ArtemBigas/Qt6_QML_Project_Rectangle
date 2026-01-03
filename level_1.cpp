#include "level_1.h"
#include <QDebug>
Level_1::Level_1(QObject *parent): QObject{parent}, gen(std::random_device{}())
{//таймер запускает закрытие окна infoDialog в Level_1.qml
    /*Важно.Сначало срабатывает конструктор и только потом появляется связь с qml файлом.
    * Нет смысла сюда грузить сигналы туда или запрашивать данные*/
    //музыка.Путь и громкость
    m_coinSound.setSource(QUrl("qrc:/qt/qml/Project_Rectangle_v2/music/coin.wav"));
    m_coinSound.setVolume(0.2f);
    if(m_Difficulty=="easy"){DELAY=20;}
    else if(m_Difficulty=="medium"){DELAY=15;}
    else if(m_Difficulty=="hard"){DELAY=10;}
}

void Level_1::setDifficulty(QString Difficulty){m_Difficulty=Difficulty;}

int Level_1::getX() const{return x;}

int Level_1::getY() const{return y;}

int Level_1::getRotation() const{return rotation;}

int Level_1::getX_target() const{return x_target;}

int Level_1::getY_target() const{return y_target;}

int Level_1::getRotation_target() const{return rotation_target;}

void Level_1::setHeight(int newHeight){height=newHeight;}

void Level_1::setWidth(int newWidth){width=newWidth;}

void Level_1::setHeight_target(int newHeight_target){height_target=newHeight_target;}

void Level_1::setWidth_target(int newWidth_target){width_target=newWidth_target;}

void Level_1::setFieldHeight(int newFieldHeight){fieldHeight=newFieldHeight;}

void Level_1::setFieldWidth(int newFieldWidth){fieldWidth=newFieldWidth;}

int Level_1::getTargets()const{return targets;}

int Level_1::getLaps()const{return laps;}

void Level_1::increaseX(){
    x+=height/18;
    if(rotation==-90){rotation=0;}
    else{rotation-=5;};
    changePosition();
    emit ChangedRotation(rotation);
    emit ChangedX(x);
    emit ChangedY(y);
}

void Level_1::increaseY(){
    y+=height/18;
    if(rotation==-90){rotation=0;}
    else{rotation-=5;};
    changePosition();
    emit ChangedRotation(rotation);
    emit ChangedX(x);
    emit ChangedY(y);
}

void Level_1::decreaseX(){
    x-=height/18;
    if(rotation==-90){rotation=0;}
    else{rotation-=5;};
    changePosition();
    emit ChangedRotation(rotation);
    emit ChangedX(x);
    emit ChangedY(y);
}

void Level_1::decreaseY(){
    y-=height/18;
    if(rotation==-90){rotation=0;}
    else{rotation-=5;};
    changePosition();
    emit ChangedRotation(rotation);
    emit ChangedX(x);
    emit ChangedY(y);}

void Level_1::timerEvent(QTimerEvent*e){
    if (start==true){
        new_place_target();emit ChangedTargets(targets);emit ChangedLaps(laps);playCoinSound();start=false;};
    sensitive=0;//обнуляем каждый цикл,чтобы не копился
//корректировка местоположения цели на случай изменения размера окна
changePosition_target();
emit ChangedRotation(rotation_target);
emit ChangedX_target(x_target);
emit ChangedY_target(y_target);
    if(x<0.25*width && y<0.25*height){side=top;qDebug("top");
    if(newRound==true){newRound=false;laps+=1;emit ChangedLaps(laps);}}
    else if(x>fieldWidth-1.25*width && y<0.25*height){side=right;qDebug("right");}
    else if(x>fieldWidth-1.25*width && y>fieldHeight-1.25*height){side=bottom;qDebug("bottom");}
    else if(x<0.25*height && y>fieldHeight-1.25*height){side=left;qDebug("left");if(newRound==false){newRound=true;}};
    switch(side){
    case top:
        increaseX();
        break;
    case right:
        increaseY();
        break;
    case bottom:
        decreaseX();
        break;
    case left:
        decreaseY();
        break;
    }
    checkCollision();
}

void Level_1::new_place_target(){
    //для x
    std::uniform_int_distribution<int> dist(0.25*width_target, fieldWidth-1.25*width_target);
    x_target=dist(gen);
    if(side==top){y_target=fieldHeight-height_target;}else{y_target=0;};
    if(m_Difficulty=="easy"){
        changePosition_target();
        emit ChangedX_target(x_target);
        emit ChangedY_target(y_target);}
    //для ротации цели на сложности medium
    else if (m_Difficulty=="medium"){
        std::uniform_int_distribution<int> dist2(0, 1);
        if (dist2(gen) == 0)
            rotation_target= 0;
        else
            rotation_target= -45;
        changePosition_target();
        emit ChangedX_target(x_target);
        emit ChangedY_target(y_target);
        emit ChangedRotation_target(rotation_target);}
    else if(m_Difficulty=="hard"){
        std::uniform_int_distribution<int> dist2(0, 18);rotation_target = (dist2(gen) * -5);
        changePosition_target();
        emit ChangedX_target(x_target);
        emit ChangedY_target(y_target);
        emit ChangedRotation_target(rotation_target);}
}

void Level_1::changePosition(){
    // Перевод градусов в радианы
    double angleRad = rotation * M_PI / 180.0;
    double cosA = std::cos(angleRad);
    double sinA = std::sin(angleRad);
    // Центр прямоугольника
    double cx = x + width * 0.5;
    double cy = y + height * 0.5;
    // Локальные (dx, dy)
    std::array<std::pair<double,double>,4> local = {
        std::make_pair(-width * 0.5, -height * 0.5), // A
        std::make_pair( width * 0.5, -height * 0.5), // B
        std::make_pair( width * 0.5,  height * 0.5), // C
        std::make_pair(-width * 0.5,  height * 0.5)  // D
    };
    // Поворот вершин
    std::array<std::pair<double,double>,4> rotated;
    for (int i = 0; i < 4; ++i) {
        double dx = local[i].first;
        double dy = local[i].second;
        double rx = cx + dx * cosA - dy * sinA;
        double ry = cy + dx * sinA + dy * cosA;
        rotated[i] = {rx, ry};
    }
    // Найдём ближайшую вершину по нужной стороне
    double targetX = x;
    double targetY = y;

    switch (side) {
    case top: {
        // хотим min y == 0
        double minY = rotated[0].second;
        for (int i = 1; i < 4; ++i)
            minY = std::min(minY, rotated[i].second);
        // сдвиг (если выше 0 — вниз; если ниже также вниз)
        targetY = y - minY;
        break;
    }
    case bottom: {
        // хотим max y == fieldHeight
        double maxY = rotated[0].second;
        for (int i = 1; i < 4; ++i)
            maxY = std::max(maxY, rotated[i].second);
        double diff = fieldHeight - maxY;
        targetY = y + diff;
        break;
    }
    case left: {
        // хотим min x == 0
        double minX = rotated[0].first;
        for (int i = 1; i < 4; ++i)
            minX = std::min(minX, rotated[i].first);
        targetX = x - minX;
        break;
    }
    case right: {
        // хотим max x == fieldWidth
        double maxX = rotated[0].first;
        for (int i = 1; i < 4; ++i)
            maxX = std::max(maxX, rotated[i].first);
        double diff = fieldWidth - maxX;
        targetX = x + diff;
        break;
    }
    }

    // Теперь ensure, что после перемещения bounding box не выходит за границы окна
    // 1) пересчитаем центр после смещения
    double newCx = targetX + width * 0.5;
    double newCy = targetY + height * 0.5;

    // 2) пересчитаем все rotated
    for (int i = 0; i < 4; ++i) {
        double dx = local[i].first;
        double dy = local[i].second;
        double rx = newCx + dx * cosA - dy * sinA;
        double ry = newCy + dx * sinA + dy * cosA;
        rotated[i] = {rx, ry};
    }

    // 3) снова AABB
    double minX2 = rotated[0].first, maxX2 = rotated[0].first;
    double minY2 = rotated[0].second, maxY2 = rotated[0].second;
    for (int i = 1; i < 4; ++i) {
        minX2 = std::min(minX2, rotated[i].first);
        maxX2 = std::max(maxX2, rotated[i].first);
        minY2 = std::min(minY2, rotated[i].second);
        maxY2 = std::max(maxY2, rotated[i].second);
    }

    // корректируем, если что-то вылезло
    if (minX2 < 0) targetX += -minX2;
    if (maxX2 > fieldWidth) targetX -= (maxX2 - fieldWidth);
    if (minY2 < 0) targetY += -minY2;
    if (maxY2 > fieldHeight) targetY -= (maxY2 - fieldHeight);
    x=targetX;
    y=targetY;
}

void Level_1::changePosition_target(){
    // Перевод градусов в радианы
    double angleRad = rotation_target * M_PI / 180.0;
    double cosA = std::cos(angleRad);
    double sinA = std::sin(angleRad);
    // Центр прямоугольника
    double cx = x_target + width_target * 0.5;
    double cy = y_target + height_target * 0.5;
    // Локальные (dx, dy)
    std::array<std::pair<double,double>,4> local = {
        std::make_pair(-width_target * 0.5, -height_target * 0.5), // A
        std::make_pair( width_target * 0.5, -height_target * 0.5), // B
        std::make_pair( width_target * 0.5,  height_target * 0.5), // C
        std::make_pair(-width_target * 0.5,  height_target * 0.5)  // D
    };
    // Поворот вершин
    std::array<std::pair<double,double>,4> rotated;
    for (int i = 0; i < 4; ++i) {
        double dx = local[i].first;
        double dy = local[i].second;
        double rx = cx + dx * cosA - dy * sinA;
        double ry = cy + dx * sinA + dy * cosA;
        rotated[i] = {rx, ry};
    }
    // Найдём ближайшую вершину по нужной стороне
    double targetX = x_target;
    double targetY = y_target;

    switch (target_bottom) {
    case false: {
        // хотим min y == 0
        double minY = rotated[0].second;
        for (int i = 1; i < 4; ++i)
            minY = std::min(minY, rotated[i].second);
        // сдвиг (если выше 0 — вниз; если ниже также вниз)
        targetY = y_target - minY;
        break;
    }
    case true: {
        // хотим max y == fieldHeight
        double maxY = rotated[0].second;
        for (int i = 1; i < 4; ++i)
            maxY = std::max(maxY, rotated[i].second);
        double diff = fieldHeight - maxY;
        targetY = y_target + diff;
        break;
    }
    }

    // Теперь ensure, что после перемещения bounding box не выходит за границы окна
    // 1) пересчитаем центр после смещения
    double newCx = targetX + width_target * 0.5;
    double newCy = targetY + height_target * 0.5;

    // 2) пересчитаем все rotated
    for (int i = 0; i < 4; ++i) {
        double dx = local[i].first;
        double dy = local[i].second;
        double rx = newCx + dx * cosA - dy * sinA;
        double ry = newCy + dx * sinA + dy * cosA;
        rotated[i] = {rx, ry};
    }

    // 3) снова AABB
    double minX2 = rotated[0].first, maxX2 = rotated[0].first;
    double minY2 = rotated[0].second, maxY2 = rotated[0].second;
    for (int i = 1; i < 4; ++i) {
        minX2 = std::min(minX2, rotated[i].first);
        maxX2 = std::max(maxX2, rotated[i].first);
        minY2 = std::min(minY2, rotated[i].second);
        maxY2 = std::max(maxY2, rotated[i].second);
    }

    // корректируем, если что-то вылезло
    if (minX2 < 0) targetX += -minX2;
    if (maxX2 > fieldWidth) targetX -= (maxX2 - fieldWidth);
    if (minY2 < 0) targetY += -minY2;
    if (maxY2 > fieldHeight) targetY -= (maxY2 - fieldHeight);
    x_target=targetX;
    y_target=targetY;
}

void Level_1::checkCollision(){
    if(x_target >= x-(height/9) && x_target <= x+(height/9))if(y_target >= y-(height/9) && y_target <= y+(height/9))
            if(rotation_target >= rotation-10 && rotation_target <= rotation+10)
            {playCoinSound();targets+=1;
                if(target_bottom==true){target_bottom=false;}else if(target_bottom==false){target_bottom=true;};
                emit ChangedTargets(targets);
                if(targets==5){killMyTimer();qDebug()<<"targets:"<<targets<<"laps"<<laps;emit finish(laps,m_Difficulty);}
                new_place_target();
            }}

void Level_1::startMyTimer(){
    if(!timerRunning) {
        timerId = startTimer(DELAY);
        timerRunning = true;
        qDebug()<<"Таймер";}
}

void Level_1::killMyTimer(){
    if (timerRunning) {
        killTimer(timerId);
        timerId = 0;//надо обнулять, если timerId>0, значит таймер запускался
        timerRunning = false;
    }
}

void Level_1::increaseRotation(){
    if(rotation==-90){rotation=0;}
    //исскуственное замедление чувствительности
    if(sensitive==2){rotation+=5;sensitive=0;}else{sensitive+=1;};
    //rotation+=5;
    changePosition();
    emit ChangedRotation(rotation);
    emit ChangedX(x);
    emit ChangedY(y);
}

void Level_1::decreaseRotation(){
    if(rotation==-90){rotation=0;}
    //исскуственное замедление чувствительности
    if(sensitive==2){rotation-=5;sensitive=0;}else{sensitive+=1;};
        //rotation+=5;
    changePosition();
    emit ChangedRotation(rotation);
    emit ChangedX(x);
    emit ChangedY(y);
}

void Level_1::playCoinSound(){
    if (m_coinSound.status() == QSoundEffect::Ready) {
        m_coinSound.play();
    }
}

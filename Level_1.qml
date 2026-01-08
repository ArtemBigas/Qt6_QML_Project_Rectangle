import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import level_1

Item {
    id:item
anchors.fill: parent
Level_1{id: level_1Obj
    //реагируем на сигнал void finish(rounds)
    onFinish: (rounds_end,difficulty_end) => {finishPopup.open();rounds.text = "Number of rounds: " + rounds_end;
              difficulty.text="Difficulty:"+difficulty_end}}
//запускаем при открытии
Component.onCompleted: { infoDialog.open()}
Popup  {
        id: infoDialog
        anchors.centerIn: Overlay.overlay   // Центр в пространстве overlay
        modal: true // <-- блокирует все остальные элементы
         closePolicy: Popup.NoAutoClose  // запрещает закрытие ESC и кликом вне
        contentItem:
       ColumnLayout{
       anchors.fill: parent
       spacing:10
       Text {
           text:
        "You play as a red square moving clockwise.
Your goal is to match it with the square's image five times in the minimum number of circles and time.
        Tapping the game board stops the movement. Dragging it up or down rotates the red square, thereby changing its trajectory."
               horizontalAlignment: Text.AlignHCenter
               wrapMode: Text.WordWrap
               font.pixelSize: 15
       }
       RadioButton{text:"easy";checked:true;ButtonGroup.group: difficultyGroup;Layout.alignment: Qt.AlignHCenter;font.pixelSize:15}
       RadioButton{text:"medium";ButtonGroup.group: difficultyGroup;Layout.alignment: Qt.AlignHCenter;font.pixelSize:15}
       RadioButton{text:"hard";ButtonGroup.group: difficultyGroup;Layout.alignment: Qt.AlignHCenter;font.pixelSize:15}
       ButtonGroup { id: difficultyGroup }//ссылка на выбранную RadioButton
            Button {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: parent.height/6
                  Layout.preferredWidth: parent.width/3
                  hoverEnabled:false  // отключить стилизацию наведения
                   Text{text:"OK";padding: 2;font.pixelSize:22;color:"black";anchors.centerIn: parent;font.family: "Verdana"}
                //обязательно скобки
                onClicked: {
                  level_1Obj.setDifficulty(difficultyGroup.checkedButton.text) // передаём в C++
                  level_1Obj.startMyTimer()
                  infoDialog.close()}
            }
        }}
Popup  {
        id: finishPopup
        anchors.centerIn: Overlay.overlay   // Центр в пространстве overlay
        modal: true // <-- блокирует все остальные элементы
         closePolicy: Popup.NoAutoClose  // запрещает закрытие ESC и кликом вне
        contentItem:
       ColumnLayout{
       spacing:10
       Text{text:"Level completed"
       Layout.alignment: Qt.AlignHCenter;font.pixelSize:15}
       Text{id:difficulty;text:"Сложность:"
       Layout.alignment: Qt.AlignHCenter;font.pixelSize:15}
       Text{id:rounds;text:"Количество кругов:"
       Layout.alignment: Qt.AlignHCenter;font.pixelSize:15}
            Button {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: parent.height/6
                  Layout.preferredWidth: parent.width/3
                  hoverEnabled:false  // отключить стилизацию наведения
                Text{text:"OK";padding: 2;font.pixelSize:20;color:"black";anchors.centerIn: parent;font.family: "Verdana"}
                //обязательно скобки
                onClicked: {stackView.push("Levels.qml");finishPopup.close()}
            }
        }}
Image{
anchors.fill: parent
//зависит от уровня
source:"images/background_level_1.png"
RowLayout{
    anchors.fill: parent
    spacing: 0
ColumnLayout{
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignVCenter
    spacing: 10
    Label {
        text: "  ";font.pixelSize:22
        padding: 2//расстояние от текста до краев
        background: Rectangle {//просто фон,без Rectangle,Label не поддерживает
            color: "transparent"
            radius: 6
        }
    }
    Label {
        text: "  ";font.pixelSize:22
        padding: 2//расстояние от текста до краев
        background: Rectangle {//просто фон,без Rectangle,Label не поддерживает
            color: "transparent"
            radius: 6
        }
    }
    Label {
        text: "  ";font.pixelSize:22
        padding: 2//расстояние от текста до краев
        background: Rectangle {//просто фон,без Rectangle,Label не поддерживает
            color: "transparent"
            radius: 6
        }
    }
    Button{
    id: pause
    hoverEnabled: false
    Layout.preferredHeight: item.height/6
    Layout.minimumWidth: item.width/6
    Layout.preferredWidth: item.width/6
    Text{id:text_pause;text:"PAUSE";font.pixelSize:22;color:"white";anchors.centerIn: parent;font.family: "Verdana"}
    background: Rectangle {
           id: btnBg_setting
           anchors.fill: parent
           radius: 14
           // Градиентный фон
           gradient: Gradient {
               GradientStop { position: 0.0; color: "green" }
               GradientStop { position: 1.0; color: "darkgreen" }
           }
              }
//храним значение Pause
    property bool isPaused: false
    onClicked: { if (!isPaused) {
    // Первая пауза
    level_1Obj.killMyTimer()
    text_pause.text = "RESUME"
    isPaused = true
    } else {
    // Повторное нажатие — возобновляем
    level_1Obj.startMyTimer()
    text_pause.text = "PAUSE"
    isPaused = false
    }}
    // Анимация уменьшения при нажатии
            onPressed: {
                pressAnim_pause.to = 0.9    // уменьшаем до 90%
                pressAnim_pause.start()
            }
            onReleased: {
                releaseAnim_pause.to = 1.0  // возвращаем обратно
                releaseAnim_pause.start()
            }
            // Анимации
                    NumberAnimation {
                        id: pressAnim_pause
                        target: pause
                        property: "scale"
                        duration: 100
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        id: releaseAnim_pause
                        target: pause
                        property: "scale"
                        duration: 150
                        easing.type: Easing.InOutQuad
                    }}
    }
ColumnLayout{
    Layout.fillWidth: true
    Layout.preferredHeight: parent.height
    // вертикальные отступы
    Layout.topMargin: 20
    Layout.bottomMargin: 20
    spacing: 10
Rectangle{
    id: play_field
    color: "white"
    Layout.fillWidth: true
    Layout.preferredHeight: parent.height
    //Component.onCompleted — чтобы сразу при создании объекта C++ получил начальное значение
    Component.onCompleted:{
        level_1Obj.fieldWidth_qml = width
        level_1Obj.fieldHeight_qml = height}
    //onWidthChanged — чтобы в дальнейшем отслеживать любые изменения этого значения
    onWidthChanged: level_1Obj.fieldWidth_qml = width
    onHeightChanged: level_1Obj.fieldHeight_qml = height
    //MouseArea должна быть обязательно в области
    MouseArea {
        id: mouseArea
        //на весь window
        anchors.fill: play_field
        // чтобы positionChanged работал и без нажатия
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton
        property real prevY: 0
        property bool isDragging: false
        onPressed: {
            level_1Obj.killMyTimer()
            prevY = mouse.y
            isDragging = true}
        onReleased: {
            level_1Obj.startMyTimer()
            isDragging = false}
//реакция на изменение позиции
        onPositionChanged: {
            if (isDragging && (mouse.buttons & Qt.LeftButton)) {
                // текущая позиция мыши
                var currentY = mouse.y
                if (currentY < prevY) {
                    // двигались вверх
                    level_1Obj.decreaseRotation()
                } else if (currentY > prevY) {
                    // двигались вниз
                    level_1Obj.increaseRotation()}
                prevY = currentY}}}
    Rectangle{
        id:rectangle_target
        x:level_1Obj.x_target_qml
        y:level_1Obj.y_target_qml
        rotation:level_1Obj.rotation_target_qml
        //находим минимум между шириной и длиной поля
        width:Math.min(play_field.width, play_field.height) / 6
        height:Math.min(play_field.width, play_field.height) / 6
        antialiasing: true
        border.color:"red"
        // Передаём значения в C++
        //Component.onCompleted — чтобы сразу при создании объекта C++ получил начальное значение
           Component.onCompleted: {
               level_1Obj.width_target_qml = width
               level_1Obj.height_target_qml = height
           }
           //onWidthChanged — чтобы в дальнейшем отслеживать любые изменения этого значения
           onWidthChanged: level_1Obj.width_target_qml = width
            onHeightChanged: level_1Obj.height_target_qml = height
    }
Rectangle{
    id:rectangle
    x:level_1Obj.x_qml
    y:level_1Obj.y_qml
    rotation:level_1Obj.rotation_qml
    width:Math.min(play_field.width, play_field.height) / 6
    height:Math.min(play_field.width, play_field.height) / 6
    antialiasing: true
    color:"red"
    // Передаём значения в C++
    //Component.onCompleted — чтобы сразу при создании объекта C++ получил начальное значение
       Component.onCompleted: {
           level_1Obj.width_qml = width
           level_1Obj.height_qml = height
       }
       //onWidthChanged — чтобы в дальнейшем отслеживать любые изменения этого значения
       onWidthChanged: level_1Obj.width_qml = width
        onHeightChanged: level_1Obj.height_qml = height
}
}}
ColumnLayout{
           Layout.fillWidth: true
           Layout.alignment: Qt.AlignVCenter
           spacing: 10
           Label {
               id: targetsLabel
               text: level_1Obj.targets_qml+"/5";font.pixelSize:22
               padding: 2//расстояние от текста до краев
               background: Rectangle {//просто фон,без Rectangle,Label не поддерживает
                   color: "white"
                   radius: 6
               }
           }
           Label {
               id:roundsLabel
               text: "Laps:"+level_1Obj.laps_qml;font.pixelSize:22
               padding: 2//расстояние от текста до краев
               background: Rectangle {//просто фон,без Rectangle,Label не поддерживает
                   color: "white"
                   radius: 6
               }
           }
           Label {
               id:timerLabel
               text: "";font.pixelSize:22
               padding: 2//расстояние от текста до краев
               background: Rectangle {//просто фон,без Rectangle,Label не поддерживает
                   color: "white"
                   radius: 6
               }
           }
           Button{
           id: return_menu
           //text: "RETURN"; font.pixelSize: 15
           hoverEnabled: false
           Layout.preferredHeight: item.height/6
           Layout.minimumWidth: item.width/6
           Layout.preferredWidth: item.width/6
           Text{id:text_return;text:"RETURN";font.pixelSize:22;color:"white";anchors.centerIn: parent;font.family: "Verdana"}
           background: Rectangle {
                             id: btnBg_return
                             anchors.fill: parent
                             radius: 14
                             // Градиентный фон
                             gradient: Gradient {
                                 GradientStop { position: 0.0; color: "green" }
                                 GradientStop { position: 1.0; color: "darkgreen" }
                             }
                                }
           onClicked: { stackView.push("Levels.qml");level_1Obj.killMyTimer()}
           // Анимация уменьшения при нажатии
                              onPressed: {
                                  pressAnim_return.to = 0.9    // уменьшаем до 90%
                                  pressAnim_return.start()
                              }
                              onReleased: {
                                  releaseAnim_return.to = 1.0  // возвращаем обратно
                                  releaseAnim_return.start()
                              }
                              // Анимации
                                      NumberAnimation {
                                          id: pressAnim_return
                                          target: return_menu
                                          property: "scale"
                                          duration: 100
                                          easing.type: Easing.InOutQuad
                                      }
                                      NumberAnimation {
                                          id: releaseAnim_return
                                          target: return_menu
                                          property: "scale"
                                          duration: 150
                                          easing.type: Easing.InOutQuad
}}
}}}
}

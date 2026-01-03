import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id:mainMenu
    anchors.fill: parent
    Image{
    anchors.fill: parent
source:"images/background.png"

ColumnLayout{
    //все пространство занимает колонна
    anchors.fill: parent
    Layout.fillHeight: true
    Layout.fillWidth: true
    spacing:5
    Button{
    id:play
    //привязали все размеры к размеру окна, поэтому при увеличении размера окна,увеличиваются и объекты
    //постоянный отступ от верха
    //Layout.topMargin: parent.height/6
    //размеры
    Layout.alignment: Qt.AlignHCenter
    Layout.preferredHeight: parent.height/6
    Layout.preferredWidth: parent.height/3
    hoverEnabled:false  // отключить стилизацию наведения
    Text{text:"Play";font.pixelSize:22;color:"red";anchors.centerIn: parent;font.family: "Verdana"}
    background: Rectangle {
           id: btnBg_play
           anchors.fill: parent
           radius: 14
           // Градиентный фон
           gradient: Gradient {
               GradientStop { position: 0.0; color: "yellow" }
               GradientStop { position: 1.0; color: "orange" }
           }
              }
    // Анимация уменьшения при нажатии
        onPressed: {
            pressAnim_play.to = 0.9    // уменьшаем до 90%
            pressAnim_play.start()
        }
        onReleased: {
            releaseAnim_play.to = 1.0  // возвращаем обратно
            releaseAnim_play.start()
        }

        // Запуск уровня
        onClicked: {
            stackView.push("Levels.qml")
        }
    // Анимации
        NumberAnimation {
            id: pressAnim_play
            target: play
            property: "scale"
            duration: 100
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            id: releaseAnim_play
            target: play
            property: "scale"
            duration: 150
            easing.type: Easing.InOutQuad
        }}

    /*Button{
    id:setting
    //привязали все размеры к размеру окна, поэтому при увеличении размера окна,увеличиваются и объекты
    //размеры
    Layout.alignment: Qt.AlignHCenter
    Layout.preferredHeight: parent.height/6
    Layout.preferredWidth: parent.height/3
    hoverEnabled:false  // отключить стилизацию наведения
    Text{text:"Setting(in progress)";font.pixelSize:22;color:"red";anchors.centerIn: parent;font.family: "Verdana"}
    background: Rectangle {
           id: btnBg_setting
           anchors.fill: parent
           radius: 14
           // Градиентный фон
           gradient: Gradient {
               GradientStop { position: 0.0; color: "yellow" }
               GradientStop { position: 1.0; color: "orange" }
           }
              }
    // Анимация уменьшения при нажатии
        onPressed: {
            pressAnim_setting.to = 0.9    // уменьшаем до 90%
            pressAnim_setting.start()
        }
        onReleased: {
            releaseAnim_setting.to = 1.0  // возвращаем обратно
            releaseAnim_setting.start()
        }


        //onClicked: {}

    // Анимации
        NumberAnimation {
            id: pressAnim_setting
            target: setting
            property: "scale"
            duration: 100
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            id: releaseAnim_setting
            target: setting
            property: "scale"
            duration: 150
            easing.type: Easing.InOutQuad
        }}*/

   /* Button{
    id:highscores
    //привязали все размеры к размеру окна, поэтому при увеличении размера окна,увеличиваются и объекты
    //размеры
    Layout.alignment: Qt.AlignHCenter
    Layout.preferredHeight: parent.height/6
    Layout.preferredWidth: parent.height/3
    hoverEnabled:false  // отключить стилизацию наведения
    Text{text:"Highscores(in progress)";font.pixelSize:22;color:"red";anchors.centerIn: parent;font.family: "Verdana"}
    background: Rectangle {
           id: btnBg_highscores
           anchors.fill: parent
           radius: 14
           // Градиентный фон
           gradient: Gradient {
               GradientStop { position: 0.0; color: "yellow" }
               GradientStop { position: 1.0; color: "orange" }
           }
              }
    // Анимация уменьшения при нажатии
        onPressed: {
            pressAnim_highscores.to = 0.9    // уменьшаем до 90%
            pressAnim_highscores.start()
        }
        onReleased: {
            releaseAnim_highscores.to = 1.0  // возвращаем обратно
            releaseAnim_highscores.start()
        }

        // Запуск уровня
        //onClicked: {}
    // Анимации
        NumberAnimation {
            id: pressAnim_highscores
            target: highscores
            property: "scale"
            duration: 100
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            id: releaseAnim_highscores
            target: highscores
            property: "scale"
            duration: 150
            easing.type: Easing.InOutQuad
        }}*/


    Button{
    id:exit
    //привязали все размеры к размеру окна, поэтому при увеличении размера окна,увеличиваются и объекты
    //размеры
    Layout.alignment: Qt.AlignHCenter
    Layout.preferredHeight: parent.height/6
    Layout.preferredWidth: parent.height/3
    hoverEnabled:false  // отключить стилизацию наведения
    Text{text:"EXIT";font.pixelSize:22;color:"red";anchors.centerIn: parent;font.family: "Verdana"}
    background: Rectangle {
           id: btnBg_exit
           anchors.fill: parent
           radius: 14
           // Градиентный фон
           gradient: Gradient {
               GradientStop { position: 0.0; color: "yellow" }
               GradientStop { position: 1.0; color: "orange" }
           }
              }
    // Анимация уменьшения при нажатии
        onPressed: {
            pressAnim_exit.to = 0.9    // уменьшаем до 90%
            pressAnim_exit.start()
        }
        onReleased: {
            releaseAnim_exit.to = 1.0  // возвращаем обратно
            releaseAnim_exit.start()
        }

        onClicked: Qt.quit()
    // Анимации
        NumberAnimation {
            id: pressAnim_exit
            target: exit
            property: "scale"
            duration: 100
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            id: releaseAnim_exit
            target: exit
            property: "scale"
            duration: 150
            easing.type: Easing.InOutQuad
        }}
    }}
}

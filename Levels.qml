import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
Item {
    id:levels
    anchors.fill: parent
    Image{
       anchors.fill: parent
   source:"images/background_levels.png"
   GridLayout{
       anchors.fill: parent
       Layout.fillHeight: true
       Layout.fillWidth: true
       columns: 4  // два столбца
       rows: 4     // две строки
       rowSpacing: 5 // пространство между строками
       columnSpacing: 5 // пространство между столбцами
       Button{
           id:level_1
           //привязали все размеры к размеру окна, поэтому при увеличении размера окна,увеличиваются и объекты
           //размеры
           Layout.alignment: Qt.AlignHCenter
           Layout.preferredHeight: parent.height/6
           Layout.preferredWidth: parent.height/3
           hoverEnabled:false  // отключить стилизацию наведения
           Text{text:"Level 1";font.pixelSize:22;color:"pink";anchors.centerIn: parent;font.family: "Verdana"}
           background: Rectangle {
                  id: btnBg_level_1
                  anchors.fill: parent
                  radius: 14
                  // Градиентный фон
                  gradient: Gradient {
                      GradientStop { position: 0.0; color: "purple" }
                      GradientStop { position: 1.0; color: "orange" }
                  }
                     }
           // Анимация уменьшения при нажатии
               onPressed: {
                   pressAnim_level_1.to = 0.9    // уменьшаем до 90%
                   pressAnim_level_1.start()
               }
               onReleased: {
                   releaseAnim_level_1.to = 1.0  // возвращаем обратно
                   releaseAnim_level_1.start()
               }

               // Запуск уровня
               onClicked: {
                   stackView.push("Level_1.qml")
               }
           // Анимации
               NumberAnimation {
                   id: pressAnim_level_1
                   target: level_1
                   property: "scale"
                   duration: 100
                   easing.type: Easing.InOutQuad
               }
               NumberAnimation {
                   id: releaseAnim_level_1
                   target: return_menu
                   property: "scale"
                   duration: 150
                   easing.type: Easing.InOutQuad
               }}


    /*Button{
    id:level_2
    text:"Level 2";font.pixelSize:15
    Layout.alignment: Qt.AlignHCenter
    Layout.preferredHeight: parent.height/6
    Layout.preferredWidth: parent.height/3}*/
       Button{
           id:return_menu
           //привязали все размеры к размеру окна, поэтому при увеличении размера окна,увеличиваются и объекты
           //размеры
           Layout.alignment: Qt.AlignHCenter
           Layout.preferredHeight: parent.height/6
           Layout.preferredWidth: parent.height/3
           hoverEnabled:false  // отключить стилизацию наведения
           Text{text:"RETURN";font.pixelSize:22;color:"pink";anchors.centerIn: parent;font.family: "Verdana"}
           background: Rectangle {
                  id: btnBg_return_menu
                  anchors.fill: parent
                  radius: 14
                  // Градиентный фон
                  gradient: Gradient {
                      GradientStop { position: 0.0; color: "purple" }
                      GradientStop { position: 1.0; color: "orange" }
                  }
                     }
           // Анимация уменьшения при нажатии
               onPressed: {
                   pressAnim_return_menu.to = 0.9    // уменьшаем до 90%
                   pressAnim_return_menu.start()
               }
               onReleased: {
                   releaseAnim_return_menu.to = 1.0  // возвращаем обратно
                   releaseAnim_return_menu.start()
               }

               // Запуск уровня
               onClicked: {
                   stackView.push("Main_Menu.qml")
               }
           // Анимации
               NumberAnimation {
                   id: pressAnim_return_menu
                   target: return_menu
                   property: "scale"
                   duration: 100
                   easing.type: Easing.InOutQuad
               }
               NumberAnimation {
                   id: releaseAnim_return_menu
                   target: return_menu
                   property: "scale"
                   duration: 150
                   easing.type: Easing.InOutQuad
               }}
   }}
}

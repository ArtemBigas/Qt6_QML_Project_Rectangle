import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import settings
Item {
    id:item
    anchors.fill:parent
    Settings{id:settingsObj}
    Image{
        anchors.fill:parent
        source:"images/background_setting"
        ColumnLayout{
        anchors.fill:parent
        //пространство между соседними элементами
        spacing:0
        Label{text:"SETTING";font.pixelSize:22;padding:2;Layout.alignment: Qt.AlignHCenter
        background: Rectangle {//просто фон,без Rectangle,Label не поддерживает
        color: "white"
        radius: 6
        }}
        ColumnLayout{spacing:0;Layout.alignment: Qt.AlignHCenter
        Label{text:"SOUND VOLUME";font.pixelSize:22;padding:2;Layout.alignment: Qt.AlignHCenter
        background: Rectangle {//просто фон,без Rectangle,Label не поддерживает
        color: "white"
        radius: 6
        }}
        RowLayout{
        Layout.alignment: Qt.AlignHCenter
        Slider{id:volume_slider
        //растягивается по высоте контейнера с учетом минимальной и максимальный высоты элемента.
        Layout.fillHeight: true
        //растягивается по ширине контейнера с учетом минимальной и максимальный ширины элемента
        Layout.fillWidth: true
        Layout.maximumHeight:item.height/10
        Layout.maximumWidth:item.width/2
        from:0;value:settingsObj.volume_qml;
        to:9;stepSize:1;
        snapMode: Slider.SnapAlways // прилипает к шагам во время перетаскивания
        onMoved:{volume_text.text=value;settingsObj.volume_qml = value}
        }
        Label{id:volume_text;text:volume_slider.value;font.pixelSize:22;padding:2;Layout.alignment:Qt.AlignHCenter}
        }}
        ColumnLayout{spacing:0;Layout.alignment: Qt.AlignHCenter
        Label{text:"SENSITIVY Y";font.pixelSize:22;padding:2;Layout.alignment: Qt.AlignHCenter
        background: Rectangle {//просто фон,без Rectangle,Label не поддерживает
        color: "white"
        radius: 6
        }}
        RowLayout{Slider{id:sensitivy_slider
        //растягивается по высоте контейнера с учетом минимальной и максимальный высоты элемента.
        Layout.fillHeight: true
        //растягивается по ширине контейнера с учетом минимальной и максимальный ширины элемента
        Layout.fillWidth: true
        Layout.maximumHeight:item.height/10
        Layout.maximumWidth:item.width/2
        from:0;value:settingsObj.sensitive_qml;
        to:9;stepSize:1
        snapMode: Slider.SnapAlways // прилипает к шагам во время перетаскивания
        onMoved:{sensitivy_text.text=value;settingsObj.sensitive_qml = value}}
        Label{id:sensitivy_text;text:sensitivy_slider.value;font.pixelSize:22;padding:2;Layout.alignment:Qt.AlignHCenter}
        }}
        Button{
        id:ok
        //привязали все размеры к размеру окна, поэтому при увеличении размера окна,увеличиваются и объекты
        //размеры
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredHeight: parent.height/6
        Layout.preferredWidth: parent.height/3
        hoverEnabled:false  // отключить стилизацию наведения
        Text{text:"OK";font.pixelSize:22;color:"red";anchors.centerIn: parent;font.family: "Verdana"}
        background: Rectangle {
               id: btnBg_ok
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
                pressAnim_ok.to = 0.9    // уменьшаем до 90%
                pressAnim_ok.start()
            }
            onReleased: {
                releaseAnim_ok.to = 1.0  // возвращаем обратно
                releaseAnim_ok.start()
            }
            onClicked: {stackView.pop()}
        // Анимации
            NumberAnimation {
                id: pressAnim_ok
                target: ok
                property: "scale"
                duration: 100
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                id: releaseAnim_ok
                target: ok
                property: "scale"
                duration: 150
                easing.type: Easing.InOutQuad
            }}
        }
    }
}

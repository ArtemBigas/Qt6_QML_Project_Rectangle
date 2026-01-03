import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id: window
    width: 1280
    height: 720
    visible: true
    title: "Main Menu"

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: Main_Menu { }  // стартовая страница — компонент из файла MainMenu.qml, это не его id Item
    }
}

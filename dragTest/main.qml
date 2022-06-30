import QtQuick 2.15
import QtQuick.Window 2.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.15

Window {
    id: mainWindow

    title: qsTr("Draggable Split View")
    minimumWidth: 800
    minimumHeight: 800
    visible: true
    color: "dimgrey"

    Component {
        id: splitHandle

        Rectangle {
            implicitWidth: 5
            implicitHeight: 5
            color: SplitHandle.pressed ? "#81e889" : (SplitHandle.hovered ? Qt.lighter("#c2f4c6", 1.1) : "#c2f4c6")
        }
    }

    MouseArea {
        id: splitViewMA
        anchors.fill: parent
    }

    SplitView {
        id: splitView

        anchors.fill: parent
        anchors.margins: 20
        orientation: Qt.Horizontal
        handle: splitHandle

        // Вертикальный левый
        Item {
            implicitWidth: parent.width/2
            SplitView.minimumWidth: 50

            SplitView {
                id: sp1
                anchors.fill: parent
                orientation: Qt.Vertical
                handle: splitHandle

                Element {
                    visualIndex: 0
                    splitV: sp1
                    color: "red"
                }

                Element {
                    visualIndex: 1
                    splitV: sp1
                    color: "blue"
                }

                function updateIndex() {
                    for (var i = 0; i < sp1.children.length; ++i) {
                        sp1.itemAt(i).visualIndex = i
                    }
                }
            }
        }

        // Вертикальный правый
        Item {
            SplitView.minimumWidth: 50

            SplitView {
                id: sp2
                anchors.fill: parent
                orientation: Qt.Vertical
                handle: splitHandle

                Element {
                    visualIndex: 0
                    splitV: sp2
                    color: "green"
                }

                Element {
                    visualIndex: 1
                    splitV: sp2
                    color: "yellow"
                }

                function updateIndex() {
                    for (var i = 0; i < sp2.children.length; ++i)
                        sp2.itemAt(i).visualIndex = i
                }
            }
        }
    }
}

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

DropArea {
    id: root

    // Для перемещений в SplitView
    required property color color
    required property SplitView splitV
    required property int visualIndex

    // Для dockable'ности
    property var targetItem: root
    property var targetParent: root.parent
    property string windowTitle: ""
    property color windowColor: "transparent"

    implicitHeight: splitV.height/splitV.children.length

    onEntered: {
        // Не дает вынести последний объект из SplitView
        if (drag.source.parent.splitV.children.length === 1)
            return
        // Перемещения в пределах одного SplitView
        if (drag.source.parent.splitV === root.splitV)
            splitV.moveItem(drag.source.parent.visualIndex, root.visualIndex)
        // Пермещение в другой SplitView
        else {
            var item = drag.source.parent.splitV.takeItem(drag.source.parent.visualIndex)
            drag.source.parent.splitV.updateIndex()
            item.splitV = root.splitV
            root.splitV.insertItem(root.visualIndex, item)
        }
        splitV.updateIndex()
    }

    Rectangle {
        id: rect

        width: parent.width
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: root.color
        opacity: 0.2
        states: [
            State {
                when: dragHandler.active
                AnchorChanges {
                    target: rect
                    anchors.horizontalCenter: undefined
                    anchors.verticalCenter: undefined
                }
            }
        ]

        Text {
            anchors.centerIn: parent
            color: "white"
            text: visualIndex
        }

        DragHandler {
            id: dragHandler
            cursorShape: Qt.ClosedHandCursor
        }

        Drag.active: dragHandler.active
        Drag.source: rect
        Drag.hotSpot.x: ma.mouseX
        Drag.hotSpot.y: ma.mouseY

        // Для отслеживания координат курсора
        MouseArea {
            id: ma
            anchors.fill: parent
        }

        Button {
            id: dockButton

            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 5
            anchors.topMargin: 5
            width: 40; height: 40
            state: "docked"
            states: [
                State {
                    name: "undocked"
                    ParentChange { target: targetItem; parent: undockedParent; x: 0; y: 0 }
                },
                State {
                    name: "docked"
                    ParentChange { target: targetItem; parent: targetParent; x: 0; y: 0 }
                }
            ]

            onStateChanged: {
                // Добавляет элемент в SplitView на место, где он был до выхода
                if (dockButton.state === "docked") {
                    undockedWindow.visible = false
                    splitV.insertItem(root.visualIndex, root)
                    splitV.updateIndex()
                }
                // Удаляет элемент из SplitView
                else {
                    undockedWindow.visible = true
                    splitV.takeItem(visualIndex)
                    splitV.updateIndex()
                }
            }

            onClicked: dockButton.state === "docked" ? dockButton.state = "undocked" : dockButton.state = "docked"
        }
    }

    Window {
        id: undockedWindow

        x: targetItem.x; y: targetItem.y
        width: targetItem.width; height: targetItem.height
        minimumHeight: targetItem.height
        minimumWidth: targetItem.width
        visible: false
        title: windowTitle

        // @disable-check M16
        onClosing: {
            close.accepted = false // Если убрать, то будет закрывать все приложение
            visible = false
            dockButton.state = "docked"
        }

        Rectangle {
            id: undockedParent

            anchors.fill: parent
            color: windowColor
        }
    }
}

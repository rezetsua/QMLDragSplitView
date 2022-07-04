import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

DropArea {
    id: root

    // Для перемещений в SplitView
    required property SplitView splitV
    required property color color
    required property int visualIndex

    // Для dockable'ности
    property var targetItem: root
    property var targetParent: root.parent
    property string windowTitle: ""
    property color windowColor: "transparent"

    SplitView.preferredHeight: splitV.height/splitV.contentChildren.length
    SplitView.minimumHeight: 50
    SplitView.fillHeight: true
    // Растягивает объект в оконном режиме
    anchors.fill: dockButton.state === "docked" ? undefined : parent


    onEntered: {
        // Перемещения в пределах одного SplitView
        if (drag.source.dropArea.splitV === root.splitV)
            splitV.moveItem(drag.source.dropArea.visualIndex, root.visualIndex)
        // Перемещение в другой SplitView
        else {
            var item = drag.source.dropArea.splitV.takeItem(drag.source.dropArea.visualIndex)
            updateIndex(drag.source.dropArea.splitV)
            item.splitV = root.splitV
            root.splitV.insertItem(root.visualIndex, item)
        }
        updateIndex(splitV)
    }

    // Закрывает побочные окна при закрытии основного
    Connections {
        target: mainWindow
        function onClosing() {
            undockedWindow.close()
        }
    }

    Rectangle {
        id: rect

        // Нужны для запомнинания предыдущих размеров объекта
        // (чтобы объект не жмыхало при перемещении и для инициализации минимальных размеров окна)
        property int oldWidth: 0
        property int oldHeight: 0
        property var dropArea: root

        width: dragHandler.active ? oldWidth : parent.width
        height: dragHandler.active ? oldHeight : parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: root.color
        opacity: 0.2
        states: [
            State {
                when: dragHandler.active
                ParentChange {
                    target: rect
                    parent: splitV.parent
                }
                PropertyChanges {
                    target: rect
                    dropArea: root
                }
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

            enabled: (lastElement || dockButton.state === "undocked") ? false : true
            cursorShape: Qt.ClosedHandCursor

            onActiveChanged: updateOldSize()
        }

        Drag.active: dragHandler.active
        Drag.source: rect
        Drag.hotSpot.x: ma.mouseX
        Drag.hotSpot.y: ma.mouseY

        // Для отслеживания координат курсора
        MouseArea {
            id: ma
            cursorShape: dragHandler.active ? Qt.ClosedHandCursor : Qt.ArrowCursor
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
                    updateIndex(splitV)
                }
                // Удаляет элемент из SplitView
                else {
                    undockedWindow.visible = true
                    splitV.takeItem(visualIndex)
                    updateIndex(splitV)
                }
            }

            onClicked: {
                // Не дает убрать последний элемент из SplitView
                if (lastElement && dockButton.state === "docked")
                    return
                updateOldSize()
                dockButton.state = dockButton.state === "docked" ? "undocked" : "docked"
            }
        }
    }

    Window {
        id: undockedWindow

        x: targetItem.x; y: targetItem.y
        width: targetItem.width; height: targetItem.height
        minimumHeight: rect.oldHeight
        minimumWidth: rect.oldWidth
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

    function updateOldSize() {
        rect.oldWidth = rect.width
        rect.oldHeight = rect.height
    }
}

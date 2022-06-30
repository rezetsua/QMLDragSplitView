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

    RowLayout {
        anchors.fill: parent
        anchors.topMargin: 20
        anchors.bottomMargin: 20
        spacing: 0

        DropArea {
            Layout.fillHeight: true
            Layout.preferredWidth: 20

            onEntered: {
                if (!sp1.parent.visible) {
                    sp1.parent.visible = true
                    var item = drag.source.parent.splitV.takeItem(drag.source.parent.visualIndex)
                    drag.source.parent.splitV.updateIndex()
                    item.splitV = sp1
                    sp1.insertItem(0, item)
                }
            }
        }

        SplitView {
            id: splitView

            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: Qt.Horizontal
            handle: Handle {color: "lightgrey"}

            // Вертикальный левый
            Item {
                implicitWidth: parent.width/2
                SplitView.minimumWidth: 50

                SplitView {
                    id: sp1
                    anchors.fill: parent
                    orientation: Qt.Vertical
                    handle: Handle {color: "darkgrey"}

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
                        if (!sp1.visible)
                            return
                        for (var i = 0; i < sp1.children.length; ++i)
                            sp1.itemAt(i).visualIndex = i
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
                    handle: Handle {color: "darkgrey"}

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
                        if (!sp2.visible)
                            return
                        for (var i = 0; i < sp2.children.length; ++i)
                            sp2.itemAt(i).visualIndex = i
                    }
                }
            }
        }

        DropArea {
            Layout.fillHeight: true
            Layout.preferredWidth: 20

            onEntered: {
                if (!sp2.parent.visible) {
                    sp2.parent.visible = true
                    var item = drag.source.parent.splitV.takeItem(drag.source.parent.visualIndex)
                    drag.source.parent.splitV.updateIndex()
                    item.splitV = sp2
                    sp2.insertItem(0, item)
                }
            }
        }
    }
}

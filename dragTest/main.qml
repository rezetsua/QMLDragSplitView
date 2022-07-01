import QtQuick 2.15
import QtQuick.Window 2.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.15

Window {
    id: mainWindow

    property bool lastElement: sp1.count + sp2.count == 1

    title: "Draggable Split View"
    minimumWidth: 800
    minimumHeight: 800
    visible: true
    color: "dimgrey"

    RowLayout {
        anchors.fill: parent
        anchors.topMargin: 20
        anchors.bottomMargin: 20
        spacing: 0

        SideDropArea {
            Layout.fillHeight: true
            Layout.preferredWidth: 20
            splitV: sp1
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
                visible: sp1.count != 0

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
                }
            }

            // Вертикальный правый
            Item {
                SplitView.minimumWidth: 50
                visible: sp2.count != 0

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
                }
            }
        }

        SideDropArea {
            Layout.fillHeight: true
            Layout.preferredWidth: 20
            splitV: sp2
        }
    }

    function updateIndex(sp) {
        for (var i = 0; i < sp.contentChildren.length; ++i)
            sp.itemAt(i).visualIndex = i
    }
}

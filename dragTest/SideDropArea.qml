import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11

Rectangle {
    id: root

    required property SplitView splitV

    color: splitV.parent.visible ? "transparent" : "lightcoral"
    opacity: 0.5

    DropArea {
        anchors.fill: parent
        onEntered: {
            if (!splitV.parent.visible) {
                var item = drag.source.parent.splitV.takeItem(drag.source.parent.visualIndex)
                updateIndex(drag.source.parent.splitV)
                item.splitV = splitV
                splitV.insertItem(0, item)
                updateIndex(splitV)
            }
        }
    }
}

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
                var item = drag.source.dropArea.splitV.takeItem(drag.source.dropArea.visualIndex)
                updateIndex(drag.source.dropArea.splitV)
                item.splitV = splitV
                splitV.insertItem(0, item)
                updateIndex(splitV)
            }
        }
    }
}

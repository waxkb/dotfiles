import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Scope {
    id: root

    property string homePath: Quickshell.env("HOME")
    property string wallpaperDir: homePath + "/wall"
    property string cacheDir: homePath + "/.cache/wallpaper-picker"
    property string thumbDir: cacheDir + "/thumbs"

    property var wallpaperList: []
    property var filteredWallpapers: []
    property string searchTerm: ""
    property int selectedIndex: 0
    property bool wallsLoaded: false
    property bool thumbsReady: false

    property int sliceWidth: 140
    property int expandedWidth: 950
    property int sliceHeight: 540
    property int skewOffset: 35
    property int sliceSpacing: -24

    property int cardWidth: 1600
    property int topBarHeight: 50

    property real lastContentX: 0
    property real lastContentY: 0

    property color bgColor: "#1a1a1a"
    property color surfaceColor: "#252525"
    property color primaryColor: "#7dd3fc"
    property color textColor: "#e2e8f0"
    property color textMuted: "#94a3b8"

    function updateFilteredWallpapers() {
        if (searchTerm === "") {
            root.filteredWallpapers = wallpaperList.slice()
        } else {
            var result = []
            var term = searchTerm.toLowerCase()
            for (var i = 0; i < wallpaperList.length; i++) {
                if (wallpaperList[i].name.toLowerCase().includes(term)) {
                    result.push(wallpaperList[i])
                }
            }
            root.filteredWallpapers = result
        }
        if (filteredWallpapers.length > 0 && selectedIndex >= filteredWallpapers.length) {
            selectedIndex = 0
        }
    }

    function applyWallpaper(wallpaper) {
        applyProc.command = ["bash", "-c", "dms ipc call wallpaper set " + wallpaper.path]
        applyProc.running = true
    }

    PanelWindow {
        id: pickerPanel
        screen: Quickshell.screens[0]
        anchors { top: true; bottom: true; left: true; right: true }
        margins { top: 0; bottom: 0; left: 0; right: 0 }
        color: "transparent"
        visible: true
        focusable: true

        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.6)
        }

        MouseArea {
            anchors.fill: parent
            onClicked: Qt.quit()
        }

        Item {
            id: cardContainer
            width: root.cardWidth
            height: root.sliceHeight + root.topBarHeight + 60
            anchors.centerIn: parent

            Rectangle {
                id: filterBar
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 10
                width: filterRow.width + 32
                height: 44
                radius: 22
                color: Qt.rgba(root.surfaceColor.r, root.surfaceColor.g, root.surfaceColor.b, 0.9)

                Row {
                    id: filterRow
                    anchors.centerIn: parent
                    spacing: 12

                    Text {
                        text: "󰸉"
                        color: root.primaryColor
                        font.pixelSize: 16
                        font.family: "JetBrainsMono Nerd Font"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    TextInput {
                        id: searchInput
                        width: 200
                        height: 32
                        color: root.textColor
                        font.pixelSize: 14
                        font.family: "JetBrainsMono Nerd Font"
                        verticalAlignment: TextInput.AlignVCenter
                        selectByMouse: true
                        focus: true
                        Keys.onPressed: function(event) {
                            if (event.key === Qt.Key_Escape) {
                                Qt.quit()
                            } else if (event.key === Qt.Key_Return) {
                                if (root.filteredWallpapers.length > 0) {
                                    root.applyWallpaper(root.filteredWallpapers[root.selectedIndex])
                                }
                            } else if (event.key === Qt.Key_Left || (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_H)) {
                                if (root.selectedIndex > 0) {
                                    root.selectedIndex--
                                    sliceListView.currentIndex = root.selectedIndex
                                }
                                event.accepted = true
                            } else if (event.key === Qt.Key_Right || (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_L)) {
                                if (root.selectedIndex < root.filteredWallpapers.length - 1) {
                                    root.selectedIndex++
                                    sliceListView.currentIndex = root.selectedIndex
                                }
                                event.accepted = true
                            }
                        }
                        onTextChanged: {
                            root.searchTerm = text
                            root.updateFilteredWallpapers()
                            root.selectedIndex = 0
                            sliceListView.positionViewAtIndex(0, ListView.Beginning)
                        }
                        Text {
                            text: "Search wallpapers..."
                            color: root.textMuted
                            font.pixelSize: 14
                            font.family: "JetBrainsMono Nerd Font"
                            visible: !parent.text
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            opacity: 0.6
                        }
                    }

                    Text {
                        text: root.filteredWallpapers.length + "/" + root.wallpaperList.length
                        color: root.textMuted
                        font.pixelSize: 12
                        font.family: "JetBrainsMono Nerd Font"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            ListView {
                id: sliceListView

                anchors.top: cardContainer.top
                anchors.topMargin: root.topBarHeight + 15
                anchors.bottom: cardContainer.bottom
                anchors.bottomMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter

                property int visibleCount: 10
                width: root.expandedWidth + (visibleCount - 1) * (root.sliceWidth + root.sliceSpacing)

                orientation: ListView.Horizontal
                model: root.filteredWallpapers
                clip: false
                spacing: root.sliceSpacing

                flickDeceleration: 1500
                maximumFlickVelocity: 3000
                boundsBehavior: Flickable.StopAtBounds

                highlightFollowsCurrentItem: true
                highlightMoveDuration: 300
                preferredHighlightBegin: (width - root.expandedWidth) / 2
                preferredHighlightEnd: (width + root.expandedWidth) / 2
                highlightRangeMode: ListView.StrictlyEnforceRange

                header: Item { width: (sliceListView.width - root.expandedWidth) / 2; height: 1 }
                footer: Item { width: (sliceListView.width - root.expandedWidth) / 2; height: 1 }

                focus: true

                Connections {
                    target: root
                    function onSelectedIndexChanged() {
                        sliceListView.currentIndex = root.selectedIndex
                    }
                }

                onCurrentIndexChanged: {
                    if (currentIndex >= 0 && currentIndex !== root.selectedIndex) {
                        root.selectedIndex = currentIndex
                    }
                }

                Keys.onEscapePressed: Qt.quit()
                Keys.onReturnPressed: {
                    if (currentIndex >= 0 && currentIndex < filteredWallpapers.length) {
                        root.applyWallpaper(filteredWallpapers[currentIndex])
                    }
                }
                Keys.onPressed: function(event) {
                    if (event.key === Qt.Key_Left || (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_H)) {
                        if (root.selectedIndex > 0) root.selectedIndex--
                        event.accepted = true
                    } else if (event.key === Qt.Key_Right || (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_L)) {
                        if (root.selectedIndex < filteredWallpapers.length - 1) root.selectedIndex++
                        event.accepted = true
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    propagateComposedEvents: true
                    onWheel: function(wheel) {
                        if (wheel.angleDelta.y > 0) {
                            sliceListView.currentIndex = Math.max(0, sliceListView.currentIndex - 1)
                        } else {
                            sliceListView.currentIndex = Math.min(filteredWallpapers.length - 1, sliceListView.currentIndex + 1)
                        }
                    }
                    onClicked: function(mouse) { mouse.accepted = false }
                }

                delegate: Item {
                    id: delegateItem

                    width: isCurrent ? root.expandedWidth : root.sliceWidth
                    height: sliceListView.height
                    property bool isCurrent: ListView.isCurrentItem
                    property bool isHovered: itemMouseArea.containsMouse

                    z: isCurrent ? 100 : (isHovered ? 90 : 50 - Math.min(Math.abs(index - sliceListView.currentIndex), 50))

                    property real viewX: x - sliceListView.contentX
                    property real fadeZone: root.sliceWidth * 1.5
                    property real edgeOpacity: {
                        if (fadeZone <= 0) return 1.0
                        var center = viewX + width * 0.5
                        var leftFade = Math.min(1.0, Math.max(0.0, center / fadeZone))
                        var rightFade = Math.min(1.0, Math.max(0.0, (sliceListView.width - center) / fadeZone))
                        return Math.min(leftFade, rightFade)
                    }
                    opacity: edgeOpacity

                    Behavior on width {
                        NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
                    }

                    Canvas {
                        id: shadowCanvas
                        z: -1
                        anchors.fill: parent
                        anchors.margins: -10
                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.clearRect(0, 0, width, height)
                            var ox = 10
                            var oy = 10
                            var w = delegateItem.width
                            var h = delegateItem.height
                            var sk = root.skewOffset
                            var sx = isCurrent ? 4 : 2
                            var sy = isCurrent ? 10 : 5
                            var alpha = isCurrent ? 0.5 : 0.3
                            ctx.globalAlpha = alpha
                            ctx.fillStyle = "#000000"
                            ctx.beginPath()
                            ctx.moveTo(ox + sk + sx, oy + sy)
                            ctx.lineTo(ox + w + sx, oy + sy)
                            ctx.lineTo(ox + w - sk + sx, oy + h + sy)
                            ctx.lineTo(ox + sx, oy + h + sy)
                            ctx.closePath()
                            ctx.fill()
                        }
                    }

                    Item {
                        id: imageContainer
                        anchors.fill: parent

                        Rectangle {
                            anchors.fill: parent
                            color: Qt.rgba(0.15, 0.15, 0.15, 0.5)
                            radius: 8
                        }

                        Image {
                            id: thumbImage
                            anchors.fill: parent
                            anchors.margins: root.skewOffset
                            source: "file://" + modelData.path
                            fillMode: Image.PreserveAspectCrop
                            smooth: true
                            asynchronous: true
                            sourceSize.width: root.expandedWidth
                            sourceSize.height: root.sliceHeight
                        }

                        Rectangle {
                            anchors.fill: parent
                            color: Qt.rgba(0, 0, 0, isCurrent ? 0 : (isHovered ? 0.2 : 0.45))
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }
                    }

                    Rectangle {
                        id: glowBorder
                        anchors.fill: parent
                        radius: 8
                        color: "transparent"
                        border.width: isCurrent ? 3 : 1
                        border.color: isCurrent ? root.primaryColor : (isHovered ? Qt.rgba(root.primaryColor.r, root.primaryColor.g, root.primaryColor.b, 0.5) : Qt.rgba(0, 0, 0, 0.5))
                        Behavior on border.color { ColorAnimation { duration: 150 } }
                    }

                    Rectangle {
                        id: nameLabel
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 45
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: nameText.width + 28
                        height: 36
                        radius: 8
                        color: Qt.rgba(0, 0, 0, 0.8)
                        border.width: 1
                        border.color: Qt.rgba(root.primaryColor.r, root.primaryColor.g, root.primaryColor.b, 0.5)
                        visible: isCurrent
                        opacity: isCurrent ? 1 : 0
                        Behavior on opacity { NumberAnimation { duration: 150 } }

                        Text {
                            id: nameText
                            anchors.centerIn: parent
                            text: modelData.name.replace(/\.[^/.]+$/, "").toUpperCase()
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 13
                            font.weight: Font.Bold
                            color: root.primaryColor
                            elide: Text.ElideMiddle
                            maximumLineCount: 1
                            width: Math.min(implicitWidth, delegateItem.width - 80)
                        }
                    }

                    MouseArea {
                        id: itemMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: function(mouse) {
                            if (isCurrent) {
                                root.applyWallpaper(modelData)
                            } else {
                                sliceListView.currentIndex = index
                            }
                        }
                    }
                }
            }

            Text {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 5
                text: "← → navigate  |  ↵ apply  |  esc close"
                color: root.textMuted
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 11
                opacity: 0.7
            }

            Text {
                anchors.centerIn: parent
                visible: root.wallsLoaded && root.filteredWallpapers.length === 0
                text: "No wallpapers found"
                color: root.textMuted
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 16
            }

            Text {
                anchors.centerIn: parent
                visible: !root.wallsLoaded && root.wallpaperList.length === 0
                text: "Loading wallpapers..."
                color: root.textMuted
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 14
                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    NumberAnimation { from: 0.4; to: 1.0; duration: 600; easing.type: Easing.InOutSine }
                    NumberAnimation { from: 1.0; to: 0.4; duration: 600; easing.type: Easing.InOutSine }
                }
            }
        }

        Component.onCompleted: {
            ensureDirs.running = true
        }
    }

    Process {
        id: ensureDirs
        command: ["mkdir", "-p", root.thumbDir]
        onExited: loadWallpapers()
    }

    function loadWallpapers() {
        root.wallpaperList = []
        root.filteredWallpapers = []
        root.wallsLoaded = false
        listWallpapers.running = true
    }

    Process {
        id: listWallpapers
        command: ["bash", "-c", 
            "find '" + root.wallpaperDir + "' -maxdepth 1 -type f \\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif' -o -iname '*.png' -o -iname '*.webp' \\) ! -name '.*' 2>/dev/null | sort | while read f; do echo \"$f|$(echo -n \\\"$f\\\" | md5sum | cut -d' ' -f1)\"; done"
        ]
        running: false
        stdout: SplitParser {
            onRead: data => {
                var line = data.trim()
                if (line.length === 0) return
                var parts = line.split("|")
                if (parts.length !== 2) return
                var path = parts[0]
                var hash = parts[1]
                var name = path.split("/").pop()
                var thumbPath = root.thumbDir + "/" + hash + ".jpg"
                root.wallpaperList.push({
                    name: name,
                    path: path,
                    thumb: thumbPath
                })
            }
        }
        onExited: {
            root.wallsLoaded = true
            root.updateFilteredWallpapers()
            if (!thumbGenProc.running) thumbGenProc.running = true
        }
    }

    Process {
        id: thumbGenProc
        command: ["bash", "-c",
            "THUMB_DIR='" + root.thumbDir + "' && " +
            "WALL_DIR='" + root.wallpaperDir + "' && " +
            "mkdir -p \"$THUMB_DIR\" && " +
            "find \"$WALL_DIR\" -maxdepth 1 -type f \\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif' -o -iname '*.png' -o -iname '*.webp' \\) ! -name '.*' 2>/dev/null | " +
            "while read f; do " +
            "  hash=$(echo -n \"$f\" | md5sum | cut -d' ' -f1); " +
            "  thumb=\"$THUMB_DIR/${hash}.jpg\"; " +
            "  if [ ! -f \"$thumb\" ] || [ \"$f\" -nt \"$thumb\" ]; then " +
            "    case \"$f\" in " +
            "      *.gif) magick \"${f}[0]\" -resize 1920x1080^ -gravity center -extent 1920x1080 -quality 85 \"$thumb\" 2>/dev/null ;; " +
            "      *) magick \"$f\" -resize 1920x1080^ -gravity center -extent 1920x1080 -quality 85 \"$thumb\" 2>/dev/null ;; " +
            "    esac; " +
            "  fi; " +
            "done"
        ]
        running: false
        onExited: {
            root.thumbsReady = true
            root.updateFilteredWallpapers()
        }
    }

    Process {
        id: applyProc
        command: ["bash", "-c", "true"]
        onExited: Qt.quit()
    }
}

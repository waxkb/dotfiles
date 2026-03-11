import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Scope {
    id: root

    property string configPath: Quickshell.env("HOME") + "/.config/quickshell"
    property string homePath: Quickshell.env("HOME")
    property string wallpaperPath: homePath + "/wall"
    property string cachePath: homePath + "/.cache"
    property var wallpaperList: []
    property string searchTerm: ""
    property int selectedIndex: 0
    property string currentWallpaper: ""
    property var filteredWallpapers: []
    property int columnCount: 1
    
    function updateFilteredWallpapers() {
        if (searchTerm === "") {
            root.filteredWallpapers = wallpaperList.slice()
        } else {
            var result = []
            for (var i = 0; i < wallpaperList.length; i++) {
                if (wallpaperList[i].name.toLowerCase().includes(searchTerm)) {
                    result.push(wallpaperList[i])
                }
            }
            root.filteredWallpapers = result
        }
    }
    property string applyCommand: "dms ipc call wallpaper set {wallpaper}"
    property string wallPath: homePath + "/wall"
    property bool wallsLoaded: false
    property bool thumbsReady: false
    property var wallpaperHashes: ({})

    property color mdSurface: "#0e1416"
    property color mdOnSurface: "#dee3e5"
    property color mdPrimary: "#83d2e4"
    property color mdOnPrimary: "#00363f"
    property color mdSecondary: "#b2cbd1"
    property color mdOnSecondary: "#1c3439"
    property color mdTertiary: "#bdc5eb"
    property color mdOnTertiary: "#272f4d"
    property color mdError: "#ffb4ab"
    property color mdOnError: "#690005"
    property color mdOutline: "#899295"
    property color mdSurfaceVariant: "#3f484b"

    function loadWallpapers() {
        root.wallpaperList = []
        root.filteredWallpapers = []
        root.wallsLoaded = false
        root.thumbsReady = false
        if (!wallpaperListProc.running) wallpaperListProc.running = true
    }

    function applyWallpaper(wallpaper) {
        root.currentWallpaper = wallpaper.path
        var cmd = root.applyCommand
            .replace(/{wallpaper}/g, wallpaper.path)
            .replace(/{wall}/g, root.wallPath)
        applyWallProc.command = ["bash", "-c", cmd]
        applyWallProc.running = true
    }

       PanelWindow {
            id: wallpaperPanel
            visible: true
            exclusionMode: ExclusionMode.Ignore
            anchors { top: true; bottom: true; left: true }
            margins { top: 40; bottom: 10; left: wallpaperPanel.visible ? 6 : -480 }
            implicitWidth: 460
            color: "transparent"
            focusable: true
            Behavior on margins.left { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(root.mdSurface.r, root.mdSurface.g, root.mdSurface.b, 0.7)
            radius: 20

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 42
                    color: Qt.rgba(0, 0, 0, 0.3)
                    radius: 12
                    border.width: wallSearchInput.activeFocus ? 1 : 0
                    border.color: root.mdPrimary
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 14
                        anchors.rightMargin: 14
                        spacing: 10
                        Text {
                            text: "󰸉"
                            color: root.mdPrimary
                            font.pixelSize: 14
                            font.family: "JetBrainsMono Nerd Font"
                        }
                       TextInput {
                              id: wallSearchInput
                              Layout.fillWidth: true
                              Layout.fillHeight: true
                              color: root.mdOnSurface
                              font.pixelSize: 14
                              font.family: "JetBrainsMono Nerd Font"
                              verticalAlignment: TextInput.AlignVCenter
                              selectByMouse: true
                              clip: true
                              focus: true
                              Keys.onPressed: function(event) {
                                  var total = root.filteredWallpapers ? root.filteredWallpapers.length : 0
                                  if (event.key === Qt.Key_Right) {
                                      root.selectedIndex = Math.min(root.selectedIndex + 1, total - 1)
                                      wallGridView.positionViewAtIndex(root.selectedIndex, GridView.Contain)
                                      event.accepted = true
                                  } else if (event.key === Qt.Key_Left) {
                                      root.selectedIndex = Math.max(root.selectedIndex - 1, 0)
                                      wallGridView.positionViewAtIndex(root.selectedIndex, GridView.Contain)
                                      event.accepted = true
                                   } else if (event.key === Qt.Key_Down) {
                                       root.selectedIndex = Math.min(root.selectedIndex + root.columnCount, total - 1)
                                       wallGridView.positionViewAtIndex(root.selectedIndex, GridView.Contain)
                                       event.accepted = true
                                   } else if (event.key === Qt.Key_Up) {
                                       root.selectedIndex = Math.max(root.selectedIndex - root.columnCount, 0)
                                       wallGridView.positionViewAtIndex(root.selectedIndex, GridView.Contain)
                                      event.accepted = true
                                  } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                      if (total > 0 && root.selectedIndex >= 0 && root.selectedIndex < total)
                                          root.applyWallpaper(root.filteredWallpapers[root.selectedIndex])
                                      event.accepted = true
                                  } else if (event.key === Qt.Key_Escape) {
                                      wallpaperPanel.visible = false
                                      wallSearchInput.text = ""
                                      event.accepted = true
                                  }
                              }
                              Text {
                                 text: "Search wallpapers..."
                                 color: root.mdOutline
                                 visible: !parent.text
                                 anchors.left: parent.left
                                 anchors.verticalCenter: parent.verticalCenter
                                 font: parent.font
                                 opacity: 0.6
                             }
                            onTextChanged: {
                                  root.searchTerm = text.toLowerCase()
                                  root.updateFilteredWallpapers()
                                  root.selectedIndex = 0
                                  wallGridView.contentY = 0
                             }
                          }
                        Text {
                            visible: wallSearchInput.text.length > 0
                            text: "󰅖"
                            color: root.mdOutline
                            font.pixelSize: 12
                            font.family: "JetBrainsMono Nerd Font"
                            opacity: clearWallMouse.containsMouse ? 1.0 : 0.7
                            Behavior on opacity { NumberAnimation { duration: 100 } }
                            MouseArea {
                                id: clearWallMouse
                                anchors.fill: parent
                                anchors.margins: -4
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    wallSearchInput.text = ""
                                    wallSearchInput.forceActiveFocus()
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Qt.rgba(0, 0, 0, 0.3)
                    radius: 15
                    clip: true

                    GridView {
                        id: wallGridView
                        anchors.fill: parent
                        anchors.margins: 10
                        cellWidth: Math.floor(width / root.columnCount)
                        cellHeight: cellWidth * 0.5625 + 30
                        boundsBehavior: Flickable.StopAtBounds
                        clip: true
                        cacheBuffer: 400
                        model: root.filteredWallpapers

                        property real targetContentY: 0
                        property bool animatingScroll: false

                        NumberAnimation {
                            id: wallScrollAnim
                            target: wallGridView
                            property: "contentY"
                            duration: 300
                            easing.type: Easing.OutCubic
                            onFinished: wallGridView.animatingScroll = false
                        }

                        function smoothScrollTo(newY) {
                            var maxY = Math.max(0, contentHeight - height)
                            newY = Math.max(0, Math.min(newY, maxY))
                            if (animatingScroll) {
                                wallScrollAnim.stop()
                            }
                            animatingScroll = true
                            wallScrollAnim.from = contentY
                            wallScrollAnim.to = newY
                            targetContentY = newY
                            wallScrollAnim.start()
                        }

                        function smoothScrollBy(delta) {
                            var base = animatingScroll ? targetContentY : contentY
                            smoothScrollTo(base + delta)
                        }

                        MouseArea {
                            anchors.fill: parent
                            propagateComposedEvents: true
                            onWheel: function(wheel) {
                                var step = -wheel.angleDelta.y / 120.0 * (wallGridView.cellHeight * 0.6)
                                wallGridView.smoothScrollBy(step)
                            }
                            onClicked: function(mouse) { mouse.accepted = false }
                            onPressed: function(mouse) { mouse.accepted = false }
                            onReleased: function(mouse) { mouse.accepted = false }
                        }

                        delegate: Item {
                            width: wallGridView.cellWidth
                            height: wallGridView.cellHeight
                            Rectangle {
                                anchors.fill: parent
                                anchors.margins: 4
                                radius: 10
                                antialiasing: true
                                color: {
                                    if (index === root.selectedIndex)
                                        return Qt.rgba(root.mdPrimary.r, root.mdPrimary.g, root.mdPrimary.b, 0.25)
                                    if (wallItemMouse.containsMouse)
                                        return Qt.rgba(1, 1, 1, 0.08)
                                    return Qt.rgba(0, 0, 0, 0.2)
                                }
                                border.width: {
                                    if (index === root.selectedIndex) return 1
                                    return 0
                                }
                                border.color: root.mdPrimary
                                Behavior on color { ColorAnimation { duration: 120 } }
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 4
                                    spacing: 2
                                    Item {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        Rectangle {
                                            anchors.fill: parent
                                            radius: 7
                                            antialiasing: true
                                            color: Qt.rgba(0.3, 0.3, 0.3, 0.3)
                                             visible: !wallThumbImage.visible
                                        }
                                         Image {
                                              id: wallThumbImage
                                              anchors.fill: parent
                                              property string thumbHash: (root.wallpaperHashes && root.wallpaperHashes[modelData.path]) ? root.wallpaperHashes[modelData.path] : ""
                                              property string thumbPath: thumbHash ? Quickshell.env("HOME") + "/.cache/wallpaper-thumbs/" + thumbHash + ".jpg" : ""
                                              property bool thumbExists: thumbPath && root.thumbsReady
                                              source: thumbExists ? "file://" + thumbPath : (modelData.path ? "file://" + modelData.path : "")
                                              fillMode: Image.PreserveAspectCrop
                                              smooth: true
                                              mipmap: true
                                              asynchronous: true
                                              cache: true
                                              sourceSize.width: 1920
                                              sourceSize.height: 1080
                                              visible: status === Image.Ready
                                              onStatusChanged: {
                                                  if (status === Image.Error && modelData.path)
                                                      source = "file://" + modelData.path
                                              }
                                              layer.enabled: true
                                              layer.smooth: true
                                              layer.effect: OpacityMask {
                                                  maskSource: Rectangle {
                                                      width: wallThumbImage.width
                                                      height: wallThumbImage.height
                                                      radius: 7
                                                      antialiasing: true
                                                  }
                                              }
                                          }
                                    }
                                    Text {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 22
                                        text: modelData.name
                                        color: {
                                            if (index === root.selectedIndex) return root.mdPrimary
                                            return root.mdOnSurface
                                        }
                                        font.pixelSize: 8
                                        font.family: "JetBrainsMono Nerd Font"
                                        font.bold: index === root.selectedIndex
                                        elide: Text.ElideMiddle
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        Behavior on color { ColorAnimation { duration: 120 } }
                                    }
                                }
                                MouseArea {
                                    id: wallItemMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.applyWallpaper(modelData)
                                    onContainsMouseChanged: {
                                        if (containsMouse) root.selectedIndex = index
                                    }
                                }
                            }
                        }
                        ScrollBar.vertical: ScrollBar {
                            active: true
                            width: 4
                            policy: ScrollBar.AsNeeded
                        }
                    }
                    Text {
                        anchors.centerIn: parent
                        visible: root.wallsLoaded && root.filteredWallpapers.length === 0
                        text: "No wallpapers found"
                        color: root.mdOutline
                        font.pixelSize: 14
                        font.family: "JetBrainsMono Nerd Font"
                    }
                    Text {
                        anchors.centerIn: parent
                        visible: !root.wallsLoaded && root.wallpaperList.length === 0
                        text: "Loading wallpapers..."
                        color: root.mdOutline
                        font.pixelSize: 13
                        font.family: "JetBrainsMono Nerd Font"
                        SequentialAnimation on opacity {
                            loops: Animation.Infinite
                            NumberAnimation { from: 0.4; to: 1.0; duration: 600; easing.type: Easing.InOutSine }
                            NumberAnimation { from: 1.0; to: 0.4; duration: 600; easing.type: Easing.InOutSine }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 28
                    color: Qt.rgba(0, 0, 0, 0.3)
                    radius: 10
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        Text { text: "←→↑↓ nav"; color: root.mdOutline; font.pixelSize: 10; font.family: "JetBrainsMono Nerd Font"; opacity: 0.7 }
                        Item { Layout.fillWidth: true }
                        Text { text: "↵ apply"; color: root.mdOutline; font.pixelSize: 10; font.family: "JetBrainsMono Nerd Font"; opacity: 0.7 }
                        Item { Layout.fillWidth: true }
                        Text { text: "esc close"; color: root.mdOutline; font.pixelSize: 10; font.family: "JetBrainsMono Nerd Font"; opacity: 0.7 }
                    }
                }
            }
        }

        Process {
            id: thumbDirProc
            command: ["mkdir", "-p", root.cachePath + "/wallpaper-thumbs"]
            onExited: root.loadWallpapers()
        }

        Process {
            id: wallpaperListProc
            command: ["bash", "-c", "find '" + root.wallpaperPath + "' -maxdepth 1 -type f \\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif' -o -iname '*.png' -o -iname '*.webp' \\) ! -name '.*' 2>/dev/null | sort"]
            stdout: SplitParser {
                onRead: data => {
                    var path = data.trim()
                    if (path.length === 0) return
                    var parts = path.split("/")
                    var name = parts[parts.length - 1]
                    root.wallpaperList.push({ name: name, path: path })
                    root.updateFilteredWallpapers()
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
                "THUMB_DIR='" + root.cachePath + "/wallpaper-thumbs' && " +
                "WALL_DIR='" + root.wallpaperPath + "' && " +
                "cd \"$THUMB_DIR\" && " +
                "find \"$WALL_DIR\" -maxdepth 1 -type f \\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif' -o -iname '*.png' -o -iname '*.webp' \\) ! -name '.*' 2>/dev/null | " +
                "while IFS= read -r f; do " +
                "  hash=$(echo -n \"$f\" | md5sum | cut -d' ' -f1); " +
                "  thumb=\"$THUMB_DIR/${hash}.jpg\"; " +
                "  if [ ! -f \"$thumb\" ] || [ \"$f\" -nt \"$thumb\" ]; then " +
                "    case \"$f\" in " +
                "      *.gif) convert \"${f}[0]\" -resize 1920x1080^ -gravity center -extent 1920x1080 -quality 92 \"$thumb\" ;; " +
                "      *) convert \"$f\" -resize 1920x1080^ -gravity center -extent 1920x1080 -quality 92 \"$thumb\" ;; " +
                "    esac; " +
                "  fi; " +
                "done"
            ]
            onExited: {
                root.thumbsReady = true
                if (!hashAllProc.running) hashAllProc.running = true
            }
        }

        Process {
            id: hashAllProc
            command: ["bash", "-c", "for f in '" + root.wallpaperPath + "'/*; do [ -f \"$f\" ] && echo \"$f|$(echo -n \"$f\" | md5sum | cut -d' ' -f1)\"; done"]
            stdout: SplitParser {
                onRead: data => {
                    var parts = data.trim().split("|")
                    if (parts.length === 2 && parts[0] && parts[1]) {
                        var updated = root.wallpaperHashes
                        updated[parts[0]] = parts[1]
                        root.wallpaperHashes = updated
                    }
                }
            }
            onExited: {
                root.wallpaperHashesChanged()
                if (!currentWallProc.running) currentWallProc.running = true
            }
        }

        Process {
            id: applyWallProc
            onExited: {
                if (!walColorsProc.running) walColorsProc.running = true
                Qt.quit()
            }
        }

        Process {
            id: walColorsProc
            command: ["bash", "-c", "cat '" + root.cachePath + "/wal/colors.json' 2>/dev/null"]
            stdout: SplitParser {
                splitMarker: ""
                onRead: data => {
                    try {
                        var json = JSON.parse(data)
                        if (json.special) {
                            root.mdSurface = json.special.background || root.mdSurface
                            root.mdOnSurface = json.special.foreground || root.mdOnSurface
                        }
                        if (json.colors) {
                            root.mdError = json.colors.color1 || root.mdError
                            root.mdSecondary = json.colors.color2 || root.mdSecondary
                            root.mdTertiary = json.colors.color4 || root.mdTertiary
                            root.mdPrimary = json.colors.color5 || root.mdPrimary
                            root.mdOutline = json.colors.color8 || root.mdOutline
                        }
                    } catch(e) {}
                }
            }
        }

        Process {
            id: currentWallProc
            command: ["bash", "-c", "readlink -f '" + root.wallpaperPath + "/current' 2>/dev/null || echo ''"]
            stdout: SplitParser { onRead: data => root.currentWallpaper = data.trim() }
        }

        Connections {
            target: root
            function onSelectedIndexChanged() {
                wallGridView.positionViewAtIndex(root.selectedIndex, GridView.Contain)
            }
        }

        Behavior on visible {
            SequentialAnimation {
                onStarted: {
                    root.selectedIndex = 0
                    root.searchTerm = ""
                    wallGridView.contentY = 0
                    if (!root.wallsLoaded) root.loadWallpapers()
                    wallSearchInput.forceActiveFocus()
                }
            }
        }

        Component.onCompleted: {
            thumbDirProc.running = true
        }
    }
}

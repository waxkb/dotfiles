import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import QtQuick.Shapes
import QtMultimedia
import "qml"

ShellRoot {
  id: root
  
  property string homeDir: Config.homeDir
  
  Colors {
    id: colors
  }
  
  property bool initDone: false
  
  Component.onCompleted: {
    initDone = true
  }
  
  WallpaperSelector {
    id: wallpaperSelector
    colors: root.colors
    showing: root.initDone
  }
}

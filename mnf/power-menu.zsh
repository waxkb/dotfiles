# Power menu using wofi (works the same with rofi/tofi if you swap the command)

# List of options
options=(
  "shutdown"
  "reboot"
  "suspend"
  "hibernate"
)

# Present the menu
choice=$(printf "%s\n" "${options[@]}" | rofi -dmenu)

case "$choice" in
  "shutdown")
    systemctl poweroff
    ;;
  "reboot")
    systemctl reboot
    ;;
  "suspend")
    systemctl suspend
    ;;
  "hibernate")
    systemctl hibernate
    ;;
esac

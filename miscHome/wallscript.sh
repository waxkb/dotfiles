LOCKFILE="/tmp/myscript.lock"

exec 9>"$LOCKFILE" || exit 1
flock -n 9 || exit 0 # exit silently if already running
dms ipc call dankdash wallpaper

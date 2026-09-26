export FZF_DEFAULT_OPTS="--no-scrollbar"
# export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS --preview 'bat --color=always --style=numbers --line-range=:500 {}' --preview-border none --height 40%"
export FZF_CTRL_R_OPTS=""
source <(fzf --zsh)

autoload -Uz add-zsh-hook

foot_cwd_update() {
  [[ -n "${FOOT_CWD_TOKEN:-}" ]] || return 0

  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/foot-cwd"
  local cwd_file="$cache_dir/$FOOT_CWD_TOKEN"
  mkdir -p "$cache_dir"
  print -r -- "$PWD" >|"$cwd_file"
}

add-zsh-hook chpwd foot_cwd_update
add-zsh-hook precmd foot_cwd_update
foot_cwd_update

# export SKIM_DEFAULT_COMMAND="fd -H"

eval "$(direnv hook zsh)"

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
  command rm -f -- "$tmp"
}

function br {
  local cmd cmd_file code
  cmd_file=$(mktemp)
  if TERM="kitty" TERMINAL="kitty" broot --outcmd "$cmd_file" "$@"; then
    cmd=$(<"$cmd_file")
    command rm -f "$cmd_file"
    eval "$cmd"
  else
    code=$?
    command rm -f "$cmd_file"
    return "$code"
  fi
}

rm() {
  if [[ "$*" == *"-rf"* || "$*" == *"-fr"* ]]; then
    echo "⚠️  You are about to run: rm $*"
    read "reply1?Are you absolutely sure? (yes/no) "
    [[ "$reply1" == "yes" ]] || {
      echo "Aborted."
      return 1
    }
    read "reply2?Really proceed? This is irreversible. (yes/no) "
    [[ "$reply2" == "yes" ]] || {
      echo "Aborted."
      return 1
    }
    read "reply3?Final confirmation — type EXACTLY: I understand: "
    [[ "$reply3" == "I understand" ]] || {
      echo "Aborted."
      return 1
    }
    command rm "$@"
  else
    command rm "$@"
  fi
}

path+=("/home/max/.local/bin")
path+=("/usr/bin")
path+=("/home/max/.cargo/bin")
path+=("/home/max/.julia/bin")
path+=("/home/max/.npm-packages/bin")

mkcd() {
  mkdir -p "$1" && cd "$1"
}

(
  if ! pgrep -u "$USER" ssh-agent >/dev/null; then
    eval "$(ssh-agent -s)" >/dev/null 2>&1
  fi

  if ! ssh-add -l | grep -q "github"; then
    KEY_FILE=$(mktemp)
    trap 'rm -f "$KEY_FILE"' EXIT
    infisical secrets get --path=/ssh-keys Main --plain 2>/dev/null | sed 's/\\n/\n/g' >"$KEY_FILE"
    chmod 600 "$KEY_FILE"
    ssh-add "$KEY_FILE" >/dev/null 2>&1
  fi
) >/dev/null 2>&1 &|

eval "$(starship init zsh)"

alias syncdots="gita ll && gita super add . && gita super commit -m "e" && gita push && gita ll"
alias ff="microfetch"
alias cf="clear; microfetch"
# w3m 0.5.6 sends HTTP/1.0 + Accept-Encoding: gzip but can't de-chunk
# GitHub's `Transfer-Encoding: chunked` + `Content-Encoding: gzip` reply
# (fails with `gzip: stdin: not in gzip format`). Force identity encoding.
alias w3m="w3m -o accept_encoding='identity'"

export PYTHONPATH=""
export STABLE_GL=1
export FORCE_X11=1

export UV_PYTHON_PREFERENCE=only-managed
export UV_PYTHON=3.14

export MOZ_ENABLE_WAYLAND=1
export MOZ_WEBRENDER_COMPOSITOR=auto
export __GLX_VENDOR_LIBRARY_NAME=nvidia

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:*infisical secrets get*:"

HISTSIZE=20000
SAVEHIST=20000
HISTFILE=~/.zsh_history

export _JAVA_AWT_WM_NONREPARENTING=1

export SOBER_USE_NEW_TEXT_RENDERER=1

alias mosim='podman run --rm -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY -e XDG_RUNTIME_DIR=/tmp -v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/$WAYLAND_DISPLAY -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro -e SDL_VIDEODRIVER=x11 --device /dev/nvidia0 --device /dev/nvidiactl --device /dev/nvidia-modeset --device /dev/nvidia-uvm --device /dev/dri -v /nix/store:/nix/store:ro -v /run/opengl-driver:/run/opengl-driver:ro -e LD_LIBRARY_PATH=/run/opengl-driver/lib -e VK_ICD_FILENAMES=/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json -e __GLX_VENDOR_LIBRARY_NAME=nvidia --security-opt label=disable -v /home/max/mosim:/mosim -v /home/max/mosim-data:/root localhost/mosim:arch /mosim/MoSimulator.x86_64'

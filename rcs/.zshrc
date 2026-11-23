if [ -f /run/.containerenv ]; then
  export JAVA_HOME=/usr/lib/jvm/temurin-21-jdk-amd64
  export PATH=$JAVA_HOME/bin:$PATH

  # NixOS host GPU passthrough (distrobox mounts host root at /run/host).
  # Without this, GL/Vulkan fall back to llvmpipe CPU rendering.
  if [ -d /run/host/run/opengl-driver ]; then
    export LD_LIBRARY_PATH="/run/host/run/opengl-driver/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    export VK_ICD_FILENAMES=/run/host/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
  fi
fi

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

gw() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -x "$dir/gradlew" ]]; then
      JAVA_HOME=~/wpilib/2026/jdk "$dir/gradlew" -p "$dir" "$@"
      return
    fi
    dir="$(dirname "$dir")"
  done
  echo "gradlew not found in any parent directory" >&2
  return 1
}

path+=("$HOME/.local/bin")
path+=("/usr/bin")
path+=("$HOME/.npm-packages/bin")

mkcd() {
  mkdir -p "$1" && cd "$1"
}

# gcr provides an agent in graphical sessions; fall back to one on a fixed
# socket so TTY/SSH logins work too and the agent survives the shell.
if [[ -z "$SSH_AUTH_SOCK" && -n "$XDG_RUNTIME_DIR" ]]; then
  export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.sock"
  ssh-add -l >/dev/null 2>&1
  (($? <= 1)) || {
    rm -f "$SSH_AUTH_SOCK"
    ssh-agent -a "$SSH_AUTH_SOCK" >/dev/null
  } # rc 0/1 = agent alive, 2 = dead socket
fi

eval "$(starship init zsh)"

alias syncdots="gita ll && gita super add . && gita super commit -m "e" && gita push && gita ll"
alias ff="microfetch"
alias cf="clear; microfetch"

export PYTHONPATH=""
export STABLE_GL=1
export FORCE_X11=1

export UV_PYTHON_PREFERENCE=only-managed
export UV_PYTHON=3.14

export MOZ_ENABLE_WAYLAND=1
export MOZ_WEBRENDER_COMPOSITOR=auto
export __GLX_VENDOR_LIBRARY_NAME=nvidia

# Keep infisical secret commands out of history (zsh uses HISTORY_IGNORE;
# bash's HISTIGNORE does nothing here)
export HISTORY_IGNORE='*infisical secrets set*:*infisical secrets get*'

HISTSIZE=20000
SAVEHIST=20000
HISTFILE=~/.zsh_history

export _JAVA_AWT_WM_NONREPARENTING=1

export SOBER_USE_NEW_TEXT_RENDERER=1

alias mosim='$HOME/mosim/MoSimulator.x86_64'

alias advantageScope='$HOME/wpilib/2026/advantagescope/advantagescope-wpilib'

alias frc='distrobox enter frc'

alias elastic='env -u LD_LIBRARY_PATH -u NIX_LD_LIBRARY_PATH -u NIX_LD \
  -u __EGL_VENDOR_LIBRARY_DIRS -u __EGL_VENDOR_LIBRARY_FILENAMES \
  -u GBM_BACKENDS_PATH -u LIBGL_DRIVERS_PATH -u LIBVA_DRIVERS_PATH \
  LIBGL_ALWAYS_SOFTWARE=1 GDK_BACKEND=x11 \
  /home/max/wpilib/2026/elastic/elastic_dashboard'

# ninfer / tailscale sidecar helpers
source "${${(%):-%x}:A:h}/ninfer.zsh"

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
  (( $? <= 1 )) || { rm -f "$SSH_AUTH_SOCK"; ssh-agent -a "$SSH_AUTH_SOCK" >/dev/null; } # rc 0/1 = agent alive, 2 = dead socket
fi

# Load the SSH key from Infisical, unless the agent already has it.
(
  if ! ssh-add -l 2>/dev/null | grep -qF 'maxwellr2028@gmail.com'; then
    KEY_FILE=$(mktemp)
    trap 'rm -f "$KEY_FILE"' EXIT
    if infisical secrets get --path=/ssh-keys Main --silent --plain </dev/null 2>/dev/null |
        sed 's/\\n/\n/g' >"$KEY_FILE" && [[ -s "$KEY_FILE" ]]; then
      ssh-add "$KEY_FILE" >/dev/null 2>&1
    fi
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

# --- ninfer / tailscale sidecar -------------------------------------------------
# Each service runs as its own tailnet node via a Tailscale sidecar container.
# Auth key: fetched from Infisical into ~/.config/ninfer/ts-authkey
# Models:   ~/models (override with NINFER_MODELS=/path/to/models)

: "${NINFER_MODELS:=$HOME/models}"

: "${NINFER_INFISICAL_PROJECT:=8a9a5706-fdda-4cfb-bd90-44c14c3fec83}"
: "${NINFER_INFISICAL_ENV:=dev}"
: "${NINFER_INFISICAL_PATH:=/tailscale}"
: "${NINFER_INFISICAL_SECRET:=Containers}"

# Fetch the tailscale auth key from Infisical and cache it in ts-authkey.
# Refreshes the cached key on every call, but falls back to it if Infisical
# is unreachable so the commands still work offline.
_ninfer_fetch_tsauthkey() {
  local cfg=${XDG_CONFIG_HOME:-$HOME/.config}/ninfer
  local keyfile=$cfg/ts-authkey
  local key tmp

  if command -v infisical >/dev/null 2>&1 \
    && key=$(infisical secrets get "$NINFER_INFISICAL_SECRET" \
      --projectId "$NINFER_INFISICAL_PROJECT" \
      --env "$NINFER_INFISICAL_ENV" \
      --path "$NINFER_INFISICAL_PATH" \
      --plain --silent 2>/dev/null) \
    && [[ -n $key ]]; then
    mkdir -p -- "$cfg" || return 1
    tmp=$(mktemp "$cfg/.ts-authkey.XXXXXX") || return 1
    if print -r -- "$key" >|"$tmp" && chmod 600 "$tmp"; then
      mv -f -- "$tmp" "$keyfile"
      return 0
    fi
    rm -f -- "$tmp"
    return 1
  fi

  if [[ -s $keyfile ]]; then
    print -u2 "ninfer: could not fetch auth key from Infisical; using cached $keyfile"
    return 0
  fi

  print -u2 "ninfer: could not fetch '$NINFER_INFISICAL_SECRET' from Infisical ($NINFER_INFISICAL_PATH, env $NINFER_INFISICAL_ENV)"
  print -u2 "ninfer: run 'infisical login' or write the key to $keyfile"
  return 1
}

ninfer() {
  local sidecar=ninfer-ts app=ninfer
  local cfg=${XDG_CONFIG_HOME:-$HOME/.config}/ninfer
  local models=${NINFER_MODELS:-$HOME/models}
  local -a serve_args=()

  _ninfer_fetch_tsauthkey || return 1
  if [[ ! -d $models ]]; then
    print -u2 "ninfer: models dir not found: $models (set NINFER_MODELS)"
    return 1
  fi

  if [[ -r $cfg/serve/serve.json ]]; then
    serve_args+=(
      -e TS_SERVE_CONFIG=/config/serve.json
      -v "$cfg/serve:/config:ro"
    )
  fi

  if ! podman container exists "$sidecar" 2>/dev/null; then
    podman volume create "${sidecar}-state" >/dev/null || return 1
    podman run -d --name "$sidecar" --hostname ninfer --network bridge \
      --cap-add NET_ADMIN --cap-add NET_RAW --device /dev/net/tun:rw \
      -e TS_HOSTNAME=ninfer \
      -e TS_STATE_DIR=/var/lib/tailscale \
      -e TS_USERSPACE=false \
      -e TS_AUTHKEY=file:/run/ts-authkey \
      -v "${sidecar}-state:/var/lib/tailscale" \
      -v "$cfg/ts-authkey:/run/ts-authkey:ro" \
      "${serve_args[@]}" \
      ghcr.io/tailscale/tailscale:latest >/dev/null || return 1
  else
    podman start "$sidecar" >/dev/null 2>&1 || true
  fi

  # Foreground: when this exits (or Ctrl-C), stop the sidecar so the
  # tailnet node goes offline with the LLM.
  podman run --rm --name "$app" \
    --network "container:$sidecar" \
    --gpus all \
    --ulimit memlock=-1 -w / \
    -v "$models:/models" \
    -v ninfer-cache:/cache \
    ghcr.io/iamwavecut/ninfer-all:cuda13.4 \
    serve --config models/inkling/inkling2-mini-host.ini --host 0.0.0.0
  local rc=$?

  podman stop "$sidecar" >/dev/null 2>&1
  return $rc
}

ninfer-down() {
  podman stop ninfer ninfer-ts >/dev/null 2>&1
  podman rm   ninfer ninfer-ts >/dev/null 2>&1
}

ninfer-status() {
  podman exec ninfer-ts tailscale status
}

ninfer-logs() {
  podman logs -f ninfer-ts
}

# Generic sidecar helper: ts-sidecar <name> <hostname>
# Then start the app with --network container:<name>-ts
ts-sidecar() {
  local name=$1 host=$2
  local cfg=${XDG_CONFIG_HOME:-$HOME/.config}/ninfer

  if [[ -z $name || -z $host ]]; then
    print -u2 "usage: ts-sidecar <name> <hostname>"
    return 1
  fi
  _ninfer_fetch_tsauthkey || return 1

  podman volume create "${name}-ts-state" >/dev/null
  podman run -d --name "${name}-ts" --hostname "$host" --network bridge \
    --cap-add NET_ADMIN --cap-add NET_RAW --device /dev/net/tun:rw \
    -e TS_HOSTNAME="$host" \
    -e TS_STATE_DIR=/var/lib/tailscale \
    -e TS_USERSPACE=false \
    -e TS_AUTHKEY=file:/run/ts-authkey \
    -v "${name}-ts-state:/var/lib/tailscale" \
    -v "$cfg/ts-authkey:/run/ts-authkey:ro" \
    ghcr.io/tailscale/tailscale:latest
}
# --- end ninfer / tailscale sidecar ---------------------------------------------

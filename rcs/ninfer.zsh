# ninfer / tailscale sidecar helpers
# Sourced from ~/.zshrc. Each service runs as its own tailnet node via a
# Tailscale sidecar container.
# Auth key: fetched from Infisical into ~/.config/ninfer/ts-authkey
# Models:   ~/models (override with NINFER_MODELS=/path/to/models)

: "${NINFER_MODELS:=$HOME/models}"

: "${NINFER_INFISICAL_PROJECT:=8a9a5706-fdda-4cfb-bd90-44c14c3fec83}"
: "${NINFER_INFISICAL_ENV:=dev}"
: "${NINFER_INFISICAL_PATH:=/Tailscale}"
: "${NINFER_INFISICAL_SECRET:=Containers}"

# Fetch the tailscale auth key from Infisical and cache it in ts-authkey.
# Refreshes the cached key on every call, but falls back to it if Infisical
# is unreachable so the commands still work offline.
_ninfer_fetch_tsauthkey() {
  local cfg=${XDG_CONFIG_HOME:-$HOME/.config}/ninfer
  local keyfile=$cfg/ts-authkey
  local key tmp

  if command -v infisical >/dev/null 2>&1 &&
    key=$(infisical secrets get "$NINFER_INFISICAL_SECRET" \
      --projectId "$NINFER_INFISICAL_PROJECT" \
      --env "$NINFER_INFISICAL_ENV" \
      --path "$NINFER_INFISICAL_PATH" \
      --plain --silent 2>/dev/null) &&
    [[ -n $key ]]; then
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
    podman volume create --ignore "${sidecar}-state" >/dev/null || return 1
    podman run -d --name "$sidecar" --hostname ninfer --network bridge \
      -p 127.0.0.1:8080:8080 \
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
  local c
  for c in ninfer ninfer-ts; do
    podman container exists "$c" 2>/dev/null || continue
    podman stop "$c" && podman rm "$c"
  done
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

  podman volume create --ignore "${name}-ts-state" >/dev/null
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

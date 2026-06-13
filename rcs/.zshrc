# export FZF_DEFAULT_COMMAND="fd -H"
export FZF_DEFAULT_OPTS="--no-scrollbar"
# export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS --preview 'bat --color=always --style=numbers --line-range=:500 {}' --preview-border none --height 40%"
export FZF_CTRL_R_OPTS=""
source <(fzf --zsh)

# export SKIM_DEFAULT_COMMAND="fd -H"

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
path+=("/home/max/python/browser/bin")
path+=("/home/max/python/bin")
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
    infisical secrets get --path=/ssh-keys PrivateMainsshKey --plain 2>/dev/null | sed 's/\\n/\n/g' >"$KEY_FILE"
    chmod 600 "$KEY_FILE"
    ssh-add "$KEY_FILE" >/dev/null 2>&1
  fi
) >/dev/null 2>&1 &|

eval "$(starship init zsh)"

alias syncdots="gita ll && gita super add . && gita super commit -m "e" && gita push && gita ll"
alias ff="microfetch"
alias cf="clear; microfetch"

export NIXPKGS_ALLOW_UNFREE=1

export PYTHONPATH=""
export STABLE_GL=1
export FORCE_X11=1

export CLAUDE_CODE_USE_OPENAI=1
export OPENAI_BASE_URL=http://localhost:8080/v1
export OPENAI_MODEL=qwen3.6

export CLAUDE_CODE_ATTRIBUTION_HEADER=0
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1

export OPENROUTER_API_KEY="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"

export ANTHROPIC_BASE_URL="http://localhost:8080"
export ANTHROPIC_API_KEY=""
export ANTHROPIC_MODEL=""

cclexp() {
  export ANTHROPIC_BASE_URL="http://localhost:8080"
  export ANTHROPIC_API_KEY=""
  export ANTHROPIC_MODEL=""
}

ccoexp() {
  export ANTHROPIC_BASE_URL="http://localhost:11434"
  export ANTHROPIC_API_KEY=""
  export ANTHROPIC_MODEL="minimax-m2.7:cloud"
}

ccrexp() {
  export ANTHROPIC_BASE_URL="https://openrouter.ai/api"
  export ANTHROPIC_API_KEY=$OPENROUTER_API_KEY
  export ANTHROPIC_MODEL="deepseek/deepseek-v4-flash:free"
}

q35Serv_m() {
  llama-server -hf unsloth/Qwen3.6-35B-A3B-GGUF:UD-IQ4_NL --host 0.0.0.0 --port 8080 -c 110000 --temp 0.6 --top_p 0.95 --top_k 20 --min_p 0.0 --presence_penalty 0.0 -ctk q4_0 -ctv q4_0 -t 6 --mmap --mlock --jinja --metrics -np 1 --fit-target 2048 --perf --chat-template-kwargs '{"preserve_thinking": true}' --image-min-tokens 1024
}

q35Serv_t_1() {
  llama-server -hf unsloth/Qwen3.6-35B-A3B-GGUF:UD-IQ4_NL --host 0.0.0.0 --port 8080 -c 110000 --temp 0.6 --top_p 0.95 --top_k 20 --min_p 0.0 --presence_penalty 0.0 -ctk q4_0 -ctv q4_0 -t 6 --mmap --mlock --jinja --metrics -np 1 --fit-target 128 --perf --chat-template-kwargs '{"preserve_thinking": true}' --no-mmproj
}

q35Serv_mtp() {
  llama-server -m /home/max/mtp/Qwen3.6-35B-A3B-customwow.gguf --host 0.0.0.0 --port 8080 -c 100000 --temp 0 --top_p 0.95 --top_k 20 --min_p 0.0 --presence_penalty 0.0 -ctk q4_0 -ctv q4_0 -t 6 --mmap --mlock --jinja --metrics -np 1 --fit-target 1250 --perf --chat-template-kwargs '{"preserve_thinking": true}' --no-mmproj --spec-type draft-mtp --spec-draft-n-max 3 -fa on
}

#--spec-type ngram-mod --spec-ngram-size-n 24 --draft-min 12 --draft-max 48

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

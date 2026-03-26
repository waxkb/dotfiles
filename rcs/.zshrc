export EDITOR='nvim'

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

source <(fzf --zsh)
rm() {
  if [[ "$*" == *"-rf"* || "$*" == *"-fr"* ]]; then
    echo "⚠️  You are about to run: rm $*"
    read "reply1?Are you absolutely sure? (yes/no) "
    [[ "$reply1" == "yes" ]] || { echo "Aborted."; return 1; }
    read "reply2?Really proceed? This is irreversible. (yes/no) "
    [[ "$reply2" == "yes" ]] || { echo "Aborted."; return 1; }
    read "reply3?Final confirmation — type EXACTLY: I understand: "
    [[ "$reply3" == "I understand" ]] || { echo "Aborted."; return 1; }
    command rm "$@"
  else
    command rm "$@"
  fi
}

export PATH="$PATH:/home/max/.local/bin"
export PATH="$PATH:/usr/bin"
export PATH="$PATH:/home/max/.cargo/bin"
export PATH="$PATH:/home/max/.julia/bin"

mkcd () {
  mkdir -p "$1" && cd "$1"
}

(
  if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    eval "$(ssh-agent -s)" > /dev/null 2>&1
  fi

  if ! ssh-add -l | grep -q "github"; then
    KEY_FILE=$(mktemp)
    trap 'rm -f "$KEY_FILE"' EXIT
    
    infisical secrets get --path=/ssh-keys PrivateMainsshKey --plain --skip-update-check 2>/dev/null | sed 's/\\n/\n/g' > "$KEY_FILE"
    
    chmod 600 "$KEY_FILE"
    ssh-add "$KEY_FILE" > /dev/null 2>&1
  fi
) >/dev/null 2>&1 &!

eval "$(starship init zsh)"

alias syncdots='gita ll && gita super add . && gita super commit -m "e" && gita push && gita ll'
alias ff='fastfetch'
alias cf='clear; fastfetch'

export LD_LIBRARY_PATH=/run/opengl-driver/lib:$LD_LIBRARY_PATH
export PYTHONPATH="" 
export STABLE_GL=1
export FORCE_X11=1

export ANTHROPIC_BASE_URL="http://localhost:4000"
export ANTHROPIC_MODEL="claude-3-5-sonnet-latest"

cclexp(){
  export ANTHROPIC_BASE_URL="http://localhost:8080"
  export OPENAI_API_KEY=''
  export ANTHROPIC_MODEL=""
}

cczexp(){
  export ANTHROPIC_BASE_URL="http://localhost:4000"
  export ANTHROPIC_MODEL="claude-3-5-sonnet-latest"
}

q35Serv() {
  llama-server -m .cache/llama.cpp/unsloth_Qwen3.5-35B-A3B-GGUF_Qwen3.5-35B-A3B-UD-IQ4_NL.gguf -c 262144 --temp 0 --top_p 0.8 --top_k 20 --min_p 0.0 --presence_penalty 0.0 -t 6 --no-mmap --mlock --jinja
}

q4Serv() {
  llama-server -m .cache/llama.cpp/Jackrong_Qwen3.5-4B-Claude-4.6-Opus-Reasoning-Distilled-v2-GGUF_Qwen3.5-4B.Q5_K_M.gguf -c 262144 --temp 0.6 --top_p 0.8 --top_k 20 --min_p 0.0 --presence_penalty 0.0 -ctk q8_0 -ctv q8_0 -t 6 --no-mmap --mlock --jinja
}

q122Serv() {
  llama-server -m .cache/llama.cpp/unsloth_Qwen3.5-122B-A10B-GGUF_UD-IQ4_NL_Qwen3.5-122B-A10B-UD-IQ4_NL-00001-of-00003.gguf -c 262144 --temp 1 --top_p 0.95 --top_k 20 --min_p 0.0 --presence_penalty 1.5 -t 6 --jinja
}

q08Serv() {
  llama-server -m .cache/llama.cpp/unsloth_Qwen3.5-0.8B-GGUF_Qwen3.5-0.8B-IQ4_NL.gguf -c 262144 --temp 0.6 --top_p 0.8 --top_k 20 --min_p 0.0 --presence_penalty 0.0 -ctk q8_0 -ctv q8_0 -t 6 --no-mmap --mlock --jinja
}

q9Serv() {
  llama-server -m /home/max/.cache/llama.cpp/Jackrong_Qwen3.5-9B-Claude-4.6-Opus-Reasoning-Distilled-v2-GGUF_Qwen3.5-9B.Q5_K_M.gguf -c 262144 --temp 0.6 --top_p 0.8 --top_k 20 --min_p 0.0 --presence_penalty 0.0 -t 6 --no-mmap --mlock --jinja
}

n30Serv() {
  llama-server -m .cache/llama.cpp/mradermacher_Nemotron-Cascade-2-30B-A3B-i1-GGUF_Nemotron-Cascade-2-30B-A3B.i1-IQ4_XS.gguf -c 262144 --temp 1.0 --top_p 0.95 -t 6 --jinja
}

q27Serv() {
  llama-server -m .cache/llama.cpp/unsloth_Qwen3.5-27B-GGUF_Qwen3.5-27B-IQ4_NL.gguf -c 262144 --temp 1 --top_p 0.95 --top_k 20 --min_p 0.0 --presence_penalty 1.5 -t 6 --jinja 
}

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:"

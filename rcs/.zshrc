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
    
    infisical secrets get --path=/ssh-keys PrivateMainsshKey --plain 2>/dev/null | sed 's/\\n/\n/g' > "$KEY_FILE"
    
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

export BRAVE_API_KEY=""

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
  llama-server -m /home/max/.cache/huggingface/hub/models--unsloth--Qwen3.5-35B-A3B-GGUF/snapshots/bc014a17be43adabd7066b7a86075ff935c6a4e2/Qwen3.5-35B-A3B-UD-IQ4_NL.gguf --host 0.0.0.0 --port 8080 -c 262144 --temp 0 --top_p 0.8 --top_k 20 --min_p 0.0 --presence_penalty 0.0 -ctk turbo3 -ctv turbo3 -t 6 --no-mmap --mlock --jinja --metrics -np 1
}

q4Serv() {
  llama-server -m /home/max/.cache/huggingface/hub/models--Jackrong--Qwen3.5-4B-Claude-4.6-Opus-Reasoning-Distilled-v2-GGUF/snapshots/40d46d9a653390d33b88ed5f77d7fae110214955/Qwen3.5-4B.Q5_K_M.gguf --host 0.0.0.0 --port 8080 -c 262144 --temp 0.6 --top_p 0.8 --top_k 20 --min_p 0.0 --presence_penalty 0.0 -ctk turbo3 -ctv turbo3 -t 6 --no-mmap --mlock --jinja -np 2 --metrics
}

q122Serv() {
  llama-server -m /home/max/.cache/huggingface/hub/models--unsloth--Qwen3.5-122B-A10B-GGUF/snapshots/51eab4d59d53f573fb9206cb3ce613f1d0aa392b/UD-IQ4_NL/Qwen3.5-122B-A10B-UD-IQ4_NL-00001-of-00003.gguf --host 0.0.0.0 --port 8080 -c 262144 --temp 1 --top_p 0.95 --top_k 20 --min_p 0.0 --presence_penalty 1.5 -ctk turbo3 -ctv turbo3 -t 6 --jinja -np 2 --metrics
}

q08Serv() {
  llama-server -m /home/max/.cache/huggingface/hub/models--unsloth--Qwen3.5-0.8B-GGUF/snapshots/6ab461498e2023f6e3c1baea90a8f0fe38ab64d0/Qwen3.5-0.8B-IQ4_NL.gguf --host 0.0.0.0 --port 8080 -c 262144 --temp 0.6 --top_p 0.8 --top_k 20 --min_p 0.0 --presence_penalty 0.0 -ctk turbo3 -ctv turbo3 -t 6 --no-mmap --mlock --jinja -np 2 --metrics
}

q9Serv() {
  llama-server -m /home/max/.cache/huggingface/hub/models--Jackrong--Qwen3.5-9B-Claude-4.6-Opus-Reasoning-Distilled-v2-GGUF/snapshots/81b88fc606f0cd77c88fb9b1e0d4e075e7c69eb5/Qwen3.5-9B.Q5_K_M.gguf --host 0.0.0.0 --port 8080 -c 262144 --temp 0.6 --top_p 0.8 --top_k 20 --min_p 0.0 --presence_penalty 0.0 -ctk turbo3 -ctv turbo3 -t 6 --no-mmap --mlock --jinja -np 2 --metrics
}

n30Serv() {
  llama-server -m /home/max/.cache/huggingface/hub/models--mradermacher--Nemotron-Cascade-2-30B-A3B-i1-GGUF/snapshots/b685793198b3096b09c7d74ef9797e431c5be9f8/Nemotron-Cascade-2-30B-A3B.i1-IQ4_XS.gguf --host 0.0.0.0 --port 8080 -c 262144 --temp 1.0 --top_p 0.95 -ctk turbo3 -ctv turbo3 -t 6 --no-mmap --mlock --jinja -np 2 --metrics
}

q27Serv() {
  llama-server -m /home/max/.cache/huggingface/hub/models--unsloth--Qwen3.5-27B-GGUF/snapshots/3221f178a6b842d04f1fb42f1c413534adcc0a6a/Qwen3.5-27B-IQ4_NL.gguf --host 0.0.0.0 --port 8080 -c 262144 --temp 1 --top_p 0.95 --top_k 20 --min_p 0.0 --presence_penalty 1.5 -ctk turbo3 -ctv turbo3 -t 6 --no-mmap --mlock --jinja -np 2 --metrics
}

o9Serv(){
  llama-server -m .cache/huggingface/hub/models--bartowski--agentscope-ai_CoPaw-Flash-9B-GGUF/snapshots/347aa7b9575ddcb8773381c9604d7b5327e42121/agentscope-ai_CoPaw-Flash-9B-Q5_K_M.gguf --host 0.0.0.0 --port 8080 -c 262144 --temp 0.6 --top_p 0.8 --top_k 20 --min_p 0.0 --presence_penalty 0.0 -ctk turbo3 -ctv turbo3 -t 6 --no-mmap --mlock --jinja -np 2 --metrics
}

obui(){
  sudo docker run \
  --network=host \
  -v open-webui:/app/backend/data \
  -e PORT=3000 \
  ghcr.io/open-webui/open-webui:main
}

# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:*infisical secrets get*:"

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

path+=("/home/max/.local/bin")
path+=("/usr/bin")
path+=("/home/max/.cargo/bin")
path+=("/home/max/.julia/bin")
path+=("/home/max/python/browser/bin")
path+=("/home/max/python/bin")
path+=("/home/max/.npm-packages/bin")

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

export NIXPKGS_ALLOW_UNFREE=1

export LD_LIBRARY_PATH=/run/opengl-driver/lib:$LD_LIBRARY_PATH
export PYTHONPATH="" 
export STABLE_GL=1
export FORCE_X11=1

export CLAUDE_CODE_USE_OPENAI=1
export OPENAI_BASE_URL=http://localhost:8080/v1
export OPENAI_MODEL=qwen3.6

export ANTHROPIC_BASE_URL="http://localhost:8081"
export OPENAI_API_KEY=''
export ANTHROPIC_MODEL=""

export CLAUDE_CODE_ATTRIBUTION_HEADER=0
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1


cclexp(){
  export ANTHROPIC_BASE_URL="http://localhost:8080"
  export OPENAI_API_KEY=''
  export ANTHROPIC_MODEL=""
}

cczexp(){
  export ANTHROPIC_BASE_URL="http://localhost:4000"
  export ANTHROPIC_MODEL="claude-3-5-sonnet-latest"
}

localllama() {
  q35Serv_1 &
  echo "Started llama.cpp"
  sleep 15
  openclaw gateway stop > /dev/null 2>&1
  openclaw gateway > /dev/null 2>&1 &
  echo "Started openclaw"
  agent-browser close --all > /dev/null 2>&1
  agent-browser open --headed reddit.com/r/localllama > /dev/null 2>&1
  sleep 1
  agent-browser snapshot > localllama.txt
  agent-browser close --all > /dev/null 2>&1
  openclaw agent --agent main -m "Read localllama.txt. Based on that r/localllama feed, have there been any new AI models released in the LAST 2 DAYS?"
}

#q35Serv_1() {
#  llama-server -m .cache/huggingface/hub/models--unsloth--Qwen3.6-35B-A3B-GGUF/snapshots/9280dd353ab587157920d5bd391ada414d84e552/Qwen3.6-35B-A3B-UD-IQ4_NL.gguf --host 0.0.0.0 --port 8080 -c 110000 --temp 0.6 --top_p 0.95 --top_k 20 --min_p 0.0 --presence_penalty 0.0 -ctk turbo3 -ctv turbo3 -t 6 --mmap --mlock --jinja --metrics -np 1 --fit-target 1024 --perf --chat-template-kwargs '{"preserve_thinking": true}' --spec-type ngram-map-k --spec-ngram-size-n 24 --draft-min 12 --draft-max 48 -mm /home/max/.cache/huggingface/hub/models--unsloth--Qwen3.6-35B-A3B-GGUF/snapshots/9280dd353ab587157920d5bd391ada414d84e552/mmproj-BF16.gguf
#}
#
#q35Serv_4() {
#  llama-server -m .cache/huggingface/hub/models--unsloth--Qwen3.6-35B-A3B-GGUF/snapshots/9280dd353ab587157920d5bd391ada414d84e552/Qwen3.6-35B-A3B-UD-IQ4_NL.gguf --host 0.0.0.0 --port 8080 -c 200000 --temp 0.6 --top_p 0.95 --top_k 20 --min_p 0.0 --presence_penalty 0.0 -ctk turbo3 -ctv turbo3 -t 6 --mmap --mlock --jinja --metrics -np 4 --fit-target 1024 --perf --chat-template-kwargs '{"preserve_thinking": true}' --spec-type ngram-map-k --spec-ngram-size-n 24 --draft-min 12 --draft-max 48 -mm /home/max/.cache/huggingface/hub/models--unsloth--Qwen3.6-35B-A3B-GGUF/snapshots/9280dd353ab587157920d5bd391ada414d84e552/mmproj-BF16.gguf
#}

q35Serv_1() {
  llama-server -hf unsloth/Qwen3.6-35B-A3B-GGUF:UD-IQ4_NL --host 0.0.0.0 --port 8080 -c 110000 --temp 0.6 --top_p 0.95 --top_k 20 --min_p 0.0 --presence_penalty 0.0 -ctk turbo3 -ctv turbo3 -t 6 --mmap --mlock --jinja --metrics -np 1 --fit-target 2048 --perf --chat-template-kwargs '{"preserve_thinking": true}' --image-min-tokens 1024
}

q35Serv_4() {
  llama-server -hf unsloth/Qwen3.6-35B-A3B-GGUF:UD-IQ4_NL --host 0.0.0.0 --port 8080 -c 200000 --temp 0.6 --top_p 0.95 --top_k 20 --min_p 0.0 --presence_penalty 0.0 -ctk turbo3 -ctv turbo3 -t 6 --mmap --mlock --jinja --metrics -np 4 --fit-target 2048 --perf --chat-template-kwargs '{"preserve_thinking": true}' --image-min-tokens 1024
}

#--spec-type ngram-map-k --spec-ngram-size-n 24 --draft-min 12 --draft-max 48


#q27Serv(){
#  llama-server -hf unsloth/Qwen3.6-27B-GGUF:Q4_K_M --host 0.0.0.0 --port 8080 -c 15000 --temp 0.6 --top_p 0.95 --top_k 20 --min_p 0.0 --presence_penalty 0.0 -ctk turbo3 -ctv turbo3 -t 6 --mmap --mlock --jinja --metrics -np 1 --fit-target 128 --perf --chat-template-kwargs '{"preserve_thinking": true}'
#}

#q27Serv(){
#  llama-server -hf hf unsloth/Qwen3.6-27B-GGUF:IQ4_XS --host 0.0.0.0 --port 8080 -c 15000 --temp 0.6 --top_p 0.95 --top_k 20 --min_p 0.0 --presence_penalty 0.0 -ctk turbo3 -ctv turbo3 -t 6 --mmap --mlock --jinja --metrics -np 1 --fit-target 128 --perf --chat-template-kwargs '{"preserve_thinking": true}'
#}

q27Serv(){
  llama-server -hf unsloth/Qwen3.6-27B-GGUF:Q3_K_S --host 0.0.0.0 --port 8080 -c 15000 --temp 0.6 --top_p 0.95 --top_k 20 --min_p 0.0 --presence_penalty 0.0 -ctk turbo3 -ctv turbo3 -t 6 --mmap --mlock --jinja --metrics -np 1 --fit-target 128 --perf --chat-template-kwargs '{"preserve_thinking": true}'
}

export PLAYWRIGHT_BROWSERS_PATH=/nix/store/ys5hrp8fq4w5fiifw7jiqs6axffskav8-playwright-browsers
export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true
export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1

obui(){
  sudo docker rm -f open-webui open-webui-custom redlib 2>/dev/null
  sudo docker run -d \
    --name open-webui-custom \
    --network=host \
    -v open-webui:/app/backend/data \
    -e WEB_LOADER_ENGINE=playwright \
    -e PLAYWRIGHT_WS_URL=ws://127.0.0.1:4000 \
    -e PORT=3000 \
    -e USER_AGENT="Mozilla/5.0 (X11; Linux x86_64)" \
  open-webui-custom:custom
  sudo docker exec -it open-webui-custom update-ca-certificates
}

export UV_PYTHON_PREFERENCE=only-managed
export UV_PYTHON=3.14

#-e ALLOW_LOCAL_NETWORKS=true

export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH


# Ignoring specific Infisical CLI commands
DEFAULT_HISTIGNORE=
export HISTIGNORE="*infisical secrets set*:*infisical secrets get*:"

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
export PATH="$PATH/home/max/.cargo/bin"

export PATH=$PATH:/home/max/.spicetify
export MPD_HOST="/home/max/.mpd/socket"

eval "$(ssh-agent -s)"  >/dev/null
ssh-add -l >/dev/null 2>&1 || ssh-add ~/.ssh/id_ed25519 >/dev/null 2>&1

mkcd () {
  mkdir -p "$1" && cd "$1"
}

eval "$(starship init zsh)"

alias syncdots='gita ll && gita super add . && gita super commit -m "e" && gita push && gita ll'
alias ff='fastfetch'
alias cf='clear; fastfetch'
alias edms='systemctl --user enable --now dms'
alias ddms='systemctl --user disable --now dms'
alias enoct='systemctl --user enable --now noctalia'
alias dnoct='systemctl --user disable --now noctalia'
alias stdms='dnoct && edms'
alias stnoct='ddms && enoct'

#export KIRI_PATH=$(nix build --no-link --print-out-paths nixpkgs#kdePackages.kirigami)/lib/qt-6/qml
#export QML2_IMPORT_PATH=$KIRI_PATH

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/max/.lmstudio/bin"
# End of LM Studio CLI section

alias runGLMServer='llama-server -m .cache/llama.cpp/unsloth_GLM-4.7-Flash-GGUF_GLM-4.7-Flash-Q4_K_M.gguf -c 32000 --temp 0.7 --top-p 1.0 --min-p 0.01 -t 6'

q35Serv() {
  llama-server -m .cache/llama.cpp/unsloth_Qwen3.5-35B-A3B-GGUF_Qwen3.5-35B-A3B-UD-Q5_K_XL.gguf -c 262144 --temp 0.6 --top_p 0.8 --top_k 20 --min_p 0.0 --presence_penalty 0.0 -ctk q4_0 -ctv q4_0 -t 6 --no-mmap --mlock
}

q27Serv() {
  llama-server -m .cache/llama.cpp/unsloth_Qwen3.5-27B-GGUF_Qwen3.5-27B-Q4_K_M.gguf -c 256144 --temp 0.6 --top_p 0.8 --top_k 20 --min_p 0.0 --presence_penalty 0.0 -ctk q4_0 -ctv q4_0 -t 6 --no-mmap --mlock
}

q97Serv() {
  llama-server -m .cache/llama.cpp/OpenMOSE_Qwen3.5-REAP-97B-A10B-GGUF_IQ4_XS_Qwen3.5-REAP-97B-A10B-IQ4_XS-00001-of-00002.gguf -c 256144 --temp 0.6 --top_p 0.95 --top_k 20 --min_p 0.0 --presence_penalty 0.0 -ctk q4_0 -ctv q4_0 -t 6
}

q4Serv() {
  llama-server -m .cache/llama.cpp/unsloth_Qwen3.5-4B-GGUF_Qwen3.5-4B-Q4_K_M.gguf -c 262144 --temp 0.6 --top_p 0.8 --top_k 20 --min_p 0.0 --presence_penalty 0.0 -ctk q4_0 -ctv q4_0 -t 6 --no-mmap --mlock
}

m139Serv (){
  llama-server -m .cache/llama.cpp/mradermacher_MiniMax-M2.5-REAP-139B-A10B-i1-GGUF_MiniMax-M2.5-REAP-139B-A10B.i1-Q4_K_S.gguf -c 256144 --temp 1.0 --top_p 0.95 --top_k 40 -ctk q4_0 -ctv q4_0 -t 6
}

#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

eval "$(fzf --bash)"
alias ff='fastfetch'
alias cf='clear; fastfetch'
# alias ls='sudo nnn -a -P p'
alias ls='sudo yazi'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

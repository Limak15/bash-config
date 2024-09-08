#
# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[ -f "/usr/bin/fastfetch" ] && fastfetch

# Add bin folder to PATH
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"

# Expand the history size
export HISTFILESIZE=10000
export HISTSIZE=500
export HISTTIMEFORMAT="%F %T" # add timestamp to history

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Use vim as main editor
export EDITOR='nvim' 

### ALIASES ###
# Git bare repo alias for dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# ls to lsd 
alias ls='lsd --group-directories-first'
alias ll='lsd -lA --group-directories-first'

# System
alias update='yay -Syu'
alias pmi='sudo pacman -S'
alias pmr='sudo pacman -Rns'
alias auri='yay -S'
alias aurr='yay -Rcns'

# vim
alias vim='nvim'
alias v='nvim'

# set feh to open images in fullscreen
alias feh='feh --scale-down -g 1280x720 -d -S filename'

bind '"\C-f":"zi\n"'

eval "$(starship init bash)"
eval "$(zoxide init bash)"

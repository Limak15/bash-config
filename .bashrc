#
# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[ -f "/usr/bin/fastfetch" ] && fastfetch

# Add bin folder to PATH
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"

### EXPORTS ###
# Expand the history size
export HISTFILESIZE=10000
export HISTSIZE=500
export HISTTIMEFORMAT="%F %T" # add timestamp to history

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Use vim as main editor
export EDITOR='nvim'

### ALIASES ###

# ls to lsd 
alias ls='lsd --group-directories-first'
alias ll='lsd -lA --group-directories-first'

# System
PACKAGE_MANAGERS="apt pacman dnf"
#Current package manager
CURR_PM=""

for pm in $PACKAGE_MANAGERS; do
    if command -v "$pm" > /dev/null; then
        CURR_PM="$pm"
        break
    fi
done

case $CURR_PM in
    pacman)
        alias update='yay -Syu'
        alias install='sudo pacman -S'
        alias remove='sudo pacman -Rns'
        alias aurinstall='yay -S'
        alias aurremove='yay -Rcns'
        ;;
    apt)
        alias update='sudo apt update && sudo apt upgrade'
        alias install='sudo apt install'
        alias remove='sudo apt remove'
        ;;
    dnf)
        alias update='sudo dnf upgrade --refresh'
        alias install='sudo dnf install'
        alias remove='sudo dnf remove'
        ;;
esac


# vim
alias vim='nvim'
alias v='nvim'

### FUNCTIONS ###

extract() {
    for archive in "$@"; do
		if [ -f "$archive" ]; then
			case $archive in
			*.tar.bz2) tar xvjf $archive ;;
			*.tar.gz) tar xvzf $archive ;;
			*.bz2) bunzip2 $archive ;;
			*.rar) rar x $archive ;;
			*.gz) gunzip $archive ;;
			*.tar) tar xvf $archive ;;
			*.tbz2) tar xvjf $archive ;;
			*.tgz) tar xvzf $archive ;;
			*.zip) unzip $archive ;;
			*.Z) uncompress $archive ;;
			*.7z) 7z x $archive ;;
			*) echo "Don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}


bind '"\C-f":"zi\n"'

if command -v fzf &> /dev/null; then
    eval "$(fzf --bash)"
fi

eval "$(starship init bash)"
eval "$(zoxide init bash)"

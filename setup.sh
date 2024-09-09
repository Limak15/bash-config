#!/usr/bin/env bash

RS='\033[0m'
RED='\033[31m'
YELLOW='\033[33m'
GREEN='\033[32m'


command_exists() {
    command -v "$1" >/dev/null 2>&1
}

error() {
    echo "${RED}$1${RS}" >&2
    exit 1
}

install_starship() {
    if command_exists starship; then
        echo "Starship already installed"
        return
    fi

    if ! curl -sS https://starship.rs/install.sh | sh; then
        error "Something happend while installing starship!"
    fi
}

install_fzf() {
    if command_exists fzf; then
        echo "Fzf already installed"
        return
    fi

    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
}

install_zoxide() {
    if command_exists zoxide; then
        echo "Zoxide already installed"
        return
    fi

    if ! curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh; then
        error "Something happend while installing zoxide!"
    fi
}

install_font() {
    FONT_NAME="MesloLGLDZ Nerd Font"
    FONT_LINK="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"

    if fc-list | grep -q "MesloLGLDZ Nerd Font"; then
        echo "$FONT_NAME is already installed"
    else
        FONTS_DIR="$HOME/.local/share/fonts"
        if ! -d $FONTS_DIR; then
            mkdir $FONTS_DIR
        fi

        if ! -d "$FONTS_DIR/ttf"; then
            mkdir "$FONTS_DIR/ttf"  
        fi

        TEMP=$(mktemp -d)
        wget "$FONT_LINK" -O "$TEMP/Meslo.zip"
        unzip "$TEMP/Meslo.zip" -d "$FONTS_DIR/ttf/Meslo/"
    fi
}

install_dependencies() {
    PACKAGE_MANAGERS="apt pacman dnf"
    PM=""
    dependencies="bash fastfetch wget unzip neovim lsd"

    for pm in $PACKAGE_MANAGERS; do
        if command_exists "$pm"; then
            PM="$pm"
            break
        fi
    done
    
    case $PM in
        apt)
            sudo apt install -y $dependencies
            ;;
        pacman)
            sudo pacman -S --needed --noconfirm $dependencies
            ;;
        dnf)
            sudo dnf install -y $dependencies
            ;;
        *)
            echo "Your package manager is not supported by this script.\n Please install this dependencies manually: ${YELLOW}$dependencies${RS}"
            ;;
    esac
}

link_config_files() {
    [ -f "$HOME/.config/starship.toml" ] && rm "$HOME/.config/starship.toml"
    [ -f "$HOME/.config/fastfetch/config.jsonc" ] && rm "$HOME/.config/fastfetch/config.jsonc"
    [ -f "$HOME/.bashrc" ] && rm "$HOME/.bashrc"

    mkdir -p "$HOME/.config/fastfetch"

    ln -s "$(pwd)/.bashrc" "$HOME/.bashrc"
    ln -s "$(pwd)/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"
    ln -s "$(pwd)/starship.toml" "$HOME/.config/starship.toml"
}


install_dependencies
install_starship
install_fzf
install_zoxide
install_font
link_config_files

echo "${YELLOW}Remember that if you have problems with icons dont showing up or any other problem with prompt please change your terminal default font to MesloLGLDZ Nerd Font${RS}"


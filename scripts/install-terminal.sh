#!/usr/bin/env bash

###############################################################################
# Terminal Tools Installation
# Modern CLI replacements and terminal enhancements
###############################################################################

set -e

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

install_terminal_tools() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        print_info "Installing terminal tools via Homebrew..."

        # Modern CLI replacements
        brew install --formula \
            bat \
            eza \
            fzf \
            ripgrep \
            fd \
            zoxide \
            btop \
            neofetch \
            tree-sitter \
            jq \
            shellcheck \
            direnv \
            carapace

        # Shells and prompt
        brew install --formula \
            zsh-autosuggestions \
            starship

        # Terminal multiplexer
        brew install --formula tmux

        # Terminal emulators
        brew install --cask ghostty 2>/dev/null || print_info "Ghostty may require manual installation"

        # File managers
        brew install --formula \
            midnight-commander

        # Fonts
        brew install --cask font-meslo-lg-nerd-font 2>/dev/null || true

        # Additional tools
        brew install --formula \
            atuin \
            lazygit \
            cmatrix

    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        print_info "Installing terminal tools..."

        # Check if WSL
        if grep -q Microsoft /proc/version 2>/dev/null; then
            print_info "WSL detected - installing WezTerm..."
            # WezTerm for Windows/WSL
            curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
            echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
            sudo apt update
            sudo apt install -y wezterm
        fi

        # Install Nerd Fonts on Linux
        print_info "Installing Nerd Fonts..."
        mkdir -p ~/.local/share/fonts

        # Download and install JetBrains Mono Nerd Font
        if [ ! -f ~/.local/share/fonts/JetBrainsMonoNerdFont-Regular.ttf ]; then
            FONT_VERSION="v3.1.1"
            wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/${FONT_VERSION}/JetBrainsMono.zip -O /tmp/JetBrainsMono.zip
            unzip -q -o /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/
            rm /tmp/JetBrainsMono.zip
            fc-cache -fv > /dev/null 2>&1
            print_success "JetBrains Mono Nerd Font installed"
        else
            print_success "Nerd Fonts already installed"
        fi

        # Use Homebrew on Linux for consistent packages
        if command_exists brew; then
            brew install \
                bat \
                eza \
                fzf \
                ripgrep \
                fd-find \
                zoxide \
                btop \
                neofetch \
                jq \
                shellcheck \
                direnv \
                starship \
                tmux \
                lazygit
        else
            # Fallback to system package manager
            if command_exists apt-get; then
                sudo apt-get install -y \
                    bat \
                    fzf \
                    ripgrep \
                    fd-find \
                    jq \
                    shellcheck \
                    tmux \
                    neofetch
            fi
        fi
    fi

    # Setup fzf key bindings
    if command_exists fzf && command_exists brew; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            local brew_prefix
            brew_prefix="$(get_brew_prefix)"
            local fzf_install="$brew_prefix/opt/fzf/install"

            if [ -x "$fzf_install" ]; then
                print_info "Setting up fzf key bindings..."
                "$fzf_install" --all --no-bash --no-zsh 2>/dev/null || \
                    print_warning "fzf key bindings setup failed (non-critical)"
            else
                print_info "Skipping fzf key bindings (fzf installer not found at $fzf_install)"
            fi
        fi
    elif ! command_exists fzf; then
        print_info "Skipping fzf setup (fzf not installed)"
    fi

    print_success "Terminal tools installed"
}

# Main execution
main() {
    install_terminal_tools
}

main "$@"

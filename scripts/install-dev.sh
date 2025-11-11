#!/usr/bin/env bash

###############################################################################
# Development Tools Installation
# Editors, language runtimes, and development utilities
###############################################################################

set -e

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# NVM version (configurable)
NVM_VERSION="${NVM_VERSION:-v0.39.7}"

install_neovim() {
    if command_exists nvim; then
        print_success "Neovim already installed"
    else
        print_info "Installing Neovim..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install neovim
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            if command_exists brew; then
                brew install neovim
            else
                sudo apt-get install -y neovim || true
            fi
        fi
        print_success "Neovim installed"
    fi
}

install_node() {
    if command_exists nvm; then
        print_success "NVM already installed"
    else
        print_info "Installing NVM (Node Version Manager) version $NVM_VERSION..."

        # Download to temporary file for verification
        local tmp_script="/tmp/nvm-install-$$.sh"
        if curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" -o "$tmp_script"; then
            # Verify the script exists and has content
            if [ -s "$tmp_script" ]; then
                print_info "Downloaded NVM installer ($(wc -c < "$tmp_script" | tr -d ' ') bytes)"
                print_info "Executing NVM installation..."
                bash "$tmp_script"
                rm "$tmp_script"

                # Load nvm
                export NVM_DIR="$HOME/.nvm"
                [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

                print_success "NVM installed"
                print_info "Note: NVM initialization code has been added to your shell config"
                print_info "Ensure your dotfiles .zshrc includes NVM initialization"
            else
                print_error "Downloaded NVM script is empty"
                rm "$tmp_script"
                print_info "Falling back to package manager Node installation..."
            fi
        else
            print_error "Failed to download NVM installer"
            print_info "Falling back to package manager Node installation..."
        fi
    fi

    # Install Node LTS via NVM if available
    if command_exists nvm; then
        print_info "Installing Node.js LTS..."
        nvm install --lts
        nvm use --lts
        nvm alias default lts/*
        print_success "Node.js $(node --version) installed"
    fi

    # Install Node if nvm failed
    if ! command_exists node; then
        print_info "Installing Node.js via package manager..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install node
        elif command_exists brew; then
            brew install node
        fi
    fi

    # Verify NVM is properly configured
    if command_exists nvm && [ -f "$HOME/.zshrc" ]; then
        if ! grep -q "NVM_DIR" "$HOME/.zshrc" 2>/dev/null; then
            print_warning "NVM initialization not found in .zshrc"
            print_warning "This may happen if dotfiles were installed after NVM"
            print_info "Make sure your dotfiles template includes NVM initialization"
        fi
    fi
}

install_python() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        print_info "Installing Python..."
        brew install python@3.12 python@3.13
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command_exists apt-get; then
            sudo apt-get install -y python3 python3-pip python3-venv
        fi
    fi
}

install_dev_tools() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        print_info "Installing development tools..."

        # Version control
        brew install git glab

        # Build tools
        brew install cmake make pkg-config

        # Additional utilities
        brew install \
            tree-sitter \
            grep \
            wget \
            openssl@3

    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command_exists apt-get; then
            sudo apt-get install -y \
                git \
                build-essential \
                cmake \
                pkg-config \
                libssl-dev
        fi
    fi

    print_success "Development tools installed"
}

# Main execution
main() {
    install_neovim
    install_node
    install_python
    install_dev_tools
}

main "$@"

#!/usr/bin/env bash

###############################################################################
# Base Tools Installation
# Installs package managers and essential base tools
###############################################################################

set -e

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Install Homebrew (macOS/Linux)
install_homebrew() {
    if command_exists brew; then
        print_success "Homebrew already installed"
        brew update
    else
        print_info "Installing Homebrew..."

        # Download to temporary file for verification
        local tmp_script="/tmp/homebrew-install-$$.sh"
        if curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o "$tmp_script"; then
            # Verify the script exists and has content
            if [ -s "$tmp_script" ]; then
                print_info "Downloaded Homebrew installer ($(wc -c < "$tmp_script" | tr -d ' ') bytes)"
                print_info "Executing Homebrew installation..."
                /bin/bash "$tmp_script"
                rm "$tmp_script"

                # Add to PATH
                if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
                    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
                fi

                print_success "Homebrew installed"
            else
                print_error "Downloaded Homebrew script is empty"
                rm "$tmp_script"
                exit 1
            fi
        else
            print_error "Failed to download Homebrew installer"
            exit 1
        fi
    fi
}

# Install essential tools
install_essentials() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        print_info "Installing base tools via Homebrew..."
        brew install \
            coreutils \
            findutils \
            gnu-tar \
            gnu-sed \
            gawk \
            wget \
            curl \
            git \
            stow

    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        if command_exists apt-get; then
            print_info "Installing base tools via apt..."
            sudo apt-get update
            sudo apt-get install -y \
                build-essential \
                curl \
                wget \
                git \
                stow \
                ca-certificates
        elif command_exists yum; then
            print_info "Installing base tools via yum..."
            sudo yum install -y \
                curl \
                wget \
                git \
                stow
        elif command_exists pacman; then
            print_info "Installing base tools via pacman..."
            sudo pacman -Sy --noconfirm \
                base-devel \
                curl \
                wget \
                git \
                stow
        fi

        # Install Homebrew on Linux for additional packages
        install_homebrew
    fi

    print_success "Base tools installed"
}

# Main execution
main() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        install_homebrew
    fi

    install_essentials

    # Verify installations
    if command_exists git && command_exists stow; then
        print_success "Base installation complete"
    else
        print_error "Base installation failed"
        exit 1
    fi
}

main "$@"

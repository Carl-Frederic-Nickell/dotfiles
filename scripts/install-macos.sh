#!/usr/bin/env bash

###############################################################################
# macOS-Specific Installation
# Tools and apps specific to macOS
###############################################################################

set -e

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

install_macos_apps() {
    print_info "Installing macOS-specific applications..."

    # Window management
    brew install --cask aerospace 2>/dev/null || print_info "Aerospace installation skipped"

    # Fonts (Nerd Fonts)
    brew tap homebrew/cask-fonts 2>/dev/null || true
    brew install --cask font-meslo-lg-nerd-font 2>/dev/null || true
    brew install --cask font-jetbrains-mono-nerd-font 2>/dev/null || true
    brew install --cask font-fira-code-nerd-font 2>/dev/null || true
    brew install --cask font-hack-nerd-font 2>/dev/null || true

    print_success "macOS applications installed"
}

configure_macos() {
    print_info "Configuring macOS defaults..."

    # Disable press-and-hold for keys in favor of key repeat
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

    # Set a faster key repeat rate
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 15

    # Show hidden files in Finder
    defaults write com.apple.finder AppleShowAllFiles -bool true

    # Show path bar in Finder
    defaults write com.apple.finder ShowPathbar -bool true

    # Show status bar in Finder
    defaults write com.apple.finder ShowStatusBar -bool true

    # SECURITY WARNING: Disabling quarantine warnings reduces malware protection
    print_warning "SECURITY: The following setting will disable quarantine warnings for downloaded apps"
    print_warning "This removes macOS Gatekeeper protection against potentially malicious software"
    read -p "Disable quarantine warnings? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        defaults write com.apple.LaunchServices LSQuarantine -bool false
        print_warning "Quarantine warnings disabled"
    else
        print_info "Keeping quarantine warnings enabled (recommended)"
    fi

    # Enable full keyboard access for all controls
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

    print_success "macOS defaults configured"
}

# Main execution
main() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        echo "This script is for macOS only"
        exit 0
    fi

    install_macos_apps
    configure_macos

    print_info "Restart Finder and some apps for changes to take effect"
}

main "$@"

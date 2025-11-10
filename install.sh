#!/usr/bin/env bash

###############################################################################
# Main Installation Script
# Cross-platform dotfiles and package installer for macOS, Linux, and Windows
###############################################################################

set -e  # Exit on error

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$SCRIPT_DIR/scripts"

# Installation flags (can be overridden by --skip-* arguments or env vars)
SKIP_BASE="${SKIP_BASE:-false}"
SKIP_TERMINAL="${SKIP_TERMINAL:-false}"
SKIP_DEVOPS="${SKIP_DEVOPS:-false}"
SKIP_DEV="${SKIP_DEV:-false}"
SKIP_DOTFILES="${SKIP_DOTFILES:-false}"
SKIP_MACOS="${SKIP_MACOS:-false}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

###############################################################################
# Helper Functions
###############################################################################

print_info() {
    echo -e "${BLUE}ℹ ${1}${NC}"
}

print_success() {
    echo -e "${GREEN}✓ ${1}${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ ${1}${NC}"
}

print_error() {
    echo -e "${RED}✗ ${1}${NC}"
}

print_header() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  ${1}${BLUE}${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if grep -q Microsoft /proc/version 2>/dev/null; then
            OS="wsl"
        else
            OS="linux"
        fi
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        OS="windows"
    else
        OS="unknown"
    fi
    echo "$OS"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Backup existing configs
backup_configs() {
    print_info "Creating backup of existing configurations..."

    BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
    if ! mkdir -p "$BACKUP_DIR"; then
        print_error "Failed to create backup directory: $BACKUP_DIR"
        exit 1
    fi

    # List of common config locations
    local configs=(
        ".config/nvim"
        ".config/tmux"
        ".config/ghostty"
        ".config/starship.toml"
        ".zshrc"
        ".bashrc"
        ".tmux.conf"
    )

    local backup_failed=0
    local configs_backed_up=0
    local skipped=0

    for config in "${configs[@]}"; do
        if [ -e "$HOME/$config" ] && [ ! -L "$HOME/$config" ]; then
            print_info "Backing up $config"
            mkdir -p "$(dirname "$BACKUP_DIR/$config")"

            if cp -r "$HOME/$config" "$BACKUP_DIR/$config" 2>/dev/null; then
                ((configs_backed_up++))
            else
                print_warning "Failed to backup $config"
                ((backup_failed++))
            fi
        else
            ((skipped++))
        fi
    done

    if [ $backup_failed -gt 0 ]; then
        print_warning "$backup_failed config(s) failed to backup"
        print_warning "Backed up: $configs_backed_up, Failed: $backup_failed, Skipped: $skipped"
        read -p "Continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_error "Installation aborted by user"
            exit 1
        fi
    else
        print_success "Backup created at: $BACKUP_DIR ($configs_backed_up files backed up, $skipped skipped)"
    fi

    # Export BACKUP_DIR so other scripts can use it
    export BACKUP_DIR
}

###############################################################################
# Argument Parsing
###############################################################################

show_help() {
    cat << EOF
Usage: ./install.sh [OPTIONS]

Cross-platform dotfiles and development environment installer.

OPTIONS:
    --help, -h              Show this help message
    --skip-base             Skip base tools installation (Homebrew, git, stow)
    --skip-terminal         Skip terminal enhancements (bat, eza, fzf, etc.)
    --skip-devops           Skip DevOps tools (Docker, K8s, Terraform, etc.)
    --skip-dev              Skip development tools (Node, Python, etc.)
    --skip-dotfiles         Skip dotfiles installation (configs)
    --skip-macos            Skip macOS-specific tools and settings

ENVIRONMENT VARIABLES:
    SKIP_BASE=1             Same as --skip-base
    SKIP_TERMINAL=1         Same as --skip-terminal
    SKIP_DEVOPS=1           Same as --skip-devops
    SKIP_DEV=1              Same as --skip-dev
    SKIP_DOTFILES=1         Same as --skip-dotfiles
    SKIP_MACOS=1            Same as --skip-macos
    NONINTERACTIVE=1        Skip interactive prompts (for CI/CD)
    NVM_VERSION=v0.40.0     Specify NVM version to install

EXAMPLES:
    # Install everything (default)
    ./install.sh

    # Skip DevOps tools
    ./install.sh --skip-devops

    # Install only base tools and dotfiles
    ./install.sh --skip-terminal --skip-devops --skip-dev

    # CI/CD usage
    NONINTERACTIVE=1 ./install.sh --skip-macos

EOF
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help|-h)
                show_help
                exit 0
                ;;
            --skip-base)
                SKIP_BASE=true
                shift
                ;;
            --skip-terminal)
                SKIP_TERMINAL=true
                shift
                ;;
            --skip-devops)
                SKIP_DEVOPS=true
                shift
                ;;
            --skip-dev)
                SKIP_DEV=true
                shift
                ;;
            --skip-dotfiles)
                SKIP_DOTFILES=true
                shift
                ;;
            --skip-macos)
                SKIP_MACOS=true
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                echo ""
                show_help
                exit 1
                ;;
        esac
    done
}

###############################################################################
# Main Installation Flow
###############################################################################

main() {
    # Parse command line arguments
    parse_args "$@"

    print_header "Dotfiles & Dev Environment Setup"

    # Detect operating system
    OS=$(detect_os)
    print_info "Detected OS: $OS"

    if [ "$OS" = "unknown" ]; then
        print_error "Unsupported operating system"
        exit 1
    fi

    # Show what will be installed
    echo ""
    print_info "Installation Plan:"
    echo "  Base Tools:        $([ "$SKIP_BASE" = true ] && echo "SKIP" || echo "INSTALL")"
    echo "  Terminal Tools:    $([ "$SKIP_TERMINAL" = true ] && echo "SKIP" || echo "INSTALL")"
    echo "  DevOps Tools:      $([ "$SKIP_DEVOPS" = true ] && echo "SKIP" || echo "INSTALL")"
    echo "  Development Tools: $([ "$SKIP_DEV" = true ] && echo "SKIP" || echo "INSTALL")"
    echo "  Dotfiles:          $([ "$SKIP_DOTFILES" = true ] && echo "SKIP" || echo "INSTALL")"
    if [ "$OS" = "macos" ]; then
        echo "  macOS Tools:       $([ "$SKIP_MACOS" = true ] && echo "SKIP" || echo "INSTALL")"
    fi
    echo ""

    # Backup existing configurations
    backup_configs

    # Make all scripts executable (safely iterate to avoid wildcard expansion issues)
    print_info "Making scripts executable..."
    find "$SCRIPTS_DIR" -maxdepth 1 -name "*.sh" -type f -exec chmod +x {} \;

    # Run installation scripts in order
    if [ "$SKIP_BASE" != true ]; then
        print_header "Installing Base Tools"
        source "$SCRIPTS_DIR/install-base.sh"
    else
        print_info "Skipping base tools installation"
    fi

    if [ "$SKIP_TERMINAL" != true ]; then
        print_header "Installing Terminal Enhancements"
        source "$SCRIPTS_DIR/install-terminal.sh"
    else
        print_info "Skipping terminal enhancements"
    fi

    if [ "$SKIP_DEVOPS" != true ]; then
        print_header "Installing DevOps Tools"
        source "$SCRIPTS_DIR/install-devops.sh"
    else
        print_info "Skipping DevOps tools"
    fi

    if [ "$SKIP_DEV" != true ]; then
        print_header "Installing Development Tools"
        source "$SCRIPTS_DIR/install-dev.sh"
    else
        print_info "Skipping development tools"
    fi

    if [ "$SKIP_DOTFILES" != true ]; then
        print_header "Installing Dotfiles"
        source "$SCRIPTS_DIR/install-dotfiles.sh"
    else
        print_info "Skipping dotfiles installation"
    fi

    # OS-specific installations
    if [ "$OS" = "macos" ] && [ "$SKIP_MACOS" != true ]; then
        print_header "Installing macOS-specific Tools"
        source "$SCRIPTS_DIR/install-macos.sh"
    elif [ "$OS" = "macos" ] && [ "$SKIP_MACOS" = true ]; then
        print_info "Skipping macOS-specific tools"
    fi

    print_header "Installation Complete! 🎉"
    print_success "Selected packages and dotfiles have been installed"
    print_info "Please restart your terminal or run: exec \$SHELL"

    # Display post-install instructions
    echo ""
    print_info "Next steps:"
    echo "  1. Restart your terminal"
    if [ "$SKIP_DEV" != true ]; then
        echo "  2. Run 'nvim' to let plugins install"
        echo "  3. Configure any API keys (AWS, etc.)"
    fi
    echo ""
    print_success "Backup location: $BACKUP_DIR"
}

# Run main function
main "$@"

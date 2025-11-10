#!/usr/bin/env bash

###############################################################################
# Dotfiles Installation using GNU Stow
# Symlinks dotfiles from the repository to home directory
###############################################################################

set -e

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common functions
source "$SCRIPT_DIR/common.sh"

DOTFILES_DIR="$(dirname "$SCRIPT_DIR")/dotfiles"
CONFIGS_DIR="$(dirname "$SCRIPT_DIR")/configs"

# Get backup directory from environment (set by main install.sh)
BACKUP_DIR="${BACKUP_DIR:-}"

check_stow() {
    if ! command_exists stow; then
        print_error "GNU Stow is not installed. Please install it first."
        print_info "Run: brew install stow  (macOS) or  sudo apt install stow  (Linux)"
        exit 1
    fi
}

remove_conflicting_configs() {
    print_info "Checking for conflicting configurations..."

    # Verify backup directory exists and is set
    if [ -z "$BACKUP_DIR" ] || [ ! -d "$BACKUP_DIR" ]; then
        print_warning "No backup directory found. Skipping removal of conflicting configs."
        print_info "Stow will handle conflicts automatically."
        return 0
    fi

    # List of configs that commonly conflict
    local configs=(
        "$HOME/.config/nvim"
        "$HOME/.config/tmux"
        "$HOME/.tmux.conf"
    )

    for config in "${configs[@]}"; do
        if [ -e "$config" ] && [ ! -L "$config" ]; then
            # Create relative path for backup verification
            local rel_path="${config#$HOME/}"
            local backup_path="$BACKUP_DIR/$rel_path"

            # Verify this config was actually backed up
            if [ -e "$backup_path" ]; then
                print_info "Removing $config (backed up to $backup_path)"
                # Use :? to prevent empty variable expansion
                rm -rf "${config:?Error: config variable is empty}"
            else
                print_warning "Skipping removal of $config - no backup found at $backup_path"
                print_info "Stow will attempt to handle this conflict"
            fi
        fi
    done
}

stow_dotfiles() {
    print_info "Installing dotfiles using GNU Stow..."

    cd "$DOTFILES_DIR" || exit 1

    # List of dotfile directories to stow
    # Add or remove directories based on what you have
    local packages=(
        "nvim"
        "tmux"
        "starship"
        "git"
        "zsh"
        "bash"
        "ghostty"
        "wezterm"
        "atuin"
        "btop"
        "eza"
        "bat"
        "ccstatusline"
        "opencode"
    )

    for package in "${packages[@]}"; do
        if [ -d "$package" ]; then
            print_info "Stowing $package..."

            # Use --adopt to take precedence over existing files
            # Use --restow to refresh symlinks
            if stow --restow --verbose=1 "$package" 2>/dev/null; then
                print_success "$package stowed"
            else
                # If stow fails, try with --adopt which will take over existing files
                print_warning "Conflicts detected for $package, adopting existing files..."
                stow --adopt --verbose=1 "$package" 2>/dev/null || print_warning "Could not stow $package"
            fi
        else
            print_warning "Directory $package not found, skipping..."
        fi
    done

    cd - > /dev/null
}

setup_shell_config() {
    print_info "Setting up shell configurations..."

    # Setup Zsh plugins
    if command_exists zsh && [[ "$OSTYPE" == "darwin"* ]]; then
        print_info "Zsh autosuggestions installed via Homebrew"
    fi
}

install_vim_plugins() {
    print_info "Neovim plugins will install automatically on first run"
    print_info "Run 'nvim' to trigger plugin installation"
}

setup_tmux_plugins() {
    if command_exists tmux; then
        print_info "Setting up Tmux Plugin Manager (TPM)..."

        local tpm_dir="$HOME/.tmux/plugins/tpm"

        if [ ! -d "$tpm_dir" ]; then
            git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
            print_success "TPM installed"
            print_info "Press 'prefix + I' in tmux to install plugins"
        else
            print_success "TPM already installed"
        fi
    fi
}

copy_additional_configs() {
    print_info "Copying additional configuration files..."

    if [ -d "$CONFIGS_DIR" ]; then
        # Copy any additional configs that shouldn't be symlinked
        # Example: SSH config, AWS config templates, etc.
        :  # Placeholder - add copy commands here if needed
    fi
}

# Main execution
main() {
    check_stow
    remove_conflicting_configs
    stow_dotfiles
    setup_shell_config
    install_vim_plugins
    setup_tmux_plugins
    copy_additional_configs

    print_success "Dotfiles installation complete!"
    print_info ""
    print_info "Next steps:"
    print_info "  1. Restart your terminal or run: exec \$SHELL"
    print_info "  2. Open nvim to install plugins"
    print_info "  3. Open tmux and press 'prefix + I' to install plugins"
    print_info "  4. Configure any API keys and credentials"
}

main "$@"

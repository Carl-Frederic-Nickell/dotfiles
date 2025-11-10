#!/usr/bin/env bash

###############################################################################
# Dotfiles Collection Script
# Collects your existing dotfiles and organizes them for GNU Stow
###############################################################################

set -e

# Source common functions if available
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/scripts/common.sh" ]; then
    source "$SCRIPT_DIR/scripts/common.sh"
else
    # Fallback if common.sh doesn't exist yet
    print_info() { echo -e "\033[0;34mℹ ${1}\033[0m"; }
    print_success() { echo -e "\033[0;32m✓ ${1}\033[0m"; }
    print_warning() { echo -e "\033[1;33m⚠ ${1}\033[0m"; }
fi

DOTFILES_DIR="$SCRIPT_DIR/dotfiles"

# Check if dotfiles directory already contains files
if [ -d "$DOTFILES_DIR" ] && [ "$(ls -A "$DOTFILES_DIR" 2>/dev/null)" ]; then
    print_warning "Directory $DOTFILES_DIR already contains files"
    echo ""
    print_warning "Existing files may be overwritten!"
    echo "$(find "$DOTFILES_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ') existing package directories found"
    echo ""
    read -p "Continue anyway and potentially overwrite? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Operation cancelled"
        exit 0
    fi
else
    print_info "This script will collect your existing dotfiles and organize them for GNU Stow"
    print_warning "Make sure you've backed up your configs before running this!"
    echo ""
    read -p "Continue? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

mkdir -p "$DOTFILES_DIR"

# Neovim
if [ -d "$HOME/.config/nvim" ]; then
    print_info "Collecting Neovim config..."
    mkdir -p "$DOTFILES_DIR/nvim/.config"
    cp -r "$HOME/.config/nvim" "$DOTFILES_DIR/nvim/.config/"
    print_success "Neovim config collected"
fi

# Tmux
if [ -f "$HOME/.config/tmux/tmux.conf" ] || [ -f "$HOME/.tmux.conf" ]; then
    print_info "Collecting Tmux config..."
    mkdir -p "$DOTFILES_DIR/tmux/.config/tmux"

    if [ -d "$HOME/.config/tmux" ]; then
        cp -r "$HOME/.config/tmux"/* "$DOTFILES_DIR/tmux/.config/tmux/"
    fi

    if [ -f "$HOME/.tmux.conf" ]; then
        cp "$HOME/.tmux.conf" "$DOTFILES_DIR/tmux/"
    fi

    print_success "Tmux config collected"
fi

# Starship
if [ -f "$HOME/.config/starship.toml" ]; then
    print_info "Collecting Starship config..."
    mkdir -p "$DOTFILES_DIR/starship/.config"
    cp "$HOME/.config/starship.toml" "$DOTFILES_DIR/starship/.config/"
    print_success "Starship config collected"
fi

# Git
if [ -f "$HOME/.gitconfig" ]; then
    print_info "Collecting Git config..."
    mkdir -p "$DOTFILES_DIR/git"
    cp "$HOME/.gitconfig" "$DOTFILES_DIR/git/"

    if [ -f "$HOME/.gitignore_global" ]; then
        cp "$HOME/.gitignore_global" "$DOTFILES_DIR/git/"
    fi

    print_success "Git config collected"
fi

# Zsh
if [ -f "$HOME/.zshrc" ]; then
    print_info "Collecting Zsh config..."
    mkdir -p "$DOTFILES_DIR/zsh"
    cp "$HOME/.zshrc" "$DOTFILES_DIR/zsh/"

    if [ -f "$HOME/.zshenv" ]; then
        cp "$HOME/.zshenv" "$DOTFILES_DIR/zsh/"
    fi

    print_success "Zsh config collected"
fi

# Bash
if [ -f "$HOME/.bashrc" ]; then
    print_info "Collecting Bash config..."
    mkdir -p "$DOTFILES_DIR/bash"
    cp "$HOME/.bashrc" "$DOTFILES_DIR/bash/"

    if [ -f "$HOME/.bash_profile" ]; then
        cp "$HOME/.bash_profile" "$DOTFILES_DIR/bash/"
    fi

    if [ -f "$HOME/.bash_aliases" ]; then
        cp "$HOME/.bash_aliases" "$DOTFILES_DIR/bash/"
    fi

    print_success "Bash config collected"
fi

# Ghostty
if [ -d "$HOME/.config/ghostty" ]; then
    print_info "Collecting Ghostty config..."
    mkdir -p "$DOTFILES_DIR/ghostty/.config"
    cp -r "$HOME/.config/ghostty" "$DOTFILES_DIR/ghostty/.config/"
    print_success "Ghostty config collected"
fi

# WezTerm
if [ -f "$HOME/.config/wezterm/wezterm.lua" ] || [ -f "$HOME/.wezterm.lua" ]; then
    print_info "Collecting WezTerm config..."
    mkdir -p "$DOTFILES_DIR/wezterm/.config/wezterm"

    if [ -d "$HOME/.config/wezterm" ]; then
        cp -r "$HOME/.config/wezterm"/* "$DOTFILES_DIR/wezterm/.config/wezterm/"
    fi

    if [ -f "$HOME/.wezterm.lua" ]; then
        cp "$HOME/.wezterm.lua" "$DOTFILES_DIR/wezterm/"
    fi

    print_success "WezTerm config collected"
fi

# Atuin
if [ -d "$HOME/.config/atuin" ]; then
    print_info "Collecting Atuin config..."
    mkdir -p "$DOTFILES_DIR/atuin/.config"
    cp -r "$HOME/.config/atuin" "$DOTFILES_DIR/atuin/.config/"
    print_success "Atuin config collected"
fi

# Btop
if [ -d "$HOME/.config/btop" ]; then
    print_info "Collecting Btop config..."
    mkdir -p "$DOTFILES_DIR/btop/.config"
    cp -r "$HOME/.config/btop" "$DOTFILES_DIR/btop/.config/"
    print_success "Btop config collected"
fi

# Eza
if [ -d "$HOME/.config/eza" ]; then
    print_info "Collecting Eza config..."
    mkdir -p "$DOTFILES_DIR/eza/.config"
    cp -r "$HOME/.config/eza" "$DOTFILES_DIR/eza/.config/"
    print_success "Eza config collected"
fi

# Bat
if [ -d "$HOME/.config/bat" ]; then
    print_info "Collecting Bat config..."
    mkdir -p "$DOTFILES_DIR/bat/.config"
    cp -r "$HOME/.config/bat" "$DOTFILES_DIR/bat/.config/"
    print_success "Bat config collected"
fi

# GitLab CLI
if [ -d "$HOME/.config/glab-cli" ]; then
    print_info "Collecting GitLab CLI config..."
    mkdir -p "$DOTFILES_DIR/glab/.config"
    cp -r "$HOME/.config/glab-cli" "$DOTFILES_DIR/glab/.config/"
    print_success "GitLab CLI config collected"
fi

# Aerospace (macOS)
if [ -f "$HOME/.config/aerospace/aerospace.toml" ]; then
    print_info "Collecting Aerospace config..."
    mkdir -p "$DOTFILES_DIR/aerospace/.config/aerospace"
    cp "$HOME/.config/aerospace/aerospace.toml" "$DOTFILES_DIR/aerospace/.config/aerospace/"
    print_success "Aerospace config collected"
fi

# ccstatusline (Claude Code)
if [ -d "$HOME/.config/ccstatusline" ]; then
    print_info "Collecting ccstatusline config..."
    mkdir -p "$DOTFILES_DIR/ccstatusline/.config"
    cp -r "$HOME/.config/ccstatusline" "$DOTFILES_DIR/ccstatusline/.config/"
    print_success "ccstatusline config collected"
fi

# opencode
if [ -d "$HOME/.config/opencode" ]; then
    print_info "Collecting opencode config..."
    mkdir -p "$DOTFILES_DIR/opencode/.config"
    cp -r "$HOME/.config/opencode" "$DOTFILES_DIR/opencode/.config/"
    print_success "opencode config collected"
fi

# Midnight Commander
if [ -d "$HOME/.config/mc" ]; then
    print_info "Collecting Midnight Commander config..."
    mkdir -p "$DOTFILES_DIR/mc/.config"
    cp -r "$HOME/.config/mc" "$DOTFILES_DIR/mc/.config/"
    print_success "Midnight Commander config collected"
fi

echo ""
print_success "Dotfiles collection complete!"
print_info "Your dotfiles are now in: $DOTFILES_DIR"
print_info ""
print_info "Next steps:"
print_info "  1. Review the collected files in $DOTFILES_DIR"
print_info "  2. Remove any sensitive information (tokens, passwords, etc.)"
print_info "  3. Commit to your dotfiles repository"
print_info "  4. Test with: cd $DOTFILES_DIR && stow <package>"

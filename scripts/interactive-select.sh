#!/usr/bin/env bash

###############################################################################
# Interactive Installation Selection
# Provides a user-friendly way to select what to install
###############################################################################

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Package definitions
declare -A CATEGORY_DESCRIPTIONS=(
    ["base"]="Essential tools (Homebrew, Git, Stow)"
    ["terminal"]="Modern CLI tools (bat, eza, fzf, ripgrep, etc.)"
    ["devops"]="DevOps tools (Docker, Terraform, Kubernetes, etc.)"
    ["dev"]="Development tools (Neovim, Node.js, Python)"
    ["dotfiles"]="Configuration files (symlink configs to home)"
    ["macos"]="macOS-specific (window manager, fonts, settings)"
)

declare -A CATEGORY_PACKAGES=(
    ["base"]="homebrew,git,stow,curl,wget,gnu-tools"
    ["terminal"]="bat,eza,fzf,ripgrep,fd,zoxide,btop,neofetch,jq,shellcheck,direnv,carapace,starship,tmux,lazygit,atuin,midnight-commander"
    ["devops"]="docker,terraform,terragrunt,aws-cli,kubectl,helm,glab,nmap,opentofu"
    ["dev"]="neovim,nvm,node,python,cmake,make,tree-sitter"
    ["dotfiles"]="nvim-config,tmux-config,zsh-config,starship-config,git-config,ghostty-config"
    ["macos"]="aerospace,nerd-fonts,ghostty,macos-defaults"
)

# Check if fzf is available
check_fzf() {
    if ! command_exists fzf; then
        print_error "fzf is required for interactive mode"
        print_info "Install fzf first: brew install fzf"
        exit 1
    fi
}

# Show category selection menu
select_categories() {
    print_info "Select installation categories (use TAB to select, ENTER to confirm):"
    echo ""

    local categories=()
    local category_list=()

    # Build category list with descriptions
    for category in base terminal devops dev dotfiles macos; do
        local desc="${CATEGORY_DESCRIPTIONS[$category]}"
        category_list+=("$category|$desc")
    done

    # Use fzf for multi-select
    local selected
    selected=$(printf '%s\n' "${category_list[@]}" | \
        fzf --multi \
            --height=40% \
            --border \
            --prompt="Select categories: " \
            --header="TAB=select/deselect, ENTER=confirm, ESC=cancel" \
            --preview='echo {}' \
            --preview-window=hidden \
            --bind 'tab:toggle+down' \
            --marker='✓' \
            --pointer='▶' \
            --header-first \
            --reverse \
            --color='header:italic:underline' | \
        cut -d'|' -f1)

    if [ -z "$selected" ]; then
        print_error "No categories selected. Exiting."
        exit 0
    fi

    echo "$selected"
}

# Show package selection for a category
select_packages_in_category() {
    local category=$1
    local packages_str="${CATEGORY_PACKAGES[$category]}"

    print_info "Select packages from '$category' category:"
    echo ""

    # Convert comma-separated packages to array
    IFS=',' read -ra packages <<< "$packages_str"

    # Use fzf for multi-select
    local selected
    selected=$(printf '%s\n' "${packages[@]}" | \
        fzf --multi \
            --height=60% \
            --border \
            --prompt="Select packages in $category: " \
            --header="TAB=select/deselect, ENTER=confirm, A=select all" \
            --preview-window=hidden \
            --bind 'tab:toggle+down' \
            --bind 'ctrl-a:select-all' \
            --marker='✓' \
            --pointer='▶' \
            --header-first \
            --reverse \
            --select-1 \
            --color='header:italic:underline')

    echo "$selected"
}

# Display selection summary
show_selection_summary() {
    local categories=("$@")

    echo ""
    print_info "═══════════════════════════════════════════════"
    print_info "Installation Summary"
    print_info "═══════════════════════════════════════════════"
    echo ""

    for category in "${categories[@]}"; do
        echo "  ✓ $category: ${CATEGORY_DESCRIPTIONS[$category]}"
    done

    echo ""
    print_info "═══════════════════════════════════════════════"
    echo ""
}

# Simple yes/no prompt
confirm() {
    local prompt=$1
    local response

    read -p "$prompt (y/N): " -n 1 -r response
    echo
    [[ $response =~ ^[Yy]$ ]]
}

# Export selections as environment variables
export_selections() {
    local categories=("$@")

    # Default: skip everything
    export SKIP_BASE=true
    export SKIP_TERMINAL=true
    export SKIP_DEVOPS=true
    export SKIP_DEV=true
    export SKIP_DOTFILES=true
    export SKIP_MACOS=true

    # Enable selected categories
    for category in "${categories[@]}"; do
        case "$category" in
            base)
                export SKIP_BASE=false
                ;;
            terminal)
                export SKIP_TERMINAL=false
                ;;
            devops)
                export SKIP_DEVOPS=false
                ;;
            dev)
                export SKIP_DEV=false
                ;;
            dotfiles)
                export SKIP_DOTFILES=false
                ;;
            macos)
                export SKIP_MACOS=false
                ;;
        esac
    done
}

# Save selections to a config file
save_selections() {
    local categories=("$@")
    local config_file="$HOME/.dotfiles-install-config"

    echo "# Dotfiles installation configuration" > "$config_file"
    echo "# Generated on $(date)" >> "$config_file"
    echo "" >> "$config_file"

    for category in base terminal devops dev dotfiles macos; do
        if [[ " ${categories[@]} " =~ " ${category} " ]]; then
            echo "SKIP_${category^^}=false" >> "$config_file"
        else
            echo "SKIP_${category^^}=true" >> "$config_file"
        fi
    done

    print_success "Configuration saved to $config_file"
    print_info "You can edit this file and use: source $config_file && ./install.sh"
}

# Advanced mode: select individual packages
advanced_package_selection() {
    print_info "═══════════════════════════════════════════════"
    print_info "Advanced Mode: Individual Package Selection"
    print_info "═══════════════════════════════════════════════"
    echo ""

    if ! confirm "Do you want to customize individual packages?"; then
        return
    fi

    print_warning "Advanced package selection coming soon!"
    print_info "For now, you can customize packages by editing:"
    print_info "  - packages/macos.txt"
    print_info "  - packages/linux.txt"
    print_info "  - Individual install scripts in scripts/"
}

# Main interactive flow
main() {
    check_fzf

    # Header
    echo ""
    print_info "╔═══════════════════════════════════════════════════════════════╗"
    print_info "║         Interactive Dotfiles Installation Selector           ║"
    print_info "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    print_info "This wizard will help you choose what to install."
    echo ""

    # Select categories
    local selected_categories
    selected_categories=$(select_categories)

    if [ -z "$selected_categories" ]; then
        print_error "No categories selected"
        exit 1
    fi

    # Convert to array
    local categories_array=()
    while IFS= read -r category; do
        categories_array+=("$category")
    done <<< "$selected_categories"

    # Show summary
    show_selection_summary "${categories_array[@]}"

    # Confirm selection
    if ! confirm "Proceed with this installation?"; then
        print_info "Installation cancelled"
        exit 0
    fi

    # Ask if user wants to save config
    echo ""
    if confirm "Save this configuration for future use?"; then
        save_selections "${categories_array[@]}"
    fi

    # Ask about advanced mode
    echo ""
    advanced_package_selection

    # Export selections
    export_selections "${categories_array[@]}"

    echo ""
    print_success "Configuration ready!"
    print_info "Proceeding to installation..."
    echo ""
}

# Run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

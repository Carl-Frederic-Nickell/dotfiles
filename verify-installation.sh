#!/usr/bin/env bash

###############################################################################
# Comprehensive Installation Verification Script
# Tests all programs and configurations installed by the dotfiles installer
###############################################################################

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Counters
PASSED=0
FAILED=0
WARNINGS=0

print_test() {
    local status=$1
    local message=$2
    local detail=$3

    if [ "$status" = "pass" ]; then
        echo -e "${GREEN}✓${NC} $message"
        ((PASSED++))
    elif [ "$status" = "fail" ]; then
        echo -e "${RED}✗${NC} $message"
        [ -n "$detail" ] && echo -e "  ${RED}→${NC} $detail"
        ((FAILED++))
    elif [ "$status" = "warn" ]; then
        echo -e "${YELLOW}⚠${NC} $message"
        [ -n "$detail" ] && echo -e "  ${YELLOW}→${NC} $detail"
        ((WARNINGS++))
    fi
}

print_section() {
    echo ""
    echo -e "${BLUE}━━━ $1 ━━━${NC}"
}

command_test() {
    local cmd=$1
    local name=${2:-$1}

    if command -v "$cmd" &>/dev/null; then
        local version
        version=$("$cmd" --version 2>&1 | head -n1 || echo "installed")
        print_test "pass" "$name is installed" "$version"
        return 0
    else
        print_test "fail" "$name is not installed"
        return 1
    fi
}

file_test() {
    local file=$1
    local name=$2

    if [ -e "$file" ]; then
        if [ -L "$file" ]; then
            local target
            target=$(readlink "$file")
            print_test "pass" "$name exists (symlink)" "→ $target"
        else
            print_test "pass" "$name exists"
        fi
        return 0
    else
        print_test "fail" "$name does not exist"
        return 1
    fi
}

config_test() {
    local file=$1
    local name=$2
    local check_content=$3

    if [ ! -e "$file" ]; then
        print_test "fail" "$name does not exist"
        return 1
    fi

    if [ -n "$check_content" ]; then
        if grep -q "$check_content" "$file" 2>/dev/null; then
            print_test "pass" "$name is configured"
            return 0
        else
            print_test "warn" "$name exists but missing expected content" "$check_content"
            return 2
        fi
    else
        print_test "pass" "$name exists"
        return 0
    fi
}

functional_test() {
    local test_cmd=$1
    local name=$2
    local expected=$3

    if eval "$test_cmd" &>/dev/null; then
        print_test "pass" "$name works correctly"
        return 0
    else
        print_test "fail" "$name failed functional test" "$test_cmd"
        return 1
    fi
}

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Comprehensive Installation Verification                  ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════╝${NC}"

# BASE TOOLS
print_section "Base Tools"
command_test "brew" "Homebrew"
command_test "git" "Git"
command_test "stow" "GNU Stow"
command_test "curl" "curl"
command_test "wget" "wget"

# GNU Tools (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    command_test "gawk" "GNU awk"
    command_test "gsed" "GNU sed"
    command_test "gtar" "GNU tar"
fi

# TERMINAL TOOLS
print_section "Terminal Enhancement Tools"
command_test "bat" "bat (cat replacement)"
command_test "eza" "eza (ls replacement)"
command_test "fzf" "fzf (fuzzy finder)"
command_test "rg" "ripgrep"
command_test "fd" "fd (find replacement)"
command_test "zoxide" "zoxide"
command_test "btop" "btop"
command_test "neofetch" "neofetch"
command_test "jq" "jq"
command_test "shellcheck" "shellcheck"
command_test "direnv" "direnv"
command_test "carapace" "carapace"
command_test "starship" "starship"
command_test "tmux" "tmux"
command_test "lazygit" "lazygit"
command_test "atuin" "atuin"
command_test "mc" "midnight-commander"

# DEVELOPMENT TOOLS
print_section "Development Tools"
command_test "nvim" "Neovim"
command_test "node" "Node.js"
command_test "npm" "npm"
command_test "python3" "Python"
command_test "pip3" "pip"
command_test "cmake" "CMake"
command_test "make" "Make"
command_test "glab" "GitLab CLI"

# Check NVM
if [ -d "$HOME/.nvm" ]; then
    print_test "pass" "NVM directory exists"
else
    print_test "warn" "NVM directory not found"
fi

# MACOS SPECIFIC
if [[ "$OSTYPE" == "darwin"* ]]; then
    print_section "macOS-Specific Tools"

    # Check for Aerospace
    if [ -d "/Applications/AeroSpace.app" ]; then
        print_test "pass" "AeroSpace (window manager)"
    else
        print_test "warn" "AeroSpace not found" "/Applications/AeroSpace.app"
    fi

    # Check for Ghostty
    if command -v ghostty &>/dev/null; then
        print_test "pass" "Ghostty terminal"
    else
        print_test "warn" "Ghostty not found"
    fi

    # Check for Docker
    if [ -d "/Applications/Docker.app" ]; then
        print_test "pass" "Docker Desktop"
    else
        print_test "warn" "Docker Desktop not found"
    fi

    # Check Nerd Fonts
    if ls ~/Library/Fonts/*Nerd* &>/dev/null || ls /Library/Fonts/*Nerd* &>/dev/null; then
        print_test "pass" "Nerd Fonts installed"
    else
        print_test "warn" "Nerd Fonts not found"
    fi
fi

# DEVOPS TOOLS (optional, may not be installed)
print_section "DevOps Tools (optional)"
command_test "docker" "Docker" || print_test "warn" "Docker not installed (optional)"
command_test "terraform" "Terraform" || print_test "warn" "Terraform not installed (optional)"
command_test "aws" "AWS CLI" || print_test "warn" "AWS CLI not installed (optional)"
command_test "kubectl" "kubectl" || print_test "warn" "kubectl not installed (optional)"
command_test "helm" "Helm" || print_test "warn" "Helm not installed (optional)"

# CONFIGURATION FILES
print_section "Configuration Files"
file_test "$HOME/.config/nvim" "Neovim config directory"
file_test "$HOME/.config/tmux" "Tmux config directory"
file_test "$HOME/.config/starship.toml" "Starship config"
file_test "$HOME/.config/ghostty" "Ghostty config directory"
file_test "$HOME/.config/atuin" "Atuin config directory"

# Shell configs
if [ -f "$HOME/.zshrc" ]; then
    config_test "$HOME/.zshrc" "Zsh config" "source"
elif [ -f "$HOME/.bashrc" ]; then
    config_test "$HOME/.bashrc" "Bash config" "source"
fi

# Git config
config_test "$HOME/.gitconfig" "Git config" "user"

# FUNCTIONAL TESTS
print_section "Functional Tests"

# Test bat can read files
if command -v bat &>/dev/null; then
    functional_test "echo 'test' | bat --plain" "bat reads input"
fi

# Test fzf
if command -v fzf &>/dev/null; then
    functional_test "echo 'test' | fzf --filter='test'" "fzf filtering"
fi

# Test ripgrep
if command -v rg &>/dev/null; then
    functional_test "echo 'test' | rg 'test'" "ripgrep search"
fi

# Test nvim
if command -v nvim &>/dev/null; then
    functional_test "nvim --version" "Neovim version check"

    # Check if lazy.nvim is installed
    if [ -d "$HOME/.local/share/nvim/lazy" ]; then
        print_test "pass" "Lazy.nvim plugin manager installed"
    else
        print_test "warn" "Lazy.nvim not found" "Plugins may not be installed yet"
    fi
fi

# Test tmux
if command -v tmux &>/dev/null; then
    functional_test "tmux -V" "tmux version check"

    # Check TPM
    if [ -d "$HOME/.tmux/plugins/tpm" ]; then
        print_test "pass" "Tmux Plugin Manager (TPM) installed"
    else
        print_test "fail" "TPM not installed"
    fi
fi

# Test starship
if command -v starship &>/dev/null; then
    functional_test "starship --version" "Starship prompt"
fi

# SHELL INTEGRATION
print_section "Shell Integration"

# Check if shell sources are set up
SHELL_NAME=$(basename "$SHELL")
case "$SHELL_NAME" in
    zsh)
        if [ -f "$HOME/.zshrc" ]; then
            # Check for important integrations
            if grep -q "starship" "$HOME/.zshrc" 2>/dev/null; then
                print_test "pass" "Starship integrated in zsh"
            else
                print_test "warn" "Starship not integrated in .zshrc"
            fi

            if grep -q "zoxide" "$HOME/.zshrc" 2>/dev/null; then
                print_test "pass" "Zoxide integrated in zsh"
            else
                print_test "warn" "Zoxide not integrated in .zshrc"
            fi
        fi
        ;;
    bash)
        if [ -f "$HOME/.bashrc" ]; then
            if grep -q "starship" "$HOME/.bashrc" 2>/dev/null; then
                print_test "pass" "Starship integrated in bash"
            else
                print_test "warn" "Starship not integrated in .bashrc"
            fi
        fi
        ;;
esac

# SUMMARY
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Summary:${NC}"
echo -e "  ${GREEN}Passed:${NC}   $PASSED"
echo -e "  ${RED}Failed:${NC}   $FAILED"
echo -e "  ${YELLOW}Warnings:${NC} $WARNINGS"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All critical tests passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some tests failed. Please review the output above.${NC}"
    exit 1
fi

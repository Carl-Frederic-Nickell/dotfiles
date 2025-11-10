#!/usr/bin/env bash

# Common functions used across installation scripts

# Check if running in non-interactive mode (CI/CD)
is_interactive() {
    [[ -t 0 && -z "$NONINTERACTIVE" && -z "$CI" ]]
}

# Color output functions (skip colors in non-interactive mode)
print_info() {
    if is_interactive; then
        echo -e "\033[0;34mℹ ${1}\033[0m"
    else
        echo "INFO: ${1}"
    fi
}

print_success() {
    if is_interactive; then
        echo -e "\033[0;32m✓ ${1}\033[0m"
    else
        echo "SUCCESS: ${1}"
    fi
}

print_warning() {
    if is_interactive; then
        echo -e "\033[1;33m⚠ ${1}\033[0m"
    else
        echo "WARNING: ${1}"
    fi
}

print_error() {
    if is_interactive; then
        echo -e "\033[0;31m✗ ${1}\033[0m"
    else
        echo "ERROR: ${1}"
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Cross-platform sed in-place function
sed_inplace() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "$@"
    else
        sed -i "$@"
    fi
}

# Detect OS type
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if grep -qi microsoft /proc/version 2>/dev/null; then
            echo "wsl"
        else
            echo "linux"
        fi
    else
        echo "unknown"
    fi
}

# Detect macOS architecture (Intel vs Apple Silicon)
detect_macos_arch() {
    if [[ "$(uname -s)" == "Darwin" ]]; then
        if [[ "$(uname -m)" == "arm64" ]]; then
            echo "apple_silicon"
        else
            echo "intel"
        fi
    else
        echo "not_macos"
    fi
}

# Detect Linux distribution
detect_linux_distro() {
    if [[ ! -f /etc/os-release ]]; then
        echo "unknown"
        return
    fi

    # Parse /etc/os-release safely without sourcing (prevents arbitrary code execution)
    local distro_id
    distro_id=$(grep '^ID=' /etc/os-release 2>/dev/null | cut -d'=' -f2 | tr -d '"' | tr -d "'")

    case "$distro_id" in
        ubuntu|debian)
            echo "debian"
            ;;
        fedora|rhel|centos|rocky|alma)
            echo "redhat"
            ;;
        arch|manjaro)
            echo "arch"
            ;;
        alpine)
            echo "alpine"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Get package manager command
get_package_manager() {
    local os_type
    os_type="$(detect_os)"

    if [[ "$os_type" == "macos" ]]; then
        echo "brew"
    elif command_exists apt-get; then
        echo "apt-get"
    elif command_exists dnf; then
        echo "dnf"
    elif command_exists yum; then
        echo "yum"
    elif command_exists pacman; then
        echo "pacman"
    elif command_exists apk; then
        echo "apk"
    elif command_exists brew; then
        echo "brew"
    else
        echo "none"
    fi
}

# Get Homebrew prefix (works across macOS Intel/ARM and Linux)
get_brew_prefix() {
    if command_exists brew; then
        brew --prefix
    elif [[ -d "/opt/homebrew" ]]; then
        echo "/opt/homebrew"
    elif [[ -d "/usr/local" ]]; then
        echo "/usr/local"
    elif [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
        echo "/home/linuxbrew/.linuxbrew"
    else
        echo ""
    fi
}

# Print environment information
print_env_info() {
    print_info "Environment Information:"
    echo "  OS: $(detect_os)"

    if [[ "$(detect_os)" == "macos" ]]; then
        echo "  Architecture: $(detect_macos_arch)"
        echo "  Homebrew: $(get_brew_prefix)"
    elif [[ "$(detect_os)" == "linux" ]] || [[ "$(detect_os)" == "wsl" ]]; then
        echo "  Distribution: $(detect_linux_distro)"
        echo "  Package Manager: $(get_package_manager)"
    fi

    echo "  Interactive: $(is_interactive && echo 'yes' || echo 'no')"
    echo "  Shell: $SHELL"
}

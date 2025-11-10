# Dotfiles & Development Environment Setup

Cross-platform dotfiles and automated installation scripts for macOS, Linux, and Windows (WSL).

> **⚡ Quick Start**: `git clone <repo-url> ~/dotfiles && cd ~/dotfiles && ./install.sh`

## Table of Contents
- [Features](#features)
- [Quick Start](#quick-start)
- [What Gets Installed](#what-gets-installed)
- [Selective Installation](#selective-installation)
- [Security & Privacy](#security--privacy)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [Advanced Usage](#advanced-usage)

## Features

- ✅ **Automated Installation**: One command to set up your entire dev environment
- 🔗 **GNU Stow Management**: Clean symlink-based dotfile management
- 🌍 **Cross-Platform**: macOS (Intel/ARM), Linux (apt/yum/pacman), Windows (WSL2)
- 🔁 **Idempotent**: Safe to run multiple times without breaking things
- 🧩 **Modular**: Install only what you need with selective flags
- 🔒 **Security-Focused**: Sanitization script, backup before changes, confirmation prompts
- 📦 **DRY Architecture**: Shared functions, no code duplication

## Quick Start

### First Time Setup

```bash
# 1. Clone the repository
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles

# 2. (Optional) Preview what will be installed
cat scripts/install-*.sh  # Review installation scripts

# 3. Run installation (creates backup automatically)
./install.sh

# 4. Restart your shell
exec $SHELL

# 5. Open nvim to install plugins (first time only)
nvim
```

### Existing Dotfiles User

```bash
# Pull latest changes
cd ~/dotfiles
git pull

# Reinstall (safe, idempotent)
./install.sh
```

## What Gets Installed

### 🚀 Base Tools
- **Package Managers**: Homebrew (macOS/Linux)
- **Core Utils**: git, stow, curl, wget, build-essential

### 💻 Terminal Enhancements
- **Shells**: Zsh with autosuggestions
- **Terminal Emulators**: Ghostty (macOS), WezTerm (WSL)
- **Prompt**: Starship (cross-shell prompt)
- **Multiplexer**: Tmux with TPM (plugin manager)
- **History**: Atuin (synced shell history with search)

### 🔧 Modern CLI Replacements
- **bat**: `cat` with syntax highlighting
- **eza**: `ls` with colors, icons, git integration
- **fzf**: Fuzzy finder for files/history
- **ripgrep**: Fast recursive search (`grep` replacement)
- **fd**: Fast file finder (`find` replacement)
- **zoxide**: Smart directory jumper (`cd` replacement)
- **btop**: System monitor (`htop` replacement)

### 🛠️ Development Tools
- **Editors**: Neovim with custom config
- **Version Control**: git, glab (GitLab CLI), lazygit
- **Runtimes**:
  - Node.js via NVM (configurable version)
  - Python 3.12/3.13
- **Tools**: jq, tree-sitter, shellcheck, direnv

### 🐳 DevOps Tools
- Docker & docker-compose
- Kubernetes tools (kubectl, k9s, etc.)
- Terraform & Terragrunt
- AWS CLI
- Various cloud/IaC tools

### 🍎 macOS Specific
- Aerospace (tiling window manager)
- Nerd Fonts (JetBrains Mono, Meslo, Fira Code, Hack)
- macOS defaults configuration (with safety prompts)

## Selective Installation

Install only the components you need:

```bash
# Install everything (default)
./install.sh

# Skip specific components
./install.sh --skip-devops           # Skip Docker, K8s, etc.
./install.sh --skip-dev              # Skip Node, Python, etc.
./install.sh --skip-terminal         # Skip terminal enhancements
./install.sh --skip-macos            # Skip macOS-specific tools

# Combine multiple flags
./install.sh --skip-devops --skip-macos

# Environment variable control
SKIP_DEVOPS=1 ./install.sh
```

### Install Individual Components

```bash
# Just install specific tools
./scripts/install-base.sh            # Package managers & core utils
./scripts/install-terminal.sh        # Terminal enhancements
./scripts/install-dev.sh             # Development tools
./scripts/install-devops.sh          # DevOps tools
./scripts/install-dotfiles.sh        # Just dotfiles (requires stow)
./scripts/install-macos.sh           # macOS-specific (macOS only)
```

## Security & Privacy

### ⚠️ Important Security Notes

1. **Review Before Installing**: Always review installation scripts before running
2. **Backup Created Automatically**: All existing configs backed up to `~/.dotfiles-backup-TIMESTAMP/`
3. **No Secrets Committed**: The repo includes a sanitization script

### Sensitive Data Protection

**Before committing changes:**

```bash
# Run sanitization to remove secrets
./sanitize.sh

# What it removes:
# - GitLab tokens (glpat-*)
# - GitHub tokens (ghp_*, gho_*)
# - AWS keys (AKIA*, aws_secret)
# - SSH private keys
# - Email addresses (optional, prompts first)
```

### What Gets Committed

✅ **Safe to commit:**
- Shell configurations (.zshrc, .bashrc)
- Editor configs (nvim, tmux)
- Tool configurations (starship, atuin, etc.)
- Scripts and automation

❌ **Never committed (in .gitignore):**
- API tokens and keys
- SSH private keys
- `.env` files
- `node_modules/`
- Private/local configs
- Temporary files

### Machine-Specific Settings

For settings that shouldn't be version controlled (local paths, tokens, etc.), use:

```bash
# Create a local config file (ignored by git)
touch ~/.zshrc.local

# Add machine-specific settings
echo 'export OLLAMA_MODELS="/custom/path"' >> ~/.zshrc.local
echo 'export CUSTOM_API_KEY="secret"' >> ~/.zshrc.local

# These are automatically loaded at the end of .zshrc
```

## Configuration

### Environment Variables

Control installation behavior:

```bash
# NVM version (default: v0.39.7)
NVM_VERSION=v0.40.0 ./install.sh

# Skip interactive prompts (for CI/CD)
export NONINTERACTIVE=1
./install.sh

# Preserve existing backup directory
export BACKUP_DIR=~/.dotfiles-backup-existing
./install.sh
```

### macOS Settings

The installation asks before applying potentially risky settings:

- ❌ **LSQuarantine** (malware protection) - **Prompts before disabling**
- ✅ Fast key repeat - Applied automatically
- ✅ Show hidden files - Applied automatically
- ✅ Finder enhancements - Applied automatically

## Troubleshooting

### Common Issues

#### 🔴 "Permission Denied" Error

```bash
# Make scripts executable
chmod +x install.sh
chmod +x scripts/*.sh
```

#### 🔴 Stow Conflicts

If GNU Stow reports conflicts:

```bash
# Option 1: Remove conflicting files (backed up automatically)
rm -rf ~/.config/nvim

# Option 2: Check your backup
ls -la ~/.dotfiles-backup-*/

# Option 3: Let stow adopt existing files
cd dotfiles && stow --adopt nvim
```

#### 🔴 Homebrew Installation Failed

```bash
# Manual Homebrew installation
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Then run specific installation
./scripts/install-terminal.sh
```

#### 🔴 NVM Not Found After Installation

```bash
# Restart your shell
exec $SHELL

# Or manually load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

#### 🔴 Fonts Not Rendering (Linux)

```bash
# Rebuild font cache
fc-cache -fv

# Restart your terminal emulator
```

#### 🔴 macOS: "Command not found" After Installation

```bash
# Intel Mac
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile

# Apple Silicon Mac
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile

# Reload
source ~/.zprofile
```

### Platform-Specific Notes

#### macOS (Intel vs Apple Silicon)

The scripts automatically detect your architecture:
- **Intel**: Homebrew at `/usr/local`
- **Apple Silicon**: Homebrew at `/opt/homebrew`

#### Linux (Different Distros)

Supported package managers:
- **Debian/Ubuntu**: apt-get
- **Fedora/RHEL/CentOS**: yum/dnf
- **Arch**: pacman

Falls back to Homebrew for consistent package versions.

#### WSL2 (Windows)

Requirements:
- WSL2 (not WSL1)
- Ubuntu 20.04+ or Debian 11+

Known issues:
- Some GUI apps require X server (VcXsrv, X410)
- Docker Desktop integration recommended
- Path differences: `/mnt/c/` for C: drive

### Getting Help

1. **Check the backup**: `ls -la ~/.dotfiles-backup-*/`
2. **Review logs**: Installation scripts print detailed output
3. **Test individual scripts**: Run `./scripts/install-X.sh` separately
4. **Validate scripts**: Run `./scripts/validate.sh` to check for issues
5. **File an issue**: Include OS, shell version, and error messages

## Advanced Usage

### Project Structure

```
dotfiles/
├── install.sh                      # Main orchestrator
├── sanitize.sh                     # Remove secrets before commit
├── collect-dotfiles.sh             # Collect configs from ~/ into repo
├── scripts/
│   ├── common.sh                   # Shared helper functions
│   ├── validate.sh                 # Shellcheck validation
│   ├── install-base.sh            # Package managers
│   ├── install-terminal.sh        # Terminal tools
│   ├── install-dev.sh             # Development tools
│   ├── install-devops.sh          # DevOps tools
│   ├── install-dotfiles.sh        # GNU Stow dotfiles
│   └── install-macos.sh           # macOS-specific
├── dotfiles/                       # Stow packages
│   ├── nvim/.config/nvim/         # Neovim config
│   ├── tmux/.config/tmux/         # Tmux config
│   ├── zsh/.zshrc                 # Zsh config
│   ├── starship/.config/starship.toml
│   └── ...
└── configs/                        # Additional configs
```

### Using GNU Stow

Stow creates symlinks from `~/dotfiles/dotfiles/<package>/` to `~/`:

```bash
cd ~/dotfiles/dotfiles

# Install a package (creates symlinks)
stow nvim                          # Links nvim/.config/nvim -> ~/.config/nvim

# Remove a package (removes symlinks)
stow -D nvim

# Restow (update existing symlinks)
stow -R nvim

# See what would happen (dry-run)
stow -n nvim

# Adopt existing files (move them into dotfiles/)
stow --adopt nvim
```

### Syncing Across Machines

Changes to files in `~/` are actually changes to `~/dotfiles/`:

```bash
# On Machine A: Edit config
nvim ~/.config/nvim/init.lua       # Actually editing ~/dotfiles/dotfiles/nvim/.config/nvim/init.lua

# Commit and push
cd ~/dotfiles
git add .
git commit -m "Updated nvim config"
git push

# On Machine B: Pull changes
cd ~/dotfiles
git pull
# Changes are live immediately (via symlinks)!
```

### Adding New Tools

1. Create installation script:
```bash
cat > scripts/install-newtool.sh <<'EOF'
#!/usr/bin/env bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

install_newtool() {
    print_info "Installing newtool..."
    brew install newtool
    print_success "Newtool installed"
}

install_newtool "$@"
EOF

chmod +x scripts/install-newtool.sh
```

2. Add to `install.sh`:
```bash
# Add after other installations
print_header "Installing New Tool"
source "$SCRIPTS_DIR/install-newtool.sh"
```

### Collecting Existing Dotfiles

If you have existing configs you want to add to the repo:

```bash
# Run collection script
./collect-dotfiles.sh

# Review what was collected
ls -la dotfiles/

# Remove sensitive data
./sanitize.sh

# Commit
git add dotfiles/
git commit -m "Added existing dotfiles"
```

### CI/CD Integration

For automated testing/deployment:

```bash
# Skip interactive prompts
export NONINTERACTIVE=1

# Skip optional components
./install.sh --skip-macos --skip-devops

# Run validation
./scripts/validate.sh
```

### Code Quality

Validate all shell scripts:

```bash
# Install shellcheck first (done by install.sh)
brew install shellcheck  # or: apt-get install shellcheck

# Run validation
./scripts/validate.sh

# Output shows:
# - Which scripts passed/failed
# - Specific shellcheck warnings
# - Summary of results
```

## Contributing

1. Fork the repository
2. Make your changes
3. Run `./scripts/validate.sh` to check for issues
4. Run `./sanitize.sh` to remove sensitive data
5. Submit a pull request

## Security Improvements

This repository has been hardened with the following security measures:

### ✅ Safe Docker Operations
- `drm` and `drmi` commands now require confirmation before deleting containers/images
- Shows what will be deleted before executing
- Prevents accidental data loss

### ✅ Remote Script Verification
- Homebrew and NVM installers are downloaded to temporary files first
- File size is verified before execution
- No direct piping of remote scripts to bash
- Protects against supply chain attacks

### ✅ Backup Validation
- Verifies backups succeeded before deleting original files
- Tracks backup success/failure counts
- Prompts user if any backups failed
- Uses `${var:?}` syntax to prevent empty variable expansion in `rm -rf`

### ✅ macOS Security
- LSQuarantine (Gatekeeper) setting prompts before disabling
- Warns about malware protection implications
- User must explicitly opt-in to reduce security

### ✅ Cross-Platform Compatibility
- Detects Intel vs Apple Silicon Macs
- Auto-detects package managers (apt, yum, dnf, pacman, apk)
- Platform-specific `sed` syntax handled automatically
- Homebrew paths detected across all platforms

### ✅ Input Validation
- `lsb_release` output validated against known Ubuntu/Debian codenames
- Prevents command injection via malicious distribution names
- Safe parsing of `/etc/os-release` without code execution
- Safer file iteration instead of wildcard expansion

### ✅ Code Quality
- All scripts source shared `common.sh` (DRY principle)
- Shellcheck validation script included
- Consistent error handling across all scripts
- CI/CD support with `NONINTERACTIVE` mode

### ⚠️ Security Tradeoff: Remote Script Execution

**Current Approach:** This installer downloads and executes remote scripts from trusted sources (Homebrew, NVM, Docker, etc.) without cryptographic checksum verification.

**Why:**
- ✅ Always installs latest versions
- ✅ No maintenance overhead
- ✅ Scripts work immediately after upstream updates
- ✅ File size verification prevents empty/truncated downloads

**Risk:**
- ❌ Vulnerable to MITM attacks on insecure networks
- ❌ Vulnerable if GitHub/official servers are compromised
- ❌ No cryptographic integrity verification

**Mitigation:**
1. Scripts are downloaded from official HTTPS URLs only
2. File size is verified before execution
3. Scripts are reviewed before first commit
4. Only run on trusted networks
5. Consider using VPN for additional protection

**Alternative Approach (High Security):**

If you require cryptographic verification, manually verify and pin specific versions:

```bash
# Example: Verify Homebrew installer manually
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o install.sh
shasum -a 256 install.sh  # Compare with known-good hash
bash install.sh
```

For production/enterprise use, consider migrating to:
- **Ansible** - Configuration management with verification
- **Nix/Home Manager** - Declarative with hash verification
- **Docker** - Containerized with image signatures

## License

MIT License - Use freely, modify as needed, share with others.

---

**Last Updated**: 2025-01-10
**Tested On**: macOS 14+ (Intel/ARM), Ubuntu 22.04+, Debian 11+, WSL2 (Ubuntu)

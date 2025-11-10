# Quick Start Guide

## Initial Setup (First Time)

### 1. Collect Your Existing Dotfiles

```bash
# Run the collection script to gather your current configs
./collect-dotfiles.sh
```

This will copy all your existing configurations into the `dotfiles/` directory with the proper structure for GNU Stow.

### 2. Review and Clean

```bash
# Check what was collected
ls -la dotfiles/

# Remove sensitive information
# Edit files to remove:
# - API keys
# - Passwords
# - Personal tokens
# - Email addresses (if desired)
```

### 3. Initialize Git Repository

```bash
# Initialize git (if not already done)
git init

# Add your remote
git remote add origin <your-github-repo-url>

# Add files
git add .

# Commit
git commit -m "Initial dotfiles and installation scripts"

# Push
git push -u origin main
```

## On a New Machine

### macOS

```bash
# Clone your dotfiles repo
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles

# Run the installation
./install.sh

# Restart terminal
exec $SHELL

# Open nvim to install plugins
nvim

# Open tmux and install plugins (prefix + I)
tmux
```

### Linux

```bash
# Clone your dotfiles repo
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles

# Run the installation
./install.sh

# Restart terminal
exec $SHELL
```

### Windows (WSL2)

```bash
# First install WSL2
wsl --install

# Install WezTerm on Windows (not in WSL)
# Download from: https://wezfurlong.org/wezterm/

# In WSL, clone your dotfiles
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles

# Run the installation
./install.sh

# Restart terminal
exec $SHELL
```

## Customization

### Add a New Tool

1. Create a script: `scripts/install-mytool.sh`
```bash
#!/usr/bin/env bash
set -e

print_info() { echo -e "\033[0;34mℹ ${1}\033[0m"; }
print_success() { echo -e "\033[0;32m✓ ${1}\033[0m"; }

print_info "Installing mytool..."
brew install mytool  # or your package manager
print_success "mytool installed"
```

2. Make it executable:
```bash
chmod +x scripts/install-mytool.sh
```

3. Add to `install.sh`:
```bash
print_header "Installing My Tool"
source "$SCRIPTS_DIR/install-mytool.sh"
```

### Add New Dotfiles

```bash
# Create directory structure
mkdir -p dotfiles/mytool/.config/mytool

# Copy your config
cp ~/.config/mytool/* dotfiles/mytool/.config/mytool/

# Test stowing
cd dotfiles
stow mytool

# Add to git
git add dotfiles/mytool
git commit -m "Add mytool dotfiles"
git push
```

## Syncing Configs

### After Editing Configs on Current Machine

```bash
cd ~/dotfiles
git status              # See what changed
git add .
git commit -m "Updated zsh aliases"
git push
```

### Getting Updates on Other Machines

```bash
cd ~/dotfiles
git pull                # Changes apply automatically via symlinks!
```

### Understanding Symlinks

When you run stow, it creates symlinks:
```
~/.config/nvim/init.lua  →  ~/dotfiles/nvim/.config/nvim/init.lua
```

This means when you edit `~/.config/nvim/init.lua`, you're actually editing the file in the git repo!

## Maintenance

### Update Packages on Current Machine

```bash
cd ~/dotfiles

# Pull latest changes first
git pull

# Re-run installation (idempotent, safe to run multiple times)
./install.sh

# Or just update dotfiles
./scripts/install-dotfiles.sh
```

### Update Package Lists

```bash
# Generate current package list
brew list --formula > current-packages.txt

# Compare with packages/macos.txt
# Add/remove packages as needed

# Commit changes
git add packages/
git commit -m "Update package list"
git push
```

## Troubleshooting

### Stow Conflicts

If you get stow conflicts:
```bash
# Option 1: Backup and remove
mv ~/.config/nvim ~/.config/nvim.backup

# Option 2: Let stow adopt the file
cd dotfiles
stow --adopt nvim
```

### Permission Errors

```bash
# Make sure scripts are executable
chmod +x install.sh collect-dotfiles.sh scripts/*.sh
```

### Package Not Found

Some packages may have different names on different OS:
- Check `packages/macos.txt` vs `packages/linux.txt`
- Search for the package: `brew search <name>` or `apt search <name>`
- Update the installation script accordingly

## Your System Information

Based on your current Mac setup, here are the key tools installed:

### DevOps
- Docker, Terraform, Terragrunt, tfenv
- AWS CLI
- GitLab CLI (glab)
- nmap, tcpdump, iperf3

### Terminal
- Ghostty (macOS/Linux), WezTerm (Windows/WSL)
- Starship prompt
- Tmux
- Zsh with autosuggestions

### CLI Tools
- bat, eza, fzf, ripgrep, fd, zoxide
- btop, neofetch, cmatrix
- lazygit, atuin
- midnight-commander

### Development
- Neovim
- Node.js (nvm)
- Python 3.12, 3.13

### macOS Specific
- Aerospace (window management)
- Nerd Fonts (JetBrains Mono, Meslo, Fira Code, Hack)

All of these are now scriptable and portable to your next machine!

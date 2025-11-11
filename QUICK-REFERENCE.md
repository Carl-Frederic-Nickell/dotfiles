# Dotfiles Installer - Quick Reference

## Installation Commands

### Interactive Mode (Easiest)
```bash
./install.sh -i
```

### Full Installation
```bash
./install.sh
```

### Selective Installation
```bash
./install.sh --skip-devops --skip-macos
```

## Interactive Mode Keys

| Key | Action |
|-----|--------|
| `↑` `↓` | Navigate |
| `TAB` | Select/deselect |
| `CTRL-A` | Select all |
| `ENTER` | Confirm |
| `ESC` | Cancel |

## Installation Categories

| Category | Description | Includes |
|----------|-------------|----------|
| `base` | Essential tools | Homebrew, Git, Stow, curl, wget |
| `terminal` | CLI enhancements | bat, eza, fzf, ripgrep, fd, zoxide, starship, tmux, atuin |
| `devops` | DevOps tools | Docker, Terraform, AWS CLI, kubectl, Helm |
| `dev` | Development | Neovim, NVM/Node.js, Python, CMake |
| `dotfiles` | Configurations | Config files for all tools |
| `macos` | macOS-specific | AeroSpace, Nerd Fonts, macOS settings |

## Common Workflows

### First-Time Setup
```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh -i
```

### Minimal Server
```bash
./install.sh --skip-devops --skip-dev --skip-macos
```

### Developer Workstation
```bash
./install.sh --skip-devops
```

### Update Existing
```bash
cd ~/dotfiles
git pull
./install.sh
```

## Configuration Files

### Save Your Selection
During interactive mode, choose "yes" when prompted to save.
Creates: `~/.dotfiles-install-config`

### Load Saved Config
```bash
source ~/.dotfiles-install-config
./install.sh
```

### Share Config
```bash
scp ~/.dotfiles-install-config user@other-machine:~/
```

## Verification

### Check Installation Health
```bash
./verify-installation.sh
```

### Check Individual Tools
```bash
# Verify Node.js
node --version
npm --version

# Verify shell config
echo $SHELL
which starship

# Verify Neovim plugins
nvim +checkhealth
```

## Troubleshooting

### NVM Not Loading
```bash
# Reload shell
exec $SHELL

# Or manually source
source ~/.zshrc
```

### Permission Issues
```bash
# Fix script permissions
chmod +x install.sh scripts/*.sh
```

### Reinstall Dotfiles Only
```bash
./scripts/install-dotfiles.sh
```

## File Locations

| What | Where |
|------|-------|
| Install scripts | `~/dotfiles/scripts/` |
| Config templates | `~/dotfiles/dotfiles/` |
| Actual configs | `~/.config/` (symlinked) |
| Backup | `~/.dotfiles-backup-YYYYMMDD-HHMMSS/` |
| Saved config | `~/.dotfiles-install-config` |

## Useful Commands

### View Help
```bash
./install.sh --help
```

### Demo Interactive Mode
```bash
./demo-interactive.sh
```

### Verify Setup
```bash
./verify-setup.sh        # Basic check
./verify-installation.sh # Comprehensive test
```

## Flag Reference

| Flag | Effect |
|------|--------|
| `-h`, `--help` | Show help |
| `-i`, `--interactive` | Interactive mode |
| `--skip-base` | Skip Homebrew, Git, Stow |
| `--skip-terminal` | Skip bat, eza, fzf, etc. |
| `--skip-devops` | Skip Docker, Terraform, etc. |
| `--skip-dev` | Skip Neovim, Node, Python |
| `--skip-dotfiles` | Skip config installation |
| `--skip-macos` | Skip macOS-specific tools |

## Environment Variables

```bash
# Skip categories
export SKIP_DEVOPS=true
export SKIP_MACOS=true

# Non-interactive mode (CI/CD)
export NONINTERACTIVE=1

# Custom NVM version
export NVM_VERSION=v0.40.0
```

## Documentation

| File | Description |
|------|-------------|
| `README.md` | Complete documentation |
| `QUICKSTART.md` | Step-by-step guide |
| `INTERACTIVE-MODE.md` | Interactive mode guide |
| `IMPROVEMENTS.md` | Recent improvements |
| `TESTING-REPORT.md` | Test results |

## Quick Tips

💡 **First time?** Use interactive mode: `./install.sh -i`

💡 **Multiple machines?** Save your config in interactive mode

💡 **Not sure what to install?** Run the demo: `./demo-interactive.sh`

💡 **Something wrong?** Run verification: `./verify-installation.sh`

💡 **Need to customize?** Edit package lists in `packages/*.txt`

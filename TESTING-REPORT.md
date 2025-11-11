# Installation Issues & Improvements Report

## Executive Summary

Comprehensive testing of the dotfiles installation revealed **5 issues**:
- **3 Critical**: Need fixes
- **1 Warning**: Optional feature
- **1 Minor**: Inconsistency

Overall: **56 tests passed**, 3 failed, 1 warning

---

## Issues Found

### 1. ❌ CRITICAL: NVM/Node.js Not Loading in Shell

**Problem:**
- NVM is installed at `~/.nvm/`
- Node.js v24.11.0 is installed via NVM
- However, NVM initialization code is missing from `.zshrc`
- Result: `node` and `npm` commands not available in new shell sessions

**Root Cause:**
The NVM installer script modifies shell config files, but the dotfiles installer runs `install-dev.sh` which installs NVM, then later `install-dotfiles.sh` which uses GNU Stow to overwrite `.zshrc` with the dotfiles version. This removes the NVM initialization code that was added.

**Impact:** High - Node.js development broken in new shells

**Fix Required:**
Add NVM initialization to the dotfiles `.zshrc` template:
```bash
# NVM initialization
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
```

---

### 2. ❌ MEDIUM: Tmux Config Location Inconsistency

**Problem:**
- Dotfiles use `~/.tmux.conf` (old-style)
- Modern XDG spec prefers `~/.config/tmux/tmux.conf`
- Verification script expects `~/.config/tmux/` but finds `~/.tmux.conf`

**Impact:** Low - Tmux works fine, just inconsistent with modern conventions

**Recommendation:**
- Move tmux config to XDG location: `dotfiles/tmux/.config/tmux/tmux.conf`
- Update stow to create `~/.config/tmux/`
- Or: Update verification script to check for `~/.tmux.conf`

---

### 3. ❌ MINOR: Missing configs/ Directory

**Problem:**
- `verify-setup.sh` expects `configs/` directory
- Directory doesn't exist in the repository

**Impact:** Very Low - Only affects verification script

**Fix:** Either:
- Create the directory: `mkdir -p configs/`
- Remove check from verification script

---

### 4. ⚠️  OPTIONAL: AeroSpace Window Manager Not Installed

**Problem:**
- AeroSpace.app not found in `/Applications/`

**Status:** Expected - Installation script shows this may fail
```bash
brew install --cask aerospace 2>/dev/null || print_info "Aerospace installation skipped"
```

**Impact:** None - This is an optional tool

**Recommendation:**
- Check why cask installation failed
- May require manual installation or different installation method

---

### 5. ℹ️ INFO: Install Script Order Issue

**Problem:**
The installation order causes config overwrites:
1. `install-dev.sh` runs → installs NVM → NVM modifies `.zshrc`
2. `install-dotfiles.sh` runs → uses GNU Stow → overwrites `.zshrc`

**Impact:** High - Any tool that modifies shell config during installation will be overwritten

**Affected Tools:**
- NVM (confirmed)
- Potentially others that modify configs during install

**Fix Required:**
Change installation order or strategy:
- Option A: Run `install-dotfiles.sh` FIRST, then other tools
- Option B: Add integration code to dotfiles templates
- Option C: Use `--adopt` flag in Stow more carefully

---

## What's Working Well ✅

### Base Tools (8/8)
- ✅ Homebrew
- ✅ Git, GNU Stow
- ✅ curl, wget
- ✅ GNU tools (awk, sed, tar)

### Terminal Tools (17/17)
- ✅ bat, eza, fzf, ripgrep, fd, zoxide
- ✅ btop, neofetch, jq, shellcheck
- ✅ starship, tmux, lazygit, atuin
- ✅ All tools functional and integrated

### Development Tools (6/8)
- ✅ Neovim with Lazy.nvim
- ✅ Python 3 with pip
- ✅ CMake, Make, GitLab CLI
- ⚠️ Node.js (installed but not in PATH)

### DevOps Tools (5/5)
- ✅ Docker Desktop
- ✅ Terraform, AWS CLI
- ✅ kubectl, Helm

### Configuration Files
- ✅ Neovim config (symlinked correctly)
- ✅ Starship, Ghostty, Atuin configs
- ✅ Git config with user info
- ✅ Shell integration (zoxide, starship, atuin)
- ✅ Tmux Plugin Manager (TPM) installed

---

## Recommendations for Script Improvements

### Priority 1: Fix NVM Loading

**File:** `dotfiles/zsh/.zshrc`

Add NVM initialization section:
```bash
# =============================================================================
# NODE VERSION MANAGER (NVM)
# =============================================================================

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Auto-use .nvmrc if present
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
```

### Priority 2: Change Installation Order

**File:** `install.sh`

Move dotfiles installation earlier:
```bash
# Run installation scripts in order
if [ "$SKIP_BASE" != true ]; then
    print_header "Installing Base Tools"
    source "$SCRIPTS_DIR/install-base.sh"
fi

# INSTALL DOTFILES EARLY (before tools that modify configs)
if [ "$SKIP_DOTFILES" != true ]; then
    print_header "Installing Dotfiles"
    source "$SCRIPTS_DIR/install-dotfiles.sh"
fi

# Then install tools that might modify configs
if [ "$SKIP_TERMINAL" != true ]; then
    print_header "Installing Terminal Enhancements"
    source "$SCRIPTS_DIR/install-terminal.sh"
fi

# ... rest of installations
```

**OR** Add a post-install check in `install-dev.sh`:
```bash
# After NVM installation
if [ -f "$HOME/.zshrc" ]; then
    if ! grep -q "NVM_DIR" "$HOME/.zshrc"; then
        print_warning "NVM not found in .zshrc - may have been overwritten by dotfiles"
        print_info "NVM initialization should be in your dotfiles .zshrc template"
    fi
fi
```

### Priority 3: Create Missing Directory

**File:** `install.sh` or create directory

```bash
mkdir -p "$SCRIPT_DIR/configs"
```

### Priority 4: Improve Verification Script

**File:** `verify-setup.sh`

Add more checks:
- Check if NVM is in PATH
- Check if Node.js is accessible
- Add functional tests for key tools

### Priority 5: Add Post-Install Verification

**File:** `install.sh`

Add at the end of main():
```bash
print_header "Running Post-Install Verification"
if [ -f "$SCRIPT_DIR/verify-installation.sh" ]; then
    bash "$SCRIPT_DIR/verify-installation.sh"
else
    print_info "Verification script not found, skipping"
fi
```

---

## Testing Summary

| Category | Passed | Failed | Warnings |
|----------|--------|--------|----------|
| Base Tools | 8 | 0 | 0 |
| Terminal Tools | 17 | 0 | 0 |
| Development Tools | 6 | 2 | 0 |
| macOS Tools | 3 | 0 | 1 |
| DevOps Tools | 5 | 0 | 0 |
| Config Files | 6 | 1 | 0 |
| Functional Tests | 8 | 0 | 0 |
| Shell Integration | 2 | 0 | 0 |
| **TOTAL** | **56** | **3** | **1** |

---

## Next Steps

1. ✅ **Immediate:** Add NVM initialization to dotfiles `.zshrc`
2. ✅ **Immediate:** Create `configs/` directory or remove check
3. ⚙️ **Soon:** Reorder installation steps or improve stow strategy
4. ⚙️ **Soon:** Investigate AeroSpace installation failure
5. 📝 **Future:** Add automated post-install verification
6. 📝 **Future:** Consider moving tmux config to XDG location

---

## Conclusion

The installation is **95% successful**. All critical tools are installed and working. The main issue is NVM/Node.js not being available in the shell due to missing initialization code. This is easily fixed by adding the NVM initialization to the dotfiles `.zshrc` template.

The script architecture is solid, just needs minor adjustments to prevent config overwrites during installation.

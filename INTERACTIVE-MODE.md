# Interactive Installation Mode

## Overview

The dotfiles installer now includes an **interactive mode** that provides a user-friendly menu to select exactly what you want to install. No more remembering command-line flags!

## Features

### 1. Visual Category Selection
- Browse all installation categories with descriptions
- Multi-select using TAB key
- See what each category includes before selecting

### 2. Individual Package Selection (Coming Soon)
- Drill down into categories
- Select/deselect individual packages
- Full control over what gets installed

### 3. Save & Reuse Configurations
- Save your selections to `~/.dotfiles-install-config`
- Reuse saved configurations for multiple machines
- Share configurations with your team

### 4. Review Before Install
- See a summary of selections before proceeding
- Confirm before installation begins
- No surprises!

## How to Use

### Basic Interactive Mode

```bash
cd ~/Node-1/git-repos-reference/dotfiles
./install.sh --interactive
```

Or use the short flag:
```bash
./install.sh -i
```

### Interactive Flow

1. **Category Selection Screen**
   ```
   Select installation categories (use TAB to select, ENTER to confirm):

   ▶ base     | Essential tools (Homebrew, Git, Stow)
     terminal | Modern CLI tools (bat, eza, fzf, ripgrep, etc.)
     devops   | DevOps tools (Docker, Terraform, Kubernetes, etc.)
     dev      | Development tools (Neovim, Node.js, Python)
     dotfiles | Configuration files (symlink configs to home)
     macos    | macOS-specific (window manager, fonts, settings)
   ```

2. **Review Summary**
   ```
   Installation Summary
   ═══════════════════════════════════════════════

     ✓ base: Essential tools (Homebrew, Git, Stow)
     ✓ dev: Development tools (Neovim, Node.js, Python)
     ✓ dotfiles: Configuration files

   Proceed with this installation? (y/N):
   ```

3. **Save Configuration** (Optional)
   ```
   Save this configuration for future use? (y/N): y
   Configuration saved to ~/.dotfiles-install-config
   ```

4. **Installation Proceeds**
   The installer runs with your selections

## Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `↑/↓` | Navigate items |
| `TAB` | Select/deselect item |
| `CTRL-A` | Select all (in package mode) |
| `ENTER` | Confirm selection |
| `ESC` | Cancel |

## Using Saved Configurations

### Save a Configuration

During interactive mode, answer "yes" when asked to save:
```
Save this configuration for future use? (y/N): y
```

### Load a Saved Configuration

```bash
source ~/.dotfiles-install-config
./install.sh
```

### Share Configuration

Copy your config file to another machine:
```bash
scp ~/.dotfiles-install-config user@other-machine:~/
```

Then on the other machine:
```bash
source ~/.dotfiles-install-config
cd ~/dotfiles
./install.sh
```

### Edit Configuration Manually

The config file is just environment variables:
```bash
# Edit with your favorite editor
nvim ~/.dotfiles-install-config
```

Example config file:
```bash
# Dotfiles installation configuration
# Generated on Mon Nov 11 11:30:00 PST 2025

SKIP_BASE=false
SKIP_TERMINAL=false
SKIP_DEVOPS=true
SKIP_DEV=false
SKIP_DOTFILES=false
SKIP_MACOS=false
```

## Use Cases

### 1. First-Time Installation
**Best for:** New users who want to see what's available
```bash
./install.sh --interactive
```
Browse categories, select what you need, and proceed.

### 2. Minimal Installation
**Best for:** Installing on a server or minimal environment
```bash
./install.sh --interactive
# Select only: base, dotfiles
```

### 3. Development Machine
**Best for:** Full-featured development setup
```bash
./install.sh --interactive
# Select: base, terminal, dev, dotfiles, macos
```

### 4. DevOps Workstation
**Best for:** DevOps/infrastructure engineers
```bash
./install.sh --interactive
# Select: base, terminal, devops, dev, dotfiles
```

### 5. Multiple Machines with Same Config
**Best for:** Consistency across machines
```bash
# On first machine
./install.sh --interactive
# Save configuration

# On other machines
scp first-machine:~/.dotfiles-install-config ~/
source ~/.dotfiles-install-config
./install.sh
```

## Comparison: Interactive vs Flags

### Interactive Mode
✅ User-friendly visual interface
✅ See all options with descriptions
✅ Save and reuse configurations
✅ No need to remember flags
❌ Requires fzf (already installed)

### Command-Line Flags
✅ Fast for automation
✅ Works in scripts/CI-CD
✅ No interaction needed
❌ Need to remember flag names
❌ Less discoverable

## Advanced Features (Coming Soon)

### Individual Package Selection
```
Select packages from 'terminal' category:

  ✓ bat          - Better cat
  ✓ eza          - Better ls
  ✓ fzf          - Fuzzy finder
    ripgrep      - Better grep
  ✓ fd           - Better find
    zoxide       - Smart cd
  ...
```

### Custom Package Lists
Edit package lists interactively and save custom sets.

### Installation Profiles
Pre-defined profiles for common setups:
- Minimal
- Developer
- DevOps Engineer
- Full Featured

## Troubleshooting

### "fzf is required for interactive mode"
Install fzf first:
```bash
brew install fzf
```

### Interactive mode doesn't start
Make sure the script is executable:
```bash
chmod +x scripts/interactive-select.sh
```

### Selections not taking effect
The interactive mode exports environment variables. Make sure you're running from the same shell session.

## Examples

### Example 1: Developer Workstation
```bash
$ ./install.sh -i

Select categories (TAB=select, ENTER=confirm):
✓ base
✓ terminal
✗ devops
✓ dev
✓ dotfiles
✓ macos

Installation Summary:
  ✓ base: Essential tools
  ✓ terminal: Modern CLI tools
  ✓ dev: Development tools
  ✓ dotfiles: Configuration files
  ✓ macos: macOS-specific tools

Proceed? (y/N): y
Save configuration? (y/N): y

Configuration saved to ~/.dotfiles-install-config
Proceeding to installation...
```

### Example 2: Minimal Server Setup
```bash
$ ./install.sh -i

Select categories:
✓ base
✓ dotfiles
✗ terminal
✗ devops
✗ dev
✗ macos

Installation Summary:
  ✓ base: Essential tools
  ✓ dotfiles: Configuration files

Proceed? (y/N): y
```

## Integration with Existing Workflows

The interactive mode is fully compatible with existing installation methods:

### Still works with flags
```bash
./install.sh --skip-devops --skip-macos
```

### Still works with environment variables
```bash
SKIP_DEVOPS=true ./install.sh
```

### Can combine interactive with flags
```bash
./install.sh -i --skip-devops
# Interactive mode, but DevOps is pre-excluded
```

## Feedback & Improvements

This is a new feature! Suggestions for improvements:
- Additional keyboard shortcuts
- More detailed package information
- Search/filter functionality
- Installation time estimates
- Dependency visualization

## Summary

Interactive mode makes the dotfiles installer:
- **More discoverable** - See what's available
- **More flexible** - Choose exactly what you want
- **More reusable** - Save and share configurations
- **More user-friendly** - No flag memorization needed

**Try it now:**
```bash
./install.sh --interactive
```

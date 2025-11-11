#!/usr/bin/env bash

###############################################################################
# Demo: Interactive Mode
# Shows how the interactive installation selector works
###############################################################################

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║         Interactive Installation Mode Demo                   ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "This is a demonstration of the new interactive mode!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

cat << 'DEMO'
When you run: ./install.sh --interactive

You'll see a menu like this:

┌─────────────────────────────────────────────────────────────┐
│ Select installation categories (TAB to select/deselect)    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ▶ base     │ Essential tools (Homebrew, Git, Stow)        │
│    terminal │ Modern CLI tools (bat, eza, fzf, etc.)       │
│    devops   │ DevOps tools (Docker, Terraform, K8s)        │
│    dev      │ Development tools (Neovim, Node.js, Python)  │
│    dotfiles │ Configuration files (symlink configs)        │
│    macos    │ macOS-specific (fonts, window manager)       │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│ TAB=select  ENTER=confirm  ESC=cancel                      │
└─────────────────────────────────────────────────────────────┘

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

After selecting (let's say you chose: base, dev, dotfiles):

┌─────────────────────────────────────────────────────────────┐
│ Installation Summary                                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ✓ base: Essential tools (Homebrew, Git, Stow)             │
│  ✓ dev: Development tools (Neovim, Node.js, Python)        │
│  ✓ dotfiles: Configuration files                           │
│                                                             │
│ Proceed with this installation? (y/N):                     │
│                                                             │
│ Save this configuration for future use? (y/N):             │
│                                                             │
└─────────────────────────────────────────────────────────────┘

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

If you save the configuration, it's stored in:
  ~/.dotfiles-install-config

You can reuse it on another machine:
  source ~/.dotfiles-install-config && ./install.sh

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DEMO

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Features:"
echo "  ✓ Visual category selection with descriptions"
echo "  ✓ Multi-select using TAB key"
echo "  ✓ Save configurations for reuse"
echo "  ✓ Review before installation"
echo "  ✓ No need to remember command-line flags"
echo ""
echo "Try it now:"
echo "  ./install.sh --interactive"
echo "  ./install.sh -i            (short form)"
echo ""
echo "Or continue using flags:"
echo "  ./install.sh --skip-devops"
echo ""
echo "Both methods work - use whichever you prefer!"
echo ""

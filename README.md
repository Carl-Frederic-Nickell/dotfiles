# 🚀 Cross-Platform Dotfiles - DevOps Environment Automation

> **Automated development environment setup for macOS, Linux, and Windows**  
> *One command to rule them all* - Professional dotfiles management with modern tooling

[![Platform Support](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux%20%7C%20Windows-brightgreen)](https://github.com/Carl-Frederic-Nickell/dotfiles)
[![Shell](https://img.shields.io/badge/Shell-Zsh-blue)](https://www.zsh.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

☕ **Enjoying this project?** [Buy me a coffee](https://www.paypal.com/paypalme/cfn89) to support further development!

---

## 📋 Overview

This dotfiles repository automates the setup of a professional development environment across multiple platforms. Built with DevOps principles in mind, it demonstrates infrastructure automation, configuration management, and cross-platform compatibility.

**Key Features:**
- 🔄 **One-command installation** across macOS, Linux, and Windows
- 🛠️ **Modern CLI tools** with consistent configurations
- 🔧 **Automatic plugin management** for editors and terminals
- 💾 **Safe backup system** before any changes
- 🎨 **Customizable configurations** for different environments

## 🎯 Target Audience

Perfect for:
- DevOps Engineers setting up new environments
- Developers switching between different systems
- System administrators managing multiple machines
- Anyone wanting a consistent, professional CLI experience

## ⚡ Quick Start

### One-Line Installation

```bash
curl -fsSL https://raw.githubusercontent.com/Carl-Frederic-Nickell/dotfiles/main/install.sh | bash
```

### Manual Installation

```bash
git clone https://github.com/Carl-Frederic-Nickell/dotfiles.git
cd dotfiles
./install.sh
```

## 🛠️ Included Tools

### Core Development Tools
- **[Neovim](https://neovim.io/)** - Modern Vim-based editor with LSP support
- **[Tmux](https://github.com/tmux/tmux)** - Terminal multiplexer for session management
- **[Zsh](https://www.zsh.org/)** - Advanced shell with autocompletion and plugins

### Modern CLI Replacements
- **[eza](https://github.com/eza-community/eza)** - Modern `ls` replacement with icons and git integration
- **[bat](https://github.com/sharkdp/bat)** - Modern `cat` with syntax highlighting
- **[fzf](https://github.com/junegunn/fzf)** - Fuzzy finder for files and commands
- **[zoxide](https://github.com/ajeetdsouza/zoxide)** - Smart `cd` command that learns your habits
- **[starship](https://starship.rs/)** - Cross-shell prompt with git integration

### DevOps & System Tools
- **[lazygit](https://github.com/jesseduffield/lazygit)** - Terminal UI for git commands
- **[jq](https://stedolan.github.io/jq/)** - JSON processor for API responses
- **[nmap](https://nmap.org/)** - Network discovery and security auditing
- **[iperf3](https://iperf.fr/)** - Network performance measurement
- **[tcpdump](https://www.tcpdump.org/)** - Network traffic analyzer

## 🎨 Customization Features

### Shell Enhancements
- **Smart autocompletion** with case-insensitive matching
- **Git integration** in prompt and file listings
- **History management** with deduplication and sharing
- **Aliases and functions** for common DevOps tasks

### Visual Improvements
- **Nerd Font icons** in file listings and terminal
- **Color-coded output** for better readability
- **Git status indicators** in directory listings
- **Customizable prompt** with system information

## 🔧 Configuration Structure

```
dotfiles/
├── install.sh              # Main installation script
├── packages/               # Package lists per platform
│   ├── macos.txt           # Homebrew packages
│   ├── ubuntu.txt          # APT packages
│   └── windows.txt         # Winget/Chocolatey packages
├── config/                 # Configuration files
│   ├── nvim/               # Neovim configuration
│   ├── tmux/               # Tmux configuration
│   ├── zshrc               # Zsh configuration
│   └── ...
└── scripts/                # Platform-specific installers
    ├── install_macos.sh    # macOS installation logic
    ├── install_ubuntu.sh   # Ubuntu/Linux installation logic
    └── install_windows.sh  # Windows installation logic
```

## 🚀 Platform-Specific Features

### macOS
- **Homebrew** package management
- **macOS-specific** aliases and functions
- **Optimized** for Apple Silicon and Intel Macs

### Linux (Ubuntu/Debian)
- **APT** package management with PPAs
- **Manual installation** of modern tools not in repos
- **Shell switching** to zsh automatically

### Windows
- **Winget** and **Chocolatey** package management
- **WSL compatibility** for Linux-like experience
- **PowerShell** integration alongside zsh

## 🔒 Safety Features

### Backup System
- **Automatic backups** before any configuration changes
- **Timestamped backup directories** for easy recovery
- **Safe symbolic linking** with conflict detection

### Error Handling
- **Graceful degradation** when tools aren't available
- **Detailed logging** for troubleshooting
- **Platform detection** with manual override options

## 💡 DevOps Principles Demonstrated

### Infrastructure as Code
- **Declarative configuration** through package lists
- **Version controlled** environment setup
- **Reproducible builds** across environments

### Automation
- **One-command deployment** for entire environment
- **Automated plugin management** and updates
- **Cross-platform compatibility** without manual intervention

### Monitoring & Maintenance
- **Health checks** for installed tools
- **Backup strategies** for configuration safety
- **Documentation** for troubleshooting and extension

## 📊 Command Examples

### Enhanced File Operations
```bash
# Modern ls with icons and git status
ll                          # Detailed listing with icons
lg                          # List with git status
ltree                       # Tree view with custom depth
lsize                       # Sort by file size
```

### Smart Navigation
```bash
# Zoxide smart cd
z projects                  # Jump to projects directory
zi                          # Interactive directory selection
```

### Fuzzy Finding
```bash
# FZF integrations
fzf                         # Fuzzy find files
fzd                         # Fuzzy find directories
fzz                         # Fuzzy find recent directories
```

### Git Workflow
```bash
# Git aliases and functions
gst                         # Git status
glog                        # Pretty git log
lazygit                     # Terminal UI for git
```

## 🔄 Maintenance

### Updating Tools
```bash
# Update package managers
brew update && brew upgrade              # macOS
sudo apt update && sudo apt upgrade     # Ubuntu
winget upgrade --all                    # Windows
```

### Syncing Configurations
```bash
# Pull latest configurations
cd ~/dotfiles
git pull origin main
./install.sh
```

## 🤝 Contributing

This repository serves as a personal development environment setup, but contributions and suggestions are welcome:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📝 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙋‍♂️ About the Author

**Carl-Frederic Nickell**  
*DevOps Engineer & Cybersecurity Enthusiast*

- 🌐 Portfolio: [carl-cyber.tech](https://carl-cyber.tech)
- 💼 LinkedIn: [Carl-Frederic Nickell](https://linkedin.com/in/carl-frederic-nickell)
- 📧 Email: contact@carl-cyber.tech

---

*This dotfiles repository demonstrates practical DevOps skills including automation, configuration management, cross-platform compatibility, and infrastructure as code principles.*

## 💖 Support

If this project helped you set up your development environment, consider supporting further development:

☕ **[Buy me a coffee](https://www.paypal.com/paypalme/cfn89)** - Every contribution helps maintain and improve this project!

Your support enables:
- 🔧 New tool integrations
- 🐛 Bug fixes and improvements  
- 📚 Enhanced documentation
- 🚀 Additional platform support

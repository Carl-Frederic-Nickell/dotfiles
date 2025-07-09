#!/bin/bash

# Ubuntu/Linux Dotfiles Installation Script
# Installiert apt-Pakete, Zusatztools und verlinkt Konfigurationsdateien

set -e

# Farben für Output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging Funktionen
log_info() {
    echo -e "${BLUE}[Ubuntu]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[Ubuntu]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[Ubuntu]${NC} $1"
}

log_error() {
    echo -e "${RED}[Ubuntu]${NC} $1"
}

# System Update
update_system() {
    log_info "Aktualisiere System..."
    sudo apt update && sudo apt upgrade -y
    log_success "System aktualisiert"
}

# Basis-Pakete installieren
install_base_packages() {
    log_info "Installiere Basis-Pakete..."
    sudo apt install -y curl wget git build-essential software-properties-common
    log_success "Basis-Pakete installiert"
}

# Zusätzliche Repositories hinzufügen
add_repositories() {
    log_info "Füge zusätzliche Repositories hinzu..."
    
    # Neovim stable PPA
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    
    # System update nach neuen Repos
    sudo apt update
    
    log_success "Repositories hinzugefügt"
}

# Moderne Tools installieren die nicht in Standard-Repos sind
install_modern_tools() {
    log_info "Installiere moderne Tools..."
    
    # Starship prompt
    if ! command -v starship &> /dev/null; then
        log_info "Installiere Starship..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y
        log_success "Starship installiert"
    fi
    
    # Eza (modernes ls)
    if ! command -v eza &> /dev/null; then
        log_info "Installiere eza..."
        wget -c https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz -O - | tar xz
        sudo mv eza /usr/local/bin/
        log_success "eza installiert"
    fi
    
    # Zoxide (smart cd)
    if ! command -v zoxide &> /dev/null; then
        log_info "Installiere zoxide..."
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
        log_success "zoxide installiert"
    fi
    
    # Lazygit
    if ! command -v lazygit &> /dev/null; then
        log_info "Installiere lazygit..."
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/local/bin
        rm lazygit.tar.gz lazygit
        log_success "lazygit installiert"
    fi
    
    log_success "Moderne Tools installiert"
}

# Pakete aus packages/ubuntu.txt installieren
install_packages() {
    if [[ -f "packages/ubuntu.txt" ]]; then
        log_info "Installiere Pakete aus packages/ubuntu.txt..."
        
        # Pakete in einem Aufruf installieren
        packages=()
        while IFS= read -r package; do
            # Leere Zeilen und Kommentare überspringen
            [[ -z "$package" || "$package" =~ ^#.* ]] && continue
            packages+=("$package")
        done < packages/ubuntu.txt
        
        if [ ${#packages[@]} -gt 0 ]; then
            log_info "Installiere: ${packages[*]}"
            sudo apt install -y "${packages[@]}" || log_warning "Einige Pakete konnten nicht installiert werden"
        fi
        
        log_success "Paketinstallation abgeschlossen"
    else
        log_warning "packages/ubuntu.txt nicht gefunden"
    fi
}

# Plugin-Manager installieren
install_plugin_managers() {
    log_info "Installiere Plugin-Manager..."
    
    # Tmux Plugin Manager (TPM)
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        log_info "Installiere Tmux Plugin Manager..."
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        log_success "TPM installiert"
    else
        log_info "TPM bereits installiert"
    fi
    
    # Lazy.nvim wird automatisch von der nvim config installiert
    log_info "Lazy.nvim wird beim ersten nvim-Start automatisch installiert"
    
    # Oh-My-Zsh (falls in der .zshrc verwendet)
    if [[ ! -d "$HOME/.oh-my-zsh" ]] && grep -q "oh-my-zsh" config/zshrc 2>/dev/null; then
        log_info "Installiere Oh-My-Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        log_success "Oh-My-Zsh installiert"
    fi
    
    log_success "Plugin-Manager Installation abgeschlossen"
}

# Konfigurationsdateien verlinken (gleiche Funktion wie macOS)
link_configs() {
    log_info "Verlinke Konfigurationsdateien..."
    
    # Backup-Verzeichnis erstellen
    backup_dir="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    if [[ -d "config" ]]; then
        # Einzelne Dateien verlinken (direkt im config/ Verzeichnis)
        for config_file in config/*; do
            [[ -f "$config_file" ]] || continue
            
            filename=$(basename "$config_file")
            target_path="$HOME/.$filename"
            
            # Backup erstellen wenn Datei existiert
            if [[ -f "$target_path" || -L "$target_path" ]]; then
                log_info "Erstelle Backup von $filename"
                cp "$target_path" "$backup_dir/" 2>/dev/null || true
            fi
            
            # Symbolischen Link erstellen
            ln -sf "$(pwd)/$config_file" "$target_path"
            log_info "Verlinkt: ~/.$filename"
        done
        
        # Verzeichnisse verlinken (für ~/.config/)
        for config_dir in config/*/; do
            [[ -d "$config_dir" ]] || continue
            
            dirname=$(basename "$config_dir")
            target_path="$HOME/.config/$dirname"
            
            # .config Verzeichnis erstellen falls nicht vorhanden
            mkdir -p "$HOME/.config"
            
            # Backup erstellen wenn Verzeichnis existiert
            if [[ -d "$target_path" || -L "$target_path" ]]; then
                log_info "Erstelle Backup von .config/$dirname"
                cp -r "$target_path" "$backup_dir/" 2>/dev/null || true
                rm -rf "$target_path"
            fi
            
            # Symbolischen Link erstellen
            ln -sf "$(pwd)/$config_dir" "$target_path"
            log_info "Verlinkt: ~/.config/$dirname"
        done
        
        log_success "Konfigurationsdateien verlinkt"
        log_info "Backup erstellt in: $backup_dir"
    else
        log_warning "config/ Verzeichnis nicht gefunden"
    fi
}

# Shell zu zsh ändern
change_shell() {
    if [[ "$SHELL" != */zsh ]]; then
        log_info "Ändere Standard-Shell zu zsh..."
        chsh -s $(which zsh)
        log_success "Shell zu zsh geändert (Neustart erforderlich)"
    else
        log_info "zsh ist bereits die Standard-Shell"
    fi
}

# Hauptfunktion
main() {
    log_info "Starte Ubuntu Installation..."
    
    # System aktualisieren
    update_system
    
    # Basis-Pakete installieren
    install_base_packages
    
    # Repositories hinzufügen
    add_repositories
    
    # Standard-Pakete installieren
    install_packages
    
    # Moderne Tools installieren
    install_modern_tools
    
    # Plugin-Manager installieren
    install_plugin_managers
    
    # Konfigurationsdateien verlinken
    link_configs
    
    # Shell ändern
    change_shell
    
    log_success "Ubuntu Installation abgeschlossen!"
    log_info "Führe 'exec zsh' aus oder starte ein neues Terminal"
    log_info "Starte nvim und tmux zum ersten Mal, um Plugins zu installieren"
}

# Script ausführen
main "$@"

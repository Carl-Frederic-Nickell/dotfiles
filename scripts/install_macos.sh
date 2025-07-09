#!/bin/bash

# macOS Dotfiles Installation Script
# Installiert Homebrew, Pakete und verlinkt Konfigurationsdateien

set -e

# Farben für Output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging Funktionen
log_info() {
    echo -e "${BLUE}[macOS]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[macOS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[macOS]${NC} $1"
}

log_error() {
    echo -e "${RED}[macOS]${NC} $1"
}

# Homebrew Installation
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        log_info "Installiere Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Homebrew zum PATH hinzufügen
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
        
        log_success "Homebrew installiert"
    else
        log_info "Homebrew bereits installiert"
        brew update
    fi
}

# Pakete aus packages/macos.txt installieren
install_packages() {
    if [[ -f "packages/macos.txt" ]]; then
        log_info "Installiere Pakete aus packages/macos.txt..."
        
        while IFS= read -r package; do
            # Leere Zeilen und Kommentare überspringen
            [[ -z "$package" || "$package" =~ ^#.* ]] && continue
            
            log_info "Installiere: $package"
            brew install "$package" || log_warning "Fehler bei Installation von $package"
        done < packages/macos.txt
        
        log_success "Paketinstallation abgeschlossen"
    else
        log_warning "packages/macos.txt nicht gefunden"
    fi
}

# Konfigurationsdateien verlinken
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
    
    # Oh-My-Zsh (falls in deiner .zshrc verwendet)
    if [[ ! -d "$HOME/.oh-my-zsh" ]] && grep -q "oh-my-zsh" config/zshrc 2>/dev/null; then
        log_info "Installiere Oh-My-Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        log_success "Oh-My-Zsh installiert"
    fi
    
    log_success "Plugin-Manager Installation abgeschlossen"
}

# Hauptfunktion
main() {
    log_info "Starte macOS Installation..."
    
    # Homebrew installieren
    install_homebrew
    
    # Pakete installieren
    install_packages
    
    # Plugin-Manager installieren
    install_plugin_managers
    
    # Konfigurationsdateien verlinken
    link_configs
    
    log_success "macOS Installation abgeschlossen!"
    log_info "Starte nvim und tmux zum ersten Mal, um Plugins zu installieren"
}

# Script ausführen
main "$@"

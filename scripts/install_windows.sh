#!/bin/bash

# Windows Dotfiles Installation Script
# Installiert Tools über winget/chocolatey und verlinkt Konfigurationsdateien

set -e

# Farben für Output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging Funktionen
log_info() {
    echo -e "${BLUE}[Windows]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[Windows]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[Windows]${NC} $1"
}

log_error() {
    echo -e "${RED}[Windows]${NC} $1"
}

# Überprüfe ob winget verfügbar ist
check_winget() {
    if ! command -v winget &> /dev/null; then
        log_error "winget ist nicht verfügbar. Bitte installiere Windows Package Manager."
        log_info "Download: https://github.com/microsoft/winget-cli/releases"
        exit 1
    fi
    log_info "winget gefunden"
}

# Chocolatey installieren (Fallback Package Manager)
install_chocolatey() {
    if ! command -v choco &> /dev/null; then
        log_info "Installiere Chocolatey..."
        powershell.exe -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
        log_success "Chocolatey installiert"
    else
        log_info "Chocolatey bereits installiert"
    fi
}

# Pakete aus packages/windows.txt installieren
install_packages() {
    if [[ -f "packages/windows.txt" ]]; then
        log_info "Installiere Pakete aus packages/windows.txt..."
        
        while IFS= read -r package; do
            # Leere Zeilen und Kommentare überspringen
            [[ -z "$package" || "$package" =~ ^#.* ]] && continue
            
            # Unterscheide zwischen winget und choco Paketen
            if [[ "$package" == winget:* ]]; then
                package_name="${package#winget:}"
                log_info "Installiere via winget: $package_name"
                winget install --id "$package_name" --silent --accept-package-agreements --accept-source-agreements || log_warning "Fehler bei winget Installation von $package_name"
            elif [[ "$package" == choco:* ]]; then
                package_name="${package#choco:}"
                log_info "Installiere via chocolatey: $package_name"
                choco install "$package_name" -y || log_warning "Fehler bei choco Installation von $package_name"
            else
                # Standard: Versuche zuerst winget, dann choco
                log_info "Installiere: $package"
                winget install --id "$package" --silent --accept-package-agreements --accept-source-agreements || \
                choco install "$package" -y || log_warning "Fehler bei Installation von $package"
            fi
        done < packages/windows.txt
        
        log_success "Paketinstallation abgeschlossen"
    else
        log_warning "packages/windows.txt nicht gefunden"
    fi
}

# Plugin-Manager installieren
install_plugin_managers() {
    log_info "Installiere Plugin-Manager..."
    
    # Tmux Plugin Manager (TPM) - falls tmux verwendet wird
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        log_info "Installiere Tmux Plugin Manager..."
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        log_success "TPM installiert"
    else
        log_info "TPM bereits installiert"
    fi
    
    # Oh-My-Zsh für WSL
    if [[ ! -d "$HOME/.oh-my-zsh" ]] && grep -q "oh-my-zsh" config/zshrc 2>/dev/null; then
        log_info "Installiere Oh-My-Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        log_success "Oh-My-Zsh installiert"
    fi
    
    log_success "Plugin-Manager Installation abgeschlossen"
}

# Konfigurationsdateien verlinken (Windows-kompatibel)
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
            
            # Symbolischen Link erstellen (Windows 10+ mit Developer Mode)
            if ln -sf "$(pwd)/$config_file" "$target_path" 2>/dev/null; then
                log_info "Verlinkt: ~/.$filename"
            else
                # Fallback: Kopiere Datei wenn Symlinks nicht funktionieren
                log_warning "Symlink fehlgeschlagen, kopiere Datei: $filename"
                cp "$config_file" "$target_path"
            fi
        done
        
        # Verzeichnisse verlinken (für ~/.config/ oder AppData)
        for config_dir in config/*/; do
            [[ -d "$config_dir" ]] || continue
            
            dirname=$(basename "$config_dir")
            
            # Windows-spezifische Pfade
            if [[ "$dirname" == "nvim" ]]; then
                target_path="$HOME/AppData/Local/nvim"
            else
                target_path="$HOME/.config/$dirname"
            fi
            
            # .config Verzeichnis erstellen falls nicht vorhanden
            mkdir -p "$(dirname "$target_path")"
            
            # Backup erstellen wenn Verzeichnis existiert
            if [[ -d "$target_path" || -L "$target_path" ]]; then
                log_info "Erstelle Backup von $dirname"
                cp -r "$target_path" "$backup_dir/" 2>/dev/null || true
                rm -rf "$target_path"
            fi
            
            # Symbolischen Link erstellen
            if ln -sf "$(pwd)/$config_dir" "$target_path" 2>/dev/null; then
                log_info "Verlinkt: $target_path"
            else
                # Fallback: Kopiere Verzeichnis
                log_warning "Symlink fehlgeschlagen, kopiere Verzeichnis: $dirname"
                cp -r "$config_dir" "$target_path"
            fi
        done
        
        log_success "Konfigurationsdateien verlinkt"
        log_info "Backup erstellt in: $backup_dir"
    else
        log_warning "config/ Verzeichnis nicht gefunden"
    fi
}

# Hauptfunktion
main() {
    log_info "Starte Windows Installation..."
    
    # Package Manager überprüfen
    check_winget
    install_chocolatey
    
    # Pakete installieren
    install_packages
    
    # Plugin-Manager installieren
    install_plugin_managers
    
    # Konfigurationsdateien verlinken
    link_configs
    
    log_success "Windows Installation abgeschlossen!"
    log_info "Starte PowerShell/WSL neu für beste Erfahrung"
    log_info "Starte nvim zum ersten Mal, um Plugins zu installieren"
}

# Script ausführen
main "$@"

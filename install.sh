#!/bin/bash

# Dotfiles Installation Script
# Automatische Entwicklungsumgebung für macOS, Linux und Windows

set -e  # Script beenden bei Fehlern

# Farben für Output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging Funktionen
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Plattform automatisch erkennen
detect_platform() {
    case "$(uname -s)" in
        Darwin)
            PLATFORM="macos"
            log_info "macOS erkannt"
            ;;
        Linux)
            if [[ -f /etc/debian_version ]]; then
                PLATFORM="ubuntu"
                log_info "Ubuntu/Debian erkannt"
            elif [[ -f /etc/redhat-release ]]; then
                PLATFORM="rhel"
                log_info "RHEL/CentOS/Fedora erkannt"
            else
                PLATFORM="unknown"
                log_warning "Linux-Distribution nicht erkannt"
            fi
            ;;
        CYGWIN*|MINGW*)
            PLATFORM="windows"
            log_info "Windows erkannt"
            ;;
        *)
            PLATFORM="unknown"
            log_warning "Plattform nicht erkannt"
            ;;
    esac
}

# Benutzerabfrage bei unbekannter Plattform
ask_platform() {
    if [[ "$PLATFORM" == "unknown" ]]; then
        log_warning "Plattform konnte nicht automatisch erkannt werden."
        echo "Bitte wähle deine Plattform:"
        echo "1) macOS"
        echo "2) Ubuntu/Debian"
        echo "3) RHEL/CentOS/Fedora"
        echo "4) Windows"
        echo "5) Abbrechen"
        
        read -p "Auswahl (1-5): " choice
        
        case $choice in
            1) PLATFORM="macos" ;;
            2) PLATFORM="ubuntu" ;;
            3) PLATFORM="rhel" ;;
            4) PLATFORM="windows" ;;
            5) log_error "Installation abgebrochen"; exit 1 ;;
            *) log_error "Ungültige Auswahl"; exit 1 ;;
        esac
    fi
}

# Überprüfung ob Plattform unterstützt wird
check_platform_support() {
    if [[ ! -f "scripts/install_${PLATFORM}.sh" ]]; then
        log_error "Plattform $PLATFORM wird noch nicht unterstützt"
        exit 1
    fi
}

# Hauptfunktion
main() {
    log_info "Starte Dotfiles Installation..."
    log_info "==============================="
    
    # Plattform erkennen
    detect_platform
    ask_platform
    check_platform_support
    
    log_success "Plattform: $PLATFORM"
    
    # Plattformspezifische Installation starten
    log_info "Starte plattformspezifische Installation..."
    bash "scripts/install_${PLATFORM}.sh"
    
    log_success "Installation abgeschlossen!"
    log_info "Starte eine neue Shell-Session oder führe 'source ~/.zshrc' aus"
}

# Script ausführen
main "$@"

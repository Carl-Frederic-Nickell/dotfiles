if status is-interactive
    # Commands to run in interactive sessions can go here
    eval "$(/opt/homebrew/bin/brew shellenv)"
end

# Existing configurations
set -x OLLAMA_MODELS "/Volumes/WD 2TB/OllamaModels"
zoxide init fish | source

# Eza environment variables
set -x EZA_ICONS_AUTO 1                      # Auto-enable icons
set -x EZA_GRID_ROWS 20                      # Grid layout rows
set -x EZA_COLORS "di=34:ln=35:so=32:pi=33"  # Custom colors
set -x EZA_CONFIG_DIR ~/.config/eza          # Config directory for theme.yml

# Basic eza abbreviations
abbr -a ls eza
abbr -a ll 'eza -la'
abbr -a la 'eza -la'
abbr -a tree 'eza -T'
abbr -a lg 'eza -la --git'

# Extended eza abbreviations
abbr -a li 'eza --icons'
abbr -a lt 'eza -T --level=2'
abbr -a lsize 'eza -la -s size --reverse'
abbr -a ltime 'eza -la -s modified --reverse'
abbr -a lconfig 'eza -la ~/.config/ --tree --level=2'
abbr -a lproj 'eza -T --level=2 --ignore-glob=node_modules'
abbr -a lgit 'eza -la --git --group-directories-first'

# DevOps specific abbreviations  
abbr -a lservices 'eza -la /etc/systemd/system/'
abbr -a llogs 'eza -la -s modified --reverse /var/log/'
abbr -a lnginx 'eza -la /etc/nginx/'

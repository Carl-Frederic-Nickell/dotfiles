# =============================================================================
# ZSH CONFIGURATION FOR DEVOPS
# =============================================================================

# Basic PATH configuration
# Detect Homebrew location (works on Apple Silicon, Intel Mac, and Linux)
if [ -d "/opt/homebrew/bin" ]; then
    export PATH="/opt/homebrew/bin:$PATH"
elif [ -d "/usr/local/bin" ]; then
    export PATH="/usr/local/bin:$PATH"
elif [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
fi

# Ollama models path (machine-specific, can be overridden in ~/.zshrc.local)
if [ -d "/Volumes/WD 2TB/OllamaModels" ]; then
    export OLLAMA_MODELS="/Volumes/WD 2TB/OllamaModels"
elif [ -d "$HOME/.ollama/models" ]; then
    export OLLAMA_MODELS="$HOME/.ollama/models"
fi

# =============================================================================
# ZSH AUTOCOMPLETION & FEATURES
# =============================================================================

# Enable autocompletion
autoload -U compinit
compinit

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Better completion menu
zstyle ':completion:*' menu select

# Completion for hidden files
setopt glob_dots

# SSH autocompletion from ~/.ssh/config
zstyle ':completion:*:ssh:*' hosts-ports-users $(awk '/^Host/ {print $2}' ~/.ssh/config | grep -v '*')

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt hist_ignore_space
setopt share_history

# =============================================================================
# TOOL INITIALIZATION
# =============================================================================

# Initialize zoxide for smart cd
eval "$(zoxide init zsh)"

# Initialize starship prompt
eval "$(starship init zsh)"

# Initialize Carapace completion
eval "$(carapace _carapace)"

# Load zsh-autosuggestions (integrates with atuin)
# Detect location across different platforms
if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f /home/linuxbrew/.linuxbrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /home/linuxbrew/.linuxbrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# =============================================================================
# NODE VERSION MANAGER (NVM)
# =============================================================================

# Initialize NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Auto-load .nvmrc when changing directories
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version 2>/dev/null)"
  local nvmrc_path="$(nvm_find_nvmrc 2>/dev/null)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default 2>/dev/null)" ]; then
    nvm use default 2>/dev/null
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc 2>/dev/null

# =============================================================================
# EZA CONFIGURATION
# =============================================================================

export EZA_ICONS_AUTO=1
export EZA_GRID_ROWS=20
export EZA_COLORS="di=34:ln=35:so=32:pi=33"
export EZA_CONFIG_DIR=~/.config/eza

# =============================================================================
# BASIC ALIASES
# =============================================================================

# Eza aliases (modern ls replacement)
alias ls='eza --icons --group-directories-first'
alias ll='eza --icons --group-directories-first -l'
alias la='eza -la'
alias tree='eza -T'
alias lg='eza -la --git'

# Extended eza aliases
alias li='eza --icons'
alias lt='eza -T --level=2'
alias lsize='eza -la -s size --reverse'
alias ltime='eza -la -s modified --reverse'
alias lconfig='eza -la ~/.config/ --tree --level=2'
alias lproj='eza -T --level=2 --ignore-glob=node_modules'
alias lgit='eza -la --git --group-directories-first'

# Modern tool replacements
alias cat='bat'
alias find='fd'
alias grep='rg'
alias top='htop'

# =============================================================================
# DEVOPS SPECIFIC ALIASES
# =============================================================================

# System monitoring
alias lservices='eza -la /etc/systemd/system/'
alias llogs='eza -la -s modified --reverse /var/log/'
alias lnginx='eza -la /etc/nginx/'
alias ports='lsof -i -P -n | grep LISTEN'
alias psg='ps aux | grep'

# Docker aliases
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dclean='docker system prune -af'

# Safe Docker cleanup functions (with confirmation)
drm() {
    local containers
    containers=$(docker ps -aq)
    if [ -n "$containers" ]; then
        echo "About to remove the following containers:"
        docker ps -a
        read -p "Continue? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            docker rm $containers
            echo "Containers removed successfully"
        else
            echo "Operation cancelled"
        fi
    else
        echo "No containers to remove"
    fi
}

drmi() {
    local images
    images=$(docker images -q)
    if [ -n "$images" ]; then
        echo "About to remove ALL Docker images:"
        docker images
        read -p "Continue? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            docker rmi $images
            echo "Images removed successfully"
        else
            echo "Operation cancelled"
        fi
    else
        echo "No images to remove"
    fi
}

# Kubernetes aliases
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kdp='kubectl describe pod'
alias kds='kubectl describe service'
alias kdd='kubectl describe deployment'

# =============================================================================
# GIT ALIASES
# =============================================================================

alias gst='git status'
alias gco='git checkout'
alias gp='git push'
alias gl='git pull'
alias ga='git add'
alias gc='git commit'
alias gb='git branch'
alias gm='git merge'
alias gd='git diff'
alias glog='git log --oneline --graph --decorate'

# =============================================================================
# NAVIGATION ALIASES
# =============================================================================

# Zoxide aliases
alias j='z'
alias ji='zi'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# =============================================================================
# SYSTEM ALIASES
# =============================================================================

alias reload='source ~/.zshrc'
alias zshrc='nvim ~/.zshrc'
alias sshconfig='nvim ~/.ssh/config'
alias hosts='sudo nvim /etc/hosts'

# Network utilities
alias myip='curl -s https://ipinfo.io/ip'
alias localip='ipconfig getifaddr en0'
alias ping='ping -c 5'

# =============================================================================
# DEVOPS FUNCTIONS
# =============================================================================

# Create and enter directory
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Quick server with Python
serve() {
    python3 -m http.server ${1:-8000}
}

# Git commit with message
gcom() {
    git add . && git commit -m "$1"
}

# Extract any archive
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# =============================================================================
# CUSTOM FUNCTIONS
# =============================================================================

# Load custom functions if they exist
if [ -f ~/.zsh_functions ]; then
    source ~/.zsh_functions
fi

# =============================================================================
# STARTUP
# =============================================================================

# Show system info on startup
neofetch
export PATH="$HOME/.local/bin:$PATH"

# Atuin installed via Homebrew, no need for manual env sourcing
eval "$(atuin init zsh)"
# shellcheck disable=SC2034,SC2153,SC2086,SC2155

# Above line is because shellcheck doesn't support zsh, per
# https://github.com/koalaman/shellcheck/wiki/SC1071, and the ignore: param in
# ludeeus/action-shellcheck only supports _directories_, not _files_. So
# instead, we manually add any error the shellcheck step finds in the file to
# the above line ...

# Source this in your ~/.zshrc
autoload -U add-zsh-hook

zmodload zsh/datetime 2>/dev/null

# If zsh-autosuggestions is installed, configure it to use Atuin's search. If
# you'd like to override this, then add your config after the $(atuin init zsh)
# in your .zshrc
_zsh_autosuggest_strategy_atuin() {
    # silence errors, since we don't want to spam the terminal prompt while typing.
    suggestion=$(ATUIN_QUERY="$1" atuin search --cmd-only --limit 1 --search-mode prefix 2>/dev/null)
}

if [ -n "${ZSH_AUTOSUGGEST_STRATEGY:-}" ]; then
    ZSH_AUTOSUGGEST_STRATEGY=("atuin" "${ZSH_AUTOSUGGEST_STRATEGY[@]}")
else
    ZSH_AUTOSUGGEST_STRATEGY=("atuin")
fi

export ATUIN_SESSION=$(atuin uuid)
ATUIN_HISTORY_ID=""

_atuin_preexec() {
    local id
    id=$(atuin history start -- "$1")
    export ATUIN_HISTORY_ID="$id"
    __atuin_preexec_time=${EPOCHREALTIME-}
}

_atuin_precmd() {
    local EXIT="$?" __atuin_precmd_time=${EPOCHREALTIME-}

    [[ -z "${ATUIN_HISTORY_ID:-}" ]] && return

    local duration=""
    if [[ -n $__atuin_preexec_time && -n $__atuin_precmd_time ]]; then
        printf -v duration %.0f $(((__atuin_precmd_time - __atuin_preexec_time) * 1000000000))
    fi

    (ATUIN_LOG=error atuin history end --exit $EXIT ${duration:+--duration=$duration} -- $ATUIN_HISTORY_ID &) >/dev/null 2>&1
    export ATUIN_HISTORY_ID=""
}

_atuin_search() {
    emulate -L zsh
    zle -I

    # swap stderr and stdout, so that the tui stuff works
    # TODO: not this
    local output
    # shellcheck disable=SC2048
    output=$(ATUIN_SHELL_ZSH=t ATUIN_LOG=error ATUIN_QUERY=$BUFFER atuin search $* -i 3>&1 1>&2 2>&3)

    zle reset-prompt
    # re-enable bracketed paste
    # shellcheck disable=SC2154
    echo -n ${zle_bracketed_paste[1]} >/dev/tty

    if [[ -n $output ]]; then
        local original_buffer=$BUFFER
        RBUFFER=""
        LBUFFER=$output

        if [[ $LBUFFER == __atuin_accept__:* ]]
        then
            LBUFFER=${LBUFFER#__atuin_accept__:}
            zle accept-line
        elif [[ $LBUFFER == __atuin_chain_command__:* ]]
        then
            local new_command=${LBUFFER#__atuin_chain_command__:}
            LBUFFER="$original_buffer $new_command"
        fi
    fi
}
_atuin_search_vicmd() {
    _atuin_search --keymap-mode=vim-normal
}
_atuin_search_viins() {
    _atuin_search --keymap-mode=vim-insert
}

_atuin_up_search() {
    # Only trigger if the buffer is a single line
    if [[ ! $BUFFER == *$'\n'* ]]; then
        _atuin_search --shell-up-key-binding "$@"
    else
        zle up-line
    fi
}
_atuin_up_search_vicmd() {
    _atuin_up_search --keymap-mode=vim-normal
}
_atuin_up_search_viins() {
    _atuin_up_search --keymap-mode=vim-insert
}

add-zsh-hook preexec _atuin_preexec
add-zsh-hook precmd _atuin_precmd

zle -N atuin-search _atuin_search
zle -N atuin-search-vicmd _atuin_search_vicmd
zle -N atuin-search-viins _atuin_search_viins
zle -N atuin-up-search _atuin_up_search
zle -N atuin-up-search-vicmd _atuin_up_search_vicmd
zle -N atuin-up-search-viins _atuin_up_search_viins

# These are compatibility widget names for "atuin <= 17.2.1" users.
zle -N _atuin_search_widget _atuin_search
zle -N _atuin_up_search_widget _atuin_up_search

bindkey -M emacs '^r' atuin-search
bindkey -M viins '^r' atuin-search-viins
bindkey -M vicmd '/' atuin-search
bindkey -M emacs '^[[A' atuin-up-search
bindkey -M vicmd '^[[A' atuin-up-search-vicmd
bindkey -M viins '^[[A' atuin-up-search-viins
bindkey -M emacs '^[OA' atuin-up-search
bindkey -M vicmd '^[OA' atuin-up-search-vicmd
bindkey -M viins '^[OA' atuin-up-search-viins
bindkey -M vicmd 'k' atuin-up-search-vicmd

# =============================================================================
# LOCAL MACHINE-SPECIFIC CONFIGURATION
# =============================================================================

# Load machine-specific settings if they exist
# Use ~/.zshrc.local for paths, environment variables, and settings
# that are specific to this machine and shouldn't be version controlled
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

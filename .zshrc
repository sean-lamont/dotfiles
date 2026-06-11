# ==========================================
# 1. UNIVERSAL HISTORY & CORE
# ==========================================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory sharehistory histignorealldups
export TERM="xterm-256color"

# ==========================================
# 2. UNIVERSAL UI & PLUGINS (RESTORED)
# ==========================================
# These will load on your bare metal Mac, and safely skip in the container
[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
command -v starship &>/dev/null && eval "$(starship init zsh)"
command -v mcfly &>/dev/null && eval "$(mcfly init zsh)"

# ==========================================
# 3. UNIVERSAL ALIASES (RESTORED)
# ==========================================
alias ls='ls --color=auto'
alias ll='ls -alF'
alias c='xclip -selection clipboard'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(fc -ln -1)"'

# ==========================================
# 4. CONTEXT-AWARE ENVIRONMENT
# ==========================================
if [[ -n "$IS_AGENT_SANDBOX" ]]; then
    # -----------------------------------
    # CONTAINER MODE (Agent Sandbox)
    # -----------------------------------
    export PATH="$HOME/.local/bin:$PATH"
    
    # Conda hook for the Miniconda container path
    [ -f "/opt/conda/bin/conda" ] && eval "$("/opt/conda/bin/conda" 'shell.zsh' 'hook')"
    
    # Agent aliases
    alias yolo="agy -p"
else
    # -----------------------------------
    # BARE METAL MODE (macOS / Host)
    # -----------------------------------
    # Homebrew Initialization
    if [ -f "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    
    # Local Conda hook
    [ -f "$HOME/miniconda3/bin/conda" ] && eval "$("$HOME/miniconda3/bin/conda" 'shell.zsh' 'hook')"
    
    # Local Secrets and SDKMAN
    [ -f "$HOME/.local_secrets.zsh" ] && source "$HOME/.local_secrets.zsh"
    [ -s "$HOME/.sdkman/bin/sdkman-init.sh" ] && source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# ==========================================
# 5. UNIVERSAL TMUX PERSISTENCE
# ==========================================
if [ -n "$TMUX" ]; then
    precmd() { tmux set-env TMUX_CONDA_ENV "$CONDA_DEFAULT_ENV" 2>/dev/null; }
    SAVED_ENV=$(tmux show-env TMUX_CONDA_ENV 2>/dev/null | cut -d= -f2)
    if [ -n "$SAVED_ENV" ] && [ "$SAVED_ENV" != "base" ]; then
        conda activate "$SAVED_ENV" 2>/dev/null
    fi
fi

# Auto-start Tmux if we aren't already in it, and aren't in PyCharm/VSCode
if command -v tmux &>/dev/null && [ -z "$TMUX" ] && [ -z "$SSH_CLIENT" ] && [ "$TERM_PROGRAM" != "vscode" ] && [[ "$TERMINAL_EMULATOR" != *"JetBrains"* ]]; then
    exec tmux new-session -A -s main
fi

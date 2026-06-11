# ==========================================
# 1. HISTORY & CORE
# ==========================================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory sharehistory histignorealldups

export PATH="$HOME/.local/bin:$PATH"
export TERM="xterm-256color"

# ==========================================
# 2. ALIASES & TOOLS
# ==========================================
alias ls='ls --color=auto'
alias ll='ls -alF'

# Agent CLI shortcuts
alias yolo="agy -p"

# Conda Hook (Hardcoded for the container path)
[ -f "$HOME/miniconda3/bin/conda" ] && eval "$("$HOME/miniconda3/bin/conda" 'shell.zsh' 'hook')"

# ==========================================
# 3. TMUX & CONDA PERSISTENCE
# ==========================================
if [ -n "$TMUX" ]; then
    precmd() { tmux set-env TMUX_CONDA_ENV "$CONDA_DEFAULT_ENV" 2>/dev/null; }
    SAVED_ENV=$(tmux show-env TMUX_CONDA_ENV 2>/dev/null | cut -d= -f2)
    if [ -n "$SAVED_ENV" ] && [ "$SAVED_ENV" != "base" ]; then
        conda activate "$SAVED_ENV" 2>/dev/null
    fi
fi

# Auto-start Tmux
if command -v tmux &>/dev/null && [ -z "$TMUX" ] && [ -z "$SSH_CLIENT" ]; then
    exec tmux new-session -A -s main
fi

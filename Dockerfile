FROM mcr.microsoft.com/devcontainers/miniconda:0-3

ENV IS_AGENT_SANDBOX=true
ENV DEBIAN_FRONTEND=noninteractive

# FIX 1: Remove the expired Yarn repository
RUN rm -f /etc/apt/sources.list.d/yarn.list

# FIX 2: Install dependencies for compiling both Tmux AND Neovim
RUN apt-get update && apt-get -y install \
    zsh build-essential curl git ripgrep unzip \
    libevent-dev ncurses-dev bison pkg-config \
    ninja-build gettext cmake \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# FIX 3: Compile Neovim from source (Bypasses the glibc version mismatch)
RUN git clone -b stable --single-branch https://github.com/neovim/neovim.git \
    && cd neovim \
    && make CMAKE_BUILD_TYPE=RelWithDebInfo \
    && make install \
    && cd .. && rm -rf neovim

# FIX 4: Compile modern Tmux (3.4) for OSC 52 clipboard routing
RUN curl -LO https://github.com/tmux/tmux/releases/download/3.4/tmux-3.4.tar.gz \
    && tar -xzf tmux-3.4.tar.gz \
    && cd tmux-3.4 \
    && ./configure && make && make install \
    && cd .. && rm -rf tmux-3.4 tmux-3.4.tar.gz

# Drop down to the secure, non-root user
USER vscode
WORKDIR /workspace


# 1. Install Starship Prompt (Requires root)
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y

# Drop down to the secure, non-root user
USER vscode
WORKDIR /workspace

# 2. Clone Zsh UI plugins to match your Mac's directory structure
RUN mkdir -p ~/.zsh \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting


# Clone and install your universal dotfiles
# (Ensure your GitHub URL is correct here)
RUN git clone https://github.com/sean-lamont/dotfiles.git ~/dotfiles \
    && bash ~/dotfiles/install.sh

CMD ["sleep", "infinity"]

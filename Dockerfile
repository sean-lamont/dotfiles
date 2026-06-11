FROM mcr.microsoft.com/devcontainers/miniconda:0-3

# Inject the context variable so your dotfiles know where they are
ENV IS_AGENT_SANDBOX=true
ENV DEBIAN_FRONTEND=noninteractive

# FIX 1: Remove the expired Yarn repository so apt doesn't crash
RUN rm -f /etc/apt/sources.list.d/yarn.list

# FIX 2: Install core tools AND the dependencies required to build modern Tmux
RUN apt-get update && apt-get -y install \
    zsh build-essential curl git ripgrep unzip \
    libevent-dev ncurses-dev bison pkg-config \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Pull the latest stable Neovim binaries
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
    && tar -C /opt -xzf nvim-linux-x86_64.tar.gz \
    && ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim \
    && rm nvim-linux-x86_64.tar.gz

# FIX 3: Compile modern Tmux (3.4) from source to enable OSC 52 passthrough
RUN curl -LO https://github.com/tmux/tmux/releases/download/3.4/tmux-3.4.tar.gz \
    && tar -xzf tmux-3.4.tar.gz \
    && cd tmux-3.4 \
    && ./configure && make && make install \
    && cd .. && rm -rf tmux-3.4 tmux-3.4.tar.gz

# Drop down to the secure, non-root user
USER vscode
WORKDIR /workspace

# Clone and install your universal dotfiles
# (Ensure your GitHub URL is correct here)
RUN git clone https://github.com/sean-lamont/dotfiles.git ~/dotfiles \
    && bash ~/dotfiles/install.sh

CMD ["sleep", "infinity"]

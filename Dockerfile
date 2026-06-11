FROM mcr.microsoft.com/devcontainers/miniconda:0-3

ENV IS_AGENT_SANDBOX=true
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y install \
    tmux zsh build-essential curl git ripgrep unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
    && tar -C /opt -xzf nvim-linux-x86_64.tar.gz \
    && ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim \
    && rm nvim-linux-x86_64.tar.gz

USER vscode
WORKDIR /workspace

RUN git clone https://github.com/sean-lamont/dotfiles.git ~/dotfiles \
    && bash ~/dotfiles/install.sh

CMD ["sleep", "infinity"]

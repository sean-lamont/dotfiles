#!/bin/bash
# Create Neovim config directory
mkdir -p "$HOME/.config/nvim"

# Create universal symlinks
ln -sfn "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"
ln -sfn "$HOME/dotfiles/.tmux.conf" "$HOME/.tmux.conf"
ln -sfn "$HOME/dotfiles/init.lua" "$HOME/.config/nvim/init.lua"

echo "Dotfiles linked successfully."

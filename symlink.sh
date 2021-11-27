#!/bin/bash

read -p "Are you sure? This operation overwrites existing files. [y/N]" -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

echo

ln -sfvn $PWD/nvim $HOME/.config/nvim
ln -sfv $PWD/gitconfig $HOME/.gitconfig
ln -sfv $PWD/global_gitignore $HOME/.global_gitignore
ln -sfv $PWD/tmux.conf $HOME/.tmux.conf
ln -sfv $PWD/zshrc $HOME/.zshrc.shared

mkdir -p $HOME/.config/alacritty/
ln -sfv $PWD/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml

mkdir -p $HOME/.config/lazygit/
ln -sfv $PWD/lazygit.yml $HOME/.config/lazygit/config.yml

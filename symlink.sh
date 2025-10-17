#!/bin/bash

read -p "Are you sure? This operation overwrites existing files. [y/N]" -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

echo

ln -sfv $PWD/git/base $HOME/.gitconfig
ln -sfv $PWD/tmux.conf $HOME/.tmux.conf
ln -sfv $PWD/zshrc $HOME/.zshrc.shared
ln -sfv $PWD/bashrc $HOME/.bashrc.shared
ln -sfv $PWD/sqliterc $HOME/.sqliterc
ln -sfv $PWD/vimrc $HOME/.vimrc

mkdir -p $HOME/.config
ln -sfvn $PWD/nvim $HOME/.config/nvim

ln -sfv $PWD/starship.toml $HOME/.config/starship.toml
ln -sfvn $PWD/polybar $HOME/.config/polybar

mkdir -p $HOME/.config/aerospace/
ln -sfv $PWD/aerospace.toml $HOME/.config/aerospace/aerospace.toml

mkdir -p $HOME/.config/alacritty/
ln -sfv $PWD/alacritty.toml $HOME/.config/alacritty/alacritty.toml

mkdir -p $HOME/.config/i3/
ln -sfv $PWD/i3config $HOME/.config/i3/config

mkdir -p $HOME/.config/flameshot/
ln -sfv $PWD/flameshot.ini $HOME/.config/flameshot/flameshot.ini

mkdir -p $HOME/.config/yay/
ln -sfv $PWD/yay.json $HOME/.config/yay/config.json

mkdir -p $HOME/.config/lazygit/
ln -sfv $PWD/lazygit.yml $HOME/.config/lazygit/config.yml

mkdir -p $HOME/.config/pypoetry/
ln -sfv $PWD/poetry.toml $HOME/.config/pypoetry/config.toml

mkdir -p $HOME/.cargo/
ln -sfv $PWD/cargo.toml $HOME/.cargo/config.toml

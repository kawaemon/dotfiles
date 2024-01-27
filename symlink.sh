#!/bin/bash

read -p "Are you sure? This operation overwrites existing files. [y/N]" -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

echo

ln -sfvn $PWD/nvim $HOME/.config/nvim

ln -sfv $PWD/git/base $HOME/.gitconfig
ln -sfv $PWD/global_gitignore $HOME/.global_gitignore
ln -sfv $PWD/tmux.conf $HOME/.tmux.conf
ln -sfv $PWD/rc.zsh $HOME/.zshrc.shared
ln -sfv $PWD/sqliterc $HOME/.sqliterc

mkdir -p $HOME/.config/alacritty/
ln -sfv $PWD/alacritty.toml $HOME/.config/alacritty/alacritty.toml
ln -sfv $PWD/starship.toml $HOME/.config/starship.toml
ln -sfv $PWD/chromium-flags.conf $HOME/.config/chromium-flags.conf

mkdir -p $HOME/.config/i3/
ln -sfv $PWD/i3config $HOME/.config/i3/config

mkdir -p $HOME/.config/flameshot/
ln -sfv $PWD/flameshot.ini $HOME/.config/flameshot/flameshot.ini

ln -sfvn $PWD/polybar $HOME/.config/polybar

mkdir -p $HOME/.config/yay/
ln -sfv $PWD/yay.json $HOME/.config/yay/config.json

mkdir -p $HOME/.config/lazygit/
ln -sfv $PWD/lazygit.yml $HOME/.config/lazygit/config.yml

mkdir -p $HOME/.cargo/
ln -sfv $PWD/cargo.toml $HOME/.cargo/config.toml

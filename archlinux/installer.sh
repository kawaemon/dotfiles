#!/bin/zsh

wget https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz
tar xf yay.tar.gz
pushd yay
makepkg -si --noconfirm
popd
rm -rf yay yay.tar.gz

makepkg -si --noconfirm

sudo systemctl daemon-reload
sudo systemctl start systemd-zram-setup@zram0.service

echo 'source $HOME/.zshrc.shared' >> $HOME/.zshrc
source $HOME/.zshrc

rustup default stable
cargo install zr
mise use -g node@20
pnpm setup

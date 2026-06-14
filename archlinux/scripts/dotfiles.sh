#!/bin/sh

set -e

cd ~
mkdir dotfiles_backup
cp -Rp .* dotfiles_backup
git clone https://github.com/xiple/dotfiles
cd ~/dotfiles
stow --adopt .
git restore .

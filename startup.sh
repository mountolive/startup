#! /bin/bash

# Basic
source "$(dirname "$0")"/util.sh
require curl
require git
require gcc
git config --global url.ssh://git@github.com/.insteadOf https://github.com/ && echo "git setted up to use ssh"

check_response "Did you added an ssh key for this device in your github account?\n"

# BASHRC
setup_bashrc
add_alias sbrc "source ~/.bashrc"
add_alias ebrc "nvim ~/.bashrc"
add_alias initvim "cd ~/.config/nvim"
add_alias apps "cd ~/apps"
add_alias aliases "nvim ~/.bash_aliases"
add_alias envsvars "nvim ~/.bash_envs"
source ~/.bashrc

mkdir -p ~/apps && echo "apps dir created"

# ASDF version manager
check_response "Did you installed pre-requisites for python and node? (check README.md)\n"
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1 && echo "asdf download"
add_env_var ". $HOME/.asdf/asdf.sh"
add_env_var ". $HOME/.asdf/completions/asdf.bash"
# source it
sbrc

# Python
echo "Installing python"
asdf plugin-add python
asdf install python 3.9.5
asdf install python 2.7.18
asdf global python 3.9.5 2.7.18
pip install neovim
pip2 install neovim
add_env_var "export PATH=\"$PATH:$HOME/.asdf/installs/python/3.9.5/bin\""
sbrc

# Node
echo "we need to install node now, sorry"
asdf plugin-add nodejs
asdf install nodejs latest
asdf global nodejs latest
npm i -g neovim

echo "installing pyright"
npm i -g pyright

# Go
apps && curl -LO https://golang.org/dl/go1.17.linux-amd64.tar.gz && echo "go 1.17 downloaded"
tar -C ~/ -xzf ~/apps/go1.17.linux-amd64.tar.gz
add_env_var "export PATH=\"$PATH:~/go/bin\""
echo "go 1.17 installed"

# Rust


# NVIM
echo "starting nvim installation"

cd ~/apps && curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage && echo "nvim downloaded correctly"
chmod u+x nvim.appimage && echo "permissions changed for nvim.appimage"
mkdir -p ~/.local/bin && ln -s ~/apps/nvim.appimage nvim && echo "nvim linked"
add_env_var "export PATH=$PATH:~/.local/bin"
# source it
sbrc

echo "setting nvim config"
cd ~/.config && git clone git@github.com:mountolive/init.vim.git && mv init.vim nvim && echo "cloned your init.vim"
mkdir -p ~/.nvim && mkdir -p ~/.nvim/plugged && echo "created plugged dir"
nvim +'PlugInstall --sync' +qa && echo "plugins installed"


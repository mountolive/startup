#! /bin/bash

# Basic
source "$(dirname "$0")"/util.sh
require curl
require git
require gcc
git config --global url.ssh://git@github.com/.insteadOf https://github.com/ && echo "git setted up to use ssh"
git config --global user.name "leo guercio"
git config --global user.email "lpguercio@gmail.com"

check_response "Did you added an ssh key for this device in your github account?\n"

# BASHRC
setup_bashrc
add_alias sbrc "source ~/.bashrc"
add_alias ebrc "nvim ~/.bashrc"
add_alias initvim "cd ~/.config/nvim"
add_alias apps "cd ~/apps"
add_alias aliases "nvim ~/.bash_aliases"
add_alias enved "nvim ~/.bash_envs"
source ~/.bashrc

mkdir -p ~/apps && echo "apps dir created"

mkdir -p ~/.local/bin 
add_env_var "export PATH=$PATH:~/bin"
add_env_var "export PATH=$PATH:~/.local/bin"
# source it
sbrc


check_response "Did you installed pre-requisites? (check README.md)\n"

# ASDF version manager
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1 && echo "asdf download"
add_env_var ". $HOME/.asdf/asdf.sh"
add_env_var ". $HOME/.asdf/completions/asdf.bash"
# source it
sbrc

# Python
echo "Installing python"
check_response "Installing python 3.9.5 and 2.7.18, cool? (Y/N)"
asdf plugin-add python
asdf install python 3.9.5
asdf install python 2.7.18
asdf global python 3.9.5 2.7.18
pip install neovim
pip2 install neovim
add_env_var "export PATH=$PATH:$HOME/.asdf/installs/python/3.9.5/bin"
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
check_response "You're going to install go 1.17. Is that ok? (Y/N)"
apps && curl -LO https://golang.org/dl/go1.17.linux-amd64.tar.gz && echo "go 1.17 downloaded"
tar -C ~/ -xzf ~/apps/go1.17.linux-amd64.tar.gz
add_env_var "export PATH=$PATH:~/go/bin"
sbrc
echo "go 1.17 installed"
echo "installing go tooling"
go install golang.org/x/tools/gopls@latest
go install mvdan.cc/gofumpt@latest
go install mvdan.cc/gofumpt/gofumports@latest
go install github.com/matryer/moq@latest

# CTags (prereq for go-tos)
echo "installing ctags"
cd ~
git clone https://github.com/universal-ctags/ctags.git
cd ctags
./autogen.sh
./configure --prefix="$(realpath ~/.local)"
make
make install

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
sbrc
cargo install rusty-tags
rustup component add rust-src
add_env_var "export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/library/"
sbrc
mkdir -p ~/.rusty-tags && \
  echo "vi_tags = \".rstags\"" >> ~/.rusty-tags/config.toml && \
  echo "emacs_tags = \"rusty-tags.emacs\"" >> ~/.rusty-tags/config.toml && \
  echo "ctags_exe = \"\"" >> ~/.rusty-tags/config.toml && \
  echo "ctags_options = \"\"" >> ~/.rusty-tags/config.toml
rustup component add clippy
rustup +nightly component add rust-analyzer-preview

# NVIM
echo "starting nvim installation"

cd ~/apps && curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage && echo "nvim downloaded correctly"
chmod u+x nvim.appimage && echo "permissions changed for nvim.appimage"
ln -s ~/apps/nvim.appimage ~/.local/bin/nvim && echo "nvim linked"

echo "setting nvim config"
cd ~/.config && git clone git@github.com:mountolive/init.vim.git && mv init.vim nvim && echo "cloned your init.vim"
mkdir -p ~/.nvim && mkdir -p ~/.nvim/plugged && echo "created plugged dir"
nvim +'PlugInstall --sync' +qa && echo "plugins installed"

# Basic
which curl && echo "please install curl"
which git && echo "please install git"
which gcc && echo "please install gcc"
git config --global url.ssh://git@github.com/.insteadOf https://github.com/ && echo "git setted up to use ssh"
read -p "Did you added an ssh key for this device in your github account? " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]
then
  echo "please do"
  exit 1
fi

# NVIM
echo "starting nvim installation"
mkdir -p ~/apps && echo "apps dir created"
cd ~/apps && curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage && echo "nvim downloaded correctly"
chmod u+x nvim.appimage && echo "permissions changed for nvim.appimage"
mkdir -p ~/.local/bin && ln -s ~/apps/nvim.appimage nvim && echo "nvim linked"
echo "setting nvim config"
cd ~/.config && git clone git@github.com:mountolive/init.vim.git && mv init.vim nvim && echo "cloned your init.vim"
mkdir -p ~/.nvim && mkdir -p ~/.nvim/plugged && echo "created plugged dir"
nvim +'PlugInstall --sync' +qa && echo "plugins installed"


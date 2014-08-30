upgrade_oh_my_zsh
cd ~/dotfiles
git pull --rebase
git submodule foreach 'git checkout master; git pull'
cd ~/.vim
rake update
rake dev:update_submodules

upgrade_oh_my_zsh
cd ~/dotfiles
git pull --rebase
git submodule foreach 'git checkout master; git pull'
cd ~/.tmux/tmux-powerline
git pull --rebase
cd ~/.vim
rake update

echo "====================================="
echo "get comeonly's dotfiles"
echo "====================================="
git clone https://github.com/comeonly/dotfiles ~/dotfiles
echo "====================================="
echo "get submodeles"
echo "====================================="
cd ~/dotfiles
git submodule update --init --recursive
echo "====================================="
echo "install oh-my-zsh"
echo "====================================="
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
echo "====================================="
echo "setup tmux"
echo "====================================="
ln -s ~/dotfiles/.tmux ~/.tmux
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
rm -f ~/.tmux/tmux-powerline/themes/default.sh
ln -s ~/dotfiles/.tmux/tmux-powerline-themes/default.sh ~/.tmux/tmux-powerline/themes/default.sh
~/.tmux/tmux-powerline/generate_rc.sh
mv ~/.tmux-powerlinerc.default ~/.tmux-powerlinerc
echo "====================================="
echo "install janus"
echo "====================================="
curl -Lo- https://raw.github.com/carlhuda/janus/master/bootstrap.sh | bash
ln -s ~/dotfiles/.janus ~/.janus
ln -s ~/dotfiles/.vimrc.before ~/.vimrc.before
ln -s ~/dotfiles/.vimrc.after ~/.vimrc.after
ln -s ~/dotfiles/.gvimrc.before ~/.gvimrc.before
ln -s ~/dotfiles/.gvimrc.after ~/.gvimrc.after
mkdir ~/.vim/_undodir

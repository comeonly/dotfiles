#!/bin/bash

set -e

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ログ関数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# ヘッダー表示
echo "====================================="
echo "  Dotfiles Update Script"
echo "====================================="
echo ""

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# dotfiles の更新
log_info "Updating dotfiles repository..."
cd $DOTFILES_DIR
git pull --rebase
log_success "Dotfiles updated"

# oh-my-zsh の更新
if [ -d ~/.oh-my-zsh ]; then
    log_info "Updating oh-my-zsh..."
    cd ~/.oh-my-zsh
    git pull --rebase
    log_success "oh-my-zsh updated"
else
    log_warning "oh-my-zsh not found, skipping..."
fi

# powerlevel10k の更新
if [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k ]; then
    log_info "Updating powerlevel10k..."
    cd ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
    git pull --rebase
    log_success "powerlevel10k updated"
else
    log_warning "powerlevel10k not found, skipping..."
fi

# zsh-autosuggestions の更新
if [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
    log_info "Updating zsh-autosuggestions..."
    cd ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git pull --rebase
    log_success "zsh-autosuggestions updated"
fi

# zsh-syntax-highlighting の更新
if [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
    log_info "Updating zsh-syntax-highlighting..."
    cd ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git pull --rebase
    log_success "zsh-syntax-highlighting updated"
fi

# Vundle の更新
if [ -d ~/.vim/bundle/Vundle.vim ]; then
    log_info "Updating Vundle..."
    cd ~/.vim/bundle/Vundle.vim
    git pull --rebase
    log_success "Vundle updated"
else
    log_warning "Vundle not found, skipping..."
fi

# Vim プラグインの更新
log_info "Updating Vim plugins..."
vim +PluginUpdate +qall
log_success "Vim plugins updated"

# .zshrc.custom の更新（ユーザー名を置換）
if [ -f $DOTFILES_DIR/.zshrc.custom ]; then
    log_info "Updating .zshrc.custom..."
    CURRENT_USER=$(whoami)
    sed "s/izuya/$CURRENT_USER/g" $DOTFILES_DIR/.zshrc.custom > ~/.zshrc.custom
    log_success ".zshrc.custom updated with username: $CURRENT_USER"
fi

echo ""
echo "====================================="
log_success "Update completed!"
echo "====================================="
echo ""
log_info "Restart your terminal or run: source ~/.zshrc"
echo ""

#!/bin/bash

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
echo "  Dotfiles Uninstall Script"
echo "====================================="
echo ""
log_warning "This will remove all dotfiles configurations!"
echo ""
echo "The following will be removed/cleaned:"
echo "  - Vim configuration (~/.vimrc, ~/.vim)"
echo "  - tmux configuration (~/.tmux.conf)"
echo "  - Zsh custom configuration (~/.zshrc.custom)"
echo "  - oh-my-zsh (optional)"
echo "  - Backup files will be restored if available"
echo ""
read -p "Are you sure you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log_info "Uninstall cancelled"
    exit 0
fi

echo ""

# Vim 設定の削除
log_info "Removing Vim configurations..."

# .vimrc
if [ -L ~/.vimrc ]; then
    rm ~/.vimrc
    log_success "Removed symlink: ~/.vimrc"
    if [ -f ~/.vimrc.backup ]; then
        mv ~/.vimrc.backup ~/.vimrc
        log_success "Restored backup: ~/.vimrc.backup -> ~/.vimrc"
    fi
elif [ -f ~/.vimrc ]; then
    log_warning "~/.vimrc is not a symlink, keeping it"
fi

# .vimrc.before
if [ -L ~/.vimrc.before ]; then
    rm ~/.vimrc.before
    log_success "Removed symlink: ~/.vimrc.before"
    if [ -f ~/.vimrc.before.backup ]; then
        mv ~/.vimrc.before.backup ~/.vimrc.before
        log_success "Restored backup: ~/.vimrc.before"
    fi
elif [ -f ~/.vimrc.before ]; then
    log_warning "~/.vimrc.before is not a symlink, keeping it"
fi

# .vimrc.after
if [ -L ~/.vimrc.after ]; then
    rm ~/.vimrc.after
    log_success "Removed symlink: ~/.vimrc.after"
    if [ -f ~/.vimrc.after.backup ]; then
        mv ~/.vimrc.after.backup ~/.vimrc.after
        log_success "Restored backup: ~/.vimrc.after"
    fi
elif [ -f ~/.vimrc.after ]; then
    log_warning "~/.vimrc.after is not a symlink, keeping it"
fi

# .vim ディレクトリの削除確認
if [ -d ~/.vim ]; then
    echo ""
    log_warning "Found ~/.vim directory"
    read -p "Do you want to remove ~/.vim directory? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf ~/.vim
        log_success "Removed: ~/.vim"
    else
        log_info "Keeping ~/.vim directory"
    fi
fi

# tmux 設定の削除
log_info "Removing tmux configurations..."

if [ -L ~/.tmux.conf ]; then
    rm ~/.tmux.conf
    log_success "Removed symlink: ~/.tmux.conf"
    if [ -f ~/.tmux.conf.backup ]; then
        mv ~/.tmux.conf.backup ~/.tmux.conf
        log_success "Restored backup: ~/.tmux.conf"
    fi
elif [ -f ~/.tmux.conf ]; then
    log_warning "~/.tmux.conf is not a symlink, keeping it"
fi

if [ -L ~/.tmux ]; then
    rm ~/.tmux
    log_success "Removed symlink: ~/.tmux"
elif [ -d ~/.tmux ]; then
    log_warning "~/.tmux is not a symlink, keeping it"
fi

# zsh カスタム設定の削除
log_info "Removing zsh custom configurations..."

if [ -f ~/.zshrc.custom ]; then
    rm ~/.zshrc.custom
    log_success "Removed: ~/.zshrc.custom"
fi

# .zshrc からカスタム設定読み込み部分を削除
if [ -f ~/.zshrc ]; then
    if grep -q ".zshrc.custom" ~/.zshrc; then
        # カスタム設定読み込み行を削除
        sed -i '/# Load custom configuration/d' ~/.zshrc
        sed -i '/\.zshrc\.custom/d' ~/.zshrc
        log_success "Removed custom configuration from ~/.zshrc"
    fi

    # バックアップがあれば復元するか確認
    if [ -f ~/.zshrc.backup ]; then
        echo ""
        read -p "Do you want to restore ~/.zshrc from backup? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            mv ~/.zshrc.backup ~/.zshrc
            log_success "Restored backup: ~/.zshrc"
        fi
    fi
fi

# oh-my-zsh の削除確認
echo ""
if [ -d ~/.oh-my-zsh ]; then
    log_warning "Found oh-my-zsh installation"
    read -p "Do you want to remove oh-my-zsh? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # powerlevel10k
        if [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k ]; then
            rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
            log_success "Removed: powerlevel10k"
        fi

        # zsh plugins
        if [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
            rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
            log_success "Removed: zsh-autosuggestions"
        fi

        if [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
            rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
            log_success "Removed: zsh-syntax-highlighting"
        fi

        # oh-my-zsh 本体
        rm -rf ~/.oh-my-zsh
        log_success "Removed: oh-my-zsh"

        # .zshrc
        if [ -f ~/.zshrc ]; then
            read -p "Do you want to remove ~/.zshrc? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                rm ~/.zshrc
                log_success "Removed: ~/.zshrc"
            fi
        fi

        # p10k設定
        if [ -f ~/.p10k.zsh ]; then
            rm ~/.p10k.zsh
            log_success "Removed: ~/.p10k.zsh"
        fi

        # デフォルトシェルを bash に戻すか確認
        CURRENT_SHELL=$(getent passwd $USER | cut -d: -f7)
        if [[ "$CURRENT_SHELL" == *"zsh"* ]]; then
            echo ""
            read -p "Do you want to change default shell back to bash? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                BASH_PATH=$(which bash)
                if chsh -s $BASH_PATH; then
                    log_success "Default shell changed to bash: $BASH_PATH"
                    log_warning "Please log out and log back in for the shell change to take effect"
                else
                    log_error "Failed to change shell. You may need to run: chsh -s $BASH_PATH"
                fi
            fi
        fi
    else
        log_info "Keeping oh-my-zsh"
    fi
fi

echo ""
echo "====================================="
log_success "Uninstall completed!"
echo "====================================="
echo ""
log_info "Summary:"
echo "  - All dotfiles symlinks have been removed"
echo "  - Backup files have been restored where available"
echo "  - The dotfiles repository itself is NOT removed"
echo ""
log_info "To reinstall, run: ./install.sh"
echo ""

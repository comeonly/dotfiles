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
echo "  Dotfiles Installation Script"
echo "====================================="
echo ""

# 現在のユーザー名を取得
CURRENT_USER=$(whoami)
log_info "Current user: $CURRENT_USER"

# Vimバージョンチェック
log_info "Checking Vim version..."
if ! command -v vim &> /dev/null; then
    log_error "Vim is not installed. Please install Vim first."
    exit 1
fi

VIM_VERSION=$(vim --version | head -n 1 | sed 's/.*\([0-9]\+\.[0-9]\+\).*/\1/')
VIM_MAJOR=$(echo $VIM_VERSION | cut -d. -f1)
VIM_MINOR=$(echo $VIM_VERSION | cut -d. -f2)

log_info "Detected Vim version: $VIM_VERSION"

# UltiSnips requires Vim 7.4.849+ or Vim 8.0+
ULTISNIPS_COMPATIBLE=false
if [ "$VIM_MAJOR" -gt 8 ]; then
    ULTISNIPS_COMPATIBLE=true
elif [ "$VIM_MAJOR" -eq 8 ]; then
    ULTISNIPS_COMPATIBLE=true
elif [ "$VIM_MAJOR" -eq 7 ] && [ "$VIM_MINOR" -ge 4 ]; then
    # Vim 7.4系の詳細パッチレベルは確認が難しいため警告
    log_warning "Vim 7.4 detected. UltiSnips requires patch 849+. Installation will continue but may fail."
    ULTISNIPS_COMPATIBLE=true
else
    log_error "Vim version too old for UltiSnips (requires 7.4.849+). Please upgrade Vim."
    exit 1
fi

log_success "Vim version is compatible"

# 必要なパッケージのインストール確認
log_info "Checking required packages..."
REQUIRED_PACKAGES=("git" "curl" "zsh")
MISSING_PACKAGES=()

for pkg in "${REQUIRED_PACKAGES[@]}"; do
    if ! command -v $pkg &> /dev/null; then
        MISSING_PACKAGES+=($pkg)
    fi
done

if [ ${#MISSING_PACKAGES[@]} -ne 0 ]; then
    log_warning "Missing packages: ${MISSING_PACKAGES[*]}"
    log_info "Please install them with: sudo apt install ${MISSING_PACKAGES[*]}"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Vundle のインストール
log_info "Installing Vundle..."
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    log_success "Vundle installed"
else
    log_warning "Vundle already exists, skipping..."
fi

# Undo ディレクトリ作成
log_info "Creating Vim undo directory..."
mkdir -p ~/.vim/_undodir
log_success "Undo directory created"

# dotfiles のシンボリックリンク作成
log_info "Creating symbolic links..."
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# .vimrc
if [ -f ~/.vimrc ] || [ -L ~/.vimrc ]; then
    log_warning "~/.vimrc already exists, backing up to ~/.vimrc.backup"
    mv ~/.vimrc ~/.vimrc.backup
fi
ln -sf $DOTFILES_DIR/.vimrc ~/.vimrc
log_success "Linked .vimrc"

# .vimrc.before (存在する場合のみ)
if [ -f $DOTFILES_DIR/.vimrc.before ]; then
    if [ -f ~/.vimrc.before ] || [ -L ~/.vimrc.before ]; then
        mv ~/.vimrc.before ~/.vimrc.before.backup
    fi
    ln -sf $DOTFILES_DIR/.vimrc.before ~/.vimrc.before
    log_success "Linked .vimrc.before"
fi

# .tmux.conf
if [ -f ~/.tmux.conf ] || [ -L ~/.tmux.conf ]; then
    log_warning "~/.tmux.conf already exists, backing up to ~/.tmux.conf.backup"
    mv ~/.tmux.conf ~/.tmux.conf.backup
fi
ln -sf $DOTFILES_DIR/.tmux.conf ~/.tmux.conf
log_success "Linked .tmux.conf"

# Vim プラグインのインストール
log_info "Installing Vim plugins (this may take a while)..."
vim +PluginInstall +qall
log_success "Vim plugins installed"

# oh-my-zsh のインストール
log_info "Installing oh-my-zsh..."
if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    log_success "oh-my-zsh installed"
else
    log_warning "oh-my-zsh already exists, skipping..."
fi

# powerlevel10k のインストール
log_info "Installing powerlevel10k theme..."
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
    log_success "powerlevel10k installed"
else
    log_warning "powerlevel10k already exists, skipping..."
fi

# zsh プラグインのインストール
log_info "Installing zsh plugins..."

# zsh-autosuggestions
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    log_success "zsh-autosuggestions installed"
else
    log_warning "zsh-autosuggestions already exists, skipping..."
fi

# zsh-syntax-highlighting
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    log_success "zsh-syntax-highlighting installed"
else
    log_warning "zsh-syntax-highlighting already exists, skipping..."
fi

# .zshrc の設定
log_info "Configuring .zshrc..."

# powerlevel10k テーマを .zshrc に設定
if [ -f ~/.zshrc ]; then
    # ZSH_THEME を powerlevel10k に変更
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

    # プラグイン追加（既存のpluginsを拡張）
    if ! grep -q "zsh-autosuggestions" ~/.zshrc; then
        sed -i 's/^plugins=(/plugins=(zsh-autosuggestions zsh-syntax-highlighting /' ~/.zshrc
    fi

    # カスタム設定ファイルの読み込みを追加
    if ! grep -q ".zshrc.custom" ~/.zshrc; then
        echo "" >> ~/.zshrc
        echo "# Load custom configuration" >> ~/.zshrc
        echo "[[ -f ~/.zshrc.custom ]] && source ~/.zshrc.custom" >> ~/.zshrc
    fi

    log_success ".zshrc configured"
fi

# .zshrc.custom のシンボリックリンク作成（ユーザー名を置換）
if [ -f $DOTFILES_DIR/.zshrc.custom ]; then
    sed "s/izuya/$CURRENT_USER/g" $DOTFILES_DIR/.zshrc.custom > ~/.zshrc.custom
    log_success ".zshrc.custom created with username: $CURRENT_USER"
fi

# デフォルトシェルを zsh に変更
log_info "Changing default shell to zsh..."
ZSH_PATH=$(which zsh)
CURRENT_SHELL=$(getent passwd $USER | cut -d: -f7)

if [ "$CURRENT_SHELL" != "$ZSH_PATH" ]; then
    if chsh -s $ZSH_PATH; then
        log_success "Default shell changed to zsh: $ZSH_PATH"
        log_warning "Please log out and log back in for the shell change to take effect"
    else
        log_error "Failed to change shell. You may need to run: chsh -s $ZSH_PATH"
    fi
else
    log_info "Default shell is already zsh: $CURRENT_SHELL"
fi

echo ""
echo "====================================="
log_success "Installation completed!"
echo "====================================="
echo ""
log_info "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Configure powerlevel10k: p10k configure"
echo "  3. Install Nerd Fonts for powerline symbols:"
echo "     https://github.com/ryanoasis/nerd-fonts"
echo ""

#!/usr/bin/env bash

R_USER=$(id -u)
if [ "$R_USER" -eq 0 ]; then
   echo "Este script debe usarse con un usuario regular."
   echo "Saliendo..."
   exit 1
fi

if [ ! -d ~/Apps ]; then
    mkdir ~/Apps
fi

# NerdFonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip
unzip JetBrainsMono.zip -d ~/.local/share/fonts
fc-cache -f -v
rm JetBrainsMono.zip

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
if [ ! -d ~/.local/bin ]; then
    mkdir -p ~/.local/bin
fi
curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer
chmod +x ~/.local/bin/rust-analyzer
export PATH="$HOME/.cargo/bin:$PATH"

# Flatpak
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak --user install flathub com.mattjakeman.ExtensionManager -y
flatpak --user install flathub com.github.tchx84.Flatseal -y
flatpak --user install flathub com.github.neithern.g4music -y
flatpak --user install flathub io.podman_desktop.PodmanDesktop -y

# Doom Emacs
read -rp "Instalar Doom Emacs? (S/N): " DOOM
if [[ $DOOM =~ ^[Ss]$ ]]; then
    if [ -d ~/.emacs.d ]; then
        rm -Rf ~/.emacs.d
    fi
    go install github.com/fatih/gomodifytags@latest
    go install github.com/cweill/gotests/...@latest
    go install github.com/x-motemen/gore/cmd/gore@latest
    go install golang.org/x/tools/cmd/guru@latest
    pip install nose
    git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
    ~/.emacs.d/bin/doom install
    sleep 5
    rm -rf ~/.doom.d
fi

# Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# Anaconda
read -rp "Instalar Anaconda3? (S/N): " ANA
if [[ $ANA =~ ^[Ss]$ ]]; then
    wget https://repo.anaconda.com/archive/Anaconda3-2023.03-Linux-x86_64.sh
    chmod +x Anaconda3-2023.03-Linux-x86_64.sh
    ./Anaconda3-2023.03-Linux-x86_64.sh
fi

# Bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
sed -i 's/"font"/"powerline"/g' "$HOME/.bashrc"

# ZSH
if [ ! -d ~/.local/share/zsh ]; then
    mkdir ~/.local/share/zsh
fi
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.local/share/zsh/powerlevel10k
chsh -s /usr/bin/zsh

# Paquetes Nix
export NIXPKGS_ALLOW_UNFREE=1
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-env -iA nixpkgs.sqlitebrowser
nix-env -iA nixpkgs.inkscape
nix-env -iA nixpkgs.gimp
nix-env -iA nixpkgs.foliate
nix-env -iA nixpkgs.calibre
nix-env -iA nixpkgs.qalculate-gtk
nix-env -iA nixpkgs.flameshot
nix-env -iA nixpkgs.qbittorrent
nix-env -iA nixpkgs.vlc
nix-env -iA nixpkgs.mpv
nix-env -iA nixpkgs.gnome-feeds
nix-env -iA nixpkgs.gitkraken
nix-env -iA nixpkgs.blanket
nix-env -iA nixpkgs.marktext
nix-env -iA nixpkgs.anki
nix-env -iA nixpkgs.github-desktop
nix-env -iA nixpkgs.obsidian
nix-env -iA nixpkgs.handbrake
nix-env -iA nixpkgs.libreoffice-fresh
nix-env -iA nixpkgs.ulauncher
nix-env -iA nixpkgs.neovim
nix-env -iA nixpkgs.helix
nix-env -iA nixpkgs.lsd
nix-env -iA nixpkgs.zsh-autosuggestions
nix-env -iA nixpkgs.zsh-syntax-highlighting
nix-env -iA nixpkgs.fzf
nix-env -iA nixpkgs.pipenv
nix-env -iA nixpkgs.lazygit
nix-env -iA nixpkgs.pgadmin4
#nix-env -iA nixpkgs.mysql80
nix-env -iA nixpkgs.mysql-workbench
nix-env -iA nixpkgs.sqlite-analyzer

go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/go-delve/delve/cmd/dlv@latest
pip install black 'python-lsp-server[all]' pyright yamllint autopep8
cargo install taplo-cli --locked
cargo install stylua
sudo npm install -g neovim prettier bash-language-server vscode-langservers-extracted emmet-ls typescript typescript-language-server yaml-language-server live-server markdownlint markdownlint-cli dockerfile-language-server-nodejs stylelint js-beautify

sleep 5

reboot


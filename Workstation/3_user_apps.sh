#!/usr/bin/env bash

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
flatpak --user install flathub org.libreoffice.LibreOffice -y
flatpak --user install flathub fr.handbrake.ghb -y
flatpak --user install flathub md.obsidian.Obsidian -y
flatpak --user install flathub com.mattjakeman.ExtensionManager -y
flatpak --user install flathub io.github.shiftey.Desktop -y
flatpak --user install flathub net.ankiweb.Anki -y
flatpak --user install flathub com.github.marktext.marktext -y
flatpak --user install flathub com.rafaelmardojai.Blanket -y
flatpak --user install flathub com.github.tchx84.Flatseal -y
flatpak --user install flathub com.github.neithern.g4music -y
flatpak --user install flathub com.axosoft.GitKraken -y
flatpak --user install flathub org.gabmus.gfeeds -y
flatpak --user install flathub io.mpv.Mpv -y
flatpak --user install flathub org.videolan.VLC -y
flatpak --user install flathub org.qbittorrent.qBittorrent -y
flatpak --user install flathub org.flameshot.Flameshot -y
flatpak --user install flathub io.github.Qalculate -y
flatpak --user install flathub com.calibre_ebook.calibre -y
flatpak --user install flathub com.github.johnfactotum.Foliate -y
flatpak --user install flathub org.gimp.GIMP -y
flatpak --user install flathub org.inkscape.Inkscape -y
flatpak --user install flathub org.sqlitebrowser.sqlitebrowser -y

# Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# Bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
sed -i 's/"font"/"powerline"/g' "$HOME/.bashrc"

# ZSH
if [ ! -d ~/.local/share/zsh ]; then
    mkdir ~/.local/share/zsh
fi
touch ~/.zshrc
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.local/share/zsh/powerlevel10k
{
    echo 'source ~/.local/share/zsh/powerlevel10k/powerlevel10k.zsh-theme'
    echo 'source /usr/share/autojump/autojump.zsh'
    echo 'source ~/.local/state/nix/profiles/profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh'
    echo 'source ~/.local/state/nix/profiles/profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
    echo -e '\n# History in cache directory:'
    echo 'HISTSIZE=10000'
    echo 'SAVEHIST=10000'
    echo 'HISTFILE=~/.cache/zshhistory'
    echo 'setopt appendhistory'
    echo 'setopt sharehistory'
    echo 'setopt incappendhistory'
    echo 'JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk'
    echo 'if [ -e /home/gaston/.nix-profile/etc/profile.d/nix.sh ]; then . /home/gaston/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer'
    echo 'export PATH="$HOME/anaconda3/bin:$HOME/Apps/flutter/bin:$HOME/.local/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/bin:$HOME/.cargo/bin:$HOME/.cargo/env:$HOME/go/bin:$HOME/.emacs.d/bin:$PATH"'
} >>~/.zshrc
chsh -s /usr/bin/zsh

# Paquetes Nix
export NIXPKGS_ALLOW_UNFREE=1
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
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

pip install black 'python-lsp-server[all]' pyright yamllint autopep8
cargo install taplo-cli --locked
cargo install stylua
sudo npm install -g neovim prettier bash-language-server vscode-langservers-extracted emmet-ls typescript typescript-language-server yaml-language-server live-server markdownlint markdownlint-cli dockerfile-language-server-nodejs stylelint js-beautify

sleep 5

reboot


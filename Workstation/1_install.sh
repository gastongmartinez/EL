#!/usr/bin/env bash

# Validacion del usuario ejecutando el script
R_USER=$(id -u)
if [ "$R_USER" -ne 0 ];
then
    echo -e "\nDebe ejecutar este script como root o utilizando sudo.\n"
    exit 1
fi

systemctl enable sshd
export LANG=en_US.UTF-8

# Ajuste Swappiness
echo -e "vm.swappiness=10\n" >> /etc/sysctl.d/90-sysctl.conf

USER=$(grep "1000" /etc/passwd | awk -F : '{ print $1 }')

############################### Apps Generales ################################
PAQUETES=(
    #### Powermanagement ####
    'tlp'
    'tlp-rdw'
    'powertop'

    #### Gnome ####
    'gnome-tweaks'
    'gnome-extensions-app'
    'gnome-shell-extension-native-window-placement'
    'gnome-shell-extension-dash-to-dock'
    'gnome-shell-extension-no-overview'
    'gnome-shell-extension-pop-shell'
    'file-roller-nautilus'

    #### WEB ####
    'brave-browser'

    #### Shells ####
    'zsh'
    'dialog'
    'autojump'
    'autojump-zsh'
    'ShellCheck'

    #### Archivos ####
    'mc'
    'thunar'
    'vifm'
    'stow'
    'ripgrep'
    'autofs'

    #### Sistema ####
    'tldr'
    'corectrl'
    'p7zip'
    'unrar'
    'kitty'
    'htop'
    'neofetch'
    'lshw-gui'
    'powerline'
    'emacs'
    'fd-find'
    'the_silver_searcher'
    'aspell'
    'pandoc'
    'dconf-editor'
    'setroubleshoot'
    'tmux'

    #### Redes ####
    'nmap'
    'wireshark'
    'firewall-applet'

    #### DEV ####
    'code'
    'git'
    'clang'
    'cmake'
    'meson'
    'python3-pip'
    'golang'
    'java-1.8.0-openjdk'
    'lldb'
    'tidy'
    'nodejs'
    'yarnpkg'
    'pcre-cpp'

    #### Fuentes ####
    'fontawesome-fonts'
    'fontforge'

    ### Bases de datos ###
    'postgresql-server'
    'sqlite'

    ### Cockpit ###
    'cockpit-machines'

    ### Virtualizacion ###
    'virt-manager'
    'ebtables-services'
    'bridge-utils'
    'libguestfs'
)
 
for PAQ in "${PAQUETES[@]}"; do
    dnf install "$PAQ" -y
done

wget https://corretto.aws/downloads/latest/amazon-corretto-17-x64-linux-jdk.rpm
dnf install amazon-corretto-17-x64-linux-jdk.rpm -y
###############################################################################

############################# Codecs ###########################################
dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y
dnf install lame\* --exclude=lame-devel -y
dnf group upgrade --with-optional Multimedia -y
dnf install ffmpeg -y
################################################################################

################################ Wallpapers #####################################
echo -e "\nInstalando wallpapers..."
git clone https://github.com/gastongmartinez/wallpapers.git
mv -f wallpapers/ "/usr/share/backgrounds/"
#################################################################################

rm amazon-corretto-17-x64-linux-jdk.rpm

{
    echo "[User]"
    echo "Session=gnome"
    echo "Icon=/usr/share/backgrounds/wallpapers/Fringe/fibonacci3.jpg"
    echo "SystemAccount=false"
} >"/var/lib/AccountsService/users/$USER"

usermod -aG libvirt "$USER"
usermod -aG kvm "$USER"

postgresql-setup --initdb --unit postgresql
systemctl enable --now cockpit.socket
firewall-cmd --add-service=cockpit --permanent

alternatives --set java /usr/lib/jvm/java-17-amazon-corretto/bin/java
alternatives --set javac /usr/lib/jvm/java-17-amazon-corretto/bin/javac

############################### GRUB ############################################
git clone https://github.com/vinceliuice/grub2-themes.git
cd grub2-themes || return
./install.sh
cd .. || return
rm -rf grub2-themes
#################################################################################

sleep 2

reboot

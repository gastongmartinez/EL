#!/usr/bin/env bash

# Validacion del usuario ejecutando el script
R_USER=$(id -u)
if [ "$R_USER" -ne 0 ];
then
    echo -e "\nDebe ejecutar este script como root o utilizando sudo.\n"
    exit 1
fi

export LANG=en_US.UTF-8

# EPEL
dnf config-manager --set-enabled crb
dnf install epel-release -y

# RPM Fusion
dnf install --nogpgcheck "https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm" -y
dnf install --nogpgcheck "https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm" -y

# Configuracion DNF
{
    echo 'fastestmirror=1'
    echo 'max_parallel_downloads=10'
} >> /etc/dnf/dnf.conf
dnf update -y

# NIX
USUARIO=$(grep "1000" /etc/passwd | awk -F : '{ print $1 }')
su "$USUARIO" <<EOF
    sh <(curl -L https://nixos.org/nix/install) --no-daemon
EOF

reboot
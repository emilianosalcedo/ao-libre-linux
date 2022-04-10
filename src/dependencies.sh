#!/bin/sh

distro=$(head -n 1 /etc/os-release | cut -d '=' -f 2 | cut -d \" -f 2)
version=$(grep 'VERSION_ID' /etc/os-release | cut -d '=' -f 2 | cut -d \" -f 2)
codename=$(grep 'VERSION_CODENAME' /etc/os-release | cut -d '=' -f 2 | cut -d \" -f 2)
libaud32deb="libfaudio0_20.01-0~buster_i386.deb"
libaud64deb="libfaudio0_20.01-0~buster_amd64.deb"
libaud32ub="libfaudio0_19.07-0~bionic_i386.deb"
libaud64ub="libfaudio0_19.07-0~bionic_amd64.deb"
wine_ver_32="https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/i386/${libaud32ub}"
wine_ver_64="https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/amd64/${libaud64ub}"
deps_debian="./dependencies/packages-debian.lst"
deps_arch="./dependencies/packages-arch.lst"

##  PARA DEBIAN:
##  wine_ver_32="https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/i386/${libaud32deb}"
##  wine_ver_64="https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/amd64/${libaud64deb}"

if [ "${distro}" = "Ubuntu" ] || [ "${distro}" = "KDE neon" ]; then
  sudo dpkg --add-architecture i386
  wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
  printf "%s\n" "deb https://dl.winehq.org/wine-builds/ubuntu/ ${codename} main" | sudo tee -a /etc/apt/sources.list

  if [ "${version}" = "18.04" ] || [ "${version}" = "16.04" ]; then
    wget "${wine_ver_32}"
    wget "${wine_ver_64}"
    sudo dpkg -i "${libaudio32ub}"
    sudo dpkg -i "${libaudio64ub}"
  fi

  sudo apt-get update
  xargs -a "${deps_debian}" sudo apt-get install -y
elif [ "${distro}" = "Manjaro" ]; then
  xargs -a "${deps_arch}" sudo pacman -S --needed 
else
  exit 0
fi

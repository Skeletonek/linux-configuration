#!/bin/bash
#
#	 Copyright (C) 2022 Skeletonek
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#    Contact: skeleton0199@gmail.com
clear
cat << EOF
Fedora Post-Install Configuration Script

Version: 0.3-36-GNOME
Author: Skeletonek (skeleton0199@gmail.com)

This script configures some things in Fedora after fresh install
Things that this script change:
 - Basic DNF configuration (SU)
 - Updating system (SU)
 - Enabling RPM Fusion Free & Non-Free (SU)
 - Enable Flathub repository in Flatpak
 - Remove PackageKit (SU) (User choice)
 - Install dnfdragora (SU) (User choice)

Use this script only on Fedora Workstation (GNOME)
This script was made particulary for version 36 but it should work for 35 and 34 as well
This script must be run in su mode to complete all functions

EOF
if [[ $(id -u) != 0 ]] ; then
  cat << EOF
  ! You didn't run this script as super user. Some commands will not work !

EOF
fi

cat << EOF
Do you want to remove PackageKit from the system?
Recommended: No
EOF

if [[ $(id -u) == 0 ]] ; then
  until [[ ${packagekit_remove^^} == "Y" ]] || [[ ${packagekit_remove^^} == "N" ]]
  do
    read -p "(y/N)?: " packagekit_remove
    packagekit_remove=${packagekit_remove:-N}
  done
fi

cat << EOF
Do you want to install dnfdragora from the system?
Recommended: Yes, if you uninstalled PackageKit
EOF

if [[ $(id -u) == 0 ]] ; then
  until [[ ${dnfdragora_install^^} == "Y" ]] || [[ ${dnfdragora_install^^} == "N" ]]
  do
    read -p "(y/N)?: " dnfdragora_install
    dnfdragora_install=${dnfdragora_install:-N}
  done
fi

cat << EOF
If you are ready to start this script type READY uppercase
Type EXIT to exit the script
EOF
until [[ $ready_string == "READY" ]] || [[ $ready_string == "EXIT" ]]
do
  read -p ": " ready_string
done

if [[ $ready_string == "READY" ]] ; then

# DNF CONFIGURATION
  if [[ $(id -u) == 0 ]] ; then
    printf "Configuring DNF...\n"
    printf "# Custom config beneath\n" >> /etc/dnf/dnf.conf
    printf "max_parallel_download=10\n" >> /etc/dnf/dnf.conf
    printf "fastestmirror=True\n" >> /etc/dnf/dnf.conf
    printf "keepcache=True\n" >> /etc/dnf/dnf.conf
  fi

# SYSTEM UPDATE
  if [[ $(id -u) == 0 ]] ; then
    printf "Performing system update...\n"
    dnf update -y
  fi

# ADD RPMFUSION FREE & NON-FREE TO DNF
  if [[ $(id -u) == 0 ]] ; then
    printf "Adding RPM Fusion Free & Non-Free...\n"
    dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
  fi

# ADD FLATHUB REPOSITORY TO FLATPAK
  printf "Adding Flathub to Flatpak repositories...\n"
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# REMOVE PACKAGEKIT
  if [[ ${packagekit_remove^^} == "Y" ]] ; then
    if [[ $(id -u) == 0 ]] ; then
      printf "Removing PackageKit...\n"
      dnf remove PackageKit -y
    fi
  fi

# INSTALL DNFDRAGORA
  if [[ ${dnfdragora_install^^} == "Y" ]] ; then
    if [[ $(id -u) == 0 ]] ; then
      printf "Installing Dnfdragora...\n"
      dnf install dnfdragora -y
    fi
  fi  

fi

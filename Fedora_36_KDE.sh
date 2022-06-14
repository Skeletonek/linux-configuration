#!/bin/bash
#
#	 Copyright (C) 2021 Skeletonek
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
echo "Fedora Post-Install Configuration Script"
echo ""
echo "Version: 0.1-36-KDE"
echo "Author: Skeletonek (skeleton0199@gmail.com)"
echo ""
echo "This script configures some things in Fedora after fresh install"
echo "Things that this script change:"
echo " - Basic DNF configuration"
echo " - Updating system"
echo " - Enabling RPM Fusion Free & Non-Free"
echo " - Enable Flathub repository in Flatpak"
echo ""
echo "Use this script only on Fedora KDE Spin"
echo "This script was made particulary for version 36 but it should work for 35 and 34 as well"
echo "This script must be run in su mode to complete all functions"
echo "Otherwise the script will run into some errors"
echo "If you are ready to start this script type READY uppercase"
echo "If you type anything diffrent, the script will terminate"
read -p ": " ready_string
if [[ $ready_string == "READY" ]] ; then

# DNF CONFIGURATION
  printf "# Custom config beneath" >> /etc/dnf/dnf.conf
  printf "max_parallel_download=10" >> /etc/dnf/dnf.conf
  printf "fastestmirror=True" >> /etc/dnf/dnf.conf
  printf "keepcache=True" >> /etc/dnf/dnf.conf

# SYSTEM UPDATE
  dnf update -y

# ADD RPMFUSION FREE & NON-FREE TO DNF
  sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# ADD FLATHUB REPOSITORY TO FLATPAK
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

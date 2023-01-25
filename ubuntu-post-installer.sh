#!/bin/bash

current_user=$USER

# Utility functions
print_status () {
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ OK ]${NC}"
  else 
    echo -e "${RED}[ FAIL ]${NC}"
  fi
}

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}##############################################"
echo -e "#### Running Ubuntu Post Installer Script ####"
echo -e "##############################################${NC}"

# Install some utilities
echo ">>> updating sources..."
sudo apt-get update >> /dev/null
print_status

echo ">>> upgrading packages..."
sudo apt-get dist-upgrade -y >> /dev/null
print_status

echo ">>> installing some new packages..."
sudo apt-get install tldr speedtest-cli micro tmux bat cmatrix usbtop htop sensors -y >> /dev/null
print_status

# Set up Snap
echo ">>> updating snap packages"
sudo snap refresh >> /dev/null
print_status

echo ">>> installing some snap packages"
sudo snap install spotify telegram-desktop skype pdftk >> /dev/null
print_status

# Set up Flatpak
echo ">>> installing and configuring flatpak..."
sudo apt-get install flatpak -y >> /dev/null
sudo apt-get install gnome-software-plugin-flatpak >> /dev/null
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo >> /dev/null
print_status

# Downloading additional software
cd ~
echo ">>> downloading gotop..."
wget https://github.com/xxxserxxx/gotop/releases/download/v4.2.0/gotop_v4.2.0_linux_amd64.deb -q
print_status

echo ">>> dowloading duf..."
wget https://github.com/muesli/duf/releases/download/v0.8.1/duf_0.8.1_linux_amd64.deb -q
print_status

# Install DEB packages
echo ">>> installing previously downloaded packages..."
sudo apt-get install ~/*.deb >> /dev/null
print_status

rm gotop*.deb duf*.deb

# Removing unnecessary packages
echo ">>> removing unnecessary packages..."
sudo apt-get autoremove -y >> /dev/null
print_status

# Setting some aliases
echo ">>> customizing aliases..."
if [ ! -f ~/.bash_aliases ]
then
    touch ~/.bash_aliases
fi

cat >> ~/.bash_aliases << _EOF_

alias disks='duf --only local'
alias gt='gotop'
alias fd="sudo fdisk -l | sed -e '/Disk \/dev\/loop/,+5d'"
alias lssize='du -h --max-depth=1 --exclude "./.*"'
alias sudo='sudo '
alias cat='batcat'

_EOF_

# Editing bashrc
cat ~/.bashrc | grep "# custom_flag" >/dev/null

if [ $? -eq 1 ];
then
echo ">>> customizing .bashrc..."
cp ~/.bashrc ~/.bashrc.old
cat >> ~/.bashrc << _EOF_

# Setting git branch in PS1
parse_git_branch() {
 git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

clear='\033[0m'

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White
Grey='\033[1;30m'         # Grey

# Background Colors
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# Color Variables to use in PS1
PS_Green="\[\033[32m\]"   # Green
PS_Blue="\[\033[34m\]"    # Blue
PS_Yellow="\[\033[33m\]"  # Yellow
PS_Clear="\[\033[0m\]"    # Clear

# Sustomizing new shell init
parse_node_version() {
 node -v
}

parse_kernel() {
 uname -r
}

# Customize the prompt. Now you can change the PS1 variable in the if/else sentence
PS1="${debian_chroot:+($debian_chroot)}${PS_Green}\u@\h${PS_Clear}:${PS_Blue}\w ${PS_Yellow}\$(parse_git_branch)${PS_Clear}$ "

echo -e "${Grey}node: ${Red}$(node -v)${clear} ${Grey}kernel: ${Green}$(uname -r)${clear}"

# Dont remove next comment if you executed the script
# custom_flag
_EOF_

echo -e "${GREEN}[ OK ]${NC}"
fi

source ~/.bashrc

echo "Done!"

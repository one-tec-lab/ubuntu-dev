sudo echo


sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup

sudo echo "deb http://archive.ubuntu.com/ubuntu bionic main universe" > /etc/apt/sources.list
sudo echo "deb-src http://archive.ubuntu.com/ubuntu bionic main universe #Added by software-properties" >> /etc/apt/sources.list
sudo echo "deb http://archive.ubuntu.com/ubuntu bionic-security main universe" >> /etc/apt/sources.list
sudo echo "deb-src http://archive.ubuntu.com/ubuntu bionic-security main universe #Added by software-properties" >> /etc/apt/sources.list
sudo echo "deb http://archive.ubuntu.com/ubuntu bionic-updates main universe" >> /etc/apt/sources.list
sudo echo "deb-src http://archive.ubuntu.com/ubuntu bionic-updates main universe #Added by software-properties" >> /etc/apt/sources.list

sudo apt-get update
sudo apt-get install ubuntu-desktop -y

################################################################
# Script_Name : Std-Xrdp-install-0.2.sh
# Description : Perform an automated standard installation of xrdp
# on ubuntu 17.10 and later
# Date : April 2018
# written by : Griffon
# Web Site :http://www.c-nergy.be - http://www.c-nergy.be/blog
# Version : 0.2
# History : 0.2 - Added Logic for Ubuntu 17.10 and 18.04 detection
# - Updated the polkit section
# - New formatting and structure
# 0.1 - Initial Script
# Disclaimer : Script provided AS IS. Use it at your own risk....
##################################################################

echo
/bin/echo -e "\e[1;36m#-------------------------------------------------------------#\e[0m"
/bin/echo -e "\e[1;36m# Standard XRDP Installation Script - Ver 0.2 #\e[0m"
/bin/echo -e "\e[1;36m# Written by Griffon - April 2018- www.c-nergy.be #\e[0m"
/bin/echo -e "\e[1;36m#-------------------------------------------------------------#\e[0m"
echo

#---------------------------------------------------#
# Step 0 - Try to Detect Ubuntu Version....
#---------------------------------------------------#

echo
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m! Detecting Ubuntu version # \e[0m"
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
echo

version=$(lsb_release -d | awk -F":" '/Description/ {print $2}')

if [[ "$version" = *"Ubuntu 17.10"* ]] || [[ "$version" = *"Ubuntu 18.04"* ]];
then
echo
/bin/echo -e "\e[1;32m.... Ubuntu Version :$version\e[0m"
/bin/echo -e "\e[1;32m.... Supported version detected....proceeding\e[0m"

else
/bin/echo -e "\e[1;31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
/bin/echo -e "\e[1;31mYour system is not running Ubuntu 17.10 Edition.\e[0m"
/bin/echo -e "\e[1;31mThe script has been tested only on Ubuntu 17.10...\e[0m"
/bin/echo -e "\e[1;31mThe script is exiting...\e[0m"
/bin/echo -e "\e[1;31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
echo
exit
fi

#---------------------------------------------------#
# Step 1 - Install xRDP Software....
#---------------------------------------------------#
echo
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m! Installing XRDP Packages...Proceeding... # \e[0m"
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
echo

sudo apt-get install xrdp -y

#---------------------------------------------------#
# Step 2 - Install Gnome Tweak Tool....
#---------------------------------------------------#
echo
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m! Installing Gnome Tweak...Proceeding... # \e[0m"
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
echo

sudo apt-get install gnome-tweak-tool -y

#---------------------------------------------------#
# Step 3 - Allow console Access ....
#---------------------------------------------------#
echo
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m! Granting Console Access...Proceeding... # \e[0m"
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
echo

sudo sed -i 's/allowed_users=console/allowed_users=anybody/' /etc/X11/Xwrapper.config

#---------------------------------------------------#
# Step 4 - create policies exceptions ....
#---------------------------------------------------#
echo
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m! Creating Polkit File...Proceeding... # \e[0m"
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
echo

sudo bash -c "cat >/etc/polkit-1/localauthority/50-local.d/45-allow.colord.pkla" <<EOF
[Allow Colord all Users]
Identity=unix-user:*
Action=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile
ResultAny=no
ResultInactive=no
ResultActive=yes
EOF

#---------------------------------------------------#
# Step 5 - Enable Extensions ....
#---------------------------------------------------#
echo
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m! Install Extensions Dock...Proceeding... # \e[0m"
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
echo
gnome-shell-extension-tool -e ubuntu-dock@ubuntu.com
gnome-shell-extension-tool -e ubuntu-appindicators@ubuntu.com
echo

#---------------------------------------------------#
# Step 6 - Credits ....
#---------------------------------------------------#
echo
/bin/echo -e "\e[1;36m#-----------------------------------------------------------------------#\e[0m"
/bin/echo -e "\e[1;36m# Installation Completed\e[0m"
/bin/echo -e "\e[1;36m# Please test your xRDP configuration....\e[0m"
/bin/echo -e "\e[1;36m# Written by Griffon - April 2018 - Ver 0.2 - Std-Xrdp-Install-0.2.sh\e[0m"
/bin/echo -e "\e[1;36m#-----------------------------------------------------------------------#\e[0m"
echo

sudo apt-get install gnome-tweak-tool  xrdp-pulseaudio-installer  -y
sudo xrdp-build-pulse-modules
cd /tmp
sudo apt source pulseaudio

cd /tmp/pulseaudio-11.1
sudo ./configure


cd /usr/src/xrdp-pulseaudio-installer
sudo make PULSE_DIR="/tmp/pulseaudio-11.1"

sudo install -t "/var/lib/xrdp-pulseaudio-installer" -D -m 644 *.so



sudo ufw allow 3389/tcp

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install docker-ce -y

sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo groupadd docker
sudo usermod -aG docker $USER
sudo echo "127.0.0.1     dockerhost" >> /etc/hosts

echo 'export GOPATH=$HOME/go' >> $HOME/.bashrc
echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> $HOME/.bashrc

source $HOME/.bashrc

sudo echo
sudo rm -rf /usr/local/go
cd Downloads/
wget https://dl.google.com/go/go1.11.2.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.11.2.linux-amd64.tar.gz
mkdir -p $HOME/go/bin





#!/bin/bash

sudo echo
################################################################
# Script_Name : install-dev.sh
# Description : Perform an automated standard installation
# of an ubuntu dev environment 
# on ubuntu 18.04.1 and later
# Date : Nov 2018
# written by : tadeo
# 
# Version : 0.2
# History : 0.2 - sourced by .bashrc
# - Updated the polkit section
# - New formatting and structure
# 0.1 - Initial Script
# Disclaimer : Script provided AS IS. Use it at your own risk....
##################################################################

function install-server {
   sudo echo
   sudo adduser devuser
   sudo usermod -aG sudo devuser

   cd $HOME/
 
   sudo echo 'APT::Periodic::Update-Package-Lists "0";' | sudo tee /etc/apt/apt.conf.d/20auto-upgrades
   sudo echo 'APT::Periodic::Unattended-Upgrade "1";' | sudo tee -a /etc/apt/apt.conf.d/20auto-upgrades

   sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup 

   sudo echo "deb http://archive.ubuntu.com/ubuntu bionic main universe" | sudo tee /etc/apt/sources.list
   sudo echo "deb-src http://archive.ubuntu.com/ubuntu bionic main universe #Added by software-properties" | sudo tee -a /etc/apt/sources.list
   sudo echo "deb http://archive.ubuntu.com/ubuntu bionic-security main universe" | sudo tee -a /etc/apt/sources.list
   sudo echo "deb-src http://archive.ubuntu.com/ubuntu bionic-security main universe #Added by software-properties" | sudo tee -a /etc/apt/sources.list
   sudo echo "deb http://archive.ubuntu.com/ubuntu bionic-updates main universe" | sudo tee -a /etc/apt/sources.list
   sudo echo "deb-src http://archive.ubuntu.com/ubuntu bionic-updates main universe #Added by software-properties" | sudo tee -a /etc/apt/sources.list

   sudo apt-get update
   #sudo apt-get upgrade -y
   sudo apt-get install gcc g++ make apt-transport-https ca-certificates curl software-properties-common openconnect ubuntu-desktop mysql-workbench gnome-tweak-tool xrdp xrdp-pulseaudio-installer -y


   ######## docker
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

   sudo apt-key fingerprint 0EBFCD88
   sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

   sudo apt-get update
   sudo apt-get install docker-ce -y

   sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   sudo chmod +x /usr/local/bin/docker-compose

   sudo groupadd docker
   sudo usermod -aG docker devuser
   sudo echo "127.0.0.1     dockerhost" | sudo tee -a  /etc/hosts


   ####### go
   echo 'export GOPATH=$HOME/go' >> $HOME/.bashrc
   echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> $HOME/.bashrc
   source $HOME/.bashrc
   sudo echo
   sudo rm -rf /usr/local/go
   cd $HOME/
   curl -sL https://dl.google.com/go/go1.11.2.linux-amd64.tar.gz -o $HOME/go.tar.gz
   sudo tar -C /usr/local -xzf go.tar.gz
   mkdir -p $HOME/go/bin

   ###### node 10
   cd $HOME/
   curl -sL https://deb.nodesource.com/setup_10.x -o $HOME/nodesource_setup.sh
   sudo bash $HOME/nodesource_setup.sh
   sudo apt-get install -y nodejs

   #YARN
   curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
   echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
   sudo apt-get update && sudo apt-get install yarn

}

function addreplacevalue {

   usesudo="$4"
   archivo="$3"
   nuevacad="$2"
   buscar="$1"
   temporal="$archivo.tmp.kalan"
   listalineas=""
   linefound=0       
   listalineas=$(cat $archivo)
   if [[ !  -z  $listalineas  ]];then
     #echo "buscando lineas existentes con:"
     #echo "$nuevacad"
     #$usesudo >$temporal
     while read -r linea; do
     if [[ $linea == *"$buscar"* ]];then
       #echo "... $linea ..."
       if [ ! "$nuevacad" == "_DELETE_" ];then
          ## just add new line if value is NOT _DELETE_
          echo $nuevacad >> $temporal
       fi
       linefound=1
     else
       echo $linea >> $temporal

     fi
     done <<< "$listalineas"

     cat $temporal > $archivo
     rm -rf $temporal
   fi
   if [ $linefound == 0 ];then
     echo "Adding new value to file: $nuevacad"
     echo $nuevacad>>$archivo
   fi
}

function install-desktop {
   sudo echo
   /bin/echo -e "\e[1;36m#-------------------------------------------------------------#\e[0m"
   /bin/echo -e "\e[1;36m# Standard XRDP Installation Script - Ver 0.2 #\e[0m"
   /bin/echo -e "\e[1;36m# Written by Tadeo - Nov 2018-  #\e[0m"
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

   echo $version

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

sudo bash -c "cat >/etc/polkit-1/localauthority/50-local.d/45-allow.colord.pkla" <<-EOF
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

   sudo ufw allow 3389/tcp


   #sudo xrdp-build-pulse-modules
   cd /tmp
   sudo apt source pulseaudio

   cd /tmp/pulseaudio-11.1
   sudo ./configure


   cd /usr/src/xrdp-pulseaudio-installer
   sudo make PULSE_DIR="/tmp/pulseaudio-11.1"

   sudo install -t "/var/lib/xrdp-pulseaudio-installer" -D -m 644 *.so


   ########### git
   sudo add-apt-repository ppa:git-core/ppa -y
   sudo apt-get update
   sudo apt-get install git -y

   mkdir -p $HOME/otl
   ####chrome
   cd $HOME
   wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
   sudo dpkg -i google-chrome-stable_current_amd64.deb

   ###### vs code
   curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
   sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
   sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
   sudo apt-get install apt-transport-https -y
   sudo apt-get update
   sudo apt-get install code -y # or code-insiders

   ####### dash to panel

   cd $HOME/otl
   git clone https://github.com/home-sweet-gnome/dash-to-panel.git
   cd $HOME/otl/dash-to-panel
   make install
   cd $HOME/


   ######## pop icons
   sudo add-apt-repository ppa:system76/pop -y
   sudo apt-get update
   sudo apt-get install pop-icon-theme -y


   #####community team
   sudo add-apt-repository ppa:communitheme/ppa -y
   sudo apt-get update
   sudo apt-get install ubuntu-communitheme-session -y

   ##### graphic editors
   sudo add-apt-repository ppa:otto-kesselgulasch/gimp -y
   sudo add-apt-repository ppa:inkscape.dev/stable -y
   sudo add-apt-repository ppa:kritalime/ppa -y
   sudo apt-get update
   sudo apt-get install gimp inkscape krita vlc -y


   #sudo apt-get -y upgrade
   
   sudo systemctl start graphical.target

   wget https://raw.githubusercontent.com/one-tec-lab/ubuntu-dev/master/saved_settings.dconf

   mkdir -p ~/.config/autostart
   
bash -c "cat >~/.config/autostart/gnome-terminal.desktop" <<-EOF
[Desktop Entry]
Type=Application
Exec=gnome-terminal
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_NG]=Terminal
Name=Terminal
Comment[en_NG]=Start Terminal On Startup
Comment=Start Terminal On Startup
EOF

echo "source ~/install-dev.sh" >> ~/.bashrc
}

function clean-otl {
   rm ~/nodesource_setup.sh
   rm ~/google-chrome-stable_current_amd64.deb 
   rm ~/go.tar.gz
}

function install-otl {
 install-server
 install-desktop
 clean-otl
}
function save-desktop-settings {
   if [ ! -f ~/desktop_settings.dconf ]; then
      echo "saving desktop settings"
      dconf dump / > ~/desktop_settings.dconf
   fi
}


if [ -f ~/saved_settings.dconf ]; then
   gnome-shell-extension-tool -e dash-to-panel@jderose9.github.com 2>/dev/null
   gsettings set org.gnome.desktop.interface icon-theme 'Pop'
   gsettings set org.gnome.desktop.interface gtk-theme 'Communitheme'
   dconf load / < ~/saved_settings.dconf
   rm -rf ~/saved_settings.dconf
fi

 

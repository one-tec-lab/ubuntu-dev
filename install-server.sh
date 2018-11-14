sudo echo
################################################################
# Script_Name : Std-Xrdp-install-0.2.sh
# Description : Perform an automated standard installation of xrdp
# on ubuntu 17.10 and later
# Date : Nov 2018
# written by : tadeo
# 
# Version : 0.2
# History : 0.2 - Added Logic for Ubuntu 17.10 and 18.04 detection
# - Updated the polkit section
# - New formatting and structure
# 0.1 - Initial Script
# Disclaimer : Script provided AS IS. Use it at your own risk....
##################################################################

sudo adduser devuser
sudo usermod -aG sudo devuser
su - devuser

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
sudo apt-get install gcc g++ make apt-transport-https ca-certificates curl software-properties-common openconnect -y


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






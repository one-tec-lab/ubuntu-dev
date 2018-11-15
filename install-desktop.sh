
sudo apt-get update
sudo apt-get -y updgrade
sudo apt-get install ubuntu-desktop -y

echo
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

sudo ufw allow 3389/tcp

sudo apt-get install xrdp-pulseaudio-installer  -y
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

####chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

####### dash to panel
mkdir -p $HOME/otl
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

sudo apt-get -y updgrade
sudo systemctl start graphical.target

mkdir -p $HOME/Desktop
echo "gnome-shell-extension-tool -e dash-to-panel@jderose9.github.com" > ~/RunMe
echo "gsettings set org.gnome.desktop.interface icon-theme 'Pop'" >> ~/RunMe
echo "gsettings set org.gnome.desktop.interface gtk-theme 'Communitheme'" >> ~/RunMe
chmod +x ~/RunMe

echo "source ~/RunMe" >> ~/.bashrc

bash -c "cat >~/.local/share/applications/start.desktop" <<EOF
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
Terminal=false
Exec=$HOME/RunMe
Name=Start Here
Icon=/usr/share/icons/Pop/64x64/categories/enjoy-music-player.svg
EOF

chmod +x ~/.local/share/applications/start.desktop
sudo chown devuser:devuser /home/devuser/.local/share/gvfs-metadata/home*


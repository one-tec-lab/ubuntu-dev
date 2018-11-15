# ubuntu-dev

The ubuntu-dev environment installs the following components:

**Server components**: Docker, Go language, NodeJS 10, npm and yarn

**Desktop Environment**: Ubuntu desktop and XRDP server for remote access


## Requirements ##
* UBUNTU 18.04 LTS
* Access to a console with sudo permissions (SSH will do)
* Git - to install git run "sudo apt-get install git -y"

To configure ubuntu-dev you need to perform 3 steps:
* 1-Install Server Components 
* 2-Install Ubuntu desktop environment
* 3-Configure Desktop apps and remote access

### 1 Install Server Components
Run the following commands in a console: 

    git clone https://github.com/one-tec-lab/ubuntu-dev.git
    cd ubuntu-dev
    sudo bash install-server.sh
    

### 2 Install Ubuntu desktop environment

Copy the following command in a new console and press enter: 
    
    curl https://raw.githubusercontent.com/one-tec-lab/ubuntu-dev/master/install-server.sh > $HOME/install-server.sh;chmod +x install-server.sh;sudo bash install-server.sh 2>&1 | tee install-server.log
    
### 3 Install desktop environment

Copy the following command in a new console and press enter: 
    
    curl https://raw.githubusercontent.com/one-tec-lab/ubuntu-dev/master/install-server.sh > $HOME/install-server.sh;chmod +x install-server.sh;sudo bash install-server.sh 2>&1 | tee install-server.log

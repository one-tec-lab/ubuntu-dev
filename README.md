# otl development environment

The ubuntu-dev environment installs the following components:

**Server components**: Docker, Go language, NodeJS 10, npm and yarn

**Desktop Environment**: Ubuntu desktop and XRDP server for remote access

### Requirements ##
* UBUNTU 18.04 LTS
* Access to a console with sudo permissions (SSH will do)

## Install
Run the following command in a terminal (ssh or bash):

    curl https://raw.githubusercontent.com/one-tec-lab/ubuntu-dev/master/install-dev.sh > $HOME/install-dev.sh;source install-dev.sh; install-otl 2>&1 | tee install-dev.log

Logs will be available at the file install-dev.log of your user home.

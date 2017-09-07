#!/bin/sh

# regist proxy cert
#  to avoid "x509: certificate signed by unknown authority"
registProxyCert(){
    cp /vagrant/certs/*.crt /usr/local/share/ca-certificates/
    update-ca-certificates
}

installDocker(){
    # https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#uninstall-old-versions
    # Uninstall old versions
    apt-get -y remove docker docker-engine docker.io

    ################################
    ## SET UP THE REPOSITORY

    # Update the apt package index:
    apt-get -y update

    # Trusty 14.04
    # apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual

    #Install packages to allow apt to use a repository over HTTPS:
    apt-get -y install apt-transport-https ca-certificates curl software-properties-common

    # Add Docker’s official GPG key:
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    apt-key fingerprint 0EBFCD88

    # set up the stable repository
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

    ################################
    ## INSTALL DOCKER CE
    apt-get -y update
    apt-get -y install docker-ce


    ################################
    ## Post-installation steps for Linux
    ## https://docs.docker.com/engine/installation/linux/linux-postinstall/

    #Manage Docker as a non-root user
    groupadd docker
    usermod -aG docker $USER
    usermod -aG docker vagrant
    # need re-login

    # Configure Docker to start on boot
    systemctl enable docker


    ################################
    ## Install Docker Compose
    ## https://docs.docker.com/compose/install/
    ## https://docs.docker.com/compose/install/#alternative-install-options

    # Install pip
    apt-get -y install python-pip
    # Install using pip
    pip install docker-compose
}

# ################################
# ## Install Node.js
# apt-get install -y nodejs npm
# npm cache clean
# npm install n -g
# n stable
# node -v


configureSSHD(){
    if [ -e "/vagrant/ssh/sshd_config" ]; then
        cp /vagrant/ssh/sshd_config /etc/ssh/sshd_config
        service sshd restart
    fi
}


## call functions
registProxyCert
installDocker
configureSSHD

# keep LF
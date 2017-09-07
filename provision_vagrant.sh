#!/bin/sh

configureSSH(){
    #Keypair generation
    if [ ! -d "`echo ~/.ssh`" ]; then
        mkdir ~/.ssh
        chmod 0700 ~/.ssh
    fi
    # must use 2048bit key 
    # > ssh-keygen -t rsa -b 2048 -f ~/vagrant_id_rsa
    if [ -e "/vagrant/ssh/vagrant_id_rsa.pub" ] && [ ! -e "`echo ~/.ssh/vagrant_id_rsa.pub`" ]; then
        cp /vagrant/ssh/vagrant_id_rsa.pub ~/.ssh/vagrant_id_rsa.pub
        cat ~/.ssh/vagrant_id_rsa.pub >> ~/.ssh/authorized_keys
        chmod 0600 ~/.ssh/*
    fi
}

configureSSH

# keep LF
#!/bin/bash

sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:mysteriumnetwork/node
sudo sed -i 's/kinetic/bionic/g' /etc/apt/sources.list.d/mysteriumnetwork-ubuntu-node-kinetic.list 
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com ECCB6A56B22C536D
sudo apt-get update
sudo apt install myst -y

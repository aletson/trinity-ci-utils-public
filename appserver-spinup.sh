#!/bin/bash
# This is the initial setup script for your application server
# A t2.micro is plenty to be going on with
# Recommend 30GB hard drive space.
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install wget python openjdk-8-jre awscli unzip libboost-all-dev libmysqlclient-dev mysql-client -y
mkdir -p /var/lib/trinity
sudo useradd trinity -d /var/lib/trinity -s /sbin/nologin
sudo dd if=/dev/zero of=/var/swapfile bs=1M count=1024
sudo mkswap /var/swapfile
sudo chmod 600 /var/swapfile
sudo swapon /var/swapfile
sudo echo "swap /var/swapfile swap defaults 0 0" >> /etc/fstab

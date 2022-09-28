#!/bin/bash
# This is the initial setup script for your application server
# A t3.micro is plenty to be going on with, at least for a dev box
# Recommend 30GB hard drive space.
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install wget python openjdk-8-jre awscli unzip libboost-all-dev -y
sudo apt-get install git clang cmake make gcc g++ libmysqlclient-dev libssl-dev libbz2-dev libreadline-dev libncurses-dev mysql-server p7zip -y
mkdir -p /var/lib/trinity
sudo useradd trinity -d /var/lib/trinity -s /sbin/nologin
sudo dd if=/dev/zero of=/var/swapfile bs=1M count=4096
sudo mkswap /var/swapfile
sudo chmod 600 /var/swapfile
sudo swapon /var/swapfile
sudo echo "swap /var/swapfile swap defaults 0 0" >> /etc/fstab
cat <<EOF > ~/.aws/credentials
aws_access_key_id = YOUR_ACCESS_KEY_GOES_HERE
aws_secret_access_key = YOUR_SECRET_KEY_GOES_HERE
EOF
cat <<EOG ~/.aws/config
[default]
region = YOUR_PRIMARY_AWS_REGION
EOG

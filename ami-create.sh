#!/bin/bash
# This file should be run to prepare a VM for having an image taken
# This should only need to be run once, then use the created image to spin up your build machine.
# Remember to periodically run apt-get update && apt-get upgrade and recapture the image.
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install git cmake make clang libmariadbclient-dev libssl1.0-dev libbz2-dev libreadline-dev libncurses-dev libboost-all-dev p7zip zip unzip build-essential
sudo update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang 100
sudo apt-get install openjdk-8-jre # For Jenkins
mkdir -p ~/.aws
cat <<EOF > ~/.aws/credentials
aws_access_key_id = YOUR_ACCESS_KEY_GOES_HERE
aws_secret_access_key = YOUR_SECRET_KEY_GOES_HERE
EOF
cat <<EOG ~/.aws/config
[default]
region = YOUR_PRIMARY_AWS_REGION
EOG

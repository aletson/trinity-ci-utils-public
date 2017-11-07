#!/bin/bash
# Use Jenkins to run this on your build server. I recommend configuring the EC2 Plugin
# to let Jenkins spin up a spot instance rather than keeping your build server up 24/7.
# Make sure the proper AWS S3 roles (read/write to bucket) are set on the server.

now=`date +"%Y%m%d%H%M%S"`
# System updates
sudo apt-get update && sudo apt-get upgrade -y

# Get and build TC source
cd ~
git clone -b 3.3.5 git://github.com/TrinityCore/TrinityCore.git
cd TrinityCore
mkdir build
cd build
cmake ../ -DCMAKE_INSTALL_PREFIX=/usr/local -DLIBSDIR=/usr/local/trinity/lib -DCONF_DIR=/etc/trinity -DTOOLS=1
make -j $(nproc) && sudo make -j $(nproc) install

# Map generation
cp /usr/local/bin/m* /usr/local/bin/vmap* ~
cd ~
./mapextractor
./vmap4extractor
mkdir vmaps
./vmap4assembler Buildings vmaps
mkdir mmaps
./mmaps_generator

rm Data/ Buildings/ Cameras/ -rf
# Package files
mkdir -p ~/trinity_$now
mkdir -p ~/trinity_$now/var/lib/trinity/src/server
mkdir -p ~/trinity_$now/var/log/trinity
mkdir -p ~/trinity_$now/etc/trinity
mkdir -p ~/trinity_$now/usr/local/bin
mkdir -p ~/trinity_$now/usr/lib/systemd/system
# These paths have to be the same because there's no portability built into the configs.
mv ~/TrinityCore/sql ~/trinity_$now/var/lib/trinity/
mv ~/TrinityCore/src/server/scripts ~/trinity_$now/var/lib/trinity/src/server/
sudo mv /usr/local/bin/worldserver /usr/local/bin/authserver ~/trinity_$now/usr/local/bin/
sudo mv /etc/trinity/*.conf.dist ~/trinity_$now/etc/trinity/
sudo sed -i 's|DataDir = "."|DataDir = "/var/lib/trinity"|' ~/trinity_$now/etc/trinity/worldserver.conf.dist
sudo sed -i 's|LogsDir = ""|LogsDir = "/var/log/trinity"|' ~/trinity_$now/etc/trinity/*.conf.dist
sudo sed -i 's|SourceDirectory = ""|SourceDirectory = "/var/lib/trinity"|' ~/trinity_$now/etc/trinity/worldserver.conf.dist
zip -r maps.zip dbc maps mmaps vmaps 
rm -rf dbc maps mmaps vmaps

mkdir -p ~/trinity_$now/DEBIAN
cat <<EOF > ~/trinity_$now/DEBIAN/control
Package: trinity
Version: $now
Section: base
Priority: optional
Architecture: amd64
Maintainer: YOUR_NAME <YOUR_EMAIL@YOUR_DOMAIN>
Description: TrinityCore
 Compiled redistributable for TrinityCore. Works with 
 systemd.
EOF
cat <<EOA > ~/trinity_$now/usr/lib/systemd/system/authserver.service
[Unit]
Description=TrinityCore Authentication Server

[Service]
WorkingDirectory=/usr/local/bin/trinity
User=trinity
Group=trinity

ExecStart=/usr/local/bin/authserver

ExecReload=/bin/kill -HUP $MAINPID

KillSignal=SIGTERM
KillMode=process

RestartSec=10s
Restart=on-abort


[Install]
WantedBy=multi-user.target
EOA
cat <<EOW > ~/trinity_$now/usr/lib/systemd/system/worldserver.service
[Unit]
Description=TrinityCore World Server

[Service]
WorkingDirectory=/usr/local/bin/trinity
User=trinity
Group=trinity

ExecStart=/usr/local/bin/worldserver

# For most worldserver.conf setting changes, you can simply type .reload config 
# in-game to see changes instantly without restarting the server.
# implement using RA?

ExecReload=/bin/kill -HUP $MAINPID

KillSignal=SIGTERM
KillMode=process

RestartSec=10s
Restart=on-abort


[Install]
WantedBy=multi-user.target
EOW
cd ~
dpkg-deb --build trinity_$now
aws s3 cp maps.zip s3://YOUR_S3_BUCKET/maps-latest.zip
aws s3 cp trinity_$now.deb s3://YOUR_S3_BUCKET/trinity.latest.deb

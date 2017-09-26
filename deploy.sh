#!/bin/bash

aws s3 cp s3://YOUR_S3_BUCKET/maps.zip ~/maps.zip
aws s3 cp s3://YOUR_S3_BUCKET/trinity.latest.deb ~/trinity.latest.deb
sudo dpkg -i --force-confnew trinity.latest.deb
sudo unzip -o maps.zip -d /var/lib/trinity/
rm maps.zip -f
sudo chown trinity:trinity /var/lib/trinity -R
sudo chown trinity:trinity /var/log/trinity -R
sudo systemctl restart worldserver
sudo systemctl restart authserver

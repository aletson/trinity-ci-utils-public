# trinity-ci-utils-public
A collection of scripts to implement continuous integration for your TrinityCore setup.

## Use of scripts
My recommendation is to set up a Jenkins CI instance and run these scripts as jobs. You can run Jenkins on a t2.nano instance with a 512MB swap file, and it should only need an 8GB hard drive.

Part of the benefit of this is that you can leverage the Jenkins EC2 Plugin to spin up c4.xlarge spot instances instead of paying for a 24/7 build server. Give the plugin an access key and secret key pair with the proper permissions (instructions are given on the plugin site) and let that do the heavy lifting. This should allow you to build the server + maps/vmaps/mmaps within about 2 hours.

Once that's done, you can deploy the binaries to your application server - a t2.micro with 1GB swap works just fine. You can use another Jenkins job to run that bash script; just configure your application server to allow launching a build node over SSH.

# trinity-ci-utils-public
A collection of scripts to implement continuous integration for your TrinityCore setup.

## Use of scripts
My recommendation is to set up a Jenkins CI instance and run these scripts as jobs. You can run Jenkins on a t3.nano instance with a 512MB swap file, and it should only need an 8GB hard drive.

Part of the benefit of this is that you can leverage the Jenkins EC2 Plugin to spin up c5.xlarge spot instances instead of paying for a 24/7 build server. Give the plugin an access key and secret key pair with the proper permissions (instructions are given on the plugin site) and let that do the heavy lifting. This should allow you to build the server + maps/vmaps/mmaps within about 2 hours.

Once that's done, you can deploy the binaries to your application server - a t3.micro with 1GB swap works just fine for a dev box. You can use another Jenkins job to run that bash script; just configure your application server to allow launching a build node over SSH.

Before you run the server for the first time, you will need to configure your authserver.conf and worldserver.conf, specifically the database connection strings. For the purposes of this discussion, I'm assuming that you've set up your database server separately and that you've already done the initial database setup. You may also want to set `Console.Enable` to 0 to avoid spamming syslog on your application server.

Also, please consider setting up remote admin (RA) in TrinityCore before implementing so that the server is still manageable from an admin perspective (e.g., downtime/maintenance announcements, etc.)

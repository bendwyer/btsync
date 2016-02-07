#!/bin/bash

# switch to Upstart folder
cd /etc/init

# download btsync.conf for Upstart
wget https://raw.githubusercontent.com/bendwyer/btsync/master/btsync.conf

# start btsync service
service btsync start

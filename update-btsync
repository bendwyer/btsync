#!/bin/bash

# Credit to Florian Knapp (https://nerd.one/bittorrent-sync-auf-uberspace/)

# switch to btsync folder
cd /usr/local/bin/btsync

# stop btsync service
service btsync stop

# create backup
mv btsync btsync.old.$(date +%F-%T)

# download new build
wget https://download-cdn.getsync.com/stable/linux-x64/BitTorrent-Sync_x64.tar.gz

# extract archive
tar -xvzf BitTorrent-Sync_x64.tar.gz

# remove archive
rm BitTorrent-Sync_x64.tar.gz

# change ownership of /usr/local/bin/btsync recursively
chown -R btsync:btsync /usr/local/bin/btsync

# start btsync service
service btsync start

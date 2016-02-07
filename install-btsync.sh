#!/bin/bash

# delete this script when complete
#rm install-btsync.sh

# make /btsync dir for downloading tar.gz
mkdir /usr/local/bin/btsync

# change dir to /usr/local/bin/btsync
cd /usr/local/bin/btsync

# download latest Linux x64 version
wget https://download-cdn.getsync.com/stable/linux-x64/BitTorrent-Sync_x64.tar.gz

# extract files from tar.gz
tar xvzf BitTorrent-Sync_x64.tar.gz

# remove archive
rm BitTorrent-Sync_x64.tar.gz

# add /usr/local/bin/btsync to PATH environment variable
export PATH=$PATH:/usr/local/bin/btsync

# make config dir
mkdir /etc/btsync

# dump config
btsync --dump-sample-config > /etc/btsync/btsync.conf

# make a directory for the storage_path
mkdir /var/lib/btsync

# make root directory for file browser
mkdir /sync-encrypted

# create log file
touch /var/log/btsync.log

# create btsync useraccount
useradd btsync

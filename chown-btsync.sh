#!/bin/bash

# change ownership of /usr/local/bin/btsync recursively
chown -R btsync:btsync /usr/local/bin/btsync

# change ownership of /etc/btsync recursively
chown -R btsync:btsync /etc/btsync

# change ownership of /var/lib/btsync recursively
chown -R btsync:btsync /var/lib/btsync

# change ownership of /sync-encrypted recursively
chown -R btsync:btsync /sync-encrypted

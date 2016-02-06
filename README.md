# btsync
Instructions and scripts for setting up BitTorrent Sync on Ubuntu Server.

## Disclaimers<br>
- I am not a Linux expert.<br>
- This information was compiled from multiple sources, so there may be mistakes. If so, they are my own.<br>
- I performed this install on Ubuntu Server 14.04 LTS. Other Linux versions may work, some may not.<br>
- Use the following instructions at your own risk.<br>

## Background
I used these scripts and instructions for setting up a BitTorrent Sync host on Ubuntu Server 14.04 LTS in Microsoft Azure. As such, the design for the server is to only hold encrypted shared folders.

While my "home" devices are linked together via `My Devices` in BitTorrent Sync, my public server(s) are not. I create an encrypted folder on my "home" BitTorrent Sync server, and share the encrypted key with my public server(s). On the public server(s), those shared folders are created as subdirectories of `/sync-encrypted`, as shown below.

## File Locations
`/usr/local/bin/btsync` - location for downloading, extracting, and storing the `btsync` executable<br>
`/etc/btsync` - location for the `btsync.conf` configuration file<br>
`/var/lib/btsync` - location for the `storage_path` option in `btsync.conf`; also where `btsync.pid` will be stored <br>
`/sync-encrypted` - location for storing encrypted sync folders<br>

## Getting Started
On your fresh Ubuntu Server install, run `wget`:<br>
```
wget https://raw.githubusercontent.com/bendwyer/btsync/master/install-btsync.sh
```

>#### Sidenote
If you're curious about what `install-btsync.sh` does, feel free to open it and take a look. I've included descriptions of what the commands are doing inside the script.<br>
```
sudo nano install-btsync.sh
```

Execute `install-btsync.sh`
```
sudo ./install-btsync.sh
```
Examine the output and make sure that there aren't any errors. When I ran `install-btsync.sh` on my Azure VM, I did receive warnings about not being able to set a password and group for the created user `btsync`. The user account created successfuly in spite of this, so I kept going.

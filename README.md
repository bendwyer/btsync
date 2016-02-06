# btsync
Instructions and scripts for setting up BitTorrent Sync on Ubuntu Server.

## Disclaimers
- I am not a Linux expert.<br>
- This information was compiled from multiple sources, so there may be mistakes. If so, they are my own.<br>
- I performed this install on Ubuntu Server 14.04 LTS. Other Linux versions may work, some may not.<br>
- Use the following instructions at your own risk.<br>

## Background
I used these scripts and instructions for setting up a BitTorrent Sync host on Ubuntu Server 14.04 LTS in Microsoft Azure. As such, the design for the server is to only hold encrypted shared folders.

While my "home" devices are linked together via `My Devices` in BitTorrent Sync, my public server is not. I create an encrypted folder on my "home" BitTorrent Sync server, and share the encrypted key with my public server. On the public server, those shared folders are created as subdirectories of `/sync-encrypted`, as shown below.

Across all of my Sync devices (home and public) I have turned off `use_relay`, `use_tracker`, and `send_statistics` in BitTorrent Sync folder defaults, utilizing only `known_hosts`. Additionally, `use_upnp` is set to `false` for all my devices.

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

>#### Sidenote: `install-btsync.sh`
If you're curious about what `install-btsync.sh` does, feel free to open it and take a look. I've included descriptions of what the commands are doing inside the script.<br>
```
sudo nano install-btsync.sh
```

Execute `install-btsync.sh`
```
sudo ./install-btsync.sh
```
Examine the output and make sure that there aren't any errors. When I ran `install-btsync.sh` on my Azure VM, I did receive warnings about not being able to set a password and group for the created user `btsync`. The user account created successfuly in spite of this, so I kept going.

## Edit `btsync.conf`
Open `btsync.conf` for editing.
```
sudo nano /etc/btsync/btsync.conf
```
### Basic Preferences
Uncomment lines by deleting the `//` at the beginning of each line.

`device_name` - what you want to call your Sync device.<br>
`storage_path` - change to `/var/lib/btsync/` and **uncomment**.<br>
`pid_file` - change to `/var/lib/btsync/btsync.pid` and **uncomment**.<br>
`use_upnp` - change to `false`.<br>
`login` - change to what you want your username to be and **uncomment**.<br>
`password_hash` - change to what you want your hashed password to be and **uncomment**. See below for more information.<br>
`directory_root` - change to `/sync-encrypted/` and **uncomment**.<br>
>#### Sidenote: `password_hash`
To make a hashed password for `btsync.conf`, you have to use `crypt(3)`. This method definitely has its limitations, but at least your password isn't stored in plaintext.<br>
```
mkpasswd
```
After running the above command, you'll be prompted for a password. Type/paste your preferred password in, and press `Enter`. If your password is above 8 characters, you'll get a warning about it only accepting the first 8 characters. Copy the output and paste it into the `password_hash` line.

### Advanced preferences
These exist at the very bottom of `btsync.conf`. 

If you don't get the syntax right for the options in this section, `btsync` won't start properly. 

These options have to be explicitly set in `btsync.conf` - changing them through the WebUI requires a restart, and after the restart those settings are lost.

Add your options below<br>
`//, "folder_rescan_interval" : "86400"`<br>
and above<br>
`}`

It should look something like this:
```
//, "folder_rescan_interval" : "86400"
  , "folder_defaults.use_relay" : false
  , "folder_defaults.use_tracker" : false
  , "folder_defaults.use_lan_broadcast" : false
//, "folder_defaults.delete_to_trash" : false
  , "send_statistics" : false
  , "folder_defaults.known_hosts" : "server.domain.tld:port#,server2.domain2.tld2:port#"
}
```
Leave `folder_rescan_interval` commented out.

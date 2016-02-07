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
`/usr/local/bin/btsync` - location for downloading, extracting, and storing the `btsync` executable.<br>
`/etc/btsync` - location for the **BitTorrent Sync** configuration file `btsync.conf`.<br>
`/var/lib/btsync` - location for the `storage_path` option in `btsync.conf`; also where `btsync.pid` will be stored.<br>
`/sync-encrypted` - location for storing encrypted sync folders.<br>
`/etc/init` - location for the **Upstart** configuration file `btsync.conf`.<br>

>#### Sidenote: `btsync.conf`
I will reference two versions of `btsync.conf` in this README. Only the **Upstart** configuration file is available to download from this repo. The **BitTorrent Sync** configuration file has to be created and edited by hand. For the sake of clarity, I will reiterate the locations of the two files:<br>
<br>
**BitTorrent Sync**
```
/etc/btsync/btsync.conf
```
**Upstart**
```
/etc/init/btsync.conf
```

## Getting Started
On your fresh Ubuntu Server install, run `wget` and download `install-btsync.sh`:<br>
```
wget https://raw.githubusercontent.com/bendwyer/btsync/master/install-btsync.sh
```
Make `install-btsync.sh` executable.
```
chmod +x install-btsync.sh
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

### Advanced Preferences
- These exist at the very bottom of `btsync.conf`. 
- If you don't get the syntax right for the options in this section, `btsync` won't start properly. 
- These options have to be explicitly set in `btsync.conf` - changing them through the WebUI requires a restart, and after the restart those settings are lost. 
  - I'm not sure why, but I think it's because of the way `btsync` and `btsync.conf` are being called, they are overwriting changes made to the `Power User` options through the WebUI.

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
  , "folder_defaults.known_hosts" : "server1.domain1.tld1:port#,server2.domain2.tld2:port#"
}
```
- I left `folder_rescan_interval` commented out.<br>
- I've turned `folder_defaults.use_lan_broadcast` off for all my devices except my "home" server. There's no reason for it to be enabled on a public server. I also have it disabled on my laptop, but that's because I'm using `folder_defaults.known_hosts` for all my Sync devices, negating the need for LAN broadcast discovery.
- For my private Sync devices, I leave `folder_defaults.delete_to_trash` set to `false`. For my public Sync devices (like an Azure VM), I leave it set to the default, `true`, which is why it's commented out here.<br>
- I've turned off `send_statistics` for all my Sync devices. While BitTorrent Sync states nothing persinally identifiable is collected, I'm not keen on leaving it on.<br>
- The `folder_defaults.known_hosts` option requires that the list of servers be comma separated with **no spaces**. On my laptop, I've included both a local and public address for my "home" server since all other methods of discovery are disabled.<br>
- More information on the available options for this section can be found here: http://help.getsync.com/hc/en-us/articles/207371636-Power-user-preferences

## Run `btsync` as `root`
Switch to `root`.
```
sudo -i
```
Add `/usr/local/bin/btsync` to `PATH` environment variable.
```
export PATH=$PATH:/usr/local/bin/btsync
```
Start `btsync`.
```
btsync --config /etc/btsync/btsync.conf --log /var/log/btsync.log
```
`btsync` should start successfully and specify a PID.
```
```
Stop `btsync`.
```
killall btsync
```
Exit `root`.
```
exit
```

## Change Ownership of Files
Run `wget` and download `chown-btsync.sh`:<br>
```
wget https://raw.githubusercontent.com/bendwyer/btsync/master/chown-btsync.sh
```
Make `chown-btsync.sh` executable.
```
chmod +x chown-btsync.sh
```

>#### Sidenote: `chown-btsync.sh`
If you're curious about what `chown-btsync.sh` does, feel free to open it and take a look. I've included descriptions of what the commands are doing inside the script.<br>
```
sudo nano chown-btsync.sh
```

Execute `chown-btsync.sh`
```
sudo ./chown-btsync.sh
```

## Making `btsync` Autostart (Upstart)
Run `wget` and download `btsync.conf`:<br>
```
wget https://raw.githubusercontent.com/bendwyer/btsync/master/btsync.conf
```
>#### Sidenote: `btsync.conf`
If you're curious about what `btsync.conf` does, feel free to open it and take a look.<br>
```
sudo nano btsync.conf
```

Move `btsync.conf` to `/etc/init`.
```
sudo mv btsync.conf /etc/init
```
Test starting the service.
```
sudo service btsync start
```
Check that the `btsync` executable is running as user `btsync`.
```
ps -ef | grep btsync | grep -v grep
```
The output should look something like this:
```

```
Reboot the server to test if `btsync` autostarts.
```
sudo reboot now
```

## Updating `btsync` Automatically
Run `wget` and download `update-btsync.sh`:<br>
```
wget 
```
Make `update-btsync.sh` executable.
```
chmod +x update-btsync.sh
```

>#### Sidenote: `update-btsync.sh`
If you're curious about what `update-btsync.sh` does, feel free to open it and take a look. I've included descriptions of what the commands are doing inside the script.<br>
```
sudo nano update-btsync.sh
```

Execute `update-btsync.sh`
```
sudo ./update-btsync.sh
```

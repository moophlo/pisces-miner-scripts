# This is a collection of scripts useful for Pisces miners P100

# DISCLAIMER: Only use this scripts if you know what you are doing!!!


# How to run clear_resync.sh:
This script will clean blockchain data and the re-sync the hotspot using Nebra or SenseCAP snapshot based on which one is the closest to the actual blockchain height

wget https://raw.githubusercontent.com/moophlo/pisces-miner-scripts/main/clear_resync.sh -O - | sudo bash


# How to run crontab_job.sh:
This script will install in crontab a job that everyday at midnight will run a check on root filesystem free space left and if it's less than 20% free will run the clean_resync.sh script

wget https://raw.githubusercontent.com/moophlo/pisces-miner-scripts/main/crontab_job.sh -O - | sudo bash


# How to run fixed_dns.sh:
This script will override the DNS servers pushed from the DHCP server in your LAN and will set the google DNS

wget https://raw.githubusercontent.com/moophlo/pisces-miner-scripts/main/fixed_dns.sh -O - | sudo bash


# How to upgrade clear_resync.sh and crontab_job.sh to latest version:

sudo wget https://raw.githubusercontent.com/moophlo/pisces-miner-scripts/main/clear_resync.sh -O /usr/bin/clear_resync.sh




# PERFORMANCE TWEAKS FROM INIGOFLORES (https://github.com/inigoflores)
# Miner Peerbook Settings Tweak 

This tool downloads a modified version of sys.config that dramatically reduces the "not found" issue that is affecting almost every Helium miner.

It sets the following values:

```
   {peerbook_update_interval, 90000},
   {max_inbound_connections, 200},
   {outbound_gossip_connections, 50},
```

These values have shown to increase the peer books size to around 200,000. In order to check to the current peer book size, you can run:

    sudo docker exec miner miner peer book -c



## Run the script

### Apply changes 

    wget https://raw.githubusercontent.com/inigoflores/pisces-p100-tools/main/setting_tweaks/apply.sh -O - | sudo bash

### Restore backup of sys.config 

    wget https://raw.githubusercontent.com/inigoflores/pisces-p100-tools/main/setting_tweaks/restore.sh -O - | sudo bash

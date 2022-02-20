# This is a collection of scripts useful for Pisces miners P100

# DISCLAIMER: Only use this scripts if you know what you are doing!!!


# Hot to run clear_resync.sh:
This script will clean blockchain data and the re-sync the hotspot using Nebra or SenseCAP snapshot based on which one is the closest to the actual blockchain height

wget https://raw.githubusercontent.com/moophlo/pisces-miner-scripts/main/clear_resync.sh -O - | sudo bash


# Hot to run crontab_job.sh:
This script will install in crontab a job that everyday at midnight will run a check on root filesystem free space left and if it's less than 20$ free will run the clean_resync.sh script

wget https://raw.githubusercontent.com/moophlo/pisces-miner-scripts/main/crontab_job.sh -O - | sudo bash


# Hot to run fixed_dns.sh:
This script will override the DNS servers pushed from the DHCP server in your LAN and will set the google DNS

wget https://raw.githubusercontent.com/moophlo/pisces-miner-scripts/main/fixed_dns.sh -O - | sudo bash


# How to upgrade clear_resync.sh and crontab_job.sh to latest version:

sudo wget https://raw.githubusercontent.com/moophlo/pisces-miner-scripts/main/clear_resync.sh -O /usr/bin/clear_resync.sh

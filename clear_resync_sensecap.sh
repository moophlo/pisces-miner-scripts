#!/bin/bash

SNAPSHOT=`curl --silent https://snapshots-wtf.sensecapmx.cloud/latest-snap.json|awk -F':' '{print $3}'| rev | cut -c2- | rev`
echo "Stopping the miner ..."
sudo docker stop miner
echo "Clearing blockchain data ..."
sudo rm -rf /home/pi/hnt/miner/blockchain.db
sudo rm -rf /home/pi/hnt/miner/ledger.db
echo "Starting the miner ..."
sudo docker start miner
echo "Downloading last available blockchain snapshot ..."
sudo wget https://snapshots-wtf.sensecapmx.cloud/snap-$SNAPSHOT -O /home/pi/hnt/miner/snap/snap-$SNAPSHOT
sleep 20
echo "Importing snapshot into the miner - this will take aproximately 20 minutes"
sudo sudo docker exec miner miner snapshot load /var/data/snap/snap-$SNAPSHOT
echo "You can safely ignore the timeout error!"

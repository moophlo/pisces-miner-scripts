#!/bin/bash

SNAPSHOT=`curl --silent https://helium-snapshots.nebra.com/latest.json|awk '{print $2}'| rev | cut -c2- | rev`
echo "Stopping the miner ..."
sudo docker stop miner
echo "Clearing blockchain data ..."
sudo rm -rf /home/pi/hnt/miner/blockchain.db/00*
sudo rm -rf /home/pi/hnt/miner/blockchain.db/01*
sudo rm -rf /home/pi/hnt/miner/blockchain.db/02*
sudo rm -rf /home/pi/hnt/miner/blockchain.db/03*
sudo rm -rf /home/pi/hnt/miner/blockchain.db/04*
sudo rm -rf /home/pi/hnt/miner/blockchain.db/05*
sudo rm -rf /home/pi/hnt/miner/blockchain.db/06*
sudo rm -rf /home/pi/hnt/miner/blockchain.db/*
sudo rm -rf /home/pi/hnt/miner/ledger.db/*
echo "Starting the miner ..."
sudo docker start miner
echo "Downloading last available blockchain snapshot ..."
sudo wget https://helium-snapshots.nebra.com/snap-$SNAPSHOT -O /home/pi/hnt/miner/snap/snap-$SNAPSHOT
echo "Importing snapshot into the miner - this will take aproximately 20 minutes"
sudo sudo docker exec miner miner snapshot load /var/data/snap/snap-$SNAPSHOT
echo "You can safely ignore the timeout error!"

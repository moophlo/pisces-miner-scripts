#!/bin/bash

SNAPSHOT_S=`curl --silent https://snapshots-wtf.sensecapmx.cloud/latest-snap.json|awk -F':' '{print $3}'| rev | cut -c2- | rev`
SNAPSHOT_N=`curl --silent https://helium-snapshots.nebra.com/latest.json|awk '{print $2}'| rev | cut -c2- | rev`


if [ $((SNAPSHOT_S)) -gt $((SNAPSHOT_N)) ]

then

  echo "Stopping the miner ..."
  sudo docker stop miner
  echo "Clearing blockchain data ..."
  sudo rm -rf /home/pi/hnt/miner/blockchain.db
  sudo rm -rf /home/pi/hnt/miner/ledger.db
  echo "Starting the miner ..."
  sudo docker start miner
  echo "Downloading last available blockchain snapshot from SenseCAP ..."
  sudo wget https://snapshots-wtf.sensecapmx.cloud/snap-$SNAPSHOT_S -O /home/pi/hnt/miner/snap/snap-$SNAPSHOT_S
  sleep 20
  echo "Importing snapshot into the miner - this will take aproximately 20 minutes"
  sudo sudo docker exec miner miner snapshot load /var/data/snap/snap-$SNAPSHOT_S
  echo "You can safely ignore the timeout error!"

else

  echo "Stopping the miner ..."
  sudo docker stop miner
  echo "Clearing blockchain data ..."
  sudo rm -rf /home/pi/hnt/miner/blockchain.db
  sudo rm -rf /home/pi/hnt/miner/ledger.db
  echo "Starting the miner ..."
  sudo docker start miner
  echo "Downloading last available blockchain snapshot from Nebra..."
  sudo wget https://helium-snapshots.nebra.com/snap-$SNAPSHOT_N -O /home/pi/hnt/miner/snap/snap-$SNAPSHOT_N
  sleep 20
  echo "Importing snapshot into the miner - this will take aproximately 20 minutes"
  sudo sudo docker exec miner miner snapshot load /var/data/snap/snap-$SNAPSHOT_N
  echo "You can safely ignore the timeout error!"

fi

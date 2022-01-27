#!/bin/bash



cat << 'EOF' > /usr/bin/clear_resync.sh
#!/bin/bash

SNAPSHOT=`curl --silent https://helium-snapshots.nebra.com/latest.json|awk '{print $2}'| rev | cut -c2- | rev`
echo "Stopping the miner ..."
sudo docker stop miner
echo "Clearing blockchain data ..."
sudo rm -rf /home/pi/hnt/miner/blockchain.db
sudo rm -rf /home/pi/hnt/miner/ledger.db
echo "Starting the miner ..."
sudo docker start miner
echo "Downloading last available blockchain snapshot ..."
sudo wget https://helium-snapshots.nebra.com/snap-$SNAPSHOT -O /home/pi/hnt/miner/snap/snap-$SNAPSHOT
sleep 20
echo "Importing snapshot into the miner - this will take aproximately 20 minutes"
sudo sudo docker exec miner miner snapshot load /var/data/snap/snap-$SNAPSHOT
echo "You can safely ignore the timeout error!"
EOF

chmod +x /usr/bin/clear_resync.sh

cat << 'EOF' > /usr/bin/fs_check.sh
#!/bin/bash

ACTUAL=`df -h /|grep -v File|awk '{print $5}'|rev|cut -c2-|rev`
TARGET=80

if [ $((ACTUAL)) -gt $((TARGET)) ]
then 
	/usr/bin/clear_resync.sh
fi
EOF

chmod +x /usr/bin/fs_check.sh

CRONTAB=/var/spool/cron/crontabs/root
if [ -f $CRONTAB ];
then
  echo "0 0 * * * /usr/bin/fs_check.sh" >> /var/spool/cron/crontabs/root
  systemctl restart cron.service
else
  echo "0 0 * * * /usr/bin/fs_check.sh" >> crontab_new
  crontab -u root crontab_new
  rm crontab_new
  systemctl restart cron.service
fi

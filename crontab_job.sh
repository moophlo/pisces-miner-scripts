#!/bin/bash

rm -f /usr/bin/clear_resync.sh

cat << 'EOF' > /usr/bin/clear_resync.sh
#!/bin/bash

SNAPSHOT_S=`curl --silent https://snapshots-wtf.sensecapmx.cloud/latest-snap.json|awk -F':' '{print $3}'| rev | cut -c2- | rev`
SNAPSHOT_N=`curl --silent https://helium-snapshots.nebra.com/latest.json|awk '{print $2}'| rev | cut -c2- | rev`


if [ $((SNAPSHOT_S)) -ge $((SNAPSHOT_N)) ]

then

minername=$(docker ps -a|grep miner|awk -F" " '{print $NF}')
newheight=`curl --silent https://snapshots-wtf.sensecapmx.cloud/latest-snap.json|awk -F':' '{print $3}'| rev | cut -c2- | rev`
echo "Snapshot height is $newheight";
echo "Stopping the miner... "
sudo docker stop $minername
echo "Clearing blockchain data... "
sudo rm -rf /home/pi/hnt/miner/blockchain.db
sudo rm -rf /home/pi/hnt/miner/ledger.db
echo -n "Starting the miner... "
sudo docker start $minername
filepath=/tmp/snap-$newheight;
if [ ! -f "$filepath" ]; then
  echo "Downloading latest snapshot from SenseCAP"
  wget -q --show-progress https://snapshots-wtf.sensecapmx.cloud/snap-$newheight -O /tmp/snap-$newheight
else
  modified=`stat -c %Y $filepath`
  now=`date +%s`
  longago=`expr $now - $modified`
  longagominutes=`expr $longago / 60`
  #NUM_SECS=`expr $HOW_LONG % 60`
  echo "Up-to-date snapshot already downloaded $longagominutes minutes ago"
  sleep 5; # Wait until the miner is fully functional
fi
echo -n "Pausing sync... "
sudo docker exec $minername sh -c 'export RELX_RPC_TIMEOUT=600; miner repair sync_pause'
echo -n "Cancelling pending sync... "
sudo docker exec $minername sh -c 'export RELX_RPC_TIMEOUT=600;miner repair sync_cancel'
echo "Start loading snap-$newheight at `date +%H:%M`. This can take up to 60 minutes"
sudo rm -f /home/pi/hnt/miner/snap/snap-*
sudo cp /tmp/snap-$newheight /home/pi/hnt/miner/snap/snap-$newheight
> /tmp/load_result
now=`date +%s`
((sudo docker exec $minername sh -c "export RELX_RPC_TIMEOUT=3600; miner snapshot load /var/data/snap/snap-$newheight > /tmp/load_result") > /dev/null 2>&1 &)
#(((sleep 30 && echo "ok") > /tmp/load_result) > /dev/null 2>&1 &)
while :
do
    result=$(cat /tmp/load_result);
    if [ "$result" = "ok" ]; then
       modified=`stat -c %Y /tmp/load_result`
       longago=`expr $modified - $now`
       longagominutes=`expr $longago / 60`
       echo " "
       echo "Snapshot loaded in $longagominutes minutes"
       sudo rm -f /home/pi/hnt/miner/snap/snap-$newheight
       rm /tmp/load_result
       echo -n "Resuming sync... "
       sudo docker exec $minername sh -c 'export RELX_RPC_TIMEOUT=600;miner repair sync_resume'
       echo "Done!"
       break;
    elif [ "$result" = "" ];then
       echo -n "."
    else
       echo "Error: Snapshot could not be loaded. Try again"
       break;
    fi
    sleep 120
done
else
minername=$(docker ps -a|grep miner|awk -F" " '{print $NF}')
newheight=`curl --silent https://helium-snapshots.nebra.com/latest.json|awk '{print $2}'| rev | cut -c2- | rev`
echo "Snapshot height is $newheight";
echo "Stopping the miner... "
sudo docker stop $minername
echo "Clearing blockchain data... "
sudo rm -rf /home/pi/hnt/miner/blockchain.db
sudo rm -rf /home/pi/hnt/miner/ledger.db
echo -n "Starting the miner... "
sudo docker start $minername
filepath=/tmp/snap-$newheight;
if [ ! -f "$filepath" ]; then
  echo "Downloading latest snapshot from Nebra"
  wget -q --show-progress https://helium-snapshots.nebra.com/snap-$newheight -O /tmp/snap-$newheight
else
  modified=`stat -c %Y $filepath`
  now=`date +%s`
  longago=`expr $now - $modified`
  longagominutes=`expr $longago / 60`
  #NUM_SECS=`expr $HOW_LONG % 60`
  echo "Up-to-date snapshot already downloaded $longagominutes minutes ago"
  sleep 5; # Wait until the miner is fully functional
fi
echo -n "Pausing sync... "
sudo docker exec $minername sh -c 'export RELX_RPC_TIMEOUT=600; miner repair sync_pause'
echo -n "Cancelling pending sync... "
sudo docker exec $minername sh -c 'export RELX_RPC_TIMEOUT=600;miner repair sync_cancel'
echo "Start loading snap-$newheight at `date +%H:%M`. This can take up to 60 minutes"
sudo rm -f /home/pi/hnt/miner/snap/snap-*
sudo cp /tmp/snap-$newheight /home/pi/hnt/miner/snap/snap-$newheight
> /tmp/load_result
now=`date +%s`
((sudo docker exec $minername sh -c "export RELX_RPC_TIMEOUT=3600; miner snapshot load /var/data/snap/snap-$newheight > /tmp/load_result") > /dev/null 2>&1 &)
#(((sleep 30 && echo "ok") > /tmp/load_result) > /dev/null 2>&1 &)
while :
do
    result=$(cat /tmp/load_result);
    if [ "$result" = "ok" ]; then
       modified=`stat -c %Y /tmp/load_result`
       longago=`expr $modified - $now`
       longagominutes=`expr $longago / 60`
       echo " "
       echo "Snapshot loaded in $longagominutes minutes"
       sudo rm -f /home/pi/hnt/miner/snap/snap-$newheight
       rm /tmp/load_result
       echo -n "Resuming sync... "
       sudo docker exec $minername sh -c 'export RELX_RPC_TIMEOUT=600;miner repair sync_resume'
       echo "Done!"
       break;
    elif [ "$result" = "" ];then
       echo -n "."
    else
       echo "Error: Snapshot could not be loaded. Try again"
       break;
    fi
    sleep 120
done
fi
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

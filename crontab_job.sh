#!/bin/bash

cat << 'EOF' > /usr/bin/fs_check.sh
#!/bin/bash

ACTUAL=`df -h /|grep -v File|awk '{print $5}'|rev|cut -c2-|rev`
TARGET=80

if [ $((ACTUAL)) -gt $((TARGET)) ]
then 
	wget https://raw.githubusercontent.com/moophlo/pisces-miner-scripts/main/clear_resync.sh -O - | bash 
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

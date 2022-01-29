#!/bin/bash

echo "Starting PPP"
pon pisces

while true
do
  sleep 300
  PUBLIC=1.2.3.4
  CURL=`curl ifconfig.co`
  if [ $PUBLIC != $CURL ]
  then
    echo "The public IP changed, probable problem with PPP. I will restart PPP"
    echo "Stopping PPP"
    poff pisces
    sleep 10
    pon pisces
    echo "Starting PPP ... again"
  fi
done

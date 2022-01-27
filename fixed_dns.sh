/etc/resolv.conf#!/bin/bash


echo "resolvconf=NO" >> /etc/resolvconf.conf

echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

dhclient -r

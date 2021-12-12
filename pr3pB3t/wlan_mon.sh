#!/bin/bash

#restarting the driver
echo "restarting the driver"
modprobe -r brcmfmac && modprobe brcmfmac

echo "deploy the access point"
P4wnP1_cli template deploy -w "AP_on"
echo "Power down the wifi"
P4wnP1_cli template deploy -w "AP_off"

echo "kill process"
airmon-ng check kill
echo "set wlan0 in monitor mode"
airmon-ng start wlan0

echo "starting Bettercap"
bettercap -iface wlan0mon -caplet pita.cap


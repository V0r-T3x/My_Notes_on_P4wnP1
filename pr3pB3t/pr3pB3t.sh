#!/bin/bash

#take two parameters
#1st -M for monitor mode and -m to manual mode
#2nd the number of the wlan to be use. natively I use the wlan0, then I write 0

# to start the monitor mode:
# ./pr3pB3t.sh -M 0
# to restart the Bettercap if I quit the prog I use:
# bettercap -iface wlan0mon -caplet pita
# to comeback to manual mode:
# ./pr3pB3t.sh -m 0

#verify if the parameter of the wireless interface is an integer
if [[ ${2} =~ ^[+-]?[0-9]+$ ]]
then

#echo "${1}"
iwtag=wlan${2}
mode=${1}
#echo ${iwtag}

if [ ${mode} == "-M" ] #Monitor Mode
then
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
   airmon-ng start ${iwtag}

   echo "starting Bettercap"
   bettercap -iface ${iwtag}mon -caplet pita

elif [ ${mode} == "-m" ] #Manual Mode
then
   echo "stop wlan0mon"
   airmon-ng stop ${iwtag}mon
   echo "starting avahi-daemon"
   service avahi-daemon start
   echo "starting wpa_supplicant"
   service wpa_supplicant start
   echo "starting dhcpcd"
   service dhcpcd start

   #restarting the driver
   echo "restarting the driver"
   modprobe -r brcmfmac && modprobe brcmfmac

   P4wnP1_cli template deploy -w AP-C_LAN_Archie
else
   echo "wrong parameter"
   exit 2
fi
fi

#!/bin/bash
echo "stop wlan0mon"
airmon-ng stop wlan0mon
echo "starting avahi-daemon"
service avahi-daemon start
echo "starting wpa_supplicant"
service wpa_supplicant start
echo "starting dhcpcd"
service dhcpcd start

#restarting the driver
echo "restarting the driver"
modprobe -r brcmfmac && modprobe brcmfmac

#echo "set power_saver on"
#iw wlan0 set power_save on
#iw wlan0 set power on

#echo "set wlan0 to managed"
#ip link set wlan0 down
#iw dev wlan0 set type managed
#ip link set wlan0 up

#echo "set power_saver on"
#iw wlan0 get power_save
#iw wlan0 set power_save on
#/sbin/iwconfig wlan0 power on

#IWCONFIG=/sbin/iwconfig
#WLAN_IFACE=wlan0

#if [ ! -x $IWCONFIG ]; then
#    exit 1
#fi
#
#if [ "$IFACE" = $WLAN_IFACE ]; then
#    $IWCONFIG $IFACE power on
#fi
#

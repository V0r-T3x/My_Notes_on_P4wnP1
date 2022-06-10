Attempt to install of P4wnP1 on the RPi02w
------
 *** *Notes only, no image available now* ***  

Thanks to [@lgeekj](https://github.com/lgeekjopt) to the modification of the P4wnP1 ( [@RoganDawes](https://github.com/rogandawes) [@mame82](https://github.com/mame82) ) files.
All infos come from a P4wnP1_aloa issus [here](https://github.com/RoganDawes/P4wnP1_aloa/issues/307)

The log of 'make dep / make compile / make installkali' is saved [here](https://github.com/V0r-T3x/My_Notes_on_P4wnP1/blob/main/logs/P4wnP1-rpiZ2.log)

----------------------------------------------------------------------------------------------------------
Corrected problems:
---------
1. There's a problem with bluetooth. report by me. The new kali img 2022.2 solve the problem.  
2. All features related to the nexmon firmware. [Nexmon support now the rpi02w](https://github.com/seemoo-lab/nexmon/)
   - Open Issue reported on the nexmon [github](https://github.com/seemoo-lab/nexmon/issues/500)

Anomalies:
1. `P4wnP1_cli led -b 0` is working but instead `0=OFF` and `>254=ON`, it is the opposite, `0=ON` and `>254=OFF`. Report by me.  

Problems reported:
---------
1. Problem with GPIO. report by [@beboxos](https://github.com/beboxos) on [twitter]( https://twitter.com/BeBoXoS/status/1482115934206758915 )
   - Hints by @mame82:
     - [SubSysGpio](https://github.com/RoganDawes/P4wnP1_aloa/blob/95de406b72cd1c66f987184a2f7455fcae337252/service/SubSysGpio.go#L62L70)
     - [p4wnp1_aloa_build_notes.md](https://github.com/RoganDawes/P4wnP1_aloa/blob/master/build_support/p4wnp1_aloa_build_notes.md)

additionnal problem notes by @mame82:

>Please also note that it is unlikely to get all features working, which rely on dedicated hardware:
>
>- wifi monitor mode + covert channel (manually modified firmware+kernel driver for Pi0w broadcom chip)
>- USB trigger (modified DWC2 kernel driver)
>
>Firmware patches for the RPi0w Broadcom chipset reside here (if you take a look into commit days, you will understand why I am not much of a help today)
>https://github.com/RoganDawes/nexmon_wifi_covert_channel/tree/p4wnp1/patches/bcm43430a1/7_45_41_46/nexmon/src

----------------------------------------------------------------------------------------------------------
Additionnal notes  
----------
- GPIO depends on the periph.io golang librairy. _[I opened an issue on the periph.io git page](https://github.com/periph/conn/issues/21)_.
Possible fix:
---------
-Changing the old source path of periph.io into these two files:  
-1.
```
GitHub\P4wnP1_aloa\service\SubSysGpio.go
```
-from this:
```
"periph.io/x/periph"
"periph.io/x/periph/conn/gpio"
"periph.io/x/periph/conn/gpio/gpioreg"
"periph.io/x/periph/conn/pin/pinreg"
"periph.io/x/periph/host"
"periph.io/x/periph/host/rpi"
```
-to this:
```
"periph.io/x/conn/v3"
"periph.io/x/conn/v3/gpio"
"periph.io/x/conn/v3/gpio/gpioreg"
"periph.io/x/conn/v3/pin/pinreg"
"periph.io/x/host/v3"
"periph.io/x/host/v3/rpi"
```
-2.
```
GitHub\P4wnP1_aloa\service\pgpio\p4wnp1gpio.go
```
- from this:
```
"periph.io/x/periph/conn/gpio"
"periph.io/x/periph/conn/physic"
```
- to this:
```
"periph.io/x/conn/v3/gpio"
"periph.io/x/conn/v3/physic"
```

- Original Package version on the P4wnP1 aloa rpi0w
- P4wnP1 v0.1.1 "2020-02-06" https://github.com/RoganDawes/P4wnP1_aloa/tags
- Golang v1.10-v1.13  "2019-09-03" https://en.wikipedia.org/wiki/Go_(programming_language)
- periph.io v3.6.2 "" https://periph.io/news/
----------------------------------------------------------------------------------------------------------

Step list for this img:
----------
*** All the steps were apply by the root accout *_(I saw @lgeekj note after to not use sudo to make dep)_* ***  
- I started with Kali non pi-tail [img](https://kali.download/arm-images/kali-2022.2/kali-linux-2022.2-raspberry-pi-zero-2-w-armhf.img.xz) for rpi02w  
- Add ssh file to boot  
- Connect to the pi with OTG keyboard/mouse and hdmi  
- become super user:  
```
sudo su
```
- Create password for the root account:  
```
passwd
```
-Delete user kali
```
userdel -r kali
```
- Enable root login over SSH:  
```
nano /etc/ssh/sshd_config
```
- Change `PermitRootLogin no` to `PermitRootLogin yes`.  
- Restart the SSH server:   
```
service sshd restart
```
- Change date, time and timezone:  
```
dpkg-reconfigure tzdata  
date --set ****-**-**  
date --set **:**:**  
```
- Use `kalipi-config` to expand the filesystem  
> 07 Advanced Options > A1 Expand Filesystem  
- Use `kalipi-config` to enable auto login in terminal mode on boot  
> 03 Boot Options > B1 Desktop / CLI > B2 Console Autologin > (Leave empty) > OK >  
- Use `kalipi-config` to connect to Wi-Fi  
> 02 Network Options > N2 Wi-fi > ...   
- Use `kalipi-config` to enable SPI & I2C  
> 05 Interfacing Options > P3 SPI > Would you like the SPI interface to be enabled? > Yes  
> 05 Interfacing Options > P4 I2C > Would you like the I2C interface to be enabled? > Yes  
- Reboot  
- Connect to ssh  
- Updating and upgrading  
```
apt update
apt upgrade
``` 
- Clone P4wnP1 github and go inside the folder:  
```
git clone https://github.com/lgeekjopt/P4wnP1_aloa
cp -r P4wnP1_aloa P4wnP1
rm -r P4wnP1_aloa
cd P4wnP1  
```
- Replace `GitHub\P4wnP1_aloa\service\SubSysGpio.go` & `GitHub\P4wnP1_aloa\service\pgpio\p4wnp1gpio.go`  
- Install dependencies, compile and install P4wnP1 (make compile probably will give error but just continue):  
- All the log is [here](https://github.com/V0r-T3x/My_Notes_on_P4wnP1/blob/main/logs/P4wnP1-rpiZ2-2022-05-27.log)  
```
make dep  
make compile  
make installkali  
```
- Install librairies for the BCM2835  
```
cd ..
wget http://www.airspayce.com/mikem/bcm2835/bcm2835-1.68.tar.gz  
tar zxvf bcm2835-1.68.tar.gz  
cd bcm2835-1.68/  
./configure && make && make check && make install  
```
- Install font
```
apt-get install ttf-wqy-zenhei  
```
- Install pip3
```
apt-get install python3-pip  
```
- Install RPi.GPIO
``` 
pip3 install RPi.GPIO  
```
- Install cmake
```
apt-get install cmake -y  
```
- Install 7zip
```
apt-get install p7zip-full  
```
- Move to the root folder
```
sudo su
cd ~  
```
- Install FBCP driver
```
wget https://www.waveshare.com/w/upload/f/f9/Waveshare_fbcp.7z  
7z x Waveshare_fbcp.7z -o./waveshare_fbcp  
cd waveshare_fbcp  
mkdir build  
cd build  
cmake -DSPI_BUS_CLOCK_DIVISOR=20 -DWAVESHARE_1INCH3_LCD_HAT=ON -DBACKLIGHT_CONTROL=ON -DSTATISTICS=0 ..  
make -j  
./fbcp  
```
-Quit the script with `CTRL+C`  
- Auto-start when Power on  
```
cp ~/waveshare_fbcp/build/fbcp /usr/local/bin/fbcp  
```
- Create new file  
```
nano /etc/rc.local  
```
- Write it inside:  
```
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

fbcp&
exit 0
```
- Make it executable
```
chmod +x /etc/rc.local  
```
- Set the display resolution  
```
nano /boot/config.txt  
```
- Then add the following lines at the end of the config.txt.  
```
hdmi_force_hotplug=1  
hdmi_cvt=300 300 60 1 0 0 0  
hdmi_group=2  
hdmi_mode=87  
display_rotate=0  
```
- And reboot the system
```
reboot now
```

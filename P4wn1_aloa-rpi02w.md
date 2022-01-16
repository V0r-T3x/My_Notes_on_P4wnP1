Attempt to install of P4wnP1 on the RPi02w
------
 *** *Warning: this img is full of bug and is for test and dev purpose* ***  
You can download an img create with these steps [here](https://mega.nz/file/GeBDVAAA#D4ObqjifovAYeAVQE9hv18dck8DZflD44Ct7ldrarv4)  

>login: kali  
>password: kali

The img is ~12gb and is compressed to <4gb for download purpose.

Thanks to [@lgeekj](https://github.com/lgeekj) to the modification of the P4wnP1 ( [@RoganDawes](https://github.com/rogandawes) [@mame82](https://github.com/mame82) ) files.
All infos come from a P4wnP1_aloa issus [here](https://github.com/RoganDawes/P4wnP1_aloa/issues/307)

The log of 'make dep / make compile / make installkali' is saved [here](https://github.com/V0r-T3x/My_Notes_on_P4wnP1/blob/main/P4wnP1-rpiZ2.log)

----------------------------------------------------------------------------------------------------------

Problems reported:
---------
1. There's a problem with bluetooth. report by me.
2. Problem with GPIO. report by [@beboxos](https://github.com/beboxos) on [twitter]( https://twitter.com/BeBoXoS/status/1482115934206758915 )
   - Hints by @mame82:
     - [SubSysGpio](https://github.com/RoganDawes/P4wnP1_aloa/blob/95de406b72cd1c66f987184a2f7455fcae337252/service/SubSysGpio.go#L62L70)
     - [p4wnp1_aloa_build_notes.md](https://github.com/RoganDawes/P4wnP1_aloa/blob/master/build_support/p4wnp1_aloa_build_notes.md)
     - Maybe the [PGPIO golang librairy](https://github.com/warthog618/gpio) is in fault.  It's replaced by [GPIOD](https://github.com/warthog618/gpiod).  ![PGPIO comparaison](/images/pgpio.png)
4. `P4wnP1_cli led -b 0` is not working. No folder at `/sys/class/leds/led0` too. Report by me.
3. All features related to the nexmon firmware
   - Open Issue reported on the nexmon [github](https://github.com/seemoo-lab/nexmon/issues/500)

additionnal problem notes by @mame82:

>Please also note that it is unlikely to get all features working, which rely on dedicated hardware:
>
>- wifi monitor mode + covert channel (manually modified firmware+kernel driver for Pi0w broadcom chip)
>- USB trigger (modified DWC2 kernel driver)
>
>Firmware patches for the RPi0w Broadcom chipset reside here (if you take a look into commit days, you will understand why I am not much of a help today)
>https://github.com/RoganDawes/nexmon_wifi_covert_channel/tree/p4wnp1/patches/bcm43430a1/7_45_41_46/nexmon/src

----------------------------------------------------------------------------------------------------------

Step list for this img:
----------
*** All the steps were apply by the root accout *_(I saw @lgeekj note after to not use sudo to make dep)_* ***  
- I started with Kali non pi-tail [img](https://kali.download/arm-images/kali-2021.4/kali-linux-2021.4-rpi-zero-2-w-armhf.img.xz) for rpi02w  
- Add ssh file to boot  
- Connect to the pi with OTG keyboard/mouse and hdmi  
- Change date, time and timezone:
```
dpkg-reconfigure tzdata  
date --set ****-**-**  
date --set **:**:**  
```
- Use `kalipi-config` to connect to Wi-Fi  
> 02 Network options > N2 Wi-fi > ...  
- Connect to ssh  
- Clone P4wnP1 github and go inside the folder:
```
git clone https://github.com/lgeekj/P4wnP1  
cd P4wnP1  
```
- Install dependencies, compile and install P4wnP1 (make compile probably will give error but just continue):
```
make dep  
make compile  
make installkali  
```
- Use `kalipi-config` to enable SPI  
>05 Interfacing Options > P3 SPI > Would you like the SPI interface to be enabled? > Yes  
- Install the Framebuffer  
   - open /etc/modules
```
nano /etc/modules
```
   - Add this to the /etc/modules
```
spi-bcm2835  
fbtft_device  
```
- Creating a new file for fbtft configuration  
```
nano /etc/modprobe.d/fbtft.conf
```
   - Adding this to the file:
```
# /etc/modprobe.d/fbtft.conf  
   options fbtft_device name=adafruit18_green   
   gpios=reset:27,dc:25,cs:8,led:24 speed=40000000 bgr=1 fps=60 custom=1 height=240 width=240 rotate=180  
```
- Install librairies for the BCM2835  
```
wget http://www.airspayce.com/mikem/bcm2835/bcm2835-1.68.tar.gz  
tar zxvf bcm2835-1.68.tar.gz  
cd bcm2835-1.68/  
./configure && sudo make && sudo make check && sudo make install  
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

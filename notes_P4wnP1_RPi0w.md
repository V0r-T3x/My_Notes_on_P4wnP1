My_Notes_on_P4wnP1 WIP
------------
My personnal notes on the P4wnP1

- flash a microSDHC class 10 minimum (32go or 64go) I use 16go for tests
- with P4wnP1 v0.1.1 with oled drivers and menu preinstalled with Win32disk Beboxos
[img](https://mega.nz/#!YYtS2S6A!Q5OgMvLUtAM_x7jt7vBTY8Zu8lHdyyPoaLdsipVufWg)

- connect to P4wnP1 on usbeth or wifi AP
```
usbeth: 172.16.0.1:8000
wifi AP: 172.24.0.1:8000
```
- restore the database of the P4wnP1 with the custom.db
- reboot to apply changes

- change message of the day, welcome text
```
nano /etc/motd
```
- set a nicer hostname :D
```
hostname -b aloa
#echo aloa > /etc/hostname
nano /etc/hostname
#echo "127.0.0.1 aloa" >> /etc/hosts
nano /etc/hosts
```
- adding CMS.json in keymaps into /usr/local/P4wnP1/keymaps
- adding HIDScripts into /usr/local/P4wnP1/HIDScripts

- add repo re4son-kernel
```
echo "deb http://http.re4son-kernel.com/re4son/ kali-pi main" > /etc/apt/sources.list.d/re4son.list
wget -O - https://re4son-kernel.com/keys/http/archive-key.asc | apt-key add -
apt update
```
- install a few useful packages and setup swap
```
apt install git dphys-swapfile
```
- set CONF_SWAPSIZE to 3072
```
nano /etc/dphys-swapfile
```
- enable swapfile
```
systemctl enable dphys-swapfile
```
- set the correct timezone
```
dpkg-reconfigure tzdata
```
- reboot to apply the effects (reboot take little time)
```
reboot
```
-------------------backup ALOA_2021-08-13-clean-------------------------------------

- install checkinstall to manage 'make' package
```
apt-get install checkinstall
```
- installing Bettercap
- install dependencies
```
apt-get install gcc-9-base libgcc-9-dev libc6-dev
```
- reinstall python to use the OLED screen
```
apt-get install python
apt-get install golang libpcap-dev libnetfilter-queue-dev wget build-essential libusb-1.0-0-dev
```
- you should make this persistent in your .bashrc or .zshrc file
```
nano /root/.bashrc
```
- add this line to the .bashrc
```
export GOPATH=/root/gocode
```
- exit SSH and reconnect
```
mkdir -p $GOPATH
```
-------------------backup ALOA_2021-08-14-before-bettercap-------------------------------------

- make a directory to extract bettercap 2.3.0 to work with Pi0
```
mkdir /root/tools/bettercap
cd /root/tools/bettercap
```
- donwload and install bettercat 2.3.*
```
wget https://github.com/bettercap/bettercap/archive/refs/tags/v2.30.2.tar.gz
tar -xf v2.30.2.tar.gz
cd bettercap-2.30.2
make
mkdir /usr/local/share/bettercap
checkinstall
```
- new package at /root/tools/bettercap/bettercap-2.30.2/bettercap_2.30.2-1_armel.deb
- you can remove from your system with dpkg -r bettercap
-installing the caplets and updates
```
bettercap -eval "caplets.update; ui.update; q"
```
- downgrade libpcap to 1.9.1-4 to use with the Broadcom bcm2835 chipset
- make a directory for libpcap
```
mkdir /root/tools/libpcap
cd /root/tools/libpcap
```
- download the libpcap0.8 and libpcap-dev .deb
```
wget http://old.kali.org/kali/pool/main/libp/libpcap/libpcap0.8_1.9.1-4_armel.deb
```
- install libpcap 1.9.1
```
dpkg -i libpcap0.8_1.9.1-4_armel.deb
```
- change pita file
```
nano /usr/local/share/bettercap/caplets/pita.cap
```
- comment this two line
```
#!monstop
#!monstart
```
- import /root/pr3pB3t.sh to test the setting of bettercap and wlan0mon
- make it executable
```
chmod 755 /root/pr3pB3t.sh
```
-------------------backup ALOA_2021-08-14-after-bettercap-------------------------------------

- installing the bettercap.service
- adding /etc/systemd/system/bettercap.service
- adding /usr/bin/bettercap-launcher
- adding /usr/bin/bettercap-unlauncher
- make them executable
```
chmod 644 /etc/systemd/system/bettercap.service
chmod 755 /usr/bin/bettercap-launcher
chmod 755 /usr/bin/bettercap-unlauncher
```

- set up a reverse SSH tunnel
- create a connection without need of password
- generate the authorization key (/root/.ssh/id_rsa) don't enter password
```
ssh-keygen
```
- no passphrase
- copy the key to the local server
```
ssh-copy-id -i ~/.ssh/id_rsa.pub -p512 yoursite.com 
```
- connect to the local server to verify if it don't need password
```
ssh -p512 yoursite.com
```
- a trigger is added to the P4wnP1.
- TRIGGER ACTIONS > ADD ONE > Enabled > joined existing WiFi > run a bash script > rssh.sh

-------------------backup ALOA_2021-08-14_2-------------------------------------

- Installing LAMP server
- updating the libpcap0.8 to the v.1.10.0
```
apt-get install libpcap0.8
```
- install dependencieapt
```
apt-get install lsb-release
```
- installing mysql
```
apt-get install mariadb-server
```
- configurating the installation of mysql
```
service mysql start
mysql_secure_installation
```
- response: n,n,y,y,y,y
- installing php last version (7.4)
```
apt-get -y install php libapache2-mod-php
```
- enabling the headers mod of apache2
```
a2enmod headers
```
- custom the 000-default.conf 
```
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

	<Directory /var/www/html>
		Order Allow,Deny
		Allow from all
		AllowOverride all
		Header set Access-Control-Allow-Origin "*"
	</Directory>

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```
- give privileges to apache2 to write into the html folder and save folder
```
chown -R www-data:www-data /var/www/html
chown -R www-data:www-data /var/www/html/save
```
- starting the apache2 service
```
systemctl start apache2
```
- downgrading the libpcap0.8
```
cd /root/tools/libpcap
dpkg -i libpcap0.8_1.9.1-4_armel.deb
```
- adding the tails-amd64-4.20.iso to the if we can boot on it (not seems to work)
- TRIGGER ACTIONS > ADD ONE > Enabled > on the service start > run a bash script > apache2.sh

-------------------backup ALOA_2021-08-14_3-------------------------------------

- installing macchanger to spoof the mac address
```
apt install macchanger
```
- cmd to randomize the mac address, -r followed by the device name
```
macchanger -r wlan0
```
- cmd to specify the mac address, -m followed by the specific mac addres followed by the device name
```
macchanger -m b2:aa:0e:56:ed:f7 wlan0
```
- download the libpcap0.8 1.10.0-2 to switch between the two while using bettercap
```
cd /root/tools/libpcap
wget http://ftp.ca.debian.org/debian/pool/main/libp/libpcap/libpcap0.8_1.10.0-2_armel.deb
```
- adding return to the AP-C_LAN_Archie template when stopping the bettercap service
```
P4wnP1_cli template deploy -w AP-C_LAN_Archie
```
- update and upgrade of kali
```
apt update
apt upgrade
```

-------------------backup ALOA_2021-08-19_0-------------------------------------

- installing kismet to scan and find breaches into wifi network suggestion of decapitator
```
apt install kismet
kismet
```
- go to localhost:2501
- set the login password

- installing airgeddon to make and evil twin on the suggestion of decapitator
```
apt install airgeddon
apt install isc-dhcp-server
apt-get install lighttpd
apt-get install mdk3 mdk4
apt-get install nftables
apt-get install hostapd-wpe
    openssl pkcs12 -in client.p12 -out client.pem -passin pass:'whatever' -passout pass:'whatever'
    cp client.pem 'user@example.org'.pem
apt-get install hcxdumptool
apt-get install asleep
apt-get install ettercap-text-only
apt-get install hcxtools
apt-get install pixiewps
apt-get install reaver
apt-get install bully
```
- change xterm to tmux
```
nano /usr/share/airgeddon/.airgeddonrc
```
- Available values: xterm, tmux - Define the needed tool to be used for windows handling - Default value xterm
```
#AIRGEDDON_WINDOWS_HANDLING=xterm
AIRGEDDON_WINDOWS_HANDLING=tmux
```
- installig hashcat
```
cd /root/tools/
git clone https://github.com/hashcat/hashcat.git
cd hashcat
apt build-dep hashcat
git submodule update --init
mkdir /usr/local/share/doc
make
```
- *checkinstall have problem with temporary files
- install with make install
```
make install
```
-------------------backup ALOA_2021-08-22_0-------------------------------------

- install ccze to have data more comprehensive with airgeddon
```
apt-get install ccze
```

- installing Beef-xss
```
apt-get install python g++ make checkinstall fakeroot
```
- create temporary folder
```
src=$(mktemp -d) && cd $src
```
- download node.js
```
mkdir /root/tools/nodejs
cd /root/tools/nodejs
curl -k -o node-v11.9.0-linux-armv61.tar.gz https://nodejs.org/dist/v11.9.0/node-v11.9.0-linux-armv6l.tar.gz
tar -xzf node-v11.9.0-linux-armv61.tar.gz
cp -r node-v11.9.0-linux-armv6l/* /usr/local
```
- script to install nodejs (but not work actually)
```
sudo wget -O - https://raw.githubusercontent.com/audstanley/NodeJs-Raspberry-Pi/master/Install-Node.sh | bash;
wget -O - https://raw.githubusercontent.com/audstanley/NodeJs-Raspberry-Pi/master/Install-Node.sh | sudo bash
```

-liberate the port 67-68 for airgeddon
```
tcpdump -i eth0 -pvn port 67 and port 68
```
- problems to install beef
- beef-project not find
```
beef-xss
   beef-xss : Depends: ruby-execjs but it is not going to be installed
            Depends: ruby-uglifier (>= 2.2.1) but it is not going to be installed
            ruby-execjs : Depends: nodejs but it is not installable (nodejs not find)
```

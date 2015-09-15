#!/bin/bash

#Bombs out on any error
set +e

#Shows you each command and the result
set +x

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confnew" \
--force-yes -fuy dist-upgrade

touch /root/test


sudo su -
apt-get update && apt-get dist-upgrade -yf

apt-get install redis-server -yf

echo justin-crabb.hack.local > /etc/hostname

useradd larry && useradd moe && useradd curly
passwd larry -d && passwd moe -d && passwd curly -d

echo "moe ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

usermod -s /bin/false larry

apt-get install nginx -yf

echo EDITOR=vim >> /etc/profile

add-apt-repository ppa:webupd8team/java -y
apt-get update

# Automates accepting of Oracle license before installation
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | /usr/bin/debconf-set-selections

apt-get install oracle-java8-installer -yfq

# THIS MAY BE WRONG
apt-get install ntpdate -yf

# MAY NEED MORE WORK
apt-get install dnsmasq -yf

# Use system as DNS cache - MAY BE WRONG
echo listen-address=127.0.0.1 >> /etc/dnsmasq.conf
echo no-dhcp-interface=lo >> /etc/dnsmasq.conf

echo 127.0.1.1 ironman >> /etc/hosts
echo 127.0.1.2 hawkeye >> /etc/hosts
echo 127.0.1.3 hulk >> /etc/hosts

# Makes hack.local default search domain
echo search hack.local >> /etc/resolv.conf

# Write protects dns resolver because dhcp resets it
chattr +i /etc/resolv.conf

apt-get update

# Removes password popup for root while installing MYSQL
echo "mysql-server mysql-server/root_password select qqq111" | debconf-set-selections 
echo "mysql-server mysql-server/root_password_again select qqq111" | debconf-set-selections

apt-get install mysql-server-5.6 -yf

# Firewall default deny all rules
ufw default deny outgoing
ufw default deny incoming

# Firewall allow rule
ufw allow proto tcp to port 22
#ufw allow proto tcp from any port 22

# Remove current timezone and sets it for UTC timezone
rm /etc/localtime
ln -s /usr/share/zoneinfo/UTC /etc/localtime

# Lists all installed packages
dpkg --get-selections >> /root/inventory

# Touches hi file every minute as part of a cronjob
echo "* * * * * root touch /root/hi" >> /etc/crontab

# Installs multiple packages
apt-get install unison curl git-core unzip tmux htop sysstat -yf

dd if=/dev/zero of=/root/onesparse bs=1 count=0 seek=1GB
mkfs.ext3 -qF /root/onesparse 
# Should mount via fstab
echo "/root/onesparse /mnt/VOL1 ext3 auto,defaults 0 0" >> /etc/fstab


# Creates three 1gb sparse files
dd if=/dev/zero of=/root/twoAsparse bs=1 count=0 seek=1GB
dd if=/dev/zero of=/root/twoBsparse bs=1 count=0 seek=1GB
dd if=/dev/zero of=/root/twoCsparse bs=1 count=0 seek=1GB

# Need this to manage LVM ??
apt-get install lvm2 -yf



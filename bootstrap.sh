#!/bin/bash

#Bombs out on any error
set +e

#Shows you each command and the result
set +x

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confnew" \
--force-yes -fuy dist-upgrade

touch /root/test


# My scripting starts here - Justin Crabb

# Raises to root
sudo su -

# Updates and upgrades
apt-get update && apt-get upgrade -yf && apt-get dist-upgrade -yf

# Installs redis-server
apt-get install redis-server -yf

# Changes hostname and domain
echo "justin-crabb.hack.local" > /etc/hostname

# Creates three users and disables interactive login
useradd larry && useradd moe && useradd curly
passwd larry -d && passwd moe -d && passwd curly -d

# Lets moe use sudo without password
echo "moe ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Changes shell for larry
usermod -s /bin/false larry

# Install nginx webserer
apt-get install nginx -yf

# Makes vim default editor ----NOT WORKING
echo "EDITOR=vim" >> /etc/profile

# Adds repo for Java install
# add-apt-repository ppa:webupd8team/java -y
# apt-get update

# Automates accepting of Oracle license before installation
# echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | /usr/bin/debconf-set-selections

# apt-get install oracle-java8-installer -yfq

# THIS MAY BE WRONG
apt-get install ntpdate -yf

# MAY NEED MORE WORK
apt-get install dnsmasq -yf

# Use system as DNS cache - MAY BE WRONG
# echo "listen-address=127.0.0.1" >> /etc/dnsmasq.conf
# echo "no-dhcp-interface=lo" >> /etc/dnsmasq.conf
dnsmasq -a 127.0.0.1

# Creates entries in hosts file
echo "127.0.1.1 ironman" >> /etc/hosts
echo "127.0.1.2 hawkeye" >> /etc/hosts
echo "127.0.1.3 hulk" >> /etc/hosts

# Makes hack.local default search domain
echo "search hack.local" >> /etc/resolv.conf

# Write protects dns resolver because dhcp resets it
chattr +i /etc/resolv.conf

apt-get update

# Removes password popup for root while installing MYSQL
echo "mysql-server mysql-server/root_password select qqq111" | debconf-set-selections 
echo "mysql-server mysql-server/root_password_again select qqq111" | debconf-set-selections

# Installs mysql
apt-get install mysql-server-5.6 -yf

# Firewall default deny all rules
ufw default deny outgoing
ufw default deny incoming

# Firewall allow rule
ufw allow 22/tcp
echo "y" | ufw enable

# Remove current timezone and sets it for UTC timezone
rm /etc/localtime
ln -s /usr/share/zoneinfo/UTC /etc/localtime

# Lists all installed packages
dpkg --get-selections >> /root/inventory

# Touches hi file every minute as part of a cronjob
echo "* * * * * root touch /root/hi" >> /etc/crontab

# Installs multiple packages
apt-get install unison curl git-core unzip tmux htop sysstat -yf

# Creates one 1gb sparse file and formats it
dd if=/dev/zero of=/root/onesparse bs=1 count=0 seek=1GB
mkfs.ext3 -qF /root/onesparse

# Creates entry in fstab for mounting
echo "/root/onesparse /mnt/VOL1 ext3 auto,defaults 0 0" >> /etc/fstab

# Creates three 1gb sparse files
dd if=/dev/zero of=/root/twoAsparse bs=1 count=0 seek=1GB
dd if=/dev/zero of=/root/twoBsparse bs=1 count=0 seek=1GB
dd if=/dev/zero of=/root/twoCsparse bs=1 count=0 seek=1GB

# Creates two 1gb sparse files
dd if=/dev/zero of=/root/threeAsparse bs=1 count=0 seek=1GB
dd if=/dev/zero of=/root/threeBsparse bs=1 count=0 seek=1GB

# Need this to manage LVM
apt-get install lvm2 -yf
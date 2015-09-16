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
# echo "EDITOR=vim" >> /etc/profile
update-alternatives --set editor /usr/bin/vim.basic

# Adds repo for Java install
# add-apt-repository ppa:webupd8team/java -y
# apt-get update

# Automates accepting of Oracle license before installation
# echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | /usr/bin/debconf-set-selections

# apt-get install oracle-java8-installer -yfq

# THIS MAY BE WRONG
apt-get install ntp -yf

# MAY NEED MORE WORK
apt-get install dnsmasq -yf

# Use system as DNS cache - MAY BE WRONG
dnsmasq -a 127.0.0.1

# Creates entries in hosts file
echo "127.0.1.1 ironman" >> /etc/hosts
echo "127.0.1.2 hawkeye" >> /etc/hosts
echo "127.0.1.3 hulk" >> /etc/hosts

# Makes hack.local default search domain
echo "search hack.local" >> /etc/resolv.conf

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

# Need this to manage LVM
apt-get install lvm2 -yf

# Creates one 1gb sparse file and formats it
dd if=/dev/zero of=/root/onesparse bs=1 count=0 seek=1GB
mkfs.ext3 -qF /root/onesparse

# Creates entry in fstab for mounting
echo "/root/onesparse /mnt/VOL1 ext3 auto,defaults 0 0" >> /etc/fstab
mkdir /mnt/VOL1
mount -a

# Creates three 1gb sparse files
dd if=/dev/zero of=/root/twoAsparse bs=1 count=0 seek=1GB
dd if=/dev/zero of=/root/twoBsparse bs=1 count=0 seek=1GB
dd if=/dev/zero of=/root/twoCsparse bs=1 count=0 seek=1GB

losetup -f ~/twoAsparse && losetup -f ~/twoBsparse && losetup -f ~/twoCsparse

# LVM stuff

pvcreate /dev/loop1
pvcreate /dev/loop2
pvcreate /dev/loop3

vgcreate vg-awesome /dev/loop1 /dev/loop2 /dev/loop3

lvcreate -l 100%FREE vg-awesome -n lv-awesomer

mkfs.ext4 -qF /dev/vg-awesome/lv-awesomer

# Creates entry in fstab for mounting
echo "/dev/vg-awesome/lv-awesomer /mnt/VOL2 ext4 auto,defaults 0 0" >> /etc/fstab
mkdir /mnt/VOL2
mount -a

# Creates two 1gb sparse files
dd if=/dev/zero of=/root/threeAsparse bs=1 count=0 seek=1GB
dd if=/dev/zero of=/root/threeBsparse bs=1 count=0 seek=1GB

losetup -f ~/threeAsparse && losetup -f ~/threeBsparse

echo "mdadm mdadm/mail_to string  root" | debconf-set-selections
echo "mdadm mdadm/initrdstart string  all" | debconf-set-selections
echo "mdadm mdadm/autostart boolean true" | debconf-set-selections
echo "mdadm mdadm/autocheck boolean true" | debconf-set-selections
echo "mdadm mdadm/initrdstart_notinconf boolean false" | debconf-set-selections
echo "mdadm mdadm/start_daemon  boolean true" | debconf-set-selections
apt-get -y install mdadm --no-install-recommends

y | mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/loop{4,5}

mkfs.ext4 -qF /dev/md0

echo "/dev/md0 /mnt/VOL3 ext4 auto,defaults 0 0" >> /etc/fstab
mkdir /mnt/VOL3
mount -a

echo "root hard nofile unlimited" >> /etc/security/limits.conf

# Write protects dns resolver because dhcp resets it
chattr +i /etc/resolv.conf
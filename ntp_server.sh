#! /bin/bash 
# Author: Meher
# Description: this is a short script to configure an NTP server on any RedHat Distro
read -p "Enter subnet IP address :  "   ip_add
read -p "Enter netmask in CIDR notation :  "  netmask
value=$ip_add/$netmask 
echo "allow $value" >> /etc/chrony.conf

sed -i 's/^pool 2/#&/' /etc/chrony.conf

firewall-cmd --add-service ntp --permanent
firewall-cmd reload

systemctl restart --now chronyd

if [ $? -eq 0 ] ; then 
       echo " your server is ready "	
else 
	echo " wrong input, check again "
fi 


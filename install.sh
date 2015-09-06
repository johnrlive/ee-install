#!/bin/bash

script_runner=$(whoami)

if [ $script_runner == "root" ] ; then
  echo -e "\nFor security reasons this script must be run as a normal user with sudo privileges\n"
  exit 1
fi

clear
echo '[Wellcome to ee-install script]'
echo '(setup can take more 5 minutes)'


#Start install prerequisite
echo '[###### Update server ######]'
sleep 1
sudo apt-get -y update
sudo apt-get -y upgrade
echo '[###### Done ######]'
sleep 1


echo '[###### Install utility tool ######]'
sleep 1
sudo apt-get install -y mc
sudo apt-get install -y aptitude
echo '[###### Done ######]'
sleep 1


echo '[###### Install EasyEngine ######]'
sleep 1
wget -qO ee rt.cx/ee && sudo bash ee
echo '[###### Done ######]'
sleep 1

echo '[###### Install EasyEngine Stacks ######]'
sleep 1
sudo ee stack install --phpmyadmin
sudo ee stack install --phpredisadmin
echo '[###### Done ######]'
sleep 1


echo '[###### Install Fail2ban ######]'
sleep 1
sudo apt-get install -y fail2ban
sudo cp -f nginx-req-limit.conf /etc/fail2ban/filter.d/nginx-req-limit.conf
sudo cp -f jail.local /etc/fail2ban/jail.local
sudo service fail2ban restart
echo '[###### Done ######]'
sleep 1


echo '[###### Adds bash_profile with aliases ######]'
sleep 1
sudo cp -f .profile ~/.profile
source ~/.profile
echo '[###### Done #####]'
sleep 1


echo '[###### Setup Unattended Updates ######]'
sleep 1
sudo apt-get install unattended-upgrades
sudo cp -f 10periodic /etc/apt/apt.conf.d/10periodic
sudo cp -f 50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades
echo '[###### Done #####]'
sleep 1


echo '[###### Adds bash_profile with aliases ######]'
sleep 1
sudo apt-get install logwatch
sudo vim /etc/cron.daily/00logwatch
echo 'add this line: /usr/sbin/logwatch --output mail --mailto test@gmail.com --detail high'
echo '[###### Done #####]'
sleep 1

exit

#!/bin/bash

source  script/common.sh
COMPONENT=frontend

DIR="/usr/share/nginx/html"

PRINT "Installing Nginx"
yum install nginx -y
STAT "$?"  "Nginx Installation"


PRINT "Download File to tmp"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
STAT "$?" "Download"

PRINT "Change Directory"
cd $DIR
if [ -d "$DIR" ]; then
    echo "--------------------------------------------------------------------------------------------------------"
    echo -e "\e[1;32m [SUCCESS] Directory Changed\e[0m"
    echo "--------------------------------------------------------------------------------------------------------"
    pwd
else
    echo "--------------------------------------------------------------------------------------------------------"
    echo -e "\e[1;31m [ERROR] Cant find the /usr/share/nginx/html directory\e[0m"
    echo "--------------------------------------------------------------------------------------------------------"
    exit 2
fi

PRINT "Deleting all in $DIR"
rm -rf * 
if [ "$(ls -A $DIR)" ]; then
    echo "--------------------------------------------------------------------------------------------------------"
    echo -e "\e[1;32m [ERROR] Take action $DIR is not Empty\e[0m"
    echo "--------------------------------------------------------------------------------------------------------"
    exit 2
else
    echo "--------------------------------------------------------------------------------------------------------"
    echo -e "\e[1;31m [SUCCESS] $DIR is empty\e[0m"
    echo "--------------------------------------------------------------------------------------------------------"
    ls -larth
    pwd
fi

PRINT "Unzipping Zip File"
unzip /tmp/frontend.zip 
STAT "$?" "Unzipping"

PRINT "Moving Main Folder"
mv frontend-main/* .
STAT "$?" "Main folder move"
ls -larth

PRINT "Moving Static Folder"
mv static/* .
STAT "$?" "Static Folder move"
ls -larth

PRINT "Remove Frontend & README"
rm -rf frontend-master README.md
STAT "$?" "Removal of Frontend & README"
ls -larth

PRINT "Move localhost.conf file to roboshop"
cat /etc/nginx/default.d/roboshop.conf
mv localhost.conf /etc/nginx/default.d/roboshop.conf
STAT "$?" "Move"
cat /etc/nginx/default.d/roboshop.conf

PRINT "Enable Nginx"
systemctl enable nginx 
STAT "$?" "Check"

PRINT "Start Nginx"
systemctl start nginx 
STAT "$?" "Start"

PRINT "Restart Nginx"
systemctl restart nginx
STAT "$?" "Restart"

PRINT "Check Status Nginx"
systemctl status nginx
STAT "$?" "Status"
#!/bin/bash

DIR="/usr/share/nginx/html"

PRINT() {
    echo "------------------------------------------------------------------------------------------"
    echo -e "\e[1;35m [INFO] $1 \e[0m"
    echo "------------------------------------------------------------------------------------------"
}

STAT() {
    if [ $1  -ne 0 ]; then
        echo "------------------------------------------------------------------------------------------"
        echo -e "\e[1;32m [ERROR] $2 has failed\e[0m"
        echo "------------------------------------------------------------------------------------------"
        exit 2
    else
        echo "------------------------------------------------------------------------------------------"
        echo -e "\e[1;31m [SUCCESS] $2 is successful\e[0m"
    echo "----------------------------------------------------------------------------------------------"
fi
}

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
fi

PRINT "Unzipping Zip File"
unzip /tmp/frontend.zip 
STAT "$?" "Unzipping"

PRINT "Moving Main Folder"
mv frontend-main/* .
STAT "$?" "Main folder move"

PRINT "Moving Static Folder"
mv static/* .
STAT "$?" "Static Folder move"

rm -rf frontend-master README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl enable nginx 
systemctl start nginx 

systemctl restart nginx
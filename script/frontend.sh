#!/bin/bash

echo "--------------------------------------------------------------------------------------------------------"
echo -e "\e[1;35m [INFO] Installing Nginx\e[0m"
echo "--------------------------------------------------------------------------------------------------------"

yum install nginx -y
if [ $?  -ne 0]; then
    echo "--------------------------------------------------------------------------------------------------------"
    echo -e "\e[1;31m [ERROR] Nginx Installation has failed\e[0m"
    echo "--------------------------------------------------------------------------------------------------------"
    exit 2
else 
    echo "--------------------------------------------------------------------------------------------------------"
    echo -e "\e[1;32m [SUCCESS] Nginx Installation Successful\e[0m"
    echo "--------------------------------------------------------------------------------------------------------"
fi


echo "--------------------------------------------------------------------------------------------------------"
echo -e "\e[1;35m [INFO] Downloading frontend file into tmp directory\e[0m"
echo "--------------------------------------------------------------------------------------------------------"


curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
if [ $?  -ne 0]; then
    echo "--------------------------------------------------------------------------------------------------------"
    echo -e "\e[1;31m [ERROR] Download has failed\e[0m"
    echo "--------------------------------------------------------------------------------------------------------"
    exit 2
else 
    echo "--------------------------------------------------------------------------------------------------------"
    echo -e "\e[1;32m [SUCCESS] Download is successfull Successful\e[0m"
    echo "--------------------------------------------------------------------------------------------------------"
fi

cd /usr/share/nginx/html 

rm -rf * 
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-master README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl enable nginx 
systemctl start nginx 

systemctl restart nginx
#!/bin/bash

USER_ID=$(id -u)
if [ "${USER_ID}" -ne 0 ]; then
    echo -e "You should be root user to perform this command"
    exit 1
fi 

OS_Prereqs() {
  set-hostname ${COMPONENT}
  disable-auto-shutdown
}



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
        echo "------------------------------------------------------------------------------------------"
fi
}

RoboShop_App_User_Add() {
  id roboshop
  if [ $? -eq 0 ]; then
    PRINT "Create RoboShop Application User  - User Already Exists"
    return
  fi
  PRINT "Create RoboShop Application User"
  useradd roboshop
  STAT $? "Creating Application User"
}

Download_Component_From_GitHub() {
  PRINT "Download ${COMPONENT} Component"
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip"
  STAT $? "Downloading ${COMPONENT}"
}

Extract_Component() {
  PRINT "Extract ${COMPONENT}"
  cd /home/roboshop
  rm -rf ${COMPONENT} && unzip /tmp/${COMPONENT}.zip && mv ${COMPONENT}-main ${COMPONENT}
  STAT $? "Extracting ${COMPONENT}"
}

Extract_Component_to_tmp() {
  PRINT "Extract ${COMPONENT}"
  cd /tmp
  rm -rf ${COMPONENT} && unzip /tmp/${COMPONENT}.zip
  STAT $? "Extracting ${COMPONENT}"
}

NodeJS_Install() {
  PRINT "Install NodeJS"
  yum install nodejs make gcc-c++ -y
  STAT $? "Installing NodeJS"
}

NodeJS_Setup() {
  NodeJS_Install
  RoboShop_App_User_Add
  Download_Component_From_GitHub
  Extract_Component
  Install_NodeJS_Dependencies
  Setup_Service
}

Install_NodeJS_Dependencies() {
  PRINT "Download NodeJS dependencies"
  cd /home/roboshop/${COMPONENT}
  npm install --unsafe-perm
  STAT $? "Downloading dependencies"
}

Setup_Service() {
  PRINT "Setup SystemD Service for ${COMPONENT}"
  mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
  sed -i  -e 's/MONGO_DNSNAME/mongodb.devopsb55.tk/' \
          -e "s/MONGO_ENDPOINT/mongodb.devopsb55.tk/" \
          -e "s/REDIS_ENDPOINT/redis.devopsb55.tk/" \
          -e "s/CATALOGUE_ENDPOINT/catalogue.devopsb55.tk/"  \
          -e "s/DBHOST/mysql.devopsb55.tk/" \
          -e 's/CARTENDPOINT/cart.devopsb55.tk/' \
          -e "s/CARTHOST/cart.devopsb55.tk/" \
          -e "s/USERHOST/user.devopsb55.tk/" \
          -e "s/AMQPHOST/rabbitmq.devopsb55.tk/" \
          /etc/systemd/system/${COMPONENT}.service
  systemctl daemon-reload && systemctl restart ${COMPONENT} && systemctl enable ${COMPONENT}
  STAT $? "Starting ${COMPONENT} Service"
}








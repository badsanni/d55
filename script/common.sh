#!/bin/bash

USER_ID=$(id -u)
if [ "${USER_ID}" -ne 0 ]; then
    echo -e "You should be root user to perform this command"
    exit 1
fi 


PRINT() {
    echo "--------------------------------------------------------------------------------------------------------"
    echo -e "\e[1;31m [INFO] $1 \e[0m"
    echo "--------------------------------------------------------------------------------------------------------"
}

#STAT() {
#    if [ $1  -ne 0 ]; then
#        echo "--------------------------------------------------------------------------------------------------------"
#        echo -e "\e[1;32m [ERROR] $2 has failed\e[0m"
#        echo "--------------------------------------------------------------------------------------------------------"
#        exit 2
#    else
#        echo "--------------------------------------------------------------------------------------------------------"
#        echo -e "\e[1;31m [SUCCESS] $2 is successful\e[0m"
#    echo "--------------------------------------------------------------------------------------------------------"
#fi
#}
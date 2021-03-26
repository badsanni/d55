#!/bin/bash

USER_ID=$(id -u)
if [ "${USER_ID}" -ne 0 ]; then
    echo -e "You should be root user to perform this command"
    exit 1
fi 




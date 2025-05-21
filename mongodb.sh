#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FLODER="/var/log/roboshop-logs"
SCRIPT_NAME="$(echo $0 | cut -d "." -f1)"
LOG_FILE=$LOGS_FLODER/$SCRIPT_NAME.logs

mkdir -p $LOGS_FLODER
echo "Script started executing at: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]
then
    echo "$R ERROR:: Please run this script with root acces $N | tee -a $LOG_FILE
    exit 1
else
    echo $G "Your running with root access" | tee -a $LOG_FILE
fi        
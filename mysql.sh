#!/bin/bash

USERID=$(id -u)
R="\e[31m"
Y="\e[32m"
G="\e[33m"
N="\e[0N"

LOGS_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME"

mkdir -p $LOGS_FOLDER
echo " Script started Executing at: $(date) "

if [ USERID -ne 0 ]
then
    echo -e " $R ERROR :: Please run this with root Access $N "
else
    echo -e " $G your running with root Access $N "
fi

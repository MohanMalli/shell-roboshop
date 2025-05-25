#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/roboshop-log"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p LOGS_FOLDER
echo "Script started executing at: $(date)

if [ $USERID -ne 0 ]
then
    echo -e " $R ERROR :: Please run the script with root Access $N "
else
    echo -e " $G Your running with root Access $N "
fi

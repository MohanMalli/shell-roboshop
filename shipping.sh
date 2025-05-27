#!/bin/bash

#START_TIME=$(date +%s)
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOGS_FOLDER
echo "Script started executing at: $(date)" 

if [ $USERID -ne 0 ]
then
    echo " $R ERROR:: Please run the script with root Access $N "
    exit 1
else
   echo " $G You are running with Root Access $N "    
fi

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e " $2 is ... $G SUCCESS $N "
    else
        echo -e " $2 is ... $R FAILURE $N "
    fi     
}


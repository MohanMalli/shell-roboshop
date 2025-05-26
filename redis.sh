#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0N"

LOGS_FOLDER="var/log/roboshop-logs"
SCRIPT_NAME="$(echo $0 | cut -d "." -f1)"
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOGS_FOLDER
echo " Script start executing at: $(date)"

if [ $USERID -ne 0 ]
then
    echo -e " $R ERROR :: Please run the script with root access $N "
    exit 1
else
    echo -e " $G Your are running with root access $N "

fi 

VALIDATE( ){
    if [ $1 -eq 0 ]
    then 
        echo -e " $2 is ... $G SUCCESS $N "
    else  
        echo -e " $2 is ... $R FAILURE $N "
        exit 1
    fi        
}

dnf module disable redis -y
VALIDATE $? "Disabling redis "

dnf module enable redis:7 -y
VALIDATE $? "Enabling redis"

dnf install redis -y
VALIDATE $? "Installing redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protect-mode/ c /protect-mode no ' /etc/redis/redis.conf
VALIDATE $? "Edited redis.conf to accept remote connections"

systemctl enable redis 
VALIDATE $? "Enabling redis"

systemctl start redis 
VALIDATE $? "Starting Redis"


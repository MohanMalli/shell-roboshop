#!/bin/bash

START_TIME=$(date +%s)
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

if [ $USERID -ne 0 ]
then
    echo -e " $R ERROR:: Please run the script with root Access $N "
    exit 1
else
    echo -e " $G You are running with root Access $N "
fi

echo " Please enter rabbitmq passwoed to setup "
read -s RABBITMQ_PASSWD

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e " $2 is ... $G SUCCESS $N "
    else
        echo -e " $2 is ... $R FAILURE $N "
        exit 1 
    fi       
}

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? " Copying System usr "

dnf install rabbitmq-server -y
VALIDATE $? " Installing rabbitmq "

systemctl enable rabbitmq-server
VALIDATE $? " Enabling rabbitmq "

systemctl start rabbitmq-server
VALIDATE $? " starting rabbitmq "

rabbitmqctl add_user roboshop $RABBITMQ_PASSWD
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

END_TIME=$(date +%s)
TOTAL_TIME=$(( $END_TIME - $START_TIME ))

echo -e "Script exection completed successfully, $Y time taken: $TOTAL_TIME seconds $N"
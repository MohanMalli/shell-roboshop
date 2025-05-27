#!/bin/bash

START_TIME=$(date +%s)
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD

mkdir -p $LOGS_FOLDER
echo "Script started executing at: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]
then
    echo -e " $R ERROR :: Please run the script with root Access $N " | tee -a $LOG_FILE
    exit 1
else
    echo -e " $G Your running with root Access $N " | tee -a $LOG_FILE
fi

VALIDATE() {
    if [ $1 -eq 0 ]
    then
        echo -e  " $2 is... $G SUCCESS $N " | tee -a $LOG_FILE
    else
        echo -e  " $2 is... $R FAILURE $N " | tee -a $LOG_FILE
        exit 1
    fi        
}

dnf install golang -y
VALIDATE $? " Installing golanguage "

id roboshop
if [ $? -ne 0 ]
then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
    VALIDATE $? "Creating roboshop system user"
else
      echo -e "System user roboshop already created ... $Y SKIPPING $N"
fi    

mkdir -p /app
VALIDATE $? "Creating app directory"

curl -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch-v3.zip 
VALIDATE $? "Downloading dispatch"

rm -rf /app/*
cd /app
unzip /tmp/dispatch.zip 
VALIDATE $? "unzipping dispatch"

go mod init dispatch
VALIDATE $? " dispatching "

go get 
VALIDATE $? 

go build
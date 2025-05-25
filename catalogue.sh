#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/roboshop-log"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD

mkdir -p LOGS_FOLDER
echo "Script started executing at: $(date)"

if [ $USERID -ne 0 ]
then
    echo -e " $R ERROR :: Please run the script with root Access $N "
    exit 1
else
    echo -e " $G Your running with root Access $N "
fi

VALIDATE() {
    if [ $1 -eq 0 ]
    then
        echo -e  " $2 is... $G SUCCESS $N "
    else
        echo -e  " $2 is... $R FAILURE $N "
        exit 1
    fi        
}

# dnf module disable nodejs -y
# VALIDATE $? "Disabling default nodejs"

# dnf module enable nodejs:20 -y
# VALIDATE $? "Enabling nodejs:20"

# dnf install nodejs -y
# VALIDATE $? "Installing nodejs:20"

# id roboshop
# if [ $? -ne 0 ]
# then
#     useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
#     VALIDATE $? "Creating roboshop system user"
# else
#       echo -e "System user roboshop already created ... $Y SKIPPING $N"
# fi    

# mkdir -p /app
# VALIDATE $? "Creating app directory"

# curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip
# VALIDATE $? "Downloading Catalogue"

# rm -rf /app/*
# cd /app
# unzip /tmp/catalogue.zip
# VALIDATE $? "unzipping catalogue"

# npm install
# VALIDATE $? "Installing Dependencies"

# cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service
# VALIDATE $? "Copying catalogue service"

# systemctl daemon-reload
# systemctl enable catalogue
# systemctl start catalogue
# VALIDATE $? "Starting Catalogue"

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y
VALIDATE $? "Installing MongoDB Client"

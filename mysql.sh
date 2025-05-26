#!/bin/bash

USERID=$(id -u)
R="\e[31m"
Y="\e[32m"
G="\e[33m"
N="\e[0N"

LOGS_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOGS_FOLDER
echo " Script started Executing at: $(date) "

if [ $USERID -ne 0 ]
then
    echo -e " $R ERROR :: Please run this with root Access $N "
    exit 1
else
    echo -e " $G your running with root Access $N "
fi

# validate functions takes input as exit status, what command they tried to install
VALIDATE(){
    if [ $1 -eq 0 ]
      then 
         echo -e "$2 is ... $G SUCCESS $N"
      else
         echo -e "$2 is ... $R FAILURE $N"
         exit 1

    fi
         
}
  
  dnf install mysql-server -y
  VALIDATE $? " Installing MySQL server "

  systemctl enable mysqld
  VALIDATE $? " Enabling MySQL "

  systemctl start mysqld 
  VALIDATE $? " Starting MySQL "

  



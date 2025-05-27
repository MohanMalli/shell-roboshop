#!/bin/bash

START_TIME=$(date +%s)
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOGS_FOLDER   | tee -a $LOG_FILE
echo " Script started Executing at: $(date) "

if [ $USERID -ne 0 ]
then
    echo -e " $R ERROR :: Please run this with root Access $N " | tee -a $LOG_FILE
    exit 1
else
    echo -e " $G your running with root Access $N "  | tee -a $LOG_FILE
fi

echo "Please enter root password to setup"
read -s MYSQL_ROOT_PASSWORD  

# validate functions takes input as exit status, what command they tried to install
VALIDATE(){
    if [ $1 -eq 0 ]
      then 
         echo -e "$2 is ... $G SUCCESS $N" | tee -a $LOG_FILE
      else
         echo -e "$2 is ... $R FAILURE $N" | tee -a $LOG_FILE
         exit 1

    fi
         
}
  
  dnf install mysql-server -y &>>$LOG_FILE
  VALIDATE $? " Installing MySQL server "

  systemctl enable mysqld &>>$LOG_FILE
  VALIDATE $? " Enabling MySQL "

  systemctl start mysqld &>>$LOG_FILE
  VALIDATE $? " Starting MySQL "

  mysql_secure_installation --set-root-pass $MYSQL_ROOT_PASSWORD &>>$LOG_FILE
  VALIDATE $? "Setting MySQL root password"

  END_TIME=$(date +%s)
  TOTAL_TIME=$(( $END_TIME - $START_TIME ))

  echo -e "Script exection completed successfully, $Y time taken: $TOTAL_TIME seconds $N"

  



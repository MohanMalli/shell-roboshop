#!/bin/bash
 
START_TIME=$(date +%s)
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
y="\e[33m"
N="\e[0N"

LOGS_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD

mkdir -p $LOGS_FOLDER
echo " Script Start execute at: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR :: Please run the script with root access $N" | tee -a $LOG_FILE
    exit 1
else 
    echo -e "$G Your are running with root access $N" | tee -a $LOG_FILE
fi

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e " $2 is ... $G SUCCESS $N " | tee -a $LOG_FILE
    else
        echo -e " $2 is ... $R FAILURE $N " | tee -a $LOG_FILE
        exit 1
    fi        
}

dnf module disable nodejs -y &>>LOG_FILE
VALIDATE $? " Disabling nodejs "

dnf module enable nodejs:20 -y &>>LOG_FILE
VALIDATE $? " Enabling nodejs "

dnf install nodejs -y &>>LOG_FILE
VALIDATE $? " Installing nodejs "

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

curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user-v3.zip &>>LOG_FILE
VALIDATE $? "Downloading user"

rm -rf /app/* &>>LOG_FILE
cd /app
unzip /tmp/user.zip 
VALIDATE $? "unzipping user"

npm install &>>LOG_FILE
VALIDATE $? "Installing Dependencies"

cp $SCRIPT_DIR/user.service /etc/systemd/system/user.service
VALIDATE $? "Copying user service"

systemctl daemon-reload &>>LOG_FILE
systemctl enable user &>>LOG_FILE
systemctl start user &>>LOG_FILE
VALIDATE $? "user"

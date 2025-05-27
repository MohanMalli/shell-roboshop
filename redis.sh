#!/bin/bash
START_TIME=$(date +%s)
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOGS_FOLDER
echo " Script start executing at: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]
then
    echo -e " $R ERROR :: Please run the script with root access $N " | tee -a $LOG_FILE
    exit 1
else
    echo -e " $G Your are running with root access $N " | tee -a $LOG_FILE

fi 

# validate functions takes input as exit status, what command they tried to install
VALIDATE( ){ 

    if [ $1 -eq 0 ]
    then 
        echo -e " $2 is ... $G SUCCESS $N " | tee -a $LOG_FILE
    else  
        echo -e " $2 is ... $R FAILURE $N " | tee -a $LOG_FILE
        exit 1
    fi        
}

dnf module disable redis -y &>>$LOG_FILE
VALIDATE $? "Disabling redis "

dnf module enable redis:7 -y &>>$LOG_FILE
VALIDATE $? "Enabling redis"

dnf install redis -y &>>$LOG_FILE
VALIDATE $? "Installing redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no ' /etc/redis/redis.conf
VALIDATE $? "Edited redis.conf to accept remote connections"


systemctl enable redis &>>$LOG_FILE
VALIDATE $? "Enabling redis"

systemctl start redis &>>$LOG_FILE
VALIDATE $? "Starting Redis"

END_TIME=$(date +%s)
TOTAL_TIME=$(($END_TIME - $START_TIME))

echo -e " Script Exection completed successfully, $Y time taken: $TOTAL_TIME seconds $N" | tee -a $LOG_FILE 
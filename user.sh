#!/bin/bash
 
#START_TIME=$(date +%s)
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
y="\e[33m"
N="\e[0N"

LOGS_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"


mkdir -p $LOGS_FOLDER
echo " Script Start execute at: $(date)"

if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR :: Please run the script with root access $N"
    exit 1
else 
    echo -e "$G Your are running with root access $N"
fi

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e " $2 is ... $G SUCCESS $N "
    else
        echo -e " $2 is ... $R FAILURE $N "
        exit 1
    fi        

}

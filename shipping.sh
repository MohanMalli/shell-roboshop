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
echo " Script Start execute at: $(date)" 

if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR :: Please run the script with root access $N" 
    exit 1
else 
    echo -e "$G Your are running with root access $N" 
fi

echo "Please enter root password to setup"
read -s MYSQL_ROOT_PASSWORD 

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e " $2 is ... $G SUCCESS $N " 
    else
        echo -e " $2 is ... $R FAILURE $N " 
        exit 1
    fi        
}

dnf install maven -y
VALIDATE $? "Installing maven and java"

id roboshop
if [ $? -eq 0 ]
then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
    VALIDATE $? " creating system user "
else
    echo -e "$G already user created ...$Y SKIPPING $N "
fi

mkdir -p /app
VALIDATE $? "Creating app directory"

curl -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip
VALIDATE $? "Downloading shipping"

rm -rf /app/*
cd /app 
unzip /tmp/shipping.zip
VALIDATE $? " unziping the shipping "

mvn clean package 
VALIDATE $? " cleaning package "

mv target/shipping-1.0.jar shipping.jar 
VALIDATE $? " Moving and renaming "

cp $SCRIPT_DIR/shipping.service /etc/systemd/system/shipping.service

systemctl daemon-reload
VALIDATE $? " reload the system "

systemctl enable shipping 
VALIDATE $? " Enabling the shipping "

systemctl start shipping 
VALIDATE $? " Start the shipping "

dnf install mysql -y 
VALIDATE $? " Installing mysql "

mysql -h mysql.malli.site -u root -p$MYSQL_ROOT_PASSWORD  -e 'use cities'
if[ $? -ne 0 ]
then
    mysql -h mysql.malli.site -uroot -pMYSQL_ROOT_PASSWORD < /app/db/schema.sql
    mysql -h mysql.malli.site -uroot -pMYSQL_ROOT_PASSWORD < /app/db/app-user.sql 
    mysql -h mysql.malli.site -uroot -pMYSQL_ROOT_PASSWORD < /app/db/master-data.sql
    VALIDATE $? " Loading data bases "
else
    echo -e "Data is already loaded into MySQL ... $Y SKIPPING $N"    
fi

systemctl restart shipping
VALIDATE $? " Restarting shipping "

END_TIME=$(date +%s)
TOTAL_TIME=$(( $END_TIME - $START_TIME ))

echo -e "Script exection completed successfully, $Y time taken: $TOTAL_TIME seconds $N"


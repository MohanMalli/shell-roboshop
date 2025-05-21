#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-0c50cc7d72d42f4dd"
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "frontend")
ZONE_ID="Z05130911714KBFT4KH1G"
DOMAIN_NAME="malli.site"

for instance in ${INSTANCES[@]}
do
  INSTANCE_ID=$(aws ec2 run-instances --image-id ami-09c813fb71547fc4f --instance-type t2.micro --security-group-ids sg-0c50cc7d72d42f4dd --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=test}]" --query "Instances[0].PrivateIpAddress" --output text)
    if [ $instance != "frontend" ]
    then
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
    else
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)     
    fi   

      echo "$Instance IP address: $IP" 
       
done  




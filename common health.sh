start with Database Servers
---------------------------------------------------------------------------------
MongoDB
Configuration Check:
Ensure the listen address in /etc/mongod.conf is updated from 127.0.0.1 to 0.0.0.0.
Service Status:
Run: sudo systemctl status mongodb
If the service is not running, check logs for errors.
Port Check:
Run: netstat -lntp
Verify port 27017 is listening.
-----------------
Connection Test:
Run: mongosh --host mongodb.malli.site
       Execute queries:show dbs
       use catalogue
       show collections
       db.products.find()
Note: Install MongoDB shell client if not present.
#############################################################
MySQL
Service Status:
Run: sudo systemctl status mysqld
If the service is not running, check logs for errors.
Port Check:
Run: netstat -lntp
Verify port 3306 is listening.
----------------
Connection Test:
Run: mysql -h mysql.malli.site -uroot -pRoboShop@1
Execute query:SHOW DATABASES;
Note: Ensure the MySQL client is installed.
###################################################################
Redis
Configuration Check:
Update listen address in /etc/redis/redis.conf from 127.0.0.1 to 0.0.0.0.
Set protected-mode to no in /etc/redis/redis.conf.
Service Status:
Run: sudo systemctl status redis
If the service is not running, check logs for errors.
Port Check:
Run: netstat -lntp
Verify port 6379 is listening.
------------------------------------------------------------------------
RabbitMQ
Service Status:
Run: sudo systemctl status rabbitmq
If the service is not running, check logs for errors.
Port Check:
	Run: netstat -lntp
	Verify port 5672 is listening.
_________________________________________________________________
Backend-Components
--------------------------------------------------------------------------------
Catalogue Service
Service Status:
Run: sudo systemctl status catalogue
If failed, verify the MongoDB Route53 record name in the service file.
Port Check:
Run: netstat -lntp
Verify port 8080 is listening.
Connection Test:
Check MongoDB connectivity: telnet <mongodb-route53-record-name> 27017
Validate MongoDB service:mongosh --host mongodb.royalreddy.site
show dbs
use catalogue
show collections
db.products.find()
.......................................................................
User Service
Service Status:
Run: sudo systemctl status user
If failed, verify MongoDB and Redis Route53 record names in the service file.
Port Check:
Run: netstat -lntp
Verify port 8080 is listening.
Connection Test:
Check MongoDB connectivity: telnet <mongodb-route53-record-name> 27017
Check Redis connectivity: telnet <redis-route53-record-name> 6379
.......................................................................
Cart Service
Service Status:
Run: sudo systemctl status cart
If failed, verify MongoDB Route53 record name in the service file.
Port Check:
Run: netstat -lntp
Verify port 8080 is listening.
Connection Test:
Check Redis connectivity: telnet <redis-route53-record-name> 6379
Check Catalogue connectivity: telnet <catalogue-route53-record-name> 8080
.......................................................................
Shipping Service
Service Status:
Run: sudo systemctl status shipping
If failed, verify MySQL Route53 record name in the service file.
Port Check:
Run: netstat -lntp
Verify port 8080 is listening.
Connection Test:
Check MySQL connectivity: telnet <mysql-route53-record-name> 3306
Validate MySQL service:mysql -h mysql.royalreddy.site -u root -pRoboShop@1
SHOW DATABASES;
Note: Ensure the cities schema appears; if not, master data may not be loaded.
.......................................................................
Payment Service
Service Status:
Run: sudo systemctl status payment
If failed, verify RabbitMQ Route53 record name in the service file.
Port Check:
Run: netstat -lntp
Verify port 8080 is listening.
Connection Test:
Check RabbitMQ connectivity: telnet <rabbitmq-route53-record-name> 5672
.......................................................................
Dispatch Service
Service Status:
Run: sudo systemctl status dispatch
If failed, verify RabbitMQ Route53 record name in the service file.
Log Check:
	After payment on the web page, check for the ID in /var/log/messages.
________________________________________________________________________
Frontend Server
---------------------------------------------------------------------------------------
Service Status:
Run: sudo systemctl status nginx
If failed, check Nginx configuration syntax: nginx -t
Connection Test:
Verify connectivity to backend components:telnet <catalogue-route53-record-name> 8080
Example: telnet catalogue.royalreddy.site 8080
Restart Nginx after deploying backend components (catalogue, user, cart, shipping, payment):systemctl restart nginx
Health Check:
Verify each component's health from the frontend server:curl -i http://catalogue.royalreddy.site:8080/health
curl -i http://cart.royalreddy.site:8080/health
curl -i http://user.royalreddy.site:8080/health
curl -i http://shipping.royalreddy.site:8080/health
curl -i http://payment.royalreddy.site:8080/health
Expected response:HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
If the health check fails, verify Route53 records and IP mappings. (edited) 
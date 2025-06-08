source common.sh

print_head "install maven"
dnf install maven -y &>>${LOG}
status_check


print_head "added robosop user"
 id roboshop &>>${LOG}
  if [ $? -ne 0 ]; then
    useradd roboshop &>>${LOG}
  fi
  status_check

print_head "app direcorectoy created"
mkdir -p /app &>>${LOG}
status_check

 print_head "content downloaded"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip  &>>${LOG}
 status_check
print_head "Cleanup Old Content"
  rm -rf /app/* &>>${LOG}
  status_check

  print_head "Extracting App Content"
  cd /app
  unzip /tmp/shipping.zip &>>${LOG}
  status_check



  mvn clean package
  mv target/shipping-1.0.jar shipping.jar


    cp ${script_location}/files/shipping.service /etc/systemd/system/shipping.service &>>${LOG}
    status_check

    systemctl daemon-reload

    systemctl enable shipping
    systemctl start shipping

    dnf install mysql -y

mysql -h mysql-dev.devops26.shop -uroot -pRoboShop@1 < /app/schema/shipping.sql


    systemctl restart shipping
source common.sh

print_head "disabled older version of nodejs"
dnf module disable nodejs -y  &>>${LOG}
status_check

print_head "enabled 18 version of nodejs"
dnf module enable nodejs:18 -y  &>>${LOG}
status_check

print_head "installed required version nodejs"
dnf install nodejs -y  &>>${LOG}
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
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
 status_check
print_head "Cleanup Old Content"
  rm -rf /app/* &>>${LOG}
  status_check

  print_head "Extracting App Content"
  cd /app
  unzip /tmp/catalogue.zip &>>${LOG}
  status_check


print_head "installed new content"
npm install &>>${LOG}
status_check


cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service.conf &>>${LOG}
status_check

systemctl daemon-reload &>>${LOG}
status_check

print_head "Copy MongoDB Repo file"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
status_check

print_head "install MongoDB Repo file"
dnf install mongodb-org-shell -y &>>${LOG}
status_check

mongo --host mongodb-dev.devops26.shop </app/schema/catalogue.js &>>${LOG}
status_check
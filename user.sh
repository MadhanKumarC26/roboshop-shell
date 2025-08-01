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
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip  &>>${LOG}
 status_check
print_head "Cleanup Old Content"
  rm -rf /app/* &>>${LOG}
  status_check

  print_head "Extracting App Content"
  cd /app
  unzip /tmp/user.zip &>>${LOG}
  status_check

  print_head "Installing NodeJS Dependencies"
    cd /app &>>${LOG}
    npm install &>>${LOG}
    status_check

    cp ${script_location}/files/user.service /etc/systemd/system/user.service &>>${LOG}
    status_check

    systemctl daemon-reload

    systemctl enable user
    systemctl start user
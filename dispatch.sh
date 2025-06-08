

source common.sh

print_head "enable golng"
dnf install golang -y &>>${LOG}
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
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip &>>${LOG}
 status_check
print_head "Cleanup Old Content"
  rm -rf /app/* &>>${LOG}
  status_check

  print_head "Extracting App Content"
  cd /app
  unzip /tmp/dispatch.zip &>>${LOG}
  status_check


go mod init dispatch
go get
go build

cp ${script_location}/files/dispatch.service /etc/systemd/system/dispatch.service.conf &>>${LOG}
status_check

systemctl daemon-reload

systemctl enable dispatch
systemctl start dispatch
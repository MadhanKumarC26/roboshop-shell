source common.sh

print_head "enable python"
dnf install python36 gcc python3-devel -y &>>${LOG}
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
curl -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip &>>${LOG}
 status_check
print_head "Cleanup Old Content"
  rm -rf /app/* &>>${LOG}
  status_check

  print_head "Extracting App Content"
  cd /app
  unzip /tmp/payment.zip &>>${LOG}
  status_check


print_head "installed dependencies content"
pip3.6 install -r requirements.txt &>>${LOG}
status_check

cp ${script_location}/files/payment.service /etc/systemd/system/payment.service.conf &>>${LOG}
status_check

systemctl daemon-reload

systemctl enable payment
systemctl start payment
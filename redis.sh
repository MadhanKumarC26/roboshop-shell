
source common.sh

print_head "diabale older verison"
dnf module disable redis -y &>>${LOG}
status_check


print_head "enable new verison"
dnf module enable redis:6 -y &>>${LOG}
status_check

print_head "download new verison"
dnf install redis -y  &>>${LOG}
status_check

print_head "update configuration"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf & /etc/redis/redis.conf  &>>${LOG}
status_check



systemctl enable redis
systemctl start redis
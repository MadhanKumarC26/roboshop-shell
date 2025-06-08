source common.sh

if [ -z "${root_mysql_password}" ]; then
  echo "Variable root_mysql_password is missing"
  exit 1
fi

print_head "disabled older version of mysql"
dnf module disable mysql -y &>>${LOG}
status_check

print_head "copy repo content"
cp ${script_location}/files/mysql.repo /etc/yum.repos.d/mysql.repo &>>${LOG}
status_check


print_head "install community version"
dnf install mysql-community-server -y
status_check

systemctl enable mysqld
systemctl start mysqld

print_head "Reset Default Database Password"
mysql_secure_installation --set-root-pass ${root_mysql_password} &>>${LOG}
if [ $? -eq 1 ]; then
  echo "Password is already changed"
fi
status_check
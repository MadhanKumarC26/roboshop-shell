

script_location=$(pwd)
LOG=/tmp/roboshop.log
status_check (){
  if [ $? -eq 0 ]; then
    echo sucuess
  else
     echo -e "\e[35m failure\e[0m"
      echo "check log files,LOG -${LOG}

  fi
}

dnf install nginx -y &>>${LOG}


systemctl enable nginx &>>${LOG}
status_check

systemctl start nginx &>>${LOG}
status_check

rm -rf /usr/share/nginx/html/* &>>${LOG}
status_check
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
status_check
cd /usr/share/nginx/html &>>${LOG}
status_check
unzip /tmp/frontend.zip &>>${LOG}
status_check

cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}
status_check

systemctl enable nginx &>>${LOG}

systemctl restart nginx &>>${LOG}
status_check
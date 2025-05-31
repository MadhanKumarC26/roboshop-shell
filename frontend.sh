

script_location=$(pwd)
LOG=/tmp/roboshop.log


dnf install nginx -y &>>${LOG}
if [ $? -eq 0 ]; then
  echo sucuess
else
    echo failure
fi

systemctl enable nginx &>>${LOG}
if [ $? -eq 0 ]; then
  echo sucuess
else
    echo failure
fi
systemctl start nginx &>>${LOG}
if [ $? -eq 0 ]; then
  echo sucuess
else
    echo failure
fi

rm -rf /usr/share/nginx/html/* &>>${LOG}
if [ $? -eq 0 ]; then
  echo sucuess
else
    echo failure
fi
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
if [ $? -eq 0 ]; then
  echo sucuess
else
    echo failure
fi

cd /usr/share/nginx/html &>>${LOG}
if [ $? -eq 0 ]; then
  echo sucuess
else
    echo failure
fi

unzip /tmp/frontend.zip &>>${LOG}
if [ $? -eq 0 ]; then
  echo sucuess
else
    echo failure
fi

cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}
if [ $? -eq 0 ]; then
  echo sucuess
else
    echo failure
fi

systemctl enable nginx &>>${LOG}

systemctl restart nginx &>>${LOG}
if [ $? -eq 0 ]; then
  echo sucuess
else
    echo failure
fi
dnf install nginx -y

systemctl enable nginx
systemctl start nginx


rm -rf /usr/share/nginx/html/*

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}


cd /usr/share/nginx/html
unzip /tmp/frontend.zip

cd /
cp /files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

#cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}


systemctl enable nginx

systemctl restart nginx

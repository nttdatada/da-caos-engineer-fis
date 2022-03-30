#!/bin/bash


sudo apt update
sudo apt upgrade -y


### Install NGINX ###
sudo apt install nginx -y

sudo systemctl anable nginx

sudo mkdir -p /var/www/site/html

sudo chown-R $USER:$USER /var/www/site 
sudo chmod -R 755 /var/www/site

echo -e "
<html>
<head>
<title>Welcome to EC2 </title> 
</head>
<body>
<h1> http://169.254.169.254/latest/meta-data/instance-id </h1>
</body>
</html>
" >> /var/www/site/html/index.html 

echo -e "
server {

    listen 8080;

    root /var/www/site/html;
    index index.html index.htm index.nginx.debian.html;
    server_name domain.com www.domain.com;
    
    location /  {
        try_files $uri $uri/ =404;
    }

}
" >> /etc/nginx/sites-available/domain.com


sudo ln -s /etc/nginx/sites-available/domain /etc/nginx/sites-enabled

sudo systemctl restart nginx 

sudo nginx -t 

hostname -i

echo "127.0.0.1     domain.com www.domain.com"
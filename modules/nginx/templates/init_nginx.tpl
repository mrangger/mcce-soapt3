#!/bin/bash

# Install dependencies docker, docker-compose
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose


project_dir="/docker"

mkdir -p $${project_dir}

# Create docker-compose config
cat << "EOF" > $${project_dir}/docker-compose.yaml

version: "3.3"

services:
  nginx:
    image: nginx:latest
    container_name: webserver
    restart: unless-stopped
    ports:
      - 80:80
      - 443:443
    volumes:
      - ./index.html:/usr/share/nginx/html/index.html
  
EOF


cat << "EOF" > $${project_dir}/index.html
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx! </title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<h2>Servername ${node_name}</h2>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
EOF


cd $${project_dir}
docker-compose up

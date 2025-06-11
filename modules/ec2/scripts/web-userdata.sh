#!/bin/bash

sudo su - ec2-user <<'EOF'
sudo yum update -y

cd /home/ec2-user
git clone https://github.com/Nisarg153/Multi-Environment-Deployment.git
cd Multi-Environment-Deployment/app-code

sudo npm install
sudo npm install aws-sdk express body-parser dotenv
sudo npm install -g pm2
sudo chown -R ec2-user:ec2-user /home/ec2-user/Multi-Environment-Deployment

pm2 start app.js --name app
pm2 startup systemd -u ec2-user --hp /home/ec2-user | tail -n 1 | sh
pm2 save

EOF
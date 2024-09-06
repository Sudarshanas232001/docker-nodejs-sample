#!/bin/bash
cd /home/ec2-user/nodejs-app
pm2 start app.js --name "nodejs-app"

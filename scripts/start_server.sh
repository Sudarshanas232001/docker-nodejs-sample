#!/bin/bash
# Navigate to the application directory
cd /home/ec2-user/nodejs-app

# Start the application
npm start > /home/ec2-user/nodejs-app/app.log 2>&1 &

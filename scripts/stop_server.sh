#!/bin/bash
echo "Starting BeforeInstall script" >> /home/ec2-user/nodejs-app/app.log
if pgrep -f 'node src/index.js'; then
  echo "Stopping existing application processes" >> /home/ec2-user/nodejs-app/app.log
  pkill -f 'node src/index.js'
else
  echo "No running application processes found" >> /home/ec2-user/nodejs-app/app.log
fi
echo "Completed BeforeInstall script" >> /home/ec2-user/nodejs-app/app.log

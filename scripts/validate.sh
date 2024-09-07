#!/bin/bash
# Simple health check to ensure the application is running
if curl -s http://localhost:3000 > /dev/null; then
  echo "Application is running"
  exit 0
else
  echo "Application is not running"
  exit 1
fi

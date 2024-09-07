#!/bin/bash
# Stop any existing application processes
if pgrep -f 'node src/index.js'; then
  pkill -f 'node src/index.js'
fi

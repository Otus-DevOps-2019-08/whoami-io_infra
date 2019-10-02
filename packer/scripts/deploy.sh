#!/bin/bash
  
git clone -b monolith https://github.com/express42/reddit.git

cd reddit
bundle install
if [ $? -ne 0 ]; then
  echo "Failed to install with bundle"
  exit 1
fi

sudo mv /tmp/reddit-start.service /etc/systemd/system/

sudo chmod 664 /etc/systemd/system/reddit-start.service

sudo systemctl daemon-reload

sudo systemctl start reddit-start

sudo systemctl enable reddit-start


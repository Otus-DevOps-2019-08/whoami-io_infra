#!/bin/bash

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927

sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

sudo apt-get update

sudo apt-get install -y mongodb-org

sudo systemctl start mongod
if [ $? -ne 0 ]; then
  echo "Failed to start mongod"
  exit 1
fi

sudo systemctl enable mongod
if [ $? -ne 0 ]; then
  echo "Failed to enable mongod"
  exit 1
fi


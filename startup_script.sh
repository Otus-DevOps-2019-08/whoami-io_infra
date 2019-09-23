#!/bin/bash

cd /home/appuser

# install dependencies 

sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential
if [ $? -ne 0 ]; then
  echo "Failed to install rube and bundler"
  exit 1
fi

# install db

wget -qO - https://www.mongodb.org/static/pgp/server-3.2.asc | sudo apt-key add

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

# deploy app

git clone -b monolith https://github.com/express42/reddit.git

cd reddit
bundle install
if [ $? -ne 0 ]; then
  echo "Failed to install with bundle"
  exit 1
fi

puma -d
if [ $? -ne 0 ]; then
  echo "Failed to start puma in detached mode"
  exit 1
fi


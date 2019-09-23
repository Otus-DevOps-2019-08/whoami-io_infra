#!/bin/bash

cd /home/appuser

git clone git@github.com:Otus-DevOps-2019-08/whoami-io_infra.git
cd whoami-io_infra
git checkout cloud-testapp

./install_ruby.sh
if [ $? -ne 0 ]; then
  echo "Failed to install ruby"
  exit 1
fi

./install_mongo.sh
if [ $? -ne 0 ]; then
  echo "Failed to install mongo
  exit 1
fi

./deploy.sh
if [ $? -ne 0 ]; then
  echo "Failed to deploy reddit"
  exit 1
fi


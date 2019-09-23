#!/bin/bash

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


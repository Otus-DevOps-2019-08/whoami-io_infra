#!/bin/bash
sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential
if [ $? -ne 0 ]; then
  echo "Failed to install rube and bundler"
  exit 1
fi

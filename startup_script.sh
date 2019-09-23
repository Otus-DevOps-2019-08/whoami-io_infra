#!/bin/bash

# install ruby and dependencies
wget -O - https://raw.githubusercontent.com/Otus-DevOps-2019-08/whoami-io_infra/cloud-testapp/install_ruby.sh | bash
if [ $? -ne 0 ]; then
  echo "Failed to install ruby"
  exit 1
fi

# install db
wget -O - https://raw.githubusercontent.com/Otus-DevOps-2019-08/whoami-io_infra/cloud-testapp/install_mongodb.sh | bash
if [ $? -ne 0 ]; then
  echo "Failed to install mongo
  exit 1
fi

# run app
cd /home/appuser

wget -O - https://raw.githubusercontent.com/Otus-DevOps-2019-08/whoami-io_infra/cloud-testapp/deploy.sh | sudo bash
if [ $? -ne 0 ]; then
  echo "Failed to deploy reddit"
  exit 1
fi


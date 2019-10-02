#!/bin/bash

# create VM instance
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family reddit-full \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --network-tier STANDARD

# assign static external ip
gcloud compute instances delete-access-config reddit-app --access-config-name "external-nat"

gcloud compute instances add-access-config reddit-app --access-config-name="External NAT" --address=35.208.161.9 --network-tier STANDARD

# create firewall rule
gcloud compute firewall-rules create default-puma-server \
	--action allow \
	--direction ingress \
	--rules tcp:9292 \
	--source-ranges 0.0.0.0/0 \
	--target-tags puma-server

# open 35.208.161.9:9292


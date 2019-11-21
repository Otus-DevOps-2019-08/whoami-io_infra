#!/usr/bin/env python

import json
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--list', action='store_true')
parser.add_argument('--host', action='store_true')


args = parser.parse_args()

with open('inventory.json') as json_file:
    data = json.load(json_file)
	
if args.list:
    print(json.dumps(data))

if args.host:
    print([])
    
#!/bin/bash

if [ "$#" -ne 2 ];then
  ehco "Usage: $0 <server> <package>"
  exit 1
fi

SERVER=$1
PACKAGE=$2

echo "Checking package: '$PACKAGE' on Server: '$SERVER'..."
ssh root@$SERVER "rpm -q $PACKAGE"

#!/bin/bash

print_help_and_exit () {
	echo "Usage: build-all.sh working-dir";
	exit 2;
}

if [ -z "$1" ]; then
    print_help_and_exit
fi

# build docker base image
docker build -t oberthur/redis-base:1.0.0 --no-cache $1/base
docker tag -f oberthur/redis-base:1.0.0 oberthur/redis-base:latest

# build docker master, slave and sentinel images
docker build -t oberthur/redis-standalone --no-cache $1/standalone
docker build -t oberthur/redis-cluster --no-cache $1/cluster


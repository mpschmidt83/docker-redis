#!/bin/bash

# stop running container
docker stop redis-cluster-node1
docker stop redis-cluster-node2
docker stop redis-cluster-node3
docker stop redis-cluster-node4
docker stop redis-cluster-node5
docker stop redis-cluster-node6

# remove existing container
docker rm redis-cluster-node1
docker rm redis-cluster-node2
docker rm redis-cluster-node3
docker rm redis-cluster-node4
docker rm redis-cluster-node5
docker rm redis-cluster-node6

# start docker container
docker run -d -p 6379:6379 --name=redis-cluster-node1 oberthur/redis-cluster
docker run -d -p 6380:6379 --name=redis-cluster-node2 oberthur/redis-cluster
docker run -d -p 6381:6379 --name=redis-cluster-node3 oberthur/redis-cluster
docker run -d -p 6382:6379 --name=redis-cluster-node4 oberthur/redis-cluster
docker run -d -p 6383:6379 --name=redis-cluster-node5 oberthur/redis-cluster
docker run -d -p 6384:6379 --name=redis-cluster-node6 oberthur/redis-cluster

docker exec -it redis-cluster-node1 /redis-trib-autoconfirm.rb create --replicas 1 \
	$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' redis-cluster-node1):6379 \
	$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' redis-cluster-node2):6379 \
	$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' redis-cluster-node3):6379 \
	$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' redis-cluster-node4):6379 \
	$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' redis-cluster-node5):6379 \
	$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' redis-cluster-node6):6379

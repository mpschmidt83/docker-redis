#!/bin/bash

ip="$(ip route get 8.8.8.8 | awk '{print $NF; exit}')"
echo "Your local IP: $ip"


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
docker run -d --net=host --name=redis-cluster-node1 oberthur/redis-cluster:latest /etc/redis.conf --port 6379
docker run -d --net=host --name=redis-cluster-node2 oberthur/redis-cluster:latest /etc/redis.conf --port 6380
docker run -d --net=host --name=redis-cluster-node3 oberthur/redis-cluster:latest /etc/redis.conf --port 6381
docker run -d --net=host --name=redis-cluster-node4 oberthur/redis-cluster:latest /etc/redis.conf --port 6382
docker run -d --net=host --name=redis-cluster-node5 oberthur/redis-cluster:latest /etc/redis.conf --port 6383
docker run -d --net=host --name=redis-cluster-node6 oberthur/redis-cluster:latest /etc/redis.conf --port 6384

docker exec -it redis-cluster-node1 /redis-trib-autoconfirm.rb create --replicas 1 \
	$ip:6379 \
	$ip:6380 \
	$ip:6381 \
	$ip:6382 \
	$ip:6383 \
	$ip:6384

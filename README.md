# Docker images containing Redis server

This repository contains docker images that allows to start Redis server instances of the following types:
- **standalone master**
- **cluster node**
- **slave**

## Images types

There are the following images defined:

- **redis_base** - base image which other images inherits from, contains redis tools for redis cluser management
- **redis_standalone** - image containing standalone redis instance (master)
- **redis_cluster** - image containing redis cluster node instance

## Scripts

You can find example scripts in "scripts" directory:
- **build_all.sh** - builds all images with proper names
- **init-cluster.sh** - initiates cluster from already running Redis instances
- **run_standalone.sh** - starts standalone Redis instance
- **run-cluster-locally.sh** - starts a Redis cluster locally (6 instances - 3 master and 3 slaves)

## Clusterization

In order to start Redis cluster, one should start at least 3 cluster nodes and execute "scripts/init-cluster.sh".

## Customization

You can run redis insiede container with custom opstions like 
/data/cfg/redis.conf --port 6379
Just add it as docker command.

# Docker images containing Redis server

This repository contains docker images that allows to start Redis server instances of the following types:
- **standalone master**
- **cluster node**
- **slave**

## Images types

There are the following images defined:

- **redis_base** - base image which other images inherits from
- **redis_standalone** - image containing standalone redis instance (master)
- **redis_slave** - image containing redis slave instance
- **redis_cluster** - image containing redis cluster node instance
- **redis_tools** - image containing redis tools for redis cluster management

## Scripts

You can find example scripts in "scripts" directory:
- **build_all.sh** - builds all images with proper names
- **init-cluster.sh** - initiates cluster from already running Redis instances
- **run_standalone.sh** - starts standalone Redis instance
- **run-cluster-locally.sh** - starts a Redis cluster locally (6 instances - 3 master and 3 slaves)

## Clusterization

In order to start Redis cluster, one should start at least 3 cluster nodes and execute "scripts/init-cluster.sh".

## Customization

Environment variables may be used to customize/update redis default properties.
ENV vars should be passed when running container.
Below you can find a list of files with ENV vars.

For now redis-slave and redis-sentinel images requires the following ENV variables to be provided:
- REDIS_MASTER_PORT_6379_TCP_ADDR
- REDIS_MASTER_PORT_6379_TCP_PORT

They can be provided manually by using "-e" parameter while running "docker run" or by linking containers together using "--link" parameter.

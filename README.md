# docker-redis

This redis image is based on __Redis 4.0.1__ and allows run redis in three ways:

* __Redis Sentinel__
* __Redis Cluster__
* __Redis Standalone__

Redis configuration files contents can be provided via environment variables (in 12-factor way). 

## Configuration
Configuration should be passed via environment variables.

### Environment variables:

* `REDIS_NODE_TYPE` - mandatory variable indicates in which configuration will run Redis. Supported values:
    * `SENTINEL` - redis will be run as Sentinel node (for Sentinel mode)
    * `SENTINEL_INIT_MASTER` - redis will be run as Sentinel Master node (for Sentinel mode)
    * `SENTINEL_SLAVE` -  - redis will be run as Sentinel Slave node (for Sentinel mode)
    * `CLUSTER_NODE` - redis will be run as Cluster node (for Cluster mode)
    * `STANDALONE` - redis will be run as Standalone node (for Standalone mode)

### Environment variables used in Sentinel mode:

* `SENTINEL_MASTER_ID` - name of master configured in `sentinel.conf` used to monitoring
* `SENTINEL_SERVICE_HOST` - ip of sentinel service 
* `SENTINEL_SERVICE_PORT` - port of sentinel service
* `SENTINEL_INIT_MASTER_HOST` - ip of redis node run as Sentinel Master
* `SENTINEL_INIT_MASTER_PORT` - port of redis node run as Sentinel Master


### Environment variables stored in files:

* `REDIS_CONFIG` - if present will be saved into `/data/redis.conf` that will be passed to redis-server command.
  Description of [redis.conf](http://download.redis.io/redis-stable/redis.conf)
* `SENTINEL_CONFIG` - if present will be saved into `/data/sentinel.conf`.
  Description of [sentinel.conf](http://download.redis.io/redis-stable/sentinel.conf)
* `CLUSTER_CONFIG` - if present will be saved into `/data/nodes.conf`.

### Command line variables
Image supports configuration provided via command line. Options from command line have bigger priority than 
configuration from redis.conf



## How to run it in Kubernetes?


### Redis Sentinel

Suggested Sentinel deployment is based on three Sentinels and three Redis nodes, one node run as a Master 
and two nodes run as a Slaves.

[Here](example/k8s/sentinel) is example configuration


### Redis Cluster

[Here](example/k8s/cluster) is example configuration


### Redis Standalone

[Here](example/k8s/standalone) is example configuration

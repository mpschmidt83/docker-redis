print_help_and_exit () {
   echo "Initiaties cluster from existing Redis instances."
   echo "Usage: create-cluster.sh <NUMBER_OF_REPLICAS> <IP:PORT ...>";
   echo "Example: create-cluster.sh 1 172.17.0.250:6379 172.17.0.251:6379 172.17.0.252:6379";
   exit 2;
}

if [ -z "$1" ]; then
    print_help_and_exit
fi

REPLICAS=$1; shift
docker run -it oberthur/redis-cluster /redis-3.0.7/src/redis-trib.rb create --replicas $REPLICAS $@

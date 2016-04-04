FROM oberthur/redis-base:latest

MAINTAINER Konrad Król <k.krol@oberthur.com>

EXPOSE 6379
RUN sysctl vm.overcommit_memory=1
ADD redis.conf /etc/redis.conf
ENTRYPOINT ["/usr/local/bin/redis-server"]
CMD ["/etc/redis.conf"]


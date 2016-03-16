FROM ubuntu:14.04.4

MAINTAINER Konrad Król <k.krol@oberthur.com>

RUN apt-get update
RUN apt-get install -y build-essential wget
RUN wget http://download.redis.io/releases/redis-3.0.7.tar.gz
RUN tar xvfz redis-3.0.7.tar.gz
RUN cd redis-3.0.7 && make
RUN cd redis-3.0.7 && make install

#
# build:  docker build -t oberthur/redis-base:1.0.0 .
# tag:    docker tag oberthur/redis-base:1.0.0 oberthur/redis-base:latest
# run:    docker run -i -t oberthur/redis-base:1.0.0 /bin/bash
# cli:    docker run --link=redis0:redis -i -t --name=redis-cli oberthur/redis-base /bin/bash
#

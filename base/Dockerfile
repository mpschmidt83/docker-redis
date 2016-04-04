FROM ubuntu:14.04.4

MAINTAINER Konrad Król <k.krol@oberthur.com>

RUN apt-get update
RUN apt-get install -y build-essential wget ruby
RUN wget http://download.redis.io/releases/redis-3.0.7.tar.gz
RUN tar xvfz redis-3.0.7.tar.gz
RUN cd redis-3.0.7 && make
RUN cd redis-3.0.7 && make install
RUN gem install redis
ADD redis-trib-autoconfirm.rb redis-trib-autoconfirm.rb
RUN chmod +x redis-trib-autoconfirm.rb


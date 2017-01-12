FROM oberthur/docker-ubuntu:16.04

MAINTAINER Marcin Schmidt <m.schmidt@oberthur.com>

ENV REDIS_VERSION 3.2.5

COPY run.sh /run.sh

RUN chmod +x run.sh \
    && apt-get update \
    && apt-get install -y build-essential wget ruby \
    && wget -O redis.tar.gz http://download.redis.io/releases/redis-$REDIS_VERSION.tar.gz \
    && mkdir -p /usr/src/redis \
    && tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 \
    && rm redis.tar.gz \
    && grep -q '^#define CONFIG_DEFAULT_PROTECTED_MODE 1$' /usr/src/redis/src/server.h \
    && sed -ri 's!^(#define CONFIG_DEFAULT_PROTECTED_MODE) 1$!\1 0!' /usr/src/redis/src/server.h \
    && grep -q '^#define CONFIG_DEFAULT_PROTECTED_MODE 0$' /usr/src/redis/src/server.h \
    && make -C /usr/src/redis \
    && make -C /usr/src/redis install \
    && rm -r /usr/src/redis



RUN mkdir /data
VOLUME /data
WORKDIR /data

EXPOSE 6379

CMD [ "/run.sh" ]
ENTRYPOINT [ "bash", "-c" ]


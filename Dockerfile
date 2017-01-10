FROM redis:3.2.5

MAINTAINER Marcin Schmidt <m.schmidt@oberthur.com>

COPY run.sh /run.sh
RUN chown redis:redis /run.sh && \
    chmod +x /run.sh

CMD [ "/run.sh" ]

ENTRYPOINT [ "bash", "-c" ]
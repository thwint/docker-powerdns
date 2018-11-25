FROM quay.io/thwint/alpine-base:3.8-0

LABEL maintainer="Tom Winterhalder <tom.winterhalder@gmail.com>"

COPY *.sh /
COPY pdns.conf /etc/pdns/
COPY sql/ /etc/pdns/sql

RUN apk add --no-cache pdns pdns-backend-mysql pdns-backend-sqlite3 pdns-backend-pgsql pdns-backend-mariadb mysql-client && \
    rm -rf /var/cache/apk/*

EXPOSE 53/tcp 53/udp 8081

HEALTHCHECK --interval=1m CMD /healthcheck.sh || exit 1

CMD ["/start.sh"]

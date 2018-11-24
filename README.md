[![Docker Repository on Quay](https://quay.io/repository/thwint/powerdns/status "Docker Repository on Quay")](https://quay.io/repository/thwint/powerdns)
![License MIT](https://img.shields.io/badge/license-MIT-blue.svg)
# PowerDNS Docker image
A docker container shipping PowerDNS nameserver

## Backends included

* MySQL
* PostgreSQL (coming soon)
* SQLite 3 (coming soon)

## Usage

### docker-compose
PowerDNS server with webserver and API enabled.
```
version: '2.1'
services:
  pdns:
    image: pdns
    container_name: pdns
    hostname: pdns
    environment:
      PDNS_LAUNCH: gmysql
      PDNS_GMYSQL_HOST: pdns.db
      PDNS_GMYSQL_PORT: 3306
      PDNS_GMYSQL_DBNAME: pdns
      PDNS_GMYSQL_USER: pdns
      PDNS_GMYSQL_PASSWORD: pdnspassword
      PDNS_WEBSERVER: "yes"
      PDNS_WEBSERVER_ADDRESS: 0.0.0.0
      PDNS_WEBSERVER_PORT: 8081
      PDNS_WEBSERVER_PASSWORD: webpassword
      PDNS_WEBSERVER_ALLOW_FROM: "172.19.0.0/16"
      PDNS_API: "yes"
      PDNS_API_KEY: mysecretapikey
      PDNS_ALLOW_AXFR_IPS: "123.45.6.7,123.54.7.6"
      PDNS_LOCAL_ADDRESS: 0.0.0.0
    ports:
      - "53:53"
    depends_on:
      - "pdns.db"
    networks:
      - default

  pdns.db:
    image: mariadb
    container_name: pdns.db
    hostname: pdns.db
    environment:
      MYSQL_ROOT_PASSWORD: dbadminpassword
      MYSQL_DATABASE: pdns
      MYSQL_USER: pdns
      MYSQL_PASSWORD: pdnspassword
    networks:
      - default
```


## Configuration

**Environment variables**

All variables beginning with PDNS will be included in pdns.conf.
PDNS_GMYSQL_HOST will become gmysql-host in pdns.conf. 

## Maintainer

* Tom Winterhalder <tom.winterhalder@gmail.com>


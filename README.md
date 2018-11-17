# PowerDNS Docker image
A docker container shipping PowerDNS nameserver

## Backends included

* MySQL
* PostgreSQL (coming soon)
* SQLite 3 (coming soon)

## Usage

### docker-compose

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
    ports:
      - "54:53"
      - "8081:8081"
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


## Configuration

**Environment variables**

All variables beginning with PDNS will be included in pdns.conf.
PDNS_GMYSQL_HOST will become gmysql-host in pdns.conf. 

## Maintainer

* Tom Winterhalder <tom.winterhalder@gmail.com>

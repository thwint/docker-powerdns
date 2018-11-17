#!/bin/sh
set -x
# translate all environment variables to values usable in configuration file
env | while IFS='=' read -r envvar_key envvar_value
do
    # Environment variables usable in pds.conf have to start with PDNS. 
    REALKEY=$(expr ${envvar_key} : 'PDNS_\([A-Za-z_=]\+\)')
    if [[ ! -z $(expr ${envvar_key} : 'PDNS_\([A-Za-z_=]\+\)') ]]; then
        if [[ ! -z $envvar_value ]]; then
          echo "${REALKEY}=${envvar_value}" | tr '[:upper:]_' '[:lower:]-' >> /etc/pdns/pdns.conf
        fi
    fi
done

# SQL file to initialize DB schema
DB_INIT_SCHEMA=/etc/pdns/sql/init_${PDNS_LAUNCH}.sql


function waitAndInitMySql {
    while ! mysqladmin ping --host=${PDNS_GMYSQL_HOST} --user=${PDNS_GMYSQL_USER} --port=${PDNS_GMYSQL_PORT} --password=${PDNS_GMYSQL_PASSWORD} --silent; do
        sleep 1
    done

    DB_CMD="mysql --host=${PDNS_GMYSQL_HOST} --user=${PDNS_GMYSQL_USER} --port=${PDNS_GMYSQL_PORT} --password=${PDNS_GMYSQL_PASSWORD} --silent"

    if [ "$(echo "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = \"${PDNS_GMYSQL_DBNAME}\";" | ${DB_CMD})" -le 1 ]; then
        echo Database is empty. Initializing database ...
        ${DB_CMD} -r -N -w ${PDNS_GMYSQL_DBNAME} < ${DB_INIT_SCHEMA}
    fi

}

function waitAndInitPSql() {
    echo not yet implemented
    exit 1
}

function initSqlite3() {
    echo not yet implemented
    exit 1

}

case ${PDNS_LAUNCH} in
    "gmysql")
        waitAndInitMySql
        ;;
    "gpgsql")
        waitAndInitPSql
        ;;
    "gsqlite3")
        initSqlite3
        ;;
    *)
        echo "Unknown DB type used! Skipping autoconfig"
        ;;
esac



# traps to properly shutdown powerdns 
trap "pdns_control quit" SIGHUP SIGINT SIGTERM

# start pdns server
/usr/sbin/pdns_server 

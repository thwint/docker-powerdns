#!/bin/sh

# check if database is running
ERR_MSG=$(mysql --host=${PDNS_GMYSQL_HOST} --port=${PDNS_GMYSQL_PORT} --user=${PDNS_GMYSQL_USER} --password=${PDNS_GMYSQL_PASSWORD} -e "show databases;" 1>/dev/null)
echo ${ERR_MSG}
if [ "${ERR_MSG}" != "" ]; then
    exit 1
fi

# check powerdns
PDNS_STATUS=$(pdns_control ping)
echo ${PDNS_STATUS}
if [ "${PDNS_STATUS}" != "PONG" ]; then
    exit 1
fi

exit 0

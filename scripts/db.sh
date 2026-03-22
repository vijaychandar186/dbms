#!/bin/bash

case "$1" in
  mysql)
    mysql -h db -u user -ppassword DB
    ;;
  oracle)
    sqlplus '"user"/"password"@//oracle:1521/XEPDB1'
    ;;
  *)
    echo "Usage: db.sh [mysql|oracle]"
    ;;
esac

#!/bin/bash

MYSQL_HOST="${MYSQL_HOST:-db}"
MYSQL_USER="${MYSQL_USER:-user}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-password}"
MYSQL_DATABASE="${MYSQL_DATABASE:-DB}"

ORACLE_HOST="${ORACLE_HOST:-oracle}"
ORACLE_PORT="${ORACLE_PORT:-1521}"
ORACLE_SERVICE="${ORACLE_SERVICE:-XEPDB1}"
ORACLE_USER="${ORACLE_USER:-user}"
ORACLE_PASSWORD="${ORACLE_PASSWORD:-password}"
ORACLE_SYS_PASSWORD="${ORACLE_SYS_PASSWORD:-password}"

echo "Waiting for MySQL to be ready..."
mysql_ready=false
for i in $(seq 1 60); do
  if mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" -e "SELECT 1" &>/dev/null; then
    echo "MySQL is ready!"
    mysql_ready=true
    break
  fi
  sleep 2
done

if [ "$mysql_ready" != "true" ]; then
  echo "Warning: MySQL did not become ready in time."
fi

echo "Waiting for Oracle to be ready..."
oracle_ready=false
for i in $(seq 1 90); do
  if printf 'exit\n' | sqlplus -L "sys/${ORACLE_SYS_PASSWORD}@//${ORACLE_HOST}:${ORACLE_PORT}/${ORACLE_SERVICE}" as sysdba &>/dev/null; then
    echo "Oracle is ready!"
    oracle_ready=true
    break
  fi
  sleep 2
done

if [ "$oracle_ready" = "true" ]; then
  # Create the app user if it doesn't exist (using quoted identifier for reserved keyword)
  cat > /tmp/create_user.sql <<'SQLEOF'
CREATE USER "user" IDENTIFIED BY "password";
GRANT CONNECT, RESOURCE, DBA TO "user";
EXIT;
SQLEOF
  
  sqlplus -S "sys/${ORACLE_SYS_PASSWORD}@//${ORACLE_HOST}:${ORACLE_PORT}/${ORACLE_SERVICE}" as sysdba @/tmp/create_user.sql 2>&1 | grep -v "^$" || true
  rm -f /tmp/create_user.sql
  
  # Test app user connection with quoted identifier
  if printf 'exit\n' | sqlplus -L "\"${ORACLE_USER}\"/\"${ORACLE_PASSWORD}\"@//${ORACLE_HOST}:${ORACLE_PORT}/${ORACLE_SERVICE}" &>/dev/null; then
    echo "Oracle user is ready!"
  else
    echo "Warning: Oracle user credentials could not be verified."
  fi
else
  echo "Warning: Oracle did not become ready in time."
fi

if [ "$mysql_ready" = "true" ] && [ "$oracle_ready" = "true" ]; then
  echo ""
  echo "All databases are ready! Connect using:"
  echo "  MySQL:  mysql -h db -u user -ppassword DB"
  echo "  Oracle: sqlplus '\"user\"/\"password\"@//oracle:1521/XEPDB1'"
  echo "  Helper: ./scripts/db.sh mysql|oracle"
else
  echo ""
  echo "Setup completed with notices:"
  [ "$mysql_ready" != "true" ] && echo "  - MySQL did not become ready in time"
  [ "$oracle_ready" != "true" ] && echo "  - Oracle did not become ready in time"
fi

exit 0

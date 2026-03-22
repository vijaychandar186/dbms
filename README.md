# Oracle + MySQL Dev Container Starter

A small SQL playground that brings Oracle XE 21c and MySQL 8.0 into one VS Code Dev Container.

It includes:

- Oracle XE 21c
- MySQL 8.0
- CloudBeaver web UI for browsing both databases
- SQL\*Plus and MySQL CLI inside the dev container
- A helper script for quick CLI access

## Quick Start

1. Open the project in VS Code.
2. Reopen it in the Dev Container.
3. Wait for the databases to finish starting.
4. Connect with the CLI commands below or a database client of your choice.

## Services

### Oracle

- Host: `oracle`
- Port: `1521`
- Service: `XEPDB1`
- User: `user`
- Password: `password`

### MySQL

- Host: `db`
- Port: `3306`
- Database: `DB`
- User: `user`
- Password: `password`

## CLI Usage

Connect to MySQL from inside the dev container:

```bash
mysql -h db -u user -ppassword DB
```

Connect to Oracle from inside the dev container:

```bash
sqlplus '"user"/"password"@//oracle:1521/XEPDB1'
```

Use the helper script:

```bash
chmod +x ./scripts/db.sh
./scripts/db.sh mysql
./scripts/db.sh oracle
```

## Web DB Viewer

The compose stack also includes CloudBeaver, a browser-based database client that can connect to both Oracle and MySQL.

- URL: `http://localhost:8978`
- Add a MySQL connection with host `db`, port `3306`, database `DB`, user `user`, password `password`
- Add an Oracle connection with host `oracle`, port `1521`, service `XEPDB1`, user `user`, password `password`

If your dev container is already running, rebuild or restart the compose stack so the new service starts.

## Useful Notes

### MySQL

- End statements with `;`
- Use `\G` for vertical output when helpful

### Oracle

- End PL/SQL blocks with `/`
- Enable printed output with `SET SERVEROUTPUT ON`

Example Oracle block:

```sql
SET SERVEROUTPUT ON

BEGIN
  DBMS_OUTPUT.PUT_LINE('Hello Oracle');
END;
/
```

## Project Structure

- `.devcontainer/docker-compose.yml`: Oracle, MySQL, CloudBeaver, and the dev container
- `.devcontainer/Dockerfile`: installs SQL\*Plus and MySQL CLI tools
- `scripts/db.sh`: quick database connection helper

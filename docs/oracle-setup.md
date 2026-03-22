# Oracle PL/SQL Dev Container

This project provides a complete development environment for Oracle PL/SQL using Docker, Docker Compose, and a VS Code Dev Container.

---

# 📦 Overview

This setup runs:

* 🟠 Oracle Database XE 21c in a container
* 🧰 A development container with Oracle Instant Client and SQL*Plus
* 💻 VS Code Dev Container integration

This allows you to write, run, and test PL/SQL scripts locally.

---

# 🧱 Services

## 🟠 oracle

Runs Oracle XE 21c using the image:

```
gvenzl/oracle-xe:21
```

### Ports

* `1521` → Oracle database

### Environment Variables

Make sure these are set correctly in your `docker-compose.yml` or `.env`:

```yaml
environment:
  ORACLE_PASSWORD: password
  APP_USER: user
  APP_USER_PASSWORD: password
```

---

## 🧰 dev

Development container used by VS Code.

### Includes

* Oracle Instant Client
* SQL*Plus
* Git
* Basic Linux tools

---

# 🔌 Connecting to Oracle

## From Dev Container

Use SQL*Plus:

```bash
sqlplus '"user"/"password"@//oracle:1521/XEPDB1'
```

---

## 📡 Connection Details

| Field    | Value    |
| -------- | -------- |
| Host     | oracle   |
| Port     | 1521     |
| Service  | XEPDB1   |
| Username | user     |
| Password | password |

⚠️ Important: Always use `XEPDB1` (Pluggable Database), not `XE`.

---

# 🧪 Testing the Connection

After connecting:

```sql
SELECT 'Connected!' FROM dual;
```

If it returns:

```
Connected!
```

✅ Your setup is working correctly

---

# 📝 Running SQL Files

## 1️⃣ Create a SQL File

```bash
nano hello.sql
```

### Example

```sql
SET SERVEROUTPUT ON

BEGIN
  DBMS_OUTPUT.PUT_LINE('Hello Oracle');
END;
/
```

---

## 2️⃣ Run Inside SQL*Plus

```sql
@hello.sql
```

---

## 3️⃣ Run Directly from Terminal

```bash
sqlplus user/password@//oracle:1521/XEPDB1 @hello.sql
```

---

# 🚪 Exit SQL*Plus

```sql
EXIT
```

---

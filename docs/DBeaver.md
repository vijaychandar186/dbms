# DBeaver Setup

Follow these steps in order.

---

# 1. Create Admin User (First Launch Only)

When you open DBeaver for the first time:

1. Launch DBeaver
2. You will be prompted to create an admin/user profile
3. Enter:

   * Username: anything (e.g. `admin`)
   * Password: anything you want
4. Click Finish

Note: This is just for DBeaver itself (not your databases)

---

# 2. Create MySQL Connection

## Step 2.1 – New Connection

1. Click New Database Connection
2. Select MySQL
3. Click Next

---

## Step 2.2 – Fill Connection Details

Enter exactly:

* Host: `db`
* Port: `3306`
* Database: `DB`
* Username: `user`
* Password: `password`

---

## Step 2.3 – Driver Properties (Important)

Scroll to Driver Properties and set:

* allowPublicKeyRetrieval = TRUE

Optional (if SSL errors):

* useSSL = FALSE

---

## Step 2.4 – Test

1. Click Test Connection
2. Download driver if prompted
3. Click Finish

---

# 3. Create Oracle Connection

## Step 3.1 – New Connection

1. Click New Database Connection
2. Select Oracle
3. Click Next

---

## Step 3.2 – Fill Connection Details

Enter exactly:

* Host: `oracle`
* Port: `1521`
* Service Type: SERVICE
* Service Name (Database field): `XEPDB1`
* Username: `user`
* Password: `password`

---

## Step 3.3 – Critical Setting

Make sure:

* You are using Service Name, NOT SID

---

## Step 3.4 – Test

1. Click Test Connection
2. Accept driver download if needed
3. Click Finish

---

# Final Check

Run these queries:

## MySQL

```sql
SELECT 1;
```

## Oracle

```sql
SELECT * FROM dual;
```

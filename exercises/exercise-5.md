# Exercise 5 — Data Control Language (DCL) and Transaction Control Language (TCL)

---

## Part A — DCL Commands

DCL commands control **who** can do **what** on database objects.

---

### Q1) Grant SELECT, INSERT, and UPDATE privileges on EMP to another user

```sql
GRANT SELECT, INSERT, UPDATE ON EMP TO other_username;
```

**Explanation:**
- `GRANT` gives a named user (or role) specific privileges on your object.
- `SELECT` — allows the grantee to query the table.
- `INSERT` — allows adding new rows.
- `UPDATE` — allows modifying existing rows.
- Replace `other_username` with the actual database user (e.g., a classmate's login ID).
- The grantor must own the object or hold `GRANT OPTION` on the privilege.

---

### Q2) Verify the table structure from your login after the grant

```sql
DESC EMP;
```

**Explanation:**
- `DESC` shows the table's column definitions. The structure is unchanged by a `GRANT` — only access rights change.
- If you `DESC` the table from the **grantee's** login, they can now see it because `SELECT` was granted.
- From the owner's login, nothing looks different — the grant is metadata only.

---

### Q3) Revoke the previously granted privileges

```sql
REVOKE SELECT, INSERT, UPDATE ON EMP FROM other_username;
```

**Explanation:**
- `REVOKE` removes previously granted privileges.
- After this, if the grantee tries `SELECT * FROM owner.EMP`, they receive:
  `ORA-01031: insufficient privileges`
- Any objects the grantee created that depend on the revoked privilege (e.g., a view over your EMP) also become invalid.

---

## Part B — TCL Commands

TCL commands control the **permanence** of DML changes within a transaction.

---

### DEPT Table Data

| DEPTNO | DNAME         | LOC           |
|--------|---------------|---------------|
| 10     | ACCOUNTING    | NEW YORK      |
| 20     | RESEARCH      | DALLAS        |
| 30     | SALES         | CHICAGO       |
| 40     | OPERATIONS    | BOSTON        |
| 50     | MANUFACTURING | BOSTON        |

---

### Q1) Create the DEPT table, insert the data above, and commit

```sql
CREATE TABLE DEPT (
    DEPTNO NUMBER(2)    PRIMARY KEY,
    DNAME  VARCHAR2(30) NOT NULL,
    LOC    VARCHAR2(30) NOT NULL
);

INSERT INTO DEPT (DEPTNO, DNAME, LOC) VALUES (10, 'ACCOUNTING',    'NEW YORK');
INSERT INTO DEPT (DEPTNO, DNAME, LOC) VALUES (20, 'RESEARCH',      'DALLAS');
INSERT INTO DEPT (DEPTNO, DNAME, LOC) VALUES (30, 'SALES',         'CHICAGO');
INSERT INTO DEPT (DEPTNO, DNAME, LOC) VALUES (40, 'OPERATIONS',    'BOSTON');
INSERT INTO DEPT (DEPTNO, DNAME, LOC) VALUES (50, 'MANUFACTURING', 'BOSTON');

COMMIT;
```

**Explanation:**
- `COMMIT` makes all DML changes in the current transaction permanent and visible to other sessions.
- DDL statements (`CREATE TABLE`) implicitly commit any open transaction before and after executing.
- Once committed, the data cannot be rolled back.

---

### Q2) Update department 40's location to 'San Francisco' — do NOT commit yet

```sql
UPDATE DEPT SET LOC = 'San Francisco' WHERE DEPTNO = 40;
```

**Explanation:**
- This change exists only in your **current session's transaction buffer** — other sessions still see `LOC = 'BOSTON'` for DEPTNO 40.
- The update is **not permanent** until `COMMIT` is issued.
- You can undo it at any point before committing using `ROLLBACK`.

---

### Q3) Rollback to restore the previous state, then display the table

```sql
ROLLBACK;

SELECT * FROM DEPT;
```

**Expected result after rollback:** DEPTNO 40 shows `LOC = 'BOSTON'` again.

**Explanation:**
- `ROLLBACK` undoes all uncommitted DML changes in the current transaction, restoring the table to its last committed state.
- The `SELECT` after the rollback confirms department 40's location is back to 'BOSTON'.

---

### Q4) Delete all entries from DEPT where location is 'CHICAGO'

```sql
DELETE FROM DEPT WHERE LOC = 'CHICAGO';
```

**Explanation:**
- This deletes the SALES department (DEPTNO 30, LOC = 'CHICAGO').
- The deletion is uncommitted — a `ROLLBACK` here would restore it.
- Do not issue `COMMIT` yet if you want the option to undo.

---

### Q5) Update DEPT: set LOC = 'BOSTON' for DEPTNO = 40

```sql
UPDATE DEPT SET LOC = 'BOSTON' WHERE DEPTNO = 40;
```

**Explanation:**
- This reverts department 40's location to 'BOSTON' (undoing Q2's change within this new transaction).

---

### Q6) Create a savepoint named 'update_over'

```sql
SAVEPOINT update_over;
```

**Explanation:**
- A `SAVEPOINT` marks a point within the current transaction that you can partially roll back to.
- Changes made **before** this savepoint can be preserved while rolling back changes made **after** it.
- Savepoints are temporary — they disappear when the transaction ends (COMMIT or full ROLLBACK).

---

### Q7) Insert a new row into DEPT

```sql
INSERT INTO DEPT (DEPTNO, DNAME, LOC) VALUES (60, 'MARKETING', 'LOS ANGELES');
```

**Explanation:**
- A new department is added after the savepoint `update_over`.
- This change is in the transaction but **after** the savepoint marker.

---

### Q8) Display the current state of the DEPT table

```sql
SELECT * FROM DEPT;
```

**Explanation:**
- At this point you should see: departments 10, 20, 40, 50 (30 was deleted in Q4), plus the new 60 added in Q7.

---

### Q9) Create a second savepoint named 'update_another'

```sql
SAVEPOINT update_another;
```

**Explanation:**
- A second marker is created. The transaction now has two savepoints: `update_over` (older) and `update_another` (newer).

---

### Q10) Display the data, rollback to 'update_over', then display again

```sql
-- Current state before rollback
SELECT * FROM DEPT;

-- Rollback to the earlier savepoint
ROLLBACK TO update_over;

-- State after partial rollback
SELECT * FROM DEPT;
```

**Inference:**
- After `ROLLBACK TO update_over`, the INSERT from Q7 (department 60) and savepoint `update_another` are undone.
- The DELETE from Q4 (DEPTNO 30) remains undone — it was before `update_over`.
- The UPDATE from Q5 (DEPTNO 40 → 'BOSTON') remains — it was before `update_over`.
- **Partial rollback** lets you undo only the most recent portion of a transaction, which is useful for correcting mistakes mid-transaction without losing all prior work.

| Command                    | Effect                                              |
|----------------------------|-----------------------------------------------------|
| `COMMIT`                   | Makes all changes permanent                         |
| `ROLLBACK`                 | Undoes all uncommitted changes                      |
| `SAVEPOINT name`           | Marks a rollback point within the transaction       |
| `ROLLBACK TO name`         | Undoes changes after the named savepoint only       |

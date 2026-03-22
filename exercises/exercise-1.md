# Exercise 1 — Creating and Managing Database Tables

## Schema Reference

### DEPT Table

| Column Name | Data Type    | Description         |
|-------------|--------------|---------------------|
| DEPTNO      | NUMBER       | Department number   |
| DNAME       | VARCHAR2(50) | Department name     |
| LOC         | VARCHAR2(50) | Department location |

### EMP Table

| Column Name | Data Type    | Description           |
|-------------|--------------|-----------------------|
| EMPNO       | NUMBER       | Employee number       |
| ENAME       | VARCHAR2(50) | Employee name         |
| JOB         | CHAR(30)     | Designation           |
| MGR         | NUMBER       | Manager's EMP number  |
| HIREDATE    | DATE         | Date of joining       |
| SAL         | NUMBER       | Basic salary          |
| COMM        | NUMBER       | Commission            |
| DEPTNO      | NUMBER       | Department number     |

---

## Questions and Solutions

### Q1) Create the tables DEPT and EMP as described above

```sql
CREATE TABLE DEPT (
    DEPTNO NUMBER,
    DNAME  VARCHAR2(50),
    LOC    VARCHAR2(50)
);
```

```sql
CREATE TABLE EMP (
    EMPNO    NUMBER,
    ENAME    VARCHAR2(50),
    JOB      CHAR(30),
    MGR      NUMBER,
    HIREDATE DATE,
    SAL      NUMBER,
    COMM     NUMBER,
    DEPTNO   NUMBER
);
```

**Explanation:**
- `CREATE TABLE` defines a new table with specified columns and their data types.
- `NUMBER` stores numeric values (integers or decimals).
- `VARCHAR2(n)` stores variable-length strings up to `n` characters — preferred over `VARCHAR` in Oracle as its behavior is well-defined.
- `CHAR(n)` stores fixed-length strings, always padded to `n` characters. Suitable for `JOB` since designation values tend to be consistent in length.
- `DATE` stores both date and time in Oracle.
- `MGR` references another employee's `EMPNO`, making it a self-referencing foreign key conceptually (enforced separately via constraints).

---

### Q2) Confirm table creation

```sql
DESC DEPT;
```

```sql
DESC EMP;
```

**Explanation:**
- `DESC` (short for `DESCRIBE`) displays the structure of a table: column names, data types, and whether nulls are allowed.
- This is used to verify that the table was created with the correct columns and types.

---

> **Note:** Questions Q3–Q6 are not present in the source material for this exercise.

---

### Q7) Add new columns COMNT and MISCEL of character type to the DEPT table

```sql
ALTER TABLE DEPT ADD (
    COMNT  CHAR(50),
    MISCEL CHAR(50)
);
```

**Explanation:**
- `ALTER TABLE ... ADD` adds one or more new columns to an existing table.
- Both columns use `CHAR(50)` as specified (fixed-length character type).
- Wrapping multiple columns in parentheses `( )` adds them in a single statement, which is cleaner than two separate `ALTER` statements.
- Newly added columns default to `NULL` for all existing rows.

---

### Q8) Increase the size of the LOC column to 15 characters in the DEPT table

```sql
ALTER TABLE DEPT MODIFY (LOC VARCHAR2(15));
```

**Explanation:**
- `ALTER TABLE ... MODIFY` changes the definition of an existing column (data type, size, or constraint).
- Increasing a column's size is always safe. Decreasing it may fail if existing data exceeds the new size.
- Here LOC is changed from `VARCHAR2(50)` to `VARCHAR2(15)` — this is a reduction, so it would only succeed if no existing value in LOC is longer than 15 characters.

---

### Q9) Mark the MISCEL column in the DEPT table as unused

```sql
ALTER TABLE DEPT SET UNUSED (MISCEL);
```

**Explanation:**
- `SET UNUSED` is an Oracle-specific DDL command that logically marks a column as inaccessible without immediately reclaiming storage.
- The column no longer appears in `SELECT *`, `DESC`, or DML operations — it is effectively invisible to users.
- The actual column data remains on disk until `DROP UNUSED COLUMNS` is executed (see Q11).
- This is preferred over immediately dropping a column on large tables because it is a fast metadata-only operation, avoiding expensive full-table rewrites during peak hours.

---

### Q10) Drop the COMNT column from the DEPT table

```sql
ALTER TABLE DEPT DROP COLUMN COMNT;
```

**Explanation:**
- `ALTER TABLE ... DROP COLUMN` permanently removes a column and all its data from the table.
- Unlike `SET UNUSED`, this immediately reclaims storage but requires a full table scan/rewrite, which can be slow on large tables.
- Once dropped, the column cannot be recovered without a backup.

---

### Q11) Drop all unused columns from the DEPT table

```sql
ALTER TABLE DEPT DROP UNUSED COLUMNS;
```

**Explanation:**
- This reclaims the storage space held by columns previously marked with `SET UNUSED` (like MISCEL from Q9).
- It is the second step in the two-phase column removal strategy: first `SET UNUSED` (fast, metadata-only), then `DROP UNUSED COLUMNS` (slower, reclaims storage).
- Running this during off-peak hours on large tables minimizes performance impact.

---

### Q12) Rename the table DEPT to DEPT12

```sql
ALTER TABLE DEPT RENAME TO DEPT12;
```

**Explanation:**
- `ALTER TABLE ... RENAME TO` renames a table. The table's data, constraints, and indexes are all preserved — only the name changes.
- Alternatively, `RENAME DEPT TO DEPT12;` achieves the same result in Oracle.
- Any views, procedures, or synonyms referencing the old name `DEPT` will break and need to be updated.

---

### Q13) Remove all rows from the DEPT12 table

```sql
TRUNCATE TABLE DEPT12;
```

**Explanation:**
- `TRUNCATE` removes all rows from a table instantly. It is a DDL operation, not DML.
- It is much faster than `DELETE FROM DEPT12` because it does not generate individual row-level undo logs — it simply deallocates the data pages.
- Key differences vs `DELETE`:
  | Feature              | TRUNCATE          | DELETE              |
  |----------------------|-------------------|---------------------|
  | Speed                | Very fast         | Slower on large tables |
  | WHERE clause support | No                | Yes                 |
  | Rollback possible    | No (in Oracle)    | Yes                 |
  | Triggers fired       | No                | Yes                 |
  | Resets auto-increment| Yes               | No                  |

---

## Additional Practice — Employee Table

These exercises build on the same DDL concepts using a separate `Employee` table.

### A1) Create the Employee table

```sql
CREATE TABLE Employee (
    name      VARCHAR2(20),
    empid     NUMBER,
    dept      VARCHAR2(20),
    phone_num NUMBER
);
```

### A2) Add DOJ and position columns to Employee

```sql
ALTER TABLE Employee ADD (
    DOJ      DATE,
    position VARCHAR2(20)
);
```

### A3) Increase the size of the name column to 25 characters

```sql
ALTER TABLE Employee MODIFY (name VARCHAR2(25));
```

### A4) Confirm the updated structure

```sql
DESC Employee;
```

### A5) Rename the position column to Designation

```sql
ALTER TABLE Employee RENAME COLUMN position TO Designation;
```

**Explanation:**
- `ALTER TABLE ... RENAME COLUMN ... TO ...` renames a single column.
- All data in the column is preserved; only the column name changes.

### A6) Confirm the rename

```sql
DESC Employee;
```

### A7) Rename the Employee table to Emp_table

```sql
ALTER TABLE Employee RENAME TO Emp_table;
```

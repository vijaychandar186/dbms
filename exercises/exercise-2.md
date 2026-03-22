# Exercise 2 — Data Manipulation Language (DML)

## Schema Reference

### EMP Table

| EMPNO | ENAME  | JOB       | MGR  | HIREDATE    | SAL  | COMM | DEPTNO |
|-------|--------|-----------|------|-------------|------|------|--------|
| 7369  | SMITH  | CLERK     | 7902 | 17-DEC-1980 | 800  | NULL | 20     |
| 7499  | ALLEN  | SALESMAN  | 7698 | 20-FEB-1981 | 1600 | 300  | 30     |
| 7521  | WARD   | SALESMAN  | 7698 | 22-FEB-1981 | 1250 | 500  | 30     |
| 7566  | JONES  | MANAGER   | 7839 | 02-APR-1981 | 2975 | NULL | 20     |
| 7654  | MARTIN | SALESMAN  | 7698 | 28-SEP-1981 | 1250 | 1400 | 30     |
| 7698  | BLAKE  | MANAGER   | 7839 | 01-MAY-1981 | 2850 | NULL | 30     |
| 7782  | CLARK  | MANAGER   | 7839 | 09-JUN-1981 | 2450 | NULL | 10     |
| 7788  | SCOTT  | ANALYST   | 7566 | 19-APR-1987 | 3000 | NULL | 20     |
| 7839  | KING   | PRESIDENT | NULL | 17-NOV-1981 | 5000 | NULL | 10     |
| 7844  | TURNER | SALESMAN  | 7698 | 08-SEP-1981 | 1500 | 0    | 30     |
| 7876  | ADAMS  | CLERK     | 7788 | 23-MAY-1987 | 1100 | NULL | 20     |
| 7900  | JAMES  | CLERK     | 7698 | 03-DEC-1981 | 950  | NULL | 30     |
| 7902  | FORD   | ANALYST   | 7566 | 03-DEC-1981 | 3000 | NULL | 20     |
| 7934  | MILLER | CLERK     | 7782 | 23-JAN-1982 | 1300 | NULL | 10     |

### DEPT Table

| DEPTNO | DNAME      | LOC      |
|--------|------------|----------|
| 10     | ACCOUNTING | NEW YORK |
| 20     | RESEARCH   | DALLAS   |
| 30     | SALES      | CHICAGO  |
| 40     | OPERATIONS | BOSTON   |

---

## Setup — Create Tables

```sql
CREATE TABLE DEPT (
    DEPTNO NUMBER(2),
    DNAME  VARCHAR2(14),
    LOC    VARCHAR2(13)
);

CREATE TABLE EMP (
    EMPNO    NUMBER(4),
    ENAME    VARCHAR2(10),
    JOB      VARCHAR2(9),
    MGR      NUMBER(4),
    HIREDATE DATE,
    SAL      NUMBER(7,2),
    COMM     NUMBER(7,2),
    DEPTNO   NUMBER(2)
);
```

---

## Questions and Solutions

### Q1) Insert rows into the DEPT table using column-list omitted syntax

```sql
INSERT INTO DEPT VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO DEPT VALUES (20, 'RESEARCH',   'DALLAS');
INSERT INTO DEPT VALUES (30, 'SALES',      'CHICAGO');
INSERT INTO DEPT VALUES (40, 'OPERATIONS', 'BOSTON');
```

**Explanation:**
- When omitting the column list, values must be supplied in the exact order the columns were defined in `CREATE TABLE`.
- This is "syntax (i)" — compact but fragile; any schema change breaks it.
- All four department rows are inserted.

---

### Q2) Insert the first two rows of the EMP table using explicit column list syntax

```sql
INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES (7499, 'ALLEN', 'SALESMAN', 7698, '20-FEB-1981', 1600, 300, 30);

INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES (7521, 'WARD',  'SALESMAN', 7698, '22-FEB-1981', 1250, 500, 30);
```

**Explanation:**
- "Syntax (ii)" explicitly names each column before the values, making the statement readable and safe against column-order changes.
- Columns not listed (none here) would default to NULL or a defined DEFAULT value.
- Dates should use `TO_DATE('20-FEB-1981', 'DD-MON-YYYY')` when the session's NLS date format differs from the string supplied.

---

### Q3) Insert the remaining rows of the EMP table

```sql
INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES (7369, 'SMITH',  'CLERK',     7902, '17-DEC-1980', 800,  NULL, 20);

INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES (7566, 'JONES',  'MANAGER',   7839, '02-APR-1981', 2975, NULL, 20);

INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES (7654, 'MARTIN', 'SALESMAN',  7698, '28-SEP-1981', 1250, 1400, 30);

INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES (7698, 'BLAKE',  'MANAGER',   7839, '01-MAY-1981', 2850, NULL, 30);

INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES (7782, 'CLARK',  'MANAGER',   7839, '09-JUN-1981', 2450, NULL, 10);

INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES (7788, 'SCOTT',  'ANALYST',   7566, '19-APR-1987', 3000, NULL, 20);

INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES (7839, 'KING',   'PRESIDENT', NULL, '17-NOV-1981', 5000, NULL, 10);

INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES (7844, 'TURNER', 'SALESMAN',  7698, '08-SEP-1981', 1500, 0,    30);

INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES (7876, 'ADAMS',  'CLERK',     7788, '23-MAY-1987', 1100, NULL, 20);

INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES (7900, 'JAMES',  'CLERK',     7698, '03-DEC-1981', 950,  NULL, 30);

INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES (7902, 'FORD',   'ANALYST',   7566, '03-DEC-1981', 3000, NULL, 20);

INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES (7934, 'MILLER', 'CLERK',     7782, '23-JAN-1982', 1300, NULL, 10);
```

**Explanation:**
- KING has `NULL` for MGR because he is the top of the hierarchy with no manager.
- TURNER has `COMM = 0` (explicitly zero), not NULL. This is a meaningful distinction: NULL means "no commission data", 0 means "commission is zero".
- Each row is a separate `INSERT` for clarity; alternatively all could be inserted in one multi-row `INSERT ... VALUES (...), (...)` statement in databases that support it.

---

### Q4) Create a MANAGER table with columns for ID, name, salary, and hire date

```sql
CREATE TABLE MANAGER (
    MGRID    NUMBER PRIMARY KEY,
    NAME     VARCHAR2(20),
    SAL      NUMBER(7,2),
    HIREDATE DATE
);
```

**Explanation:**
- `PRIMARY KEY` ensures MGRID is unique and NOT NULL — no two managers share an ID, and every row must have one.
- The column is named `MGRID` (Manager ID), not `MRGID` (which was a typo in the original).

---

### Q5) Populate MANAGER by copying employees whose job is 'MANAGER' from EMP

```sql
INSERT INTO MANAGER (MGRID, NAME, SAL, HIREDATE)
SELECT EMPNO, ENAME, SAL, HIREDATE
FROM EMP
WHERE JOB = 'MANAGER';
```

**Explanation:**
- `INSERT INTO ... SELECT` copies data from one table directly into another without intermediate steps.
- The column list on `INSERT` must match the columns returned by `SELECT` in order and data type.
- This inserts JONES, BLAKE, and CLARK from the EMP table.

---

### Q6) Change LOC of every row in DEPT to 'NEW YORK'

```sql
UPDATE DEPT SET LOC = 'NEW YORK';
```

**Explanation:**
- An `UPDATE` without a `WHERE` clause modifies every row in the table.
- After this statement, all four departments will have `LOC = 'NEW YORK'`.
- Use with caution in production — always include a `WHERE` clause unless a full-table update is intended.

---

### Q7) Set LOC = 'DALLAS' for department number 20

```sql
UPDATE DEPT SET LOC = 'DALLAS' WHERE DEPTNO = 20;
```

**Explanation:**
- `WHERE DEPTNO = 20` restricts the update to exactly one row (assuming DEPTNO is unique).
- Only the RESEARCH department's location is changed; other departments are unaffected.

---

### Q8) Delete the row(s) from EMP where employee name is 'PAUL'

```sql
DELETE FROM EMP WHERE ENAME = 'PAUL';
```

**Explanation:**
- `DELETE FROM` removes rows matching the condition. If no rows match, no error is raised — zero rows are affected.
- `DELETE` is a DML operation and can be rolled back (unlike `TRUNCATE`).
- Since 'PAUL' does not exist in the standard dataset, this query succeeds but deletes 0 rows.

---

### Q9) List all columns and rows from DEPT

```sql
SELECT * FROM DEPT;
```

**Explanation:**
- `SELECT *` retrieves all columns. Useful for quick checks, but in application code always prefer listing columns explicitly to avoid breakage if schema changes.

---

### Q10) List employee names and salaries from EMP

```sql
SELECT ENAME, SAL FROM EMP;
```

**Explanation:**
- Projecting only the needed columns reduces data transfer and makes the result easier to read.

---

### Q11) List all unique department names from DEPT (no duplicates)

```sql
SELECT DISTINCT DNAME FROM DEPT;
```

**Explanation:**
- `DISTINCT` eliminates duplicate values in the result set.
- Without it, if multiple rows shared the same DNAME, each would appear separately.

---

### Q12) Find the name of the employee whose EMPNO is 7788

```sql
SELECT ENAME FROM EMP WHERE EMPNO = 7788;
```

**Expected result:** `SCOTT`

**Explanation:**
- The `WHERE` clause filters rows to only those where `EMPNO = 7788`.
- Because EMPNO is a unique identifier, this returns at most one row.

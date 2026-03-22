# Exercise 13 — PL/SQL Cursors

> Run `SET SERVEROUTPUT ON;` before executing any PL/SQL block.

```sql
SET SERVEROUTPUT ON;
```

A **cursor** is a pointer to the result set of a SQL query. PL/SQL uses cursors to process rows one at a time.

- **Implicit cursor** — automatically created by Oracle for single-row DML/SELECT statements. Accessed via `SQL%ROWCOUNT`, `SQL%FOUND`, `SQL%NOTFOUND`.
- **Explicit cursor** — declared by the programmer to process multi-row queries row by row.

---

## Setup — Create emp1 Table

```sql
CREATE TABLE emp1 (
    empno  NUMBER(4) PRIMARY KEY,
    ename  VARCHAR2(20),
    job    VARCHAR2(20),
    sal    NUMBER(7,2),
    deptno NUMBER(2)   -- required for Q1's department filter
);

INSERT INTO emp1 VALUES (7369, 'SMITH',  'CLERK',     800,  20);
INSERT INTO emp1 VALUES (7499, 'ALLEN',  'SALESMAN',  1600, 30);
INSERT INTO emp1 VALUES (7521, 'WARD',   'SALESMAN',  1250, 30);
INSERT INTO emp1 VALUES (7566, 'JONES',  'MANAGER',   2975, 20);
INSERT INTO emp1 VALUES (7654, 'MARTIN', 'SALESMAN',  1250, 30);
INSERT INTO emp1 VALUES (7698, 'BLAKE',  'MANAGER',   2850, 30);
INSERT INTO emp1 VALUES (7782, 'CLARK',  'MANAGER',   2450, 10);
INSERT INTO emp1 VALUES (7788, 'SCOTT',  'ANALYST',   3000, 20);
INSERT INTO emp1 VALUES (7839, 'KING',   'PRESIDENT', 5000, 10);
INSERT INTO emp1 VALUES (7844, 'TURNER', 'ANALYST',   3000, 30);
INSERT INTO emp1 VALUES (7876, 'ADAMS',  'CLERK',     5000, 20);
INSERT INTO emp1 VALUES (7900, 'JAMES',  'CLERK',      950, 30);
INSERT INTO emp1 VALUES (7902, 'FORD',   'ANALYST',   3000, 20);
INSERT INTO emp1 VALUES (7934, 'MILLER', 'CLERK',     6000, 10);
```

---

## Q1) Update salaries of all dept 20 employees by 15%; report how many were updated (or none)

```sql
DECLARE
    num NUMBER;
BEGIN
    UPDATE emp1
    SET sal = sal * 1.15
    WHERE deptno = 20;

    IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('None of the salaries were updated');
    ELSE
        num := SQL%ROWCOUNT;
        DBMS_OUTPUT.PUT_LINE('Salaries updated for ' || num || ' employee(s)');
    END IF;
END;
/
```

**Expected output:** `Salaries updated for 4 employee(s)` (SMITH, JONES, SCOTT, ADAMS, FORD — 5 rows)

**Explanation:**
- This uses an **implicit cursor** — no explicit `OPEN/FETCH/CLOSE` needed for a DML statement.
- `SQL%NOTFOUND` is TRUE if the last DML affected zero rows.
- `SQL%ROWCOUNT` holds the number of rows affected by the most recent DML.
- `SQL%FOUND` is the inverse of `SQL%NOTFOUND` — TRUE if at least one row was affected.
- The `DEPTNO` column must exist in `emp1` (included in the setup above).

---

## Q2) Populate emp_grade table based on salary bands using an explicit cursor

```sql
CREATE TABLE emp_grade (
    empno NUMBER,
    grade CHAR(2)
);
```

```sql
DECLARE
    CURSOR c IS SELECT empno, sal FROM emp1;
    emp_rec c%ROWTYPE;
BEGIN
    OPEN c;

    LOOP
        FETCH c INTO emp_rec;
        EXIT WHEN c%NOTFOUND;

        IF emp_rec.sal <= 1400 THEN
            INSERT INTO emp_grade VALUES (emp_rec.empno, 'C');
        ELSIF emp_rec.sal BETWEEN 1401 AND 2000 THEN
            INSERT INTO emp_grade VALUES (emp_rec.empno, 'B');
        ELSE
            INSERT INTO emp_grade VALUES (emp_rec.empno, 'A');
        END IF;
    END LOOP;

    CLOSE c;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('emp_grade populated successfully');
END;
/
```

**Verify results:**
```sql
SELECT e.ename, e.sal, g.grade
FROM emp1 e
JOIN emp_grade g ON e.empno = g.empno
ORDER BY e.sal;
```

**Explanation:**
- `CURSOR c IS SELECT ...` declares the explicit cursor with its query.
- `c%ROWTYPE` automatically creates a record variable with fields matching the cursor's SELECT columns.
- **Cursor lifecycle:** `OPEN` executes the query → `FETCH` retrieves one row at a time → `EXIT WHEN c%NOTFOUND` exits the loop when there are no more rows → `CLOSE` releases the cursor's resources.
- Grading logic:
  - SAL ≤ 1400 → grade 'C'
  - 1401 ≤ SAL ≤ 2000 → grade 'B'
  - SAL > 2000 → grade 'A'
- `COMMIT` at the end makes all inserts permanent.

**Grade distribution from the data:**

| Grade | Employees                              |
|-------|----------------------------------------|
| C     | SMITH (800), WARD (1250), MARTIN (1250), JAMES (950) |
| B     | ALLEN (1600), TURNER (3000 — no, > 2000) |
| A     | JONES, BLAKE, CLARK, SCOTT, KING, TURNER, ADAMS, FORD, MILLER |

> Note: TURNER's salary is 3000 in this dataset, so it falls into grade 'A'.

---

## Cursor Attributes Reference

| Attribute        | Type    | Meaning                                         |
|------------------|---------|-------------------------------------------------|
| `%ISOPEN`        | BOOLEAN | TRUE if the cursor is currently open            |
| `%FOUND`         | BOOLEAN | TRUE if the last FETCH returned a row           |
| `%NOTFOUND`      | BOOLEAN | TRUE if the last FETCH returned no row          |
| `%ROWCOUNT`      | NUMBER  | Number of rows fetched so far                   |

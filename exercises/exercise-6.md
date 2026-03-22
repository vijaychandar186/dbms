# Exercise 6 — SQL Aggregate Functions

## Setup — Create and Populate EMP Table

```sql
DROP TABLE emp;

CREATE TABLE emp (
    EMPNO    NUMBER(4)    PRIMARY KEY,
    ENAME    VARCHAR2(10),
    JOB      VARCHAR2(9),
    MGR      NUMBER(4),
    HIREDATE DATE,
    SAL      NUMBER(7,2),
    COMM     NUMBER(7,2),
    DEPTNO   NUMBER(2)
);

INSERT INTO emp VALUES (7369, 'SMITH',  'CLERK',     7902, TO_DATE('17-DEC-1980','DD-MON-YYYY'),  800,  NULL, 20);
INSERT INTO emp VALUES (7499, 'ALLEN',  'SALESMAN',  7698, TO_DATE('20-FEB-1981','DD-MON-YYYY'), 1600,  300,  30);
INSERT INTO emp VALUES (7521, 'WARD',   'SALESMAN',  7698, TO_DATE('22-FEB-1981','DD-MON-YYYY'), 1250,  500,  30);
INSERT INTO emp VALUES (7566, 'JONES',  'MANAGER',   7839, TO_DATE('02-APR-1981','DD-MON-YYYY'), 2975,  NULL, 20);
INSERT INTO emp VALUES (7654, 'MARTIN', 'SALESMAN',  7698, TO_DATE('28-SEP-1981','DD-MON-YYYY'), 1250, 1400,  30);
INSERT INTO emp VALUES (7698, 'BLAKE',  'MANAGER',   7839, TO_DATE('01-MAY-1981','DD-MON-YYYY'), 2850,  NULL, 30);
INSERT INTO emp VALUES (7782, 'CLARK',  'MANAGER',   7839, TO_DATE('09-JUN-1981','DD-MON-YYYY'), 2450,  NULL, 10);
INSERT INTO emp VALUES (7788, 'SCOTT',  'ANALYST',   7566, TO_DATE('19-APR-1987','DD-MON-YYYY'), 3000,  NULL, 20);
INSERT INTO emp VALUES (7839, 'KING',   'PRESIDENT', NULL, TO_DATE('17-NOV-1981','DD-MON-YYYY'), 5000,  NULL, 10);
INSERT INTO emp VALUES (7844, 'TURNER', 'SALESMAN',  7698, TO_DATE('08-SEP-1981','DD-MON-YYYY'), 1500,     0, 30);
INSERT INTO emp VALUES (7876, 'ADAMS',  'CLERK',     7788, TO_DATE('23-MAY-1987','DD-MON-YYYY'), 1100,  NULL, 20);
INSERT INTO emp VALUES (7900, 'JAMES',  'CLERK',     7698, TO_DATE('03-DEC-1981','DD-MON-YYYY'),  950,  NULL, 30);
INSERT INTO emp VALUES (7902, 'FORD',   'ANALYST',   7566, TO_DATE('03-DEC-1981','DD-MON-YYYY'), 3000,  NULL, 20);
INSERT INTO emp VALUES (7934, 'MILLER', 'CLERK',     7782, TO_DATE('23-JAN-1982','DD-MON-YYYY'), 1300,  NULL, 10);
```

---

## Questions and Solutions

### Q1) Find the total number of rows in EMP

```sql
SELECT COUNT(*) FROM emp;
```

**Expected result:** `14`

**Explanation:**
- `COUNT(*)` counts every row, including those with NULL values in any column.
- It is the correct way to count rows — `COUNT(column)` would skip NULLs in that column.

---

### Q2) Find the number of distinct designations in EMP

```sql
SELECT COUNT(DISTINCT job) FROM emp;
```

**Expected result:** `5` (CLERK, SALESMAN, MANAGER, ANALYST, PRESIDENT)

**Explanation:**
- `DISTINCT` inside an aggregate function counts unique non-NULL values only.
- Without `DISTINCT`, `COUNT(job)` would return 14 (all rows, since no JOB is NULL in this dataset).

---

### Q3) What is the difference between COUNT(comm) and COUNT(NVL(comm, 0))?

```sql
-- Counts only rows where COMM is NOT NULL
SELECT COUNT(comm) FROM emp;
```

**Expected result:** `4` (ALLEN, WARD, MARTIN, TURNER have non-null COMM)

```sql
-- Counts all rows (NULL COMM values replaced with 0 before counting)
SELECT COUNT(NVL(comm, 0)) FROM emp;
```

**Expected result:** `14`

**Explanation:**
- `COUNT(column)` ignores NULL values — it only counts rows where the column has an actual value.
- `NVL(comm, 0)` replaces NULL with 0 before the count, so every row now has a non-NULL value and all 14 are counted.
- This distinction matters when you need "count of employees who could receive commission" vs "total number of employees".

---

### Q4) Find the maximum, minimum, and average salary in EMP

```sql
SELECT MAX(sal) AS max_salary,
       MIN(sal) AS min_salary,
       ROUND(AVG(sal), 2) AS avg_salary
FROM emp;
```

**Expected result:** MAX = 5000, MIN = 800, AVG ≈ 2073.21

**Explanation:**
- `MAX` and `MIN` find the highest and lowest values, ignoring NULLs.
- `AVG` computes the mean of non-NULL values. NULLs in SAL are excluded from both the sum and the count — in this dataset SAL has no NULLs, so all 14 rows contribute.
- `ROUND(..., 2)` limits output to 2 decimal places.

---

### Q5) Count the number of employees in department 30

```sql
SELECT COUNT(*) AS emp_count FROM emp WHERE deptno = 30;
```

**Expected result:** `6` (ALLEN, WARD, MARTIN, BLAKE, TURNER, JAMES)

**Explanation:**
- The `WHERE` clause filters rows before the aggregate function runs.
- `COUNT(*)` then counts only the filtered rows.

---

### Q6) Find the maximum salary paid to a CLERK

```sql
SELECT MAX(sal) AS max_clerk_salary FROM emp WHERE job = 'CLERK';
```

**Expected result:** `1300` (MILLER)

**Explanation:**
- `WHERE job = 'CLERK'` restricts the dataset to clerks first, then `MAX(sal)` finds the highest among them.

---

### Q7) List each job and the number of employees in that job, ordered by count descending

```sql
SELECT job,
       COUNT(*) AS num_employees
FROM emp
GROUP BY job
ORDER BY num_employees DESC;
```

**Expected result:**

| JOB       | NUM_EMPLOYEES |
|-----------|---------------|
| CLERK     | 4             |
| SALESMAN  | 4             |
| MANAGER   | 3             |
| ANALYST   | 2             |
| PRESIDENT | 1             |

**Explanation:**
- `GROUP BY job` creates one output group per unique JOB value.
- `COUNT(*)` runs within each group.
- `ORDER BY num_employees DESC` sorts largest group first.

---

### Q8) List total, max, min, and average salary per job

```sql
SELECT job,
       SUM(sal)          AS total_salary,
       MAX(sal)          AS max_salary,
       MIN(sal)          AS min_salary,
       ROUND(AVG(sal),2) AS avg_salary
FROM emp
GROUP BY job;
```

**Explanation:**
- All four aggregate functions run simultaneously within each job group.
- The result has one row per distinct JOB value — 5 rows total.

---

### Q9) For department 20 only, show total/max/min/avg salary per job — only where average salary > 1000

```sql
SELECT job,
       SUM(sal)          AS total_salary,
       MAX(sal)          AS max_salary,
       MIN(sal)          AS min_salary,
       ROUND(AVG(sal),2) AS avg_salary
FROM emp
WHERE deptno = 20
GROUP BY job
HAVING AVG(sal) > 1000;
```

**Explanation:**
- `WHERE deptno = 20` filters rows **before** grouping — only dept 20 employees are considered.
- `GROUP BY job` groups those filtered rows by job.
- `HAVING AVG(sal) > 1000` filters **groups** after aggregation — groups with an average salary of 1000 or less are excluded.
- Key distinction: `WHERE` filters rows; `HAVING` filters groups. You cannot use aggregate functions in a `WHERE` clause.

---

### Q10) Show job and total salary for all jobs except 'PRESIDENT', where total salary exceeds 5000

```sql
SELECT job,
       SUM(sal) AS total_salary
FROM emp
WHERE job <> 'PRESIDENT'
GROUP BY job
HAVING SUM(sal) > 5000;
```

**Explanation:**
- `WHERE job <> 'PRESIDENT'` removes KING's row before grouping.
- `HAVING SUM(sal) > 5000` keeps only jobs where the combined salary of all employees in that job exceeds 5000.
- Expected result: CLERK (4950 — excluded), SALESMAN (5600 — included), MANAGER (8275 — included), ANALYST (6000 — included).

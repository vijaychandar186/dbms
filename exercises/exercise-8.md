# Exercise 8 — Sub Queries

## Setup — Create and Populate EMP and DEPT Tables

```sql
DROP TABLE EMP;
DROP TABLE DEPT;

CREATE TABLE EMP (
    EMPNO    NUMBER(4)   PRIMARY KEY,
    ENAME    VARCHAR2(10),
    JOB      VARCHAR2(9),
    MGR      NUMBER(4),
    HIREDATE DATE,
    SAL      NUMBER(7,2),
    COMM     NUMBER(7,2),
    DEPTNO   NUMBER(2)
);

CREATE TABLE DEPT (
    DEPTNO NUMBER(2)   PRIMARY KEY,
    DNAME  VARCHAR2(14),
    LOC    VARCHAR2(13)
);

INSERT INTO EMP VALUES (7369, 'SMITH',  'CLERK',     7902, TO_DATE('17-DEC-1980','DD-MON-YYYY'),  800,  NULL, 20);
INSERT INTO EMP VALUES (7499, 'ALLEN',  'SALESMAN',  7698, TO_DATE('20-FEB-1981','DD-MON-YYYY'), 1600,  300,  30);
INSERT INTO EMP VALUES (7521, 'WARD',   'SALESMAN',  7698, TO_DATE('22-FEB-1981','DD-MON-YYYY'), 1250,  500,  30);
INSERT INTO EMP VALUES (7566, 'JONES',  'MANAGER',   7839, TO_DATE('02-APR-1981','DD-MON-YYYY'), 2975,  NULL, 20);
INSERT INTO EMP VALUES (7654, 'MARTIN', 'SALESMAN',  7698, TO_DATE('28-SEP-1981','DD-MON-YYYY'), 1250, 1400,  30);
INSERT INTO EMP VALUES (7698, 'BLAKE',  'MANAGER',   7839, TO_DATE('01-MAY-1981','DD-MON-YYYY'), 2850,  NULL, 30);
INSERT INTO EMP VALUES (7782, 'CLARK',  'MANAGER',   7839, TO_DATE('09-JUN-1981','DD-MON-YYYY'), 2450,  NULL, 10);
INSERT INTO EMP VALUES (7788, 'SCOTT',  'ANALYST',   7566, TO_DATE('19-APR-1987','DD-MON-YYYY'), 3000,  NULL, 20);
INSERT INTO EMP VALUES (7839, 'KING',   'PRESIDENT', NULL, TO_DATE('17-NOV-1981','DD-MON-YYYY'), 5000,  NULL, 10);
INSERT INTO EMP VALUES (7844, 'TURNER', 'SALESMAN',  7698, TO_DATE('08-SEP-1981','DD-MON-YYYY'), 1500,     0, 30);
INSERT INTO EMP VALUES (7876, 'ADAMS',  'CLERK',     7788, TO_DATE('23-MAY-1987','DD-MON-YYYY'), 1100,  NULL, 20);
INSERT INTO EMP VALUES (7900, 'JAMES',  'CLERK',     7698, TO_DATE('03-DEC-1981','DD-MON-YYYY'),  950,  NULL, 30);
INSERT INTO EMP VALUES (7902, 'FORD',   'ANALYST',   7566, TO_DATE('03-DEC-1981','DD-MON-YYYY'), 3000,  NULL, 20);
INSERT INTO EMP VALUES (7934, 'MILLER', 'CLERK',     7782, TO_DATE('23-JAN-1982','DD-MON-YYYY'), 1300,  NULL, 10);

INSERT INTO DEPT VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO DEPT VALUES (20, 'RESEARCH',   'DALLAS');
INSERT INTO DEPT VALUES (30, 'SALES',      'CHICAGO');
INSERT INTO DEPT VALUES (40, 'OPERATIONS', 'BOSTON');
```

---

## Questions and Solutions

### Q1) List employees whose salary is greater than that of employee 7566 (JONES)

```sql
SELECT ename FROM EMP
WHERE sal > (SELECT sal FROM EMP WHERE empno = 7566);
```

**JONES's salary = 2975. Expected result:** SCOTT (3000), KING (5000), FORD (3000), BLAKE (2850 — no, 2850 < 2975)

**Correct expected result:** BLAKE is excluded (2850 < 2975). Result: SCOTT, KING, FORD.

**Explanation:**
- The **inner query** (subquery) runs first: `SELECT sal FROM EMP WHERE empno = 7566` → returns `2975`.
- The **outer query** then uses that value: `WHERE sal > 2975`.
- This is a **single-row subquery** — it returns exactly one value, so `>` is valid.

---

### Q2) List employees whose job matches employee 7369 and whose salary exceeds employee 7876

```sql
SELECT ename FROM EMP
WHERE job = (SELECT job  FROM EMP WHERE empno = 7369)
  AND sal > (SELECT sal  FROM EMP WHERE empno = 7876);
```

**SMITH (7369) job = 'CLERK'. ADAMS (7876) sal = 1100.**
**Expected result:** MILLER (job=CLERK, sal=1300 > 1100)

**Explanation:**
- Two independent scalar subqueries run in the `WHERE` clause.
- Both conditions must be true (AND) for a row to be included.
- SMITH and ADAMS themselves may or may not appear — check: SMITH sal=800 < 1100 (excluded), ADAMS sal=1100 is not > 1100 (excluded). Only MILLER (CLERK, 1300) qualifies.

---

### Q3) List the name, job, and salary of the employee(s) earning the minimum salary

```sql
SELECT ename, job, sal FROM EMP
WHERE sal = (SELECT MIN(sal) FROM EMP);
```

**Expected result:** SMITH, CLERK, 800

**Explanation:**
- `MIN(sal)` in the subquery returns `800`.
- The outer query finds every employee earning exactly 800.
- This is more robust than `ORDER BY sal ASC` + fetching the first row, because it returns all employees tied for the minimum.

---

### Q4) Show department number and minimum salary per department, only where that minimum exceeds the minimum salary of department 20

```sql
SELECT deptno, MIN(sal) AS min_salary
FROM EMP
GROUP BY deptno
HAVING MIN(sal) > (SELECT MIN(sal) FROM EMP WHERE deptno = 20);
```

**Dept 20 min = 800 (SMITH). Expected result:** Dept 10 (min=1300), Dept 30 (min=950) — both > 800.

**Explanation:**
- The subquery returns the minimum salary for dept 20: `800`.
- `HAVING MIN(sal) > 800` keeps only departments whose lowest-paid employee earns more than 800.
- `HAVING` is used (not `WHERE`) because the filter applies to an aggregate result.

---

### Q5) List EMPNO, ENAME, JOB of non-clerks whose salary is less than at least one clerk's salary

```sql
SELECT empno, ename, job FROM EMP
WHERE job <> 'CLERK'
  AND sal < ANY (SELECT sal FROM EMP WHERE job = 'CLERK');
```

**Clerk salaries: 800 (SMITH), 1100 (ADAMS), 950 (JAMES), 1300 (MILLER).**

**Expected result:** Employees who are not CLERKs and earn less than 1300 (the max clerk salary).
Result includes: ALLEN (1600 — no), WARD (1250 < 1300 ✓), MARTIN (1250 ✓), TURNER (1500 — no), BLAKE (2850 — no), etc.

**Explanation:**
- `ANY` means "at least one value in the subquery set satisfies the condition".
- `sal < ANY (800, 950, 1100, 1300)` is equivalent to `sal < 1300` (less than the maximum).
- Contrast with `ALL`: `sal < ALL (...)` would mean less than every value, i.e., less than 800.

---

### Q6) List employees whose salary is greater than the average salary of their own department

```sql
SELECT empno, ename, job
FROM EMP outer_emp
WHERE sal > (
    SELECT AVG(sal)
    FROM EMP
    WHERE deptno = outer_emp.deptno
);
```

**Explanation:**
- This is a **correlated subquery** — the inner query references `outer_emp.deptno` from the outer query, so it re-executes once per outer row.
- For each employee, the subquery computes the average salary of that employee's department, then the outer query checks if the employee earns more.
- Dept 10 avg ≈ 2916.67 → KING (5000) qualifies. Dept 20 avg ≈ 2175 → JONES (2975), SCOTT (3000), FORD (3000) qualify. Dept 30 avg ≈ 1566.67 → BLAKE (2850), ALLEN (1600) qualify.

---

### Q7) List employees whose salary matches either SCOTT's or WARD's salary

```sql
SELECT ename, job, sal FROM EMP
WHERE sal IN (SELECT sal FROM EMP WHERE ename IN ('SCOTT', 'WARD'));
```

**SCOTT sal = 3000, WARD sal = 1250.**
**Expected result:** All employees with sal = 3000 or sal = 1250 (WARD, MARTIN, SCOTT, FORD).

**Explanation:**
- The subquery returns a **set of values**: `{3000, 1250}`.
- `IN (subquery)` is a **multi-row subquery** — use `IN`, `ANY`, `ALL`, or `EXISTS`, not `=`.
- `=` would fail here because the subquery returns more than one row.

---

### Q8) List employees with the same salary AND same job as FORD

```sql
SELECT ename, job, sal FROM EMP
WHERE sal = (SELECT sal FROM EMP WHERE ename = 'FORD')
  AND job = (SELECT job FROM EMP WHERE ename = 'FORD');
```

**FORD: sal = 3000, job = 'ANALYST'. Expected result:** SCOTT (ANALYST, 3000) and FORD himself.

**Explanation:**
- Two separate scalar subqueries retrieve FORD's salary and job.
- Both conditions must match — an employee must be an ANALYST earning 3000.
- Alternatively, use a single subquery returning a row: `WHERE (sal, job) = (SELECT sal, job FROM EMP WHERE ename = 'FORD')` (row value comparison, supported in Oracle).

---

### Q9) List employees with the same job as JONES and a higher salary than FORD

```sql
SELECT ename, job, deptno, sal FROM EMP
WHERE job = (SELECT job FROM EMP WHERE ename = 'JONES')
  AND sal > (SELECT sal FROM EMP WHERE ename = 'FORD');
```

**JONES job = 'MANAGER'. FORD sal = 3000.**
**Expected result:** Managers earning more than 3000 — none in this dataset (JONES=2975, BLAKE=2850, CLARK=2450). Result is empty.

**Explanation:**
- No manager in the standard EMP dataset earns more than FORD's 3000. The query is correct even though the result set is empty.

---

### Q10) List employees in dept 10 whose job matches any job held in dept 30 (SALES)

```sql
SELECT ename, job FROM EMP
WHERE deptno = 10
  AND job IN (SELECT job FROM EMP WHERE deptno = 30);
```

**Dept 30 jobs:** SALESMAN (ALLEN, WARD, MARTIN, TURNER), MANAGER (BLAKE).
**Dept 10 employees:** KING (PRESIDENT), CLARK (MANAGER), MILLER (CLERK).

**Expected result:** CLARK (MANAGER — also exists in dept 30).

**Explanation:**
- The subquery returns all distinct jobs in dept 30: `{'SALESMAN', 'MANAGER'}`.
- The outer query filters dept 10 employees whose job is in that set.
- CLARK is a MANAGER in dept 10, and MANAGER also exists in dept 30, so CLARK qualifies.

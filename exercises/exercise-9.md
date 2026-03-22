# Exercise 9 — Views

> This exercise uses the standard EMP and DEPT tables from Exercise 8. Ensure both tables are populated before running these queries.

---

## What is a View?

A **view** is a stored SQL query that behaves like a virtual table. It does not store data itself — it fetches data from the underlying base tables each time it is queried. Views are used to:
- Simplify complex queries
- Restrict column/row access for security
- Present data in a different format without duplicating it

---

## Questions and Solutions

### Q1) Create view `empv10` containing EMPNO, ENAME, JOB for department 10 employees

```sql
CREATE VIEW empv10 AS
SELECT empno, ename, job
FROM EMP
WHERE deptno = 10;
```

**Verify structure:**
```sql
DESC empv10;
```

**Expected view contents:**

| EMPNO | ENAME  | JOB       |
|-------|--------|-----------|
| 7782  | CLARK  | MANAGER   |
| 7839  | KING   | PRESIDENT |
| 7934  | MILLER | CLERK     |

**Explanation:**
- `CREATE VIEW name AS SELECT ...` defines the view.
- The view definition is stored in the data dictionary; no data is copied.
- `DESC empv10` shows the column names and types as if it were a table.

---

### Q2) Create view `empv30` with column aliases for dept 30 employees (EMPNO, ENAME, SAL)

```sql
CREATE VIEW empv30 AS
SELECT empno AS "Employee Number",
       ename AS "Employee Name",
       sal   AS "Salary"
FROM EMP
WHERE deptno = 30;
```

**Display contents:**
```sql
SELECT * FROM empv30;
```

**Explanation:**
- Column aliases in the view definition become the view's column names.
- Querying the view shows the renamed columns, not the original table column names.
- Useful for presenting data with more readable labels to end users.

---

### Q3) Update `empv10` to give CLERKs a 10% salary increase; confirm the change in EMP

> **Note:** `empv10` as defined in Q1 does **not** include the SAL column. To update salary through a view, the view must expose the SAL column. Use the version from Q4 (which includes SAL) or redefine the view first.

```sql
-- Recreate empv10 to include SAL before updating
CREATE OR REPLACE VIEW empv10 AS
SELECT empno, ename, job, sal
FROM EMP
WHERE deptno = 10;

-- Now update CLERK salaries through the view
UPDATE empv10 SET sal = sal * 1.1 WHERE job = 'CLERK';

-- Confirm the change in the base table
SELECT empno, ename, job, sal FROM EMP WHERE deptno = 10;
```

**Explanation:**
- DML on a simple view (single base table, no aggregates, no DISTINCT, no GROUP BY) propagates directly to the underlying table.
- After the update, MILLER's salary in EMP changes from 1300 to 1430.
- The change is visible in the base table because the view is just a window into it.

---

### Q4) Modify `empv10` to include EMPNO, ENAME, JOB, SAL with column aliases

```sql
CREATE OR REPLACE VIEW empv10 AS
SELECT empno AS "Employee Number",
       ename AS "Employee Name",
       job   AS "Job Title",
       sal   AS "Salary"
FROM EMP
WHERE deptno = 10;
```

**Explanation:**
- `CREATE OR REPLACE VIEW` updates an existing view definition without dropping and recreating it.
- Any privileges granted on the original view are preserved.
- The four columns are now aliased for readability.

---

### Q5) Create view `pay` with ENAME, monthly salary, annual salary, and DEPTNO

```sql
CREATE VIEW pay AS
SELECT ename,
       ROUND(sal / 12, 2)  AS monthly_sal,
       sal * 12            AS annual_sal,
       deptno
FROM EMP;
```

**Explanation:**
- `sal` in EMP is already the monthly salary (annual salary = sal × 12).
- `ROUND(sal / 12, 2)` computes a per-month breakdown rounded to 2 decimal places.
- This view does not use a `WHERE` clause — it covers all employees.
- Views containing expressions (like `sal * 12`) are **not directly updatable** on those derived columns.

---

### Q6) Create view `dept_stat` with department number, name, min salary, max salary, total salary

```sql
CREATE VIEW dept_stat AS
SELECT d.deptno,
       d.dname,
       MIN(e.sal) AS min_sal,
       MAX(e.sal) AS max_sal,
       SUM(e.sal) AS total_sal
FROM EMP e
JOIN DEPT d ON e.deptno = d.deptno
GROUP BY d.deptno, d.dname;
```

**Explanation:**
- This view joins EMP and DEPT and computes per-department aggregates.
- Because it uses `GROUP BY` and aggregate functions, it is a **read-only** view — DML is not allowed on it.
- `GROUP BY d.deptno, d.dname` is required because DNAME is a non-aggregated column in the SELECT.

---

### Q7) Create a read-only view `empv10` with all columns for dept 10 employees

```sql
CREATE OR REPLACE VIEW empv10 AS
SELECT * FROM EMP WHERE deptno = 10
WITH READ ONLY;
```

**Explanation:**
- `WITH READ ONLY` prevents any DML (INSERT, UPDATE, DELETE) through this view.
- Attempting `DELETE FROM empv10 WHERE empno = 7839` produces:
  `ORA-42399: cannot perform a DML operation on a read-only view`
- Use this when you want to expose data for reporting without risk of accidental modification.

---

### Q8) Drop the view `empv20`

```sql
DROP VIEW empv20;
```

**Explanation:**
- `DROP VIEW` removes the view definition from the data dictionary.
- The **base table** and its data are completely unaffected — only the virtual table definition is deleted.
- If `empv20` does not exist, Oracle raises `ORA-00942: table or view does not exist`. Use `DROP VIEW empv20` only if the view was created earlier in the session.

---

## Summary — View Types

| View Type         | Created With                         | DML Allowed? |
|-------------------|--------------------------------------|--------------|
| Simple view       | Single table, no aggregates          | Yes          |
| Complex view      | JOIN, GROUP BY, or expressions       | No           |
| Read-only view    | Any query + `WITH READ ONLY`         | No           |

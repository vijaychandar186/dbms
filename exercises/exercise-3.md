# Exercise 3 — Basic SELECT Statements

> This exercise continues from Exercise 2. The EMP, DEPT, and MANAGER tables (with data) are assumed to already exist.

---

## Questions and Solutions

### Q1) Update all records in MANAGER by increasing salary by 10% as a bonus

```sql
UPDATE MANAGER SET SAL = SAL * 1.1;
```

**Explanation:**
- Multiplying SAL by `1.1` is equivalent to adding 10% (`SAL + SAL * 0.1`).
- No `WHERE` clause — every manager gets the raise.
- The result is a decimal value; consider `ROUND(SAL * 1.1, 2)` if you want to avoid fractional cents.

---

### Q2) Delete records from MANAGER where salary is less than 2750

```sql
DELETE FROM MANAGER WHERE SAL < 2750;
```

**Explanation:**
- This removes managers whose salary (after the Q1 raise) falls below 2750.
- After Q1, JONES = 3272.50, BLAKE = 3135, CLARK = 2695. So CLARK (2695 < 2750) is deleted.

---

### Q3) Display each employee's name as "Name" and their annual salary as "Annual Salary"

```sql
SELECT ename          AS "Name",
       sal * 12       AS "Annual Salary"
FROM emp;
```

**Explanation:**
- `sal` holds the monthly salary; multiplying by 12 gives the annual figure.
- Column aliases using double quotes preserve mixed case and spaces in the heading.
- Without quotes, Oracle would uppercase any alias.

---

### Q4) List the concatenated name and designation of each employee

```sql
SELECT ename || ' - ' || job AS "Name and Designation"
FROM emp;
```

**Explanation:**
- `||` is Oracle's string concatenation operator.
- The result looks like: `SMITH - CLERK`, `KING - PRESIDENT`, etc.
- A hyphen with spaces is added between the two values for readability.

---

### Q5) List the names of employees whose designation is 'CLERK'

```sql
SELECT ename FROM emp WHERE job = 'CLERK';
```

**Expected result:** SMITH, ADAMS, JAMES, MILLER

**Explanation:**
- String comparisons in Oracle are case-sensitive. `'CLERK'` must be uppercase to match the stored values.

---

### Q6) List all details of employees who joined before 30 September 1981

```sql
SELECT * FROM emp WHERE hiredate < TO_DATE('30-SEP-1981', 'DD-MON-YYYY');
```

**Explanation:**
- `TO_DATE` converts the string to a DATE type with an explicit format mask, making the query independent of the session's `NLS_DATE_FORMAT`.
- `<` excludes 30-SEP-1981 itself. Use `<=` to include that date.
- Employees hired before this date: SMITH, ALLEN, WARD, JONES, BLAKE, CLARK, MARTIN, TURNER, KING (Nov 81 is after, so excluded), etc.

---

### Q7) List names of employees whose EMPNO is one of 7369, 7839, 7934, or 7788

```sql
SELECT ename FROM emp WHERE empno IN (7369, 7839, 7934, 7788);
```

**Expected result:** SMITH, KING, MILLER, SCOTT

**Explanation:**
- `IN (...)` is shorthand for multiple `OR` conditions: `empno = 7369 OR empno = 7839 OR ...`
- Cleaner and easier to extend than chained `OR` clauses.

---

### Q8) List names of employees who are not Managers

```sql
SELECT ename FROM emp WHERE job <> 'MANAGER';
```

**Explanation:**
- `<>` is the standard SQL "not equal" operator. `!=` is also accepted in Oracle.
- Returns everyone except JONES, BLAKE, and CLARK.

---

### Q9) List names of employees not in departments 10, 30, or 40

```sql
SELECT ename FROM emp WHERE deptno NOT IN (10, 30, 40);
```

**Expected result:** SMITH, JONES, SCOTT, ADAMS, FORD (all in dept 20)

**Explanation:**
- `NOT IN` excludes rows matching any value in the list.
- **Important caveat:** If any value in the `NOT IN` list is NULL, the entire condition evaluates to UNKNOWN and returns no rows. Here all department numbers are non-null, so this is safe.

---

### Q10) List names of employees hired between 30 June 1981 and 31 December 1981 (inclusive)

```sql
SELECT ename
FROM emp
WHERE hiredate BETWEEN TO_DATE('30-JUN-1981', 'DD-MON-YYYY')
                   AND TO_DATE('31-DEC-1981', 'DD-MON-YYYY');
```

**Expected result:** ALLEN, WARD, JONES, MARTIN, BLAKE, CLARK, TURNER, KING, JAMES, FORD

**Explanation:**
- `BETWEEN x AND y` is inclusive on both ends — equivalent to `hiredate >= x AND hiredate <= y`.
- `TO_DATE` with an explicit format mask is used for reliability.

---

### Q11) List all distinct designations in the company

```sql
SELECT DISTINCT job FROM emp;
```

**Expected result:** CLERK, SALESMAN, MANAGER, ANALYST, PRESIDENT

**Explanation:**
- `DISTINCT` collapses multiple rows with the same value into one.
- Useful for understanding what unique values exist in a column.

---

### Q12) List names of employees not eligible for commission (COMM is NULL)

```sql
SELECT ename FROM emp WHERE comm IS NULL;
```

**Explanation:**
- You cannot use `= NULL` in SQL — NULL comparisons always return UNKNOWN using `=` or `<>`.
- `IS NULL` is the correct syntax to check for the absence of a value.
- Employees with no commission entry (NULL): SMITH, JONES, BLAKE, CLARK, SCOTT, KING, ADAMS, JAMES, FORD, MILLER.

---

### Q13) List names and designations of employees who report to nobody (no manager)

```sql
SELECT ename, job FROM emp WHERE mgr IS NULL;
```

**Expected result:** KING, PRESIDENT

**Explanation:**
- Only KING has `MGR IS NULL` because he is the company president — there is no one above him.
- Again, `IS NULL` is required; `mgr = NULL` would return no rows.

---

### Q14) List all employees not assigned to any department

```sql
SELECT ename FROM emp WHERE deptno IS NULL;
```

**Explanation:**
- In the standard dataset, every employee has a DEPTNO, so this returns no rows.
- In a real scenario this catches data entry errors or employees added before a department assignment is made.

---

### Q15) List names of employees who are eligible for commission (COMM is not NULL)

```sql
SELECT ename FROM emp WHERE comm IS NOT NULL;
```

**Expected result:** ALLEN, WARD, MARTIN, TURNER

**Explanation:**
- `IS NOT NULL` returns only rows where the column has an actual value.
- Note that TURNER has `COMM = 0` — this is not NULL, so TURNER is included.

---

### Q16) List employees whose name starts or ends with the letter 'S'

```sql
SELECT ename FROM emp
WHERE ename LIKE 'S%' OR ename LIKE '%S';
```

**Expected result:** SMITH, SCOTT, JONES, JAMES, ADAMS

**Explanation:**
- `%` matches any sequence of zero or more characters.
- `LIKE 'S%'` matches names starting with S; `LIKE '%S'` matches names ending with S.
- JONES ends in S; SMITH and SCOTT start with S; JAMES ends in S; ADAMS ends in S.

---

### Q17) List names of employees whose second character is 'I'

```sql
SELECT ename FROM emp WHERE ename LIKE '_I%';
```

**Expected result:** KING, MILLER

**Explanation:**
- `_` (underscore) matches exactly one character.
- `_I%` means: any single character, then 'I', then anything. So the second character must be 'I'.
- KING → K**I**NG, MILLER → M**I**LLER.

---

### Q18) Sort EMP by hire date ascending; show ename, job, deptno, hiredate

```sql
SELECT ename, job, deptno, hiredate
FROM emp
ORDER BY hiredate ASC;
```

**Explanation:**
- `ORDER BY hiredate ASC` sorts oldest hire date first. `ASC` is the default and can be omitted.
- The earliest hire in the dataset is SMITH (17-DEC-1980).

---

### Q19) Sort EMP by annual salary descending; show empno, ename, job, annual salary

```sql
SELECT empno,
       ename,
       job,
       sal * 12 AS "Annual Salary"
FROM emp
ORDER BY sal DESC;
```

**Explanation:**
- Ordering by `sal DESC` is equivalent to ordering by `sal * 12 DESC` because multiplying all values by the same positive constant preserves their relative order.
- KING (sal=5000) appears first; SMITH (sal=800) appears last.

---

### Q20) List ename, deptno, sal sorted by department ascending, then salary descending within each department

```sql
SELECT ename, deptno, sal
FROM emp
ORDER BY deptno ASC, sal DESC;
```

**Explanation:**
- Multiple `ORDER BY` columns are evaluated left to right.
- Primary sort: departments in ascending order (10, 20, 30).
- Secondary sort: within each department, highest salary listed first.
- This makes it easy to see the highest earner per department at a glance.

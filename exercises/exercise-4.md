# Exercise 4 — Integrity Constraints

## Schema Reference

### Department Table

| Column Name | Data Type    | Constraint  | Description         |
|-------------|--------------|-------------|---------------------|
| DEPT_NO     | NUMBER(5)    | PRIMARY KEY | Department number   |
| DNAME       | VARCHAR2(10) |             | Department name     |
| DLOC        | VARCHAR2(10) |             | Department location |

### EMP Table

| Column Name  | Data Type    | Constraint                          | Description              |
|--------------|--------------|-------------------------------------|--------------------------|
| EMP_NO       | NUMBER(5)    | PRIMARY KEY                         | Employee number          |
| ENAME        | VARCHAR2(10) |                                     | Employee name            |
| JOB          | VARCHAR2(10) |                                     | Designation              |
| MANAGER_NAME | VARCHAR2(10) | DEFAULT 'Mr.K. RAM'                 | Manager's name           |
| HIRE_DATE    | DATE         |                                     | Date of joining          |
| SALARY       | NUMBER(10,2) |                                     | Basic salary             |
| COMMISSION   | NUMBER(10,2) |                                     | Commission amount        |
| DEPT_NO      | VARCHAR2(5)  | FOREIGN KEY → Department(DEPT_NO)   | Department number        |

---

## Questions and Solutions

### Q1) Create the Department table with DEPT_NO as primary key

```sql
CREATE TABLE Department (
    DEPT_NO NUMBER(5)    PRIMARY KEY,
    DNAME   VARCHAR2(10),
    DLOC    VARCHAR2(10)
);
```

**Explanation:**
- `PRIMARY KEY` enforces two rules simultaneously: the column must be **UNIQUE** and **NOT NULL**.
- No two departments can share the same DEPT_NO, and every row must have one.
- Oracle automatically creates a unique index on the primary key column.

---

### Q2) Create the EMP table with EMP_NO as primary key, MANAGER_NAME with a default, and a foreign key on DEPT_NO

```sql
CREATE TABLE EMP (
    EMP_NO       NUMBER(5)    PRIMARY KEY,
    ENAME        VARCHAR2(10),
    JOB          VARCHAR2(10),
    MANAGER_NAME VARCHAR2(10) DEFAULT 'Mr.K. RAM',
    HIRE_DATE    DATE,
    SALARY       NUMBER(10,2),
    COMMISSION   NUMBER(10,2),
    DEPT_NO      NUMBER(5),
    CONSTRAINT fk_dept FOREIGN KEY (DEPT_NO) REFERENCES Department(DEPT_NO)
);
```

**Explanation:**
- `DEFAULT 'Mr.K. RAM'` — if a row is inserted without specifying MANAGER_NAME, the column is automatically populated with `'Mr.K. RAM'`.
- `FOREIGN KEY (DEPT_NO) REFERENCES Department(DEPT_NO)` — every value placed in EMP.DEPT_NO must exist in Department.DEPT_NO, or be NULL. This prevents orphaned employee records.
- `CONSTRAINT fk_dept` gives the foreign key a meaningful name, making error messages and future `ALTER TABLE ... DROP CONSTRAINT fk_dept` statements readable.
- Note: DEPT_NO in EMP is defined as `NUMBER(5)` to match the type in Department.

---

### Q3) Add a UNIQUE constraint on the DNAME column of Department

```sql
ALTER TABLE Department ADD CONSTRAINT uk_dname UNIQUE (DNAME);
```

**Explanation:**
- `UNIQUE` prevents two departments from having the same name.
- Unlike PRIMARY KEY, a UNIQUE column **can** contain NULL values (in Oracle, multiple NULLs are allowed in a UNIQUE column).
- Naming the constraint `uk_dname` makes it easy to drop later: `ALTER TABLE Department DROP CONSTRAINT uk_dname`.

---

### Q4) Add a NOT NULL constraint to the HIRE_DATE column of the EMP table

```sql
ALTER TABLE EMP MODIFY (HIRE_DATE NOT NULL);
```

**Explanation:**
- `NOT NULL` is a column-level constraint — it prevents any row from having a NULL value in HIRE_DATE.
- This will **fail** if any existing row already has `HIRE_DATE = NULL`. Populate those rows first before applying the constraint.
- In Oracle, NOT NULL constraints are modified via `MODIFY`, not `ADD CONSTRAINT`.
- Note: HIRE_DATE belongs to the **EMP** table, not Department. Applying it to Department would fail because that column does not exist there.

---

### Q5) Add a CHECK constraint on EMP to restrict salary between 10,000 and 20,000

```sql
ALTER TABLE EMP ADD CONSTRAINT chk_salary CHECK (SALARY BETWEEN 10000 AND 20000);
```

**Explanation:**
- `CHECK` enforces a logical condition on each row. Any `INSERT` or `UPDATE` that would produce a SALARY outside [10000, 20000] is rejected.
- `BETWEEN` is inclusive: salary can be exactly 10000 or exactly 20000.
- Rows with `SALARY = NULL` **pass** the check — Oracle does not enforce CHECK on NULLs.

---

### Q6) Add a foreign key constraint on DEPT_NO of EMP referencing Department

> **Note:** The foreign key `fk_dept` was already added inline during `CREATE TABLE` in Q2. Adding it again with the same column would create a duplicate constraint. Use this statement only if the table was created **without** the foreign key in Q2, or use a new constraint name.

```sql
ALTER TABLE EMP ADD CONSTRAINT fk_dept_alter FOREIGN KEY (DEPT_NO) REFERENCES Department(DEPT_NO);
```

**Explanation:**
- This is the standalone `ALTER TABLE` form of adding a foreign key — useful when adding it after table creation.
- If `fk_dept` from Q2 already exists, drop it first or use a different name.
- A foreign key can also be dropped with: `ALTER TABLE EMP DROP CONSTRAINT fk_dept;`

---

### Q7) Add a CHECK constraint to ensure COMMISSION is less than 10% of SALARY

```sql
ALTER TABLE EMP ADD CONSTRAINT chk_commission CHECK (COMMISSION < SALARY * 0.1);
```

**Explanation:**
- This is an inter-column CHECK: it compares two columns in the same row.
- If COMMISSION or SALARY is NULL, the condition evaluates to UNKNOWN (not FALSE), so the row is allowed through.
- To also guard against NULL commission, use: `CHECK (COMMISSION IS NULL OR COMMISSION < SALARY * 0.1)`.

---

### Q8) Insert valid rows into Department and EMP

```sql
-- Insert departments first (parent table must be populated before child)
INSERT INTO Department (DEPT_NO, DNAME, DLOC) VALUES (10, 'SALES',      'NEW YORK');
INSERT INTO Department (DEPT_NO, DNAME, DLOC) VALUES (20, 'ACCOUNTING', 'DALLAS');

-- Insert employees referencing existing departments
INSERT INTO EMP (EMP_NO, ENAME, JOB, HIRE_DATE, SALARY, COMMISSION, DEPT_NO)
VALUES (7369, 'SMITH', 'CLERK', TO_DATE('17-DEC-1980', 'DD-MON-YYYY'), 15000, NULL, 20);

INSERT INTO EMP (EMP_NO, ENAME, JOB, HIRE_DATE, SALARY, COMMISSION, DEPT_NO)
VALUES (7499, 'ALLEN', 'SALESMAN', TO_DATE('20-FEB-1981', 'DD-MON-YYYY'), 16000, 300, 10);
```

**Explanation:**
- The parent table (`Department`) must have the referenced DEPT_NO values before inserting into the child table (`EMP`), otherwise the foreign key check fails.
- MANAGER_NAME is omitted — it will use the default value `'Mr.K. RAM'`.
- Salaries are set within the CHECK constraint range [10000, 20000].

---

### Q9) Attempt to insert a row that violates the foreign key constraint (expected to fail)

```sql
-- DEPT_NO = 40 does not exist in Department table → foreign key violation
INSERT INTO EMP (EMP_NO, ENAME, JOB, HIRE_DATE, SALARY, COMMISSION, DEPT_NO)
VALUES (7521, 'WARD', 'SALESMAN', TO_DATE('22-FEB-1981', 'DD-MON-YYYY'), 12500, 500, 40);
```

**Expected error:**
```
ORA-02291: integrity constraint (FK_DEPT) violated - parent key not found
```

**Explanation:**
- Department 40 was not inserted in Q8, so `DEPT_NO = 40` has no parent in the Department table.
- The database rejects the insert to maintain referential integrity — an employee cannot belong to a non-existent department.
- To fix: either insert department 40 first, or use a valid DEPT_NO (10 or 20).

---

### Q10) Remove the primary key constraint from the EMP table

```sql
ALTER TABLE EMP DROP PRIMARY KEY;
```

**Explanation:**
- `DROP PRIMARY KEY` drops the primary key constraint without needing to know its system-generated name.
- Alternatively, if it was named explicitly (e.g., `CONSTRAINT pk_emp`), use: `ALTER TABLE EMP DROP CONSTRAINT pk_emp`.
- **Warning:** Dropping a primary key that is referenced by a foreign key in another table will fail unless `CASCADE` is added: `ALTER TABLE EMP DROP PRIMARY KEY CASCADE`. This also drops dependent foreign key constraints.

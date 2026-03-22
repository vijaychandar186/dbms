# Exercise 15 — PL/SQL Triggers

> Run `SET SERVEROUTPUT ON;` before executing any PL/SQL block.

```sql
SET SERVEROUTPUT ON;
```

A **trigger** is a PL/SQL block that executes **automatically** in response to a DML event (`INSERT`, `UPDATE`, `DELETE`) on a table. Triggers are used for auditing, enforcing complex business rules, and maintaining derived data.

---

## Trigger Syntax

```sql
CREATE [OR REPLACE] TRIGGER trigger_name
{BEFORE | AFTER} {INSERT | UPDATE | DELETE} [OR ...]
ON table_name
[FOR EACH ROW]
[WHEN (condition)]
DECLARE
    -- declarations
BEGIN
    -- trigger body
END;
/
```

- `BEFORE` — fires before the DML operation modifies the row.
- `AFTER` — fires after the modification.
- `FOR EACH ROW` — row-level trigger; fires once per affected row.
- Without `FOR EACH ROW` — statement-level trigger; fires once per DML statement.
- `:NEW` — record holding the new column values (available on INSERT and UPDATE).
- `:OLD` — record holding the original column values (available on UPDATE and DELETE).

| Event    | `:OLD` available? | `:NEW` available? |
|----------|-------------------|-------------------|
| INSERT   | No (all NULL)     | Yes               |
| UPDATE   | Yes               | Yes               |
| DELETE   | Yes               | No (all NULL)     |

---

## Setup — Create employee Table

```sql
CREATE TABLE employee (
    eno   NUMBER(5) PRIMARY KEY,
    ename VARCHAR2(50),
    dept  VARCHAR2(20),
    sal   NUMBER(10,2)
);

INSERT INTO employee VALUES (101, 'Alice', 'HR',  45000);
INSERT INTO employee VALUES (102, 'Bob',   'CS',  60000);
INSERT INTO employee VALUES (103, 'Carol', 'IT',  55000);
COMMIT;
```

---

## Trigger — Audit Salary Changes on INSERT or UPDATE

```sql
CREATE OR REPLACE TRIGGER salary_change
BEFORE INSERT OR UPDATE ON employee
FOR EACH ROW
WHEN (NEW.eno > 0)
DECLARE
    sal_diff NUMBER;
BEGIN
    IF INSERTING THEN
        DBMS_OUTPUT.PUT_LINE('New employee inserted: ' || :NEW.ename);
        DBMS_OUTPUT.PUT_LINE('Starting salary: ' || :NEW.sal);
    ELSIF UPDATING THEN
        sal_diff := :NEW.sal - :OLD.sal;
        DBMS_OUTPUT.PUT_LINE('Salary updated for: ' || :NEW.ename);
        DBMS_OUTPUT.PUT_LINE('Old salary    = ' || :OLD.sal);
        DBMS_OUTPUT.PUT_LINE('New salary    = ' || :NEW.sal);
        DBMS_OUTPUT.PUT_LINE('Difference    = ' || sal_diff);
    END IF;
END;
/
```

**Explanation:**
- `BEFORE INSERT OR UPDATE` — fires before either of these events. The `WHEN` clause can use `NEW`/`OLD` without the colon (`:` is only needed inside the trigger body).
- `WHEN (NEW.eno > 0)` — additional guard: the trigger only fires if the employee number is positive.
- `INSERTING` and `UPDATING` are PL/SQL predicates that indicate which event triggered execution. This avoids incorrect use of `:OLD.sal` during an INSERT (where `:OLD.sal` would be NULL, making `sal_diff` NULL).
- `sal_diff := :NEW.sal - :OLD.sal` — computes the change. Positive means a raise; negative means a pay cut.

---

## Test the Trigger

**Test 1 — INSERT a new employee:**
```sql
INSERT INTO employee VALUES (104, 'Dave', 'CS', 50000);
```

**Expected output:**
```
New employee inserted: Dave
Starting salary: 50000
```

---

**Test 2 — UPDATE an existing salary:**
```sql
UPDATE employee SET sal = sal + 500 WHERE eno = 102;
```

**Expected output:**
```
Salary updated for: Bob
Old salary    = 60000
New salary    = 60500
Difference    = 500
```

---

**Verify the table after DML:**
```sql
SELECT * FROM employee;
```

---

## Dropping a Trigger

```sql
DROP TRIGGER salary_change;
```

**Explanation:**
- Dropping a trigger removes it permanently. The table and its data are unaffected.
- To temporarily disable without dropping: `ALTER TRIGGER salary_change DISABLE;`
- To re-enable: `ALTER TRIGGER salary_change ENABLE;`

---

## Summary — Trigger Use Cases

| Use Case                   | Example                                             |
|----------------------------|-----------------------------------------------------|
| Audit trail                | Log old/new values to a history table               |
| Enforce business rules     | Prevent salary from decreasing                      |
| Auto-populate columns      | Set `created_at` timestamp on INSERT                |
| Maintain derived data      | Update a summary table when detail rows change      |
| Prevent invalid DML        | Use `RAISE_APPLICATION_ERROR` to block bad updates  |

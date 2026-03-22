# Exercise 12 — PL/SQL Functions

> Run `SET SERVEROUTPUT ON;` before executing any PL/SQL block.

```sql
SET SERVEROUTPUT ON;
```

A **function** is a named PL/SQL block that **returns a value** via the `RETURN` clause. Unlike procedures, functions can be called inside SQL expressions (e.g., `SELECT my_func(x) FROM dual`).

---

## Function 1 — Factorial (Recursive)

**Create the function:**
```sql
CREATE OR REPLACE FUNCTION factorial (n IN NUMBER)
RETURN NUMBER
IS
BEGIN
    IF n < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Factorial undefined for negative numbers');
    ELSIF n = 0 OR n = 1 THEN
        RETURN 1;  -- base case
    ELSE
        RETURN n * factorial(n - 1);  -- recursive case
    END IF;
END;
/
```

**Call the function:**
```sql
DECLARE
    n    NUMBER := 5;
    fact NUMBER;
BEGIN
    fact := factorial(n);
    DBMS_OUTPUT.PUT_LINE('Factorial of ' || n || ' is ' || fact);
END;
/
```

**Expected output:** `Factorial of 5 is 120`

**Explanation:**
- **Recursive functions** call themselves with a smaller input until they reach a base case.
- Base case: `factorial(0) = 1` and `factorial(1) = 1` — these stop the recursion.
- Recursive case: `factorial(5) = 5 × factorial(4) = 5 × 4 × 3 × 2 × 1 = 120`.
- `RAISE_APPLICATION_ERROR` raises a user-defined error with a custom message for invalid input.
- `/` on its own line tells SQL*Plus to execute the preceding PL/SQL block.

---

## Function 2 — Check if a Number is Prime

**Create the function:**
```sql
CREATE OR REPLACE FUNCTION is_prime (n IN NUMBER)
RETURN BOOLEAN
IS
    divisor NUMBER := 2;
BEGIN
    IF n <= 1 THEN
        RETURN FALSE;
    END IF;

    WHILE divisor <= SQRT(n) LOOP
        IF MOD(n, divisor) = 0 THEN
            RETURN FALSE;  -- found a factor, not prime
        END IF;
        divisor := divisor + 1;
    END LOOP;

    RETURN TRUE;  -- no factors found
END;
/
```

**Call the function:**
```sql
DECLARE
    n NUMBER := 17;
BEGIN
    IF is_prime(n) THEN
        DBMS_OUTPUT.PUT_LINE(n || ' is a prime number.');
    ELSE
        DBMS_OUTPUT.PUT_LINE(n || ' is not a prime number.');
    END IF;
END;
/
```

**Expected output:** `17 is a prime number.`

**Explanation:**
- A prime number is divisible only by 1 and itself.
- We only need to check divisors up to √n — if n has a factor larger than √n, it must also have one smaller than √n.
- `WHILE divisor <= SQRT(n)` iterates through all candidate divisors. `MOD(n, divisor) = 0` means `divisor` divides `n` evenly.
- **Note:** Functions returning `BOOLEAN` cannot be called directly in SQL (`SELECT is_prime(17) FROM dual` would fail). They are for PL/SQL blocks only. Use a wrapper with `CASE` for SQL use.

---

## Function 3 — Count Students in 'CSE' Department

**Setup table:**
```sql
CREATE TABLE Student (
    Sno   NUMBER,
    sname VARCHAR2(50),
    dept  VARCHAR2(50),
    cgpa  NUMBER
);

INSERT INTO Student VALUES (1, 'John', 'CSE', 8.5);
INSERT INTO Student VALUES (2, 'Jane', 'CSE', 9.0);
INSERT INTO Student VALUES (3, 'Mike', 'CSE', 7.5);
```

**Create the function:**
```sql
CREATE OR REPLACE FUNCTION get_cse_student_count
RETURN NUMBER
IS
    cse_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO cse_count
    FROM Student
    WHERE dept = 'CSE';

    RETURN cse_count;
END;
/
```

**Call the function:**
```sql
DECLARE
    cse_count NUMBER;
BEGIN
    cse_count := get_cse_student_count();
    DBMS_OUTPUT.PUT_LINE('Number of students in CSE department: ' || cse_count);
END;
/
```

**Expected output:** `Number of students in CSE department: 3`

**Explanation:**
- `SELECT ... INTO variable` fetches exactly one value from a query into a PL/SQL variable.
- This is a **no-parameter function** — it queries the table and returns a count.
- Since it returns `NUMBER`, it can also be called in SQL: `SELECT get_cse_student_count() FROM dual;`

---

## Function 4 — Retrieve Maximum CGPA from Student Table

**Create the function:**
```sql
CREATE OR REPLACE FUNCTION get_max_cgpa
RETURN NUMBER
IS
    max_cgpa NUMBER;
BEGIN
    SELECT MAX(cgpa) INTO max_cgpa FROM Student;
    RETURN max_cgpa;
END;
/
```

**Call the function:**
```sql
DECLARE
    max_cgpa NUMBER;
BEGIN
    max_cgpa := get_max_cgpa();
    DBMS_OUTPUT.PUT_LINE('Maximum CGPA: ' || max_cgpa);
END;
/
```

**Expected output:** `Maximum CGPA: 9`

**Explanation:**
- `MAX(cgpa)` returns the highest CGPA in the table.
- `SELECT ... INTO` works here because a single aggregate function always returns exactly one row.
- This function can also be used inline in SQL: `SELECT get_max_cgpa() FROM dual;`

---

## Function 5 — Compute the Average of Two Numbers

**Create the function:**
```sql
CREATE OR REPLACE FUNCTION average_of_two (
    num1 IN NUMBER,
    num2 IN NUMBER
)
RETURN NUMBER
IS
BEGIN
    RETURN (num1 + num2) / 2;
END;
/
```

**Call from SQL:**
```sql
SELECT average_of_two(10, 20) AS average FROM dual;
```

**Expected output:** `15`

**Call from PL/SQL:**
```sql
DECLARE
    result NUMBER;
BEGIN
    result := average_of_two(10, 20);
    DBMS_OUTPUT.PUT_LINE('Average: ' || result);
END;
/
```

**Explanation:**
- This function has no local variables — the computation `(num1 + num2) / 2` is returned directly.
- `DUAL` is a special one-row, one-column Oracle table used to evaluate expressions or call functions in a SQL context.
- Since this function has no side effects and takes only number inputs, it is safe to call in both SQL and PL/SQL.

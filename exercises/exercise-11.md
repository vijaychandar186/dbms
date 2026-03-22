# Exercise 11 — PL/SQL Procedures

> Run `SET SERVEROUTPUT ON;` before executing any PL/SQL block.

```sql
SET SERVEROUTPUT ON;
```

A **procedure** is a named, stored PL/SQL block that performs an action. Unlike functions, procedures do not return a value directly — they use `OUT` or `IN OUT` parameters to pass results back to the caller.

---

## Procedure 1 — Display 'Hello World!'

**Create the procedure:**
```sql
CREATE OR REPLACE PROCEDURE display_hello_world
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello World!');
END;
/
```

**Execute:**
```sql
EXECUTE display_hello_world;
```

**Expected output:** `Hello World!`

**Explanation:**
- `CREATE OR REPLACE PROCEDURE` defines or redefines a stored procedure.
- `IS` marks the start of the declaration section (no variables here, so it's empty).
- `EXECUTE` (or `EXEC`) runs the procedure from SQL*Plus. In a PL/SQL block, call it as a statement: `display_hello_world;`.

---

## Procedure 2 — Find the Minimum of Two Numbers

**Create the procedure:**
```sql
CREATE OR REPLACE PROCEDURE find_minimum (
    num1    IN  NUMBER,
    num2    IN  NUMBER,
    min_num OUT NUMBER
)
IS
BEGIN
    IF num1 < num2 THEN
        min_num := num1;
    ELSE
        min_num := num2;
    END IF;
END;
/
```

**Call the procedure:**
```sql
DECLARE
    num1    NUMBER := 10;
    num2    NUMBER := 5;
    min_num NUMBER;
BEGIN
    find_minimum(num1, num2, min_num);
    DBMS_OUTPUT.PUT_LINE('Minimum value: ' || min_num);
END;
/
```

**Expected output:** `Minimum value: 5`

**Explanation:**
- `IN` parameters are read-only inputs — the procedure cannot modify them.
- `OUT` parameters are write-only outputs — the caller gets the result via this variable.
- The logic compares num1 and num2, then assigns the smaller value to `min_num`.
- In the calling block, `min_num` is declared as a variable and passed as the OUT argument.

---

## Procedure 3 — Compute the Cube of a Number

**Create the procedure:**
```sql
CREATE OR REPLACE PROCEDURE get_cube (
    num  IN  NUMBER,
    cube OUT NUMBER
)
IS
BEGIN
    cube := num * num * num;
END;
/
```

**Call the procedure:**
```sql
DECLARE
    num  NUMBER := 4;
    cube NUMBER;
BEGIN
    get_cube(num, cube);
    DBMS_OUTPUT.PUT_LINE('Cube of ' || num || ' is ' || cube);
END;
/
```

**Expected output:** `Cube of 4 is 64`

**Explanation:**
- `num * num * num` computes the cube. Oracle also provides `POWER(num, 3)` which is equivalent.
- The result is stored in the `OUT` variable `cube` and printed by the calling block.

---

## Procedure 4 — Check if a String is a Palindrome

**Create the procedure:**
```sql
CREATE OR REPLACE PROCEDURE check_palindrome (
    str           IN  VARCHAR2,
    is_palindrome OUT BOOLEAN
)
IS
    reversed_str VARCHAR2(100) := '';
BEGIN
    -- Build the reversed string character by character
    FOR i IN REVERSE 1..LENGTH(str) LOOP
        reversed_str := reversed_str || SUBSTR(str, i, 1);
    END LOOP;

    -- Compare original and reversed
    IF reversed_str = str THEN
        is_palindrome := TRUE;
    ELSE
        is_palindrome := FALSE;
    END IF;
END;
/
```

**Call the procedure:**
```sql
DECLARE
    str           VARCHAR2(100) := 'racecar';
    is_palindrome BOOLEAN;
BEGIN
    check_palindrome(str, is_palindrome);
    IF is_palindrome THEN
        DBMS_OUTPUT.PUT_LINE(str || ' is a palindrome.');
    ELSE
        DBMS_OUTPUT.PUT_LINE(str || ' is not a palindrome.');
    END IF;
END;
/
```

**Expected output:** `racecar is a palindrome.`

**Explanation:**
- `FOR i IN REVERSE 1..LENGTH(str)` iterates the index from the last character to the first.
- `SUBSTR(str, i, 1)` extracts one character at position `i`.
- `reversed_str` is initialised to `''` (empty string) to avoid the NULL concatenation issue — in Oracle, `NULL || 'x'` = `'x'`, but being explicit is clearer.
- After the loop, comparing `reversed_str = str` determines if the word reads the same backwards.

---

## Procedure 5 — Delete a Specific Row from a Table

**Setup table:**
```sql
CREATE TABLE student4 (
    id      NUMBER(10)    PRIMARY KEY,
    name    VARCHAR2(100) NOT NULL,
    email   VARCHAR2(100) UNIQUE,
    phone   VARCHAR2(20),
    age     NUMBER(3),
    gender  VARCHAR2(10),
    address VARCHAR2(200)
);

INSERT INTO student4 VALUES (101, 'John Smith',  'john.smith@example.com',  '555-1234', 25, 'Male',   '123 Main St');
INSERT INTO student4 VALUES (202, 'Jane Doe',    'jane.doe@example.com',    '555-5678', 22, 'Female', '456 Maple Ave');
INSERT INTO student4 VALUES (303, 'Bob Johnson', 'bob.johnson@example.com', '555-2468', 28, 'Male',   '789 Elm St');
```

**Create the procedure:**
```sql
CREATE OR REPLACE PROCEDURE delete_row (
    row_id IN NUMBER
)
IS
BEGIN
    DELETE FROM student4 WHERE id = row_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No row found with ID ' || row_id);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Row with ID ' || row_id || ' deleted successfully.');
        COMMIT;
    END IF;
END;
/
```

**Call the procedure:**
```sql
DECLARE
    row_id NUMBER := 101;
BEGIN
    delete_row(row_id);
END;
/
```

**Expected output:** `Row with ID 101 deleted successfully.`

**Explanation:**
- `DELETE FROM student4 WHERE id = row_id` deletes the matching row.
- `SQL%ROWCOUNT` is an implicit cursor attribute that holds the number of rows affected by the most recent DML statement.
- Checking `SQL%ROWCOUNT = 0` guards against silently doing nothing when an invalid ID is passed.
- `COMMIT` inside the procedure makes the deletion permanent. Omit it if the caller wants to control the transaction boundary.

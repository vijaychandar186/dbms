# Exercise 14 — PL/SQL Exception Handling

> Run `SET SERVEROUTPUT ON;` before executing any PL/SQL block.

```sql
SET SERVEROUTPUT ON;
```

**Exception handling** in PL/SQL allows a program to detect and respond to runtime errors gracefully, instead of crashing with an unhandled Oracle error.

Structure:
```sql
BEGIN
    -- normal code
EXCEPTION
    WHEN exception_name THEN
        -- error handling code
END;
```

---

## Built-in (Predefined) vs User-Defined Exceptions

| Type                    | Description                                              | Example                   |
|-------------------------|----------------------------------------------------------|---------------------------|
| **Predefined**          | Named Oracle exceptions raised automatically             | `ZERO_DIVIDE`, `NO_DATA_FOUND` |
| **User-defined**        | Declared with `EXCEPTION` keyword, raised with `RAISE`  | Custom business rules     |

---

## Q1 — Handle Division by Zero

```sql
DECLARE
    a NUMBER;
    b NUMBER;
    c NUMBER;
BEGIN
    a := &a;
    b := &b;
    c := a / b;  -- raises ZERO_DIVIDE automatically if b = 0
    DBMS_OUTPUT.PUT_LINE('Result: ' || c);
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('Error: Cannot divide by zero');
END;
/
```

**Sample runs:**
- Input a=10, b=2 → `Result: 5`
- Input a=10, b=0 → `Error: Cannot divide by zero`

**Explanation:**
- When `b = 0`, Oracle raises the predefined exception `ZERO_DIVIDE` (`ORA-01476`) automatically — no manual check is needed.
- The `EXCEPTION` block catches it and prints a friendly message instead of crashing.
- The clean version above is simpler and more correct than using an `IF b > 0` guard: if you guard with `IF`, a zero value in the `ELSE` branch would still attempt the division unnecessarily. Letting Oracle raise and catching it is the idiomatic PL/SQL approach.
- To also handle other unexpected errors, add `WHEN OTHERS THEN`:

```sql
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('Error: Cannot divide by zero');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END;
```

---

## Q2 — Validate Age with a User-Defined Exception

```sql
DECLARE
    age    NUMBER;
    inage  EXCEPTION;   -- declare the user-defined exception
BEGIN
    age := &age;

    IF age >= 0 AND age < 200 THEN
        DBMS_OUTPUT.PUT_LINE('Your age is: ' || age);
    ELSE
        RAISE inage;    -- manually trigger the exception
    END IF;

EXCEPTION
    WHEN inage THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid age entered (' || age || '). Age must be between 0 and 199.');
END;
/
```

**Sample runs:**
- Input age=25 → `Your age is: 25`
- Input age=-5 → `Error: Invalid age entered (-5). Age must be between 0 and 199.`
- Input age=300 → `Error: Invalid age entered (300). Age must be between 0 and 199.`

**Explanation:**
- `inage EXCEPTION` declares a custom exception variable in the `DECLARE` section.
- `RAISE inage` manually fires the exception when the age is out of the valid range [0, 199].
- The `WHEN inage THEN` handler in the `EXCEPTION` block catches only this specific exception.
- User-defined exceptions are useful for enforcing business rules that have no corresponding Oracle error code.

---

## Common Predefined Exceptions Reference

| Exception Name       | Oracle Error | When It Is Raised                                      |
|----------------------|--------------|--------------------------------------------------------|
| `ZERO_DIVIDE`        | ORA-01476    | Division by zero                                       |
| `NO_DATA_FOUND`      | ORA-01403    | `SELECT INTO` returns no rows                          |
| `TOO_MANY_ROWS`      | ORA-01422    | `SELECT INTO` returns more than one row                |
| `VALUE_ERROR`        | ORA-06502    | Arithmetic, conversion, or size constraint error       |
| `INVALID_NUMBER`     | ORA-01722    | Conversion of a string to a number fails               |
| `DUP_VAL_ON_INDEX`   | ORA-00001    | Unique constraint violated on INSERT/UPDATE            |
| `CURSOR_ALREADY_OPEN`| ORA-06511    | Attempt to open an already-open cursor                 |

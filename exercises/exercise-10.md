# Exercise 10 — PL/SQL Conditional and Iterative Statements

> Run `SET SERVEROUTPUT ON;` before executing any PL/SQL block to enable output.

```sql
SET SERVEROUTPUT ON;
```

---

## Program 1 — Convert Fahrenheit to Celsius

```sql
DECLARE
    fahrenheit NUMBER;
    celsius    NUMBER;
BEGIN
    fahrenheit := &fahrenheit;  -- accepts runtime input
    celsius    := (fahrenheit - 32) * 5 / 9;
    DBMS_OUTPUT.PUT_LINE('Temperature in Celsius: ' || ROUND(celsius, 2));
END;
/
```

**Explanation:**
- `&fahrenheit` is a substitution variable — Oracle SQL*Plus/SQL Developer prompts the user for a value at runtime.
- The formula `(F - 32) × 5/9` converts Fahrenheit to Celsius.
- `ROUND(celsius, 2)` limits the output to 2 decimal places.
- **Sample:** Input 98.6°F → Output `37°C`.

---

## Program 2 — Sum of Even Integers from 1 to 10

```sql
DECLARE
    total NUMBER := 0;  -- := is the PL/SQL assignment operator
BEGIN
    FOR i IN 1..10 LOOP
        IF MOD(i, 2) = 0 THEN
            total := total + i;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Sum of even integers from 1 to 10: ' || total);
END;
/
```

**Expected output:** `Sum of even integers from 1 to 10: 30` (2+4+6+8+10)

**Explanation:**
- `:=` is the PL/SQL assignment operator. Using `=` alone is a comparison, not an assignment.
- `FOR i IN 1..10` iterates i from 1 to 10 inclusive. The loop variable `i` is implicitly declared.
- `MOD(i, 2) = 0` checks if `i` is even (divisible by 2 with no remainder).
- The variable is named `total` instead of `sum` to avoid conflict with Oracle's built-in `SUM` function.

---

## Program 3 — Greatest of Three Numbers

```sql
DECLARE
    a   NUMBER := &a;
    b   NUMBER := &b;
    c   NUMBER := &c;
    max NUMBER;
BEGIN
    max := a;

    IF b > max THEN
        max := b;
    END IF;

    IF c > max THEN
        max := c;
    END IF;

    DBMS_OUTPUT.PUT_LINE('The greatest of ' || a || ', ' || b || ', and ' || c || ' is ' || max);
END;
/
```

**Explanation:**
- The algorithm initialises `max` to `a`, then replaces it with `b` if `b` is larger, then with `c` if `c` is larger.
- Two separate `IF` blocks (not `IF-ELSIF`) ensure both `b` and `c` are compared against the running maximum.
- **Sample:** a=10, b=35, c=22 → output `The greatest of 10, 35, and 22 is 35`.

---

## Program 4 — Check Whether a Number is Odd or Even

```sql
DECLARE
    num NUMBER;
BEGIN
    num := &num;

    IF MOD(num, 2) = 0 THEN
        DBMS_OUTPUT.PUT_LINE(num || ' is even');
    ELSE
        DBMS_OUTPUT.PUT_LINE(num || ' is odd');
    END IF;
END;
/
```

**Explanation:**
- `IF ... ELSE ... END IF` is the two-branch conditional.
- `MOD(num, 2)` returns the remainder when `num` is divided by 2.
  - Result = 0 → even; Result = 1 (or -1 for negatives) → odd.
- **Samples:** 8 → `8 is even`; 7 → `7 is odd`; 0 → `0 is even`.

---

## Program 5 — Factorial of a Number

```sql
DECLARE
    num       NUMBER := &num;
    factorial NUMBER := 1;
BEGIN
    IF num < 0 THEN
        DBMS_OUTPUT.PUT_LINE('Factorial is not defined for negative numbers');
    ELSIF num = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Factorial of 0 is 1');
    ELSE
        FOR i IN 1..num LOOP
            factorial := factorial * i;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('Factorial of ' || num || ' is ' || factorial);
    END IF;
END;
/
```

**Explanation:**
- `factorial` is initialised to `1` (the identity element for multiplication).
- The `FOR` loop multiplies `factorial` by each integer from 1 to `num` in order.
  - i=1: 1×1=1; i=2: 1×2=2; i=3: 2×3=6; i=4: 6×4=24; i=5: 24×5=120.
- Edge cases are handled: negative input is rejected; 0! = 1 by mathematical definition.
- **Sample:** num=5 → `Factorial of 5 is 120`.

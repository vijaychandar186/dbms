# PL/SQL Tutorial - Complete Learning Guide

A comprehensive, step-by-step guide to PL/SQL with integrated Learn → Implement pairs for every concept.

---

## Table of Contents

### **PHASE 1: Foundations**
- Introduction & Environment Setup

### **PHASE 2: Language Basics**
1. [Lesson 1: Basic Syntax & Block Structure](#lesson-1-basic-syntax--block-structure) (Learn + Implement)
2. [Lesson 2: Data Types](#lesson-2-data-types) (Learn + Implement)
3. [Lesson 3: Variables & Constants](#lesson-3-variables--constants) (Learn + Implement)
4. [Lesson 4: Operators](#lesson-4-operators) (Learn + Implement)

### **PHASE 3: Control Flow**
5. [Lesson 5: Conditions (IF / CASE)](#lesson-5-conditions-if--case) (Learn + Implement)
6. [Lesson 6: Loops](#lesson-6-loops) (Learn + Implement)

### **PHASE 4: Working with Data**
7. [Lesson 7: Strings](#lesson-7-strings) (Learn + Implement)
8. [Lesson 8: Date & Time](#lesson-8-date--time) (Learn + Implement)
9. [Lesson 9: Records](#lesson-9-records) (Learn + Implement)
10. [Lesson 10: Arrays (VARRAYs & Nested Tables)](#lesson-10-arrays-varrays--nested-tables) (Learn + Implement)
11. [Lesson 11: Collections](#lesson-11-collections) (Learn + Implement)

### **PHASE 5: Reusable Code**
12. [Lesson 12: Procedures](#lesson-12-procedures) (Learn + Implement)
13. [Lesson 13: Functions](#lesson-13-functions) (Learn + Implement)
14. [Lesson 14: Packages](#lesson-14-packages) (Learn + Implement)

### **PHASE 6: Database Interaction**
15. [Lesson 15: Cursors](#lesson-15-cursors) (Learn + Implement)
16. [Lesson 16: Transactions](#lesson-16-transactions) (Learn + Implement)
17. [Lesson 17: DBMS Output](#lesson-17-dbms-output) (Learn + Implement)

### **PHASE 7: Advanced Features**
18. [Lesson 18: Exception Handling](#lesson-18-exception-handling) (Learn + Implement)
19. [Lesson 19: Triggers](#lesson-19-triggers) (Learn + Implement)
20. [Lesson 20: Object-Oriented PL/SQL](#lesson-20-object-oriented-plsql) (Learn + Implement)

### **PHASE 8: Capstone Project**
- [Complete Project Challenges](#complete-project-challenges)

---

## FOUNDATIONS

### What is PL/SQL?

PL/SQL (Procedural Language/Structured Query Language) is Oracle's procedural extension to SQL. It adds programming constructs like variables, loops, conditions, and procedures directly inside the database engine, enabling you to write powerful business logic that runs close to your data.

### PL/SQL vs SQL

| Feature | SQL | PL/SQL |
|---|---|---|
| Purpose | Query/manipulate data | Add logic around data operations |
| Variables | ❌ | ✅ |
| Loops | ❌ | ✅ |
| Conditions | Limited | Full IF/CASE/ELSIF |
| Error handling | ❌ | ✅ EXCEPTION block |
| Reusable code | ❌ | ✅ Procedures, Functions, Packages |

### Environment Setup

PL/SQL runs inside an Oracle Database. To follow along:

- **Oracle Database Express Edition (XE)** — Free, available at oracle.com/xe
- **Oracle Live SQL** — Free browser-based environment at livesql.oracle.com
- **SQL*Plus** — Command-line client bundled with Oracle
- **SQL Developer** — Free GUI IDE from Oracle

Enable DBMS_OUTPUT so you can see printed results:

```sql
SET SERVEROUTPUT ON;
```

---

# PHASE 2: LANGUAGE BASICS

## Lesson 1: Basic Syntax & Block Structure

### Learn

Every piece of PL/SQL code lives inside a **block**. A block has four sections:

```
[DECLARE]          -- Optional: variables, constants, cursors
BEGIN              -- Required: executable statements
   ...
[EXCEPTION]        -- Optional: error handling
END;               -- Required: closes the block
/                  -- Required: submits the block to Oracle
```

Blocks can be **anonymous** (run once, not saved) or **named** (stored as procedures, functions, packages, or triggers).

**Key syntax rules:**
- Statements end with a semicolon `;`
- Block ends with `END;` followed by `/` on a new line
- Comments: `--` single line, `/* */` multi-line
- PL/SQL is case-insensitive for keywords, but conventionally UPPERCASE for keywords

### Implement

Your first PL/SQL block:

```sql
-- Anonymous block: prints a greeting
BEGIN
   DBMS_OUTPUT.PUT_LINE('Hello, PL/SQL!');
END;
/
```

A block with all sections:

```sql
DECLARE
   v_message VARCHAR2(100);   -- variable declaration
BEGIN
   v_message := 'PL/SQL is running!';
   DBMS_OUTPUT.PUT_LINE(v_message);
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('An error occurred.');
END;
/
```

✅ **Your turn:** Write an anonymous block that prints your name and today's date using `SYSDATE`.

---

## Lesson 2: Data Types

### Learn

PL/SQL has a rich type system. Types fall into four categories:

**Scalar Types** (single values)

| Type | Description | Example |
|---|---|---|
| `NUMBER(p,s)` | Numeric, p digits, s decimal places | `NUMBER(8,2)` |
| `INTEGER` | Whole numbers | `INTEGER` |
| `BINARY_INTEGER` | Fast integers for counters | `BINARY_INTEGER` |
| `VARCHAR2(n)` | Variable-length string, max n chars | `VARCHAR2(200)` |
| `CHAR(n)` | Fixed-length string | `CHAR(10)` |
| `DATE` | Date and time | `DATE` |
| `TIMESTAMP` | Date + time with fractional seconds | `TIMESTAMP` |
| `BOOLEAN` | TRUE / FALSE / NULL | `BOOLEAN` |
| `CLOB` | Large text (up to 4 GB) | `CLOB` |

**Composite Types** — Records, collections (covered in later lessons)

**Reference Types** — REF CURSOR, pointers to rows

**LOB Types** — CLOB, BLOB, BFILE for large data

**Special Type Anchors:**

```sql
-- %TYPE anchors a variable to a column's type
v_name researchers.name%TYPE;

-- %ROWTYPE anchors a variable to an entire row's structure
v_row  researchers%ROWTYPE;
```

Using `%TYPE` and `%ROWTYPE` means your variable automatically adapts if the table definition changes — a best practice.

### Implement

Declare and use several data types:

```sql
DECLARE
   v_researcher_name  VARCHAR2(100);
   v_citations        NUMBER(10);
   v_avg_score        NUMBER(6,2);
   v_is_active        BOOLEAN;
   v_hire_date        DATE;

   -- Anchored types (best practice)
   v_field            researchers.field%TYPE;
BEGIN
   v_researcher_name := 'Geoffrey Hinton';
   v_citations       := 180000;
   v_avg_score       := 98.75;
   v_is_active       := TRUE;
   v_hire_date       := SYSDATE;
   v_field           := 'Neural Networks';

   DBMS_OUTPUT.PUT_LINE('Name:       ' || v_researcher_name);
   DBMS_OUTPUT.PUT_LINE('Citations:  ' || v_citations);
   DBMS_OUTPUT.PUT_LINE('Score:      ' || v_avg_score);
   DBMS_OUTPUT.PUT_LINE('Active:     ' || CASE WHEN v_is_active THEN 'Yes' ELSE 'No' END);
   DBMS_OUTPUT.PUT_LINE('Hired:      ' || TO_CHAR(v_hire_date, 'YYYY-MM-DD'));
END;
/
```

✅ **Your turn:**
1. Declare a variable anchored to `companies.name%TYPE` and assign it a value
2. Declare a `BOOLEAN` variable and print a message depending on its value

---

## Lesson 3: Variables & Constants

### Learn

**Variables** store values that can change throughout the block.

```sql
variable_name  datatype [NOT NULL] [:= initial_value];
```

**Constants** store values that never change after declaration.

```sql
constant_name  CONSTANT datatype := value;
```

**Assignment operator** is `:=` (not `=` — that's for comparison).

**Key rules:**
- Variables default to `NULL` if not initialized
- `NOT NULL` forces you to provide an initial value
- Constants must always be initialized at declaration

### Implement

```sql
DECLARE
   -- Variables
   v_company_name    VARCHAR2(100) := 'Anthropic';
   v_researcher_count NUMBER       := 0;
   v_department       VARCHAR2(50);        -- NULL by default

   -- Constants
   c_max_citations   CONSTANT NUMBER       := 999999;
   c_db_version      CONSTANT VARCHAR2(20) := '19c';
   c_founded_year    CONSTANT INTEGER      := 2021;

   -- NOT NULL variable (must be initialized)
   v_status          VARCHAR2(20) NOT NULL := 'Active';
BEGIN
   -- Reassign variable
   v_researcher_count := v_researcher_count + 5;
   v_department       := 'AI Safety';

   DBMS_OUTPUT.PUT_LINE('Company:     ' || v_company_name);
   DBMS_OUTPUT.PUT_LINE('Researchers: ' || v_researcher_count);
   DBMS_OUTPUT.PUT_LINE('Department:  ' || v_department);
   DBMS_OUTPUT.PUT_LINE('Max allowed: ' || c_max_citations);
   DBMS_OUTPUT.PUT_LINE('Founded:     ' || c_founded_year);
   DBMS_OUTPUT.PUT_LINE('Status:      ' || v_status);

   -- This would cause a compile error: c_max_citations := 500;
END;
/
```

✅ **Your turn:**
1. Declare a constant for your database name and a variable for the current user
2. Try assigning a new value to your constant — observe the error

---

## Lesson 4: Operators

### Learn

**Arithmetic Operators**

| Operator | Meaning | Example |
|---|---|---|
| `+` | Addition | `v_x + 10` |
| `-` | Subtraction | `v_x - 5` |
| `*` | Multiplication | `v_x * 2` |
| `/` | Division | `v_x / 4` |
| `**` | Exponentiation | `2 ** 8` |

**Comparison Operators**

| Operator | Meaning |
|---|---|
| `=` | Equal |
| `!=` or `<>` | Not equal |
| `<` / `>` | Less / Greater than |
| `<=` / `>=` | Less / Greater or equal |
| `IS NULL` | Value is null |
| `IS NOT NULL` | Value is not null |
| `LIKE` | Pattern match |
| `BETWEEN` | Range check |
| `IN` | Membership check |

**Logical Operators:** `AND`, `OR`, `NOT`

**String Concatenation:** `||`

### Implement

```sql
DECLARE
   v_a      NUMBER := 15;
   v_b      NUMBER := 4;
   v_name   VARCHAR2(50) := 'Deep';
   v_result NUMBER;
   v_text   VARCHAR2(100);
BEGIN
   -- Arithmetic
   DBMS_OUTPUT.PUT_LINE('Sum:        ' || (v_a + v_b));
   DBMS_OUTPUT.PUT_LINE('Difference: ' || (v_a - v_b));
   DBMS_OUTPUT.PUT_LINE('Product:    ' || (v_a * v_b));
   DBMS_OUTPUT.PUT_LINE('Quotient:   ' || (v_a / v_b));
   DBMS_OUTPUT.PUT_LINE('Power:      ' || (v_a ** 2));

   -- String concatenation
   v_text := v_name || ' ' || 'Learning Research';
   DBMS_OUTPUT.PUT_LINE('Text:       ' || v_text);

   -- Comparison in a condition
   IF v_a > v_b THEN
      DBMS_OUTPUT.PUT_LINE(v_a || ' is greater than ' || v_b);
   END IF;

   -- NULL check
   v_result := NULL;
   IF v_result IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('v_result is NULL');
   END IF;
END;
/
```

✅ **Your turn:**
1. Compute the area of a circle (π × r²) using PL/SQL — define `c_pi CONSTANT NUMBER := 3.14159`
2. Concatenate a researcher's first name and last name into a full name variable

---

# PHASE 3: CONTROL FLOW

## Lesson 5: Conditions (IF / CASE)

### Learn

**IF Statement**

```sql
IF condition THEN
   statements;
ELSIF another_condition THEN
   statements;
ELSE
   statements;
END IF;
```

**CASE Statement**

```sql
-- Simple CASE (like a switch)
CASE variable
   WHEN value1 THEN statements;
   WHEN value2 THEN statements;
   ELSE statements;
END CASE;

-- Searched CASE (like IF/ELSIF)
CASE
   WHEN condition1 THEN statements;
   WHEN condition2 THEN statements;
   ELSE statements;
END CASE;
```

### Implement

```sql
DECLARE
   v_citations   NUMBER := 120000;
   v_field       VARCHAR2(50) := 'AI Safety';
   v_level       VARCHAR2(30);
BEGIN
   -- IF / ELSIF / ELSE
   IF v_citations > 150000 THEN
      v_level := 'Legend';
   ELSIF v_citations > 100000 THEN
      v_level := 'Highly Cited';
   ELSIF v_citations > 50000 THEN
      v_level := 'Well Cited';
   ELSE
      v_level := 'Emerging';
   END IF;
   DBMS_OUTPUT.PUT_LINE('Citation level: ' || v_level);

   -- Simple CASE
   CASE v_field
      WHEN 'Deep Learning'         THEN DBMS_OUTPUT.PUT_LINE('Focus: Vision & Perception');
      WHEN 'AI Safety'             THEN DBMS_OUTPUT.PUT_LINE('Focus: Safety & Ethics');
      WHEN 'Reinforcement Learning'THEN DBMS_OUTPUT.PUT_LINE('Focus: Decision Making');
      ELSE                              DBMS_OUTPUT.PUT_LINE('Focus: General AI');
   END CASE;

   -- Searched CASE
   CASE
      WHEN v_citations > 100000 AND v_field = 'AI Safety' THEN
         DBMS_OUTPUT.PUT_LINE('Top safety researcher!');
      WHEN v_citations > 100000 THEN
         DBMS_OUTPUT.PUT_LINE('High-impact researcher.');
      ELSE
         DBMS_OUTPUT.PUT_LINE('Growing researcher.');
   END CASE;
END;
/
```

✅ **Your turn:**
1. Write an IF block that categorizes a company's founding year as "Pioneer" (before 2000), "Modern" (2000–2015), or "New Player" (after 2015)
2. Use a CASE statement to map field names to department codes

---

## Lesson 6: Loops

### Learn

PL/SQL has three loop types plus a FOR loop variant for cursors.

**Basic LOOP** — loops forever until an EXIT statement

```sql
LOOP
   statements;
   EXIT WHEN condition;
END LOOP;
```

**WHILE LOOP** — checks condition before each iteration

```sql
WHILE condition LOOP
   statements;
END LOOP;
```

**FOR LOOP** — iterates over a numeric range automatically

```sql
FOR i IN start_value..end_value LOOP
   statements;
END LOOP;

-- Reverse
FOR i IN REVERSE start_value..end_value LOOP
   statements;
END LOOP;
```

**CONTINUE** skips to the next iteration; **EXIT** exits the loop.

### Implement

```sql
DECLARE
   v_counter  NUMBER := 1;
   v_total    NUMBER := 0;
BEGIN
   -- Basic LOOP
   DBMS_OUTPUT.PUT_LINE('--- Basic LOOP ---');
   LOOP
      DBMS_OUTPUT.PUT_LINE('Iteration: ' || v_counter);
      v_counter := v_counter + 1;
      EXIT WHEN v_counter > 3;
   END LOOP;

   -- WHILE LOOP
   DBMS_OUTPUT.PUT_LINE('--- WHILE LOOP ---');
   v_counter := 1;
   WHILE v_counter <= 3 LOOP
      v_total := v_total + v_counter;
      v_counter := v_counter + 1;
   END LOOP;
   DBMS_OUTPUT.PUT_LINE('Sum 1-3: ' || v_total);

   -- FOR LOOP
   DBMS_OUTPUT.PUT_LINE('--- FOR LOOP ---');
   FOR i IN 1..5 LOOP
      IF MOD(i, 2) = 0 THEN
         CONTINUE;   -- skip even numbers
      END IF;
      DBMS_OUTPUT.PUT_LINE('Odd number: ' || i);
   END LOOP;

   -- Reverse FOR LOOP
   DBMS_OUTPUT.PUT_LINE('--- REVERSE FOR LOOP ---');
   FOR i IN REVERSE 1..3 LOOP
      DBMS_OUTPUT.PUT_LINE('Countdown: ' || i);
   END LOOP;
END;
/
```

✅ **Your turn:**
1. Use a FOR loop to print the squares of numbers 1 through 10
2. Use a WHILE loop to calculate the factorial of 5

---

# PHASE 4: WORKING WITH DATA

## Lesson 7: Strings

### Learn

PL/SQL provides many built-in string functions:

| Function | Description | Example |
|---|---|---|
| `LENGTH(s)` | Number of characters | `LENGTH('Hello')` → 5 |
| `UPPER(s)` | Convert to uppercase | `UPPER('hello')` → `HELLO` |
| `LOWER(s)` | Convert to lowercase | `LOWER('HELLO')` → `hello` |
| `INITCAP(s)` | Capitalize each word | `INITCAP('hello world')` → `Hello World` |
| `SUBSTR(s,pos,len)` | Extract substring | `SUBSTR('Hello',2,3)` → `ell` |
| `INSTR(s,search)` | Find position of substring | `INSTR('Hello','ll')` → 3 |
| `TRIM(s)` | Remove leading/trailing spaces | `TRIM('  Hi  ')` → `Hi` |
| `LTRIM(s)` | Remove leading spaces | `LTRIM('  Hi')` → `Hi` |
| `RTRIM(s)` | Remove trailing spaces | `RTRIM('Hi  ')` → `Hi` |
| `REPLACE(s,old,new)` | Replace substring | `REPLACE('Hi Bob','Bob','Alice')` |
| `LPAD(s,n,pad)` | Left pad to width n | `LPAD('5',3,'0')` → `005` |
| `RPAD(s,n,pad)` | Right pad to width n | `RPAD('OK',5,'.')` → `OK...` |
| `CONCAT(s1,s2)` | Join two strings | `CONCAT('Hello',' World')` |
| `TO_CHAR(val,fmt)` | Convert number/date to string | `TO_CHAR(SYSDATE,'YYYY-MM-DD')` |
| `TO_NUMBER(s)` | Convert string to number | `TO_NUMBER('42')` |

### Implement

```sql
DECLARE
   v_full_name   VARCHAR2(100) := '  Geoffrey Hinton  ';
   v_email       VARCHAR2(100) := 'hinton@google.com';
   v_field       VARCHAR2(50)  := 'neural networks';
   v_id_padded   VARCHAR2(10);
BEGIN
   -- Trim and format name
   DBMS_OUTPUT.PUT_LINE('Trimmed:    "' || TRIM(v_full_name) || '"');
   DBMS_OUTPUT.PUT_LINE('Upper:      ' || UPPER(v_full_name));
   DBMS_OUTPUT.PUT_LINE('InitCap:    ' || INITCAP(v_field));
   DBMS_OUTPUT.PUT_LINE('Length:     ' || LENGTH(TRIM(v_full_name)));

   -- Extract parts of email
   DBMS_OUTPUT.PUT_LINE('Username:   ' || SUBSTR(v_email, 1, INSTR(v_email,'@') - 1));
   DBMS_OUTPUT.PUT_LINE('Domain:     ' || SUBSTR(v_email, INSTR(v_email,'@') + 1));

   -- Replace and pad
   DBMS_OUTPUT.PUT_LINE('Replaced:   ' || REPLACE(v_email, 'google', 'deepmind'));
   v_id_padded := LPAD(42, 6, '0');
   DBMS_OUTPUT.PUT_LINE('Padded ID:  ' || v_id_padded);

   -- Concatenation
   DBMS_OUTPUT.PUT_LINE('Full info:  ' || INITCAP(TRIM(v_full_name)) || ' | ' || UPPER(v_field));
END;
/
```

✅ **Your turn:**
1. Extract the first name and last name separately from a full name string using `INSTR` and `SUBSTR`
2. Format a researcher's ID as a 8-character zero-padded string using `LPAD`

---

## Lesson 8: Date & Time

### Learn

**Key date functions:**

| Function | Description |
|---|---|
| `SYSDATE` | Current date and time |
| `SYSTIMESTAMP` | Current timestamp with timezone |
| `ADD_MONTHS(d,n)` | Add n months to date |
| `MONTHS_BETWEEN(d1,d2)` | Months between two dates |
| `LAST_DAY(d)` | Last day of d's month |
| `NEXT_DAY(d, 'DAY')` | Next occurrence of a weekday |
| `TRUNC(d)` | Remove time portion |
| `ROUND(d)` | Round to nearest day |
| `TO_DATE(s, fmt)` | Parse string to date |
| `TO_CHAR(d, fmt)` | Format date to string |
| `EXTRACT(part FROM d)` | Pull YEAR/MONTH/DAY/HOUR |

**Common format masks:** `'YYYY-MM-DD'`, `'DD/MM/YYYY'`, `'YYYY-MM-DD HH24:MI:SS'`

**Date arithmetic:**
- `date + n` adds n days
- `date - date` returns the number of days between two dates

### Implement

```sql
DECLARE
   v_today         DATE := SYSDATE;
   v_hire_date     DATE := TO_DATE('2021-05-15', 'YYYY-MM-DD');
   v_months_worked NUMBER;
   v_next_review   DATE;
BEGIN
   DBMS_OUTPUT.PUT_LINE('Today:           ' || TO_CHAR(v_today, 'YYYY-MM-DD HH24:MI:SS'));
   DBMS_OUTPUT.PUT_LINE('Hire Date:       ' || TO_CHAR(v_hire_date, 'DD Month YYYY'));

   -- Calculate tenure
   v_months_worked := ROUND(MONTHS_BETWEEN(v_today, v_hire_date));
   DBMS_OUTPUT.PUT_LINE('Months worked:   ' || v_months_worked);

   -- Add months
   v_next_review := ADD_MONTHS(v_hire_date, 12);
   DBMS_OUTPUT.PUT_LINE('First review:    ' || TO_CHAR(v_next_review, 'YYYY-MM-DD'));

   -- Arithmetic
   DBMS_OUTPUT.PUT_LINE('Days since hire: ' || ROUND(v_today - v_hire_date));

   -- Extract parts
   DBMS_OUTPUT.PUT_LINE('Hire year:       ' || EXTRACT(YEAR FROM v_hire_date));
   DBMS_OUTPUT.PUT_LINE('Hire month:      ' || EXTRACT(MONTH FROM v_hire_date));

   -- Last day of this month
   DBMS_OUTPUT.PUT_LINE('Month ends:      ' || TO_CHAR(LAST_DAY(v_today), 'YYYY-MM-DD'));
END;
/
```

✅ **Your turn:**
1. Calculate how many days are left until the end of the current year
2. Given a publication date, determine how many years ago it was published

---

## Lesson 9: Records

### Learn

A **record** is a composite variable that groups related fields into one unit — similar to a struct in other languages. There are three ways to declare records:

1. **Table-based** (`%ROWTYPE`) — mirrors an entire table row
2. **Cursor-based** (`cursor%ROWTYPE`) — mirrors a cursor's columns
3. **Programmer-defined** (`TYPE ... IS RECORD`) — custom structure

```sql
-- Table-based record
v_row  table_name%ROWTYPE;

-- Custom record type
TYPE t_researcher IS RECORD (
   name       VARCHAR2(100),
   citations  NUMBER,
   is_active  BOOLEAN
);
v_rec t_researcher;
```

Access fields with dot notation: `v_rec.name`, `v_rec.citations`.

### Implement

```sql
DECLARE
   -- Table-based record
   v_company   companies%ROWTYPE;

   -- Custom record type
   TYPE t_summary IS RECORD (
      researcher_name  VARCHAR2(100),
      company_name     VARCHAR2(100),
      total_citations  NUMBER,
      pub_count        INTEGER
   );
   v_summary t_summary;

BEGIN
   -- Populate table-based record from SELECT INTO
   SELECT id, name, founded_year, headquarters
   INTO   v_company
   FROM   companies
   WHERE  name = 'Anthropic';

   DBMS_OUTPUT.PUT_LINE('Company:    ' || v_company.name);
   DBMS_OUTPUT.PUT_LINE('Founded:    ' || v_company.founded_year);
   DBMS_OUTPUT.PUT_LINE('HQ:         ' || v_company.headquarters);

   -- Populate custom record manually
   v_summary.researcher_name := 'Ilya Sutskever';
   v_summary.company_name    := 'OpenAI';
   v_summary.total_citations := 45000;
   v_summary.pub_count       := 12;

   DBMS_OUTPUT.PUT_LINE('---');
   DBMS_OUTPUT.PUT_LINE('Researcher: ' || v_summary.researcher_name);
   DBMS_OUTPUT.PUT_LINE('Company:    ' || v_summary.company_name);
   DBMS_OUTPUT.PUT_LINE('Citations:  ' || v_summary.total_citations);
   DBMS_OUTPUT.PUT_LINE('Pubs:       ' || v_summary.pub_count);
END;
/
```

✅ **Your turn:**
1. Declare a `%ROWTYPE` variable for the `researchers` table and fetch a row into it
2. Create a custom record type that stores a publication title, year, and whether it was highly cited (BOOLEAN)

---

## Lesson 10: Arrays (VARRAYs & Nested Tables)

### Learn

PL/SQL has two array-like collection types covered here:

**VARRAY** (Variable-size array)
- Fixed maximum size declared upfront
- Ordered, indexed from 1
- Stored as a single object

```sql
TYPE type_name IS VARRAY(max_size) OF element_type;
```

**Nested Table**
- No declared maximum size — grows dynamically
- Indexed from 1 like VARRAY
- Can be sparse (elements can be deleted leaving gaps)

```sql
TYPE type_name IS TABLE OF element_type;
```

Both must be initialized before use with a constructor call.

### Implement

```sql
DECLARE
   -- VARRAY: fixed max 5 elements
   TYPE t_top_fields IS VARRAY(5) OF VARCHAR2(50);
   v_fields t_top_fields := t_top_fields('Deep Learning', 'AI Safety', 'NLP');

   -- Nested Table: dynamic size
   TYPE t_citation_list IS TABLE OF NUMBER;
   v_citations t_citation_list := t_citation_list(50000, 120000, 45000, 180000, 55000);

   v_total NUMBER := 0;
BEGIN
   -- Iterate VARRAY
   DBMS_OUTPUT.PUT_LINE('Top Research Fields:');
   FOR i IN 1..v_fields.COUNT LOOP
      DBMS_OUTPUT.PUT_LINE('  ' || i || '. ' || v_fields(i));
   END LOOP;

   -- Extend VARRAY by one element
   v_fields.EXTEND;
   v_fields(4) := 'Reinforcement Learning';
   DBMS_OUTPUT.PUT_LINE('Added field: ' || v_fields(4));

   -- Iterate Nested Table and compute sum
   DBMS_OUTPUT.PUT_LINE('Citations list:');
   FOR i IN 1..v_citations.COUNT LOOP
      v_total := v_total + v_citations(i);
      DBMS_OUTPUT.PUT_LINE('  [' || i || '] ' || v_citations(i));
   END LOOP;
   DBMS_OUTPUT.PUT_LINE('Total citations: ' || v_total);

   -- Extend and add to nested table
   v_citations.EXTEND;
   v_citations(v_citations.LAST) := 160000;
   DBMS_OUTPUT.PUT_LINE('New count: ' || v_citations.COUNT);
END;
/
```

**Useful collection methods:** `COUNT`, `FIRST`, `LAST`, `EXTEND`, `TRIM`, `DELETE`, `EXISTS`, `LIMIT`

✅ **Your turn:**
1. Create a VARRAY of 7 company names and print each with its index
2. Create a nested table of publication years, compute the average, and find the earliest year

---

## Lesson 11: Collections

### Learn

The third collection type — **Associative Arrays** (also called Index-By Tables) — is the most flexible and commonly used in PL/SQL programs.

```sql
TYPE type_name IS TABLE OF value_type INDEX BY key_type;
```

- Key can be `PLS_INTEGER` (numeric) or `VARCHAR2(n)` (string key — like a hash map)
- No size limit, no initialization needed, no constructor call required
- Ideal for lookups, caches, and temporary in-memory tables

**Methods summary for all collections:**

| Method | Description |
|---|---|
| `COUNT` | Number of elements |
| `FIRST` | First index |
| `LAST` | Last index |
| `NEXT(i)` | Index after i |
| `PRIOR(i)` | Index before i |
| `EXISTS(i)` | TRUE if element at index i exists |
| `EXTEND(n)` | Add n empty elements (not for assoc arrays) |
| `DELETE(i)` | Remove element at index i |
| `TRIM(n)` | Remove n elements from end |

### Implement

```sql
DECLARE
   -- Numeric-indexed associative array
   TYPE t_citations_map IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
   v_cit_map t_citations_map;

   -- String-indexed associative array (like a dictionary)
   TYPE t_company_hq IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(50);
   v_hq_map t_company_hq;

   v_idx PLS_INTEGER;
BEGIN
   -- Populate numeric-indexed array
   v_cit_map(1) := 150000;
   v_cit_map(2) := 180000;
   v_cit_map(3) := 45000;

   -- Traverse with FIRST/NEXT
   v_idx := v_cit_map.FIRST;
   WHILE v_idx IS NOT NULL LOOP
      DBMS_OUTPUT.PUT_LINE('Index ' || v_idx || ': ' || v_cit_map(v_idx));
      v_idx := v_cit_map.NEXT(v_idx);
   END LOOP;

   -- String-keyed dictionary
   v_hq_map('Google')    := 'Mountain View';
   v_hq_map('OpenAI')    := 'San Francisco';
   v_hq_map('DeepMind')  := 'London';
   v_hq_map('Anthropic') := 'San Francisco';

   DBMS_OUTPUT.PUT_LINE('OpenAI HQ:    ' || v_hq_map('OpenAI'));
   DBMS_OUTPUT.PUT_LINE('DeepMind HQ:  ' || v_hq_map('DeepMind'));

   -- Check existence before access
   IF v_hq_map.EXISTS('Meta') THEN
      DBMS_OUTPUT.PUT_LINE('Meta HQ: ' || v_hq_map('Meta'));
   ELSE
      DBMS_OUTPUT.PUT_LINE('Meta not in map.');
   END IF;

   DBMS_OUTPUT.PUT_LINE('Total entries: ' || v_hq_map.COUNT);
END;
/
```

✅ **Your turn:**
1. Build an associative array mapping researcher names to their citation counts, then find and print the highest cited researcher
2. Use `DELETE` to remove one entry and print the count before and after

---

# PHASE 5: REUSABLE CODE

## Lesson 12: Procedures

### Learn

A **stored procedure** is a named PL/SQL block saved in the database that can be called repeatedly. It does not return a value directly (use functions for that).

```sql
CREATE [OR REPLACE] PROCEDURE procedure_name (
   param1  [IN | OUT | IN OUT]  datatype,
   param2  [IN | OUT | IN OUT]  datatype
)
IS
   -- local variable declarations
BEGIN
   -- statements
EXCEPTION
   -- error handling
END procedure_name;
/
```

**Parameter modes:**
- `IN` — input only (default), caller passes a value, procedure cannot change it
- `OUT` — procedure writes a value back to the caller
- `IN OUT` — both: caller passes a value AND procedure can modify and return it

Call a procedure with `EXEC` or from another block with `procedure_name(args)`.

### Implement

```sql
-- Simple IN procedure
CREATE OR REPLACE PROCEDURE print_researcher_info (
   p_researcher_id IN researchers.id%TYPE
)
IS
   v_name   researchers.name%TYPE;
   v_field  researchers.field%TYPE;
   v_cit    researchers.citations%TYPE;
BEGIN
   SELECT name, field, citations
   INTO   v_name, v_field, v_cit
   FROM   researchers
   WHERE  id = p_researcher_id;

   DBMS_OUTPUT.PUT_LINE('Name:      ' || v_name);
   DBMS_OUTPUT.PUT_LINE('Field:     ' || v_field);
   DBMS_OUTPUT.PUT_LINE('Citations: ' || v_cit);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No researcher found with ID ' || p_researcher_id);
END print_researcher_info;
/

-- Call it
EXEC print_researcher_info(1);

-- Procedure with OUT parameter
CREATE OR REPLACE PROCEDURE get_company_stats (
   p_company_id    IN  companies.id%TYPE,
   p_researcher_ct OUT NUMBER,
   p_total_cit     OUT NUMBER
)
IS
BEGIN
   SELECT COUNT(*), NVL(SUM(citations), 0)
   INTO   p_researcher_ct, p_total_cit
   FROM   researchers
   WHERE  company_id = p_company_id;
END get_company_stats;
/

-- Call procedure with OUT
DECLARE
   v_count  NUMBER;
   v_total  NUMBER;
BEGIN
   get_company_stats(1, v_count, v_total);
   DBMS_OUTPUT.PUT_LINE('Researchers: ' || v_count);
   DBMS_OUTPUT.PUT_LINE('Total cit:   ' || v_total);
END;
/
```

✅ **Your turn:**
1. Write a procedure `update_citations` that takes a researcher ID and a new citation count and updates the table
2. Write a procedure with an `OUT` parameter that returns the name of the company with the most researchers

---

## Lesson 13: Functions

### Learn

A **function** is like a procedure but it **must return a value** using a `RETURN` statement. Functions can be used inside SQL queries (if they're pure).

```sql
CREATE [OR REPLACE] FUNCTION function_name (
   param1 IN datatype,
   ...
)
RETURN return_datatype
IS
   -- declarations
BEGIN
   -- statements
   RETURN expression;
EXCEPTION
   ...
END function_name;
/
```

**Key differences from procedures:**
- Must have a `RETURN` clause in the header and at least one `RETURN` statement in the body
- Can be called directly in SQL: `SELECT my_func(id) FROM table`
- Should have no side effects if used in SQL (no DML inside)

### Implement

```sql
-- Function: categorize a researcher by citations
CREATE OR REPLACE FUNCTION get_citation_level (
   p_citations IN NUMBER
)
RETURN VARCHAR2
IS
BEGIN
   IF p_citations > 150000 THEN
      RETURN 'Legend';
   ELSIF p_citations > 100000 THEN
      RETURN 'Highly Cited';
   ELSIF p_citations > 50000 THEN
      RETURN 'Well Cited';
   ELSE
      RETURN 'Emerging';
   END IF;
END get_citation_level;
/

-- Use function in a PL/SQL block
BEGIN
   DBMS_OUTPUT.PUT_LINE(get_citation_level(180000));  -- Legend
   DBMS_OUTPUT.PUT_LINE(get_citation_level(45000));   -- Emerging
END;
/

-- Use function directly in SQL query
SELECT name, citations, get_citation_level(citations) AS level
FROM researchers
ORDER BY citations DESC;

-- Function that returns a computed value
CREATE OR REPLACE FUNCTION calc_h_index_estimate (
   p_citations IN NUMBER,
   p_pub_count IN NUMBER
)
RETURN NUMBER
IS
BEGIN
   IF p_pub_count = 0 THEN
      RETURN 0;
   END IF;
   RETURN ROUND(SQRT(p_citations / p_pub_count));
END calc_h_index_estimate;
/

BEGIN
   DBMS_OUTPUT.PUT_LINE('H-index estimate: ' || calc_h_index_estimate(120000, 80));
END;
/
```

✅ **Your turn:**
1. Write a function `years_since_founded` that takes a `founded_year` and returns how many years ago that was
2. Use your function in a SELECT query against the `companies` table

---

## Lesson 14: Packages

### Learn

A **package** bundles related procedures, functions, types, variables, and cursors into a single named unit. It has two parts:

**Package Specification** — the public interface (what callers can see):

```sql
CREATE OR REPLACE PACKAGE package_name IS
   -- public type declarations
   -- public variable declarations
   -- procedure/function signatures (no body)
END package_name;
/
```

**Package Body** — the implementation (private details):

```sql
CREATE OR REPLACE PACKAGE BODY package_name IS
   -- private variables/types only visible inside the body
   -- full procedure/function implementations
END package_name;
/
```

**Benefits:**
- Logical grouping of related code
- Package-level variables persist for the session (like global state)
- Overloading: same name, different parameter signatures
- Improved performance (entire package loaded into memory at first call)

Call with dot notation: `package_name.procedure_name(args)`

### Implement

```sql
-- Package specification
CREATE OR REPLACE PACKAGE researcher_pkg IS
   -- Public constant
   c_max_citations CONSTANT NUMBER := 999999;

   -- Public procedures/functions
   PROCEDURE print_info      (p_id IN NUMBER);
   FUNCTION  get_level       (p_citations IN NUMBER) RETURN VARCHAR2;
   PROCEDURE update_citations(p_id IN NUMBER, p_new_cit IN NUMBER);
END researcher_pkg;
/

-- Package body
CREATE OR REPLACE PACKAGE BODY researcher_pkg IS

   -- Private helper (not in spec → not callable from outside)
   FUNCTION format_name(p_name IN VARCHAR2) RETURN VARCHAR2 IS
   BEGIN
      RETURN INITCAP(TRIM(p_name));
   END format_name;

   -- Public implementations
   PROCEDURE print_info(p_id IN NUMBER) IS
      v_row researchers%ROWTYPE;
   BEGIN
      SELECT * INTO v_row FROM researchers WHERE id = p_id;
      DBMS_OUTPUT.PUT_LINE('Name:  ' || format_name(v_row.name));
      DBMS_OUTPUT.PUT_LINE('Field: ' || v_row.field);
      DBMS_OUTPUT.PUT_LINE('Level: ' || get_level(v_row.citations));
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Researcher not found.');
   END print_info;

   FUNCTION get_level(p_citations IN NUMBER) RETURN VARCHAR2 IS
   BEGIN
      IF p_citations > 150000 THEN RETURN 'Legend';
      ELSIF p_citations > 100000 THEN RETURN 'Highly Cited';
      ELSIF p_citations >  50000 THEN RETURN 'Well Cited';
      ELSE RETURN 'Emerging';
      END IF;
   END get_level;

   PROCEDURE update_citations(p_id IN NUMBER, p_new_cit IN NUMBER) IS
   BEGIN
      UPDATE researchers SET citations = p_new_cit WHERE id = p_id;
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Updated researcher ' || p_id || ' to ' || p_new_cit || ' citations.');
   END update_citations;

END researcher_pkg;
/

-- Call package members
BEGIN
   researcher_pkg.print_info(2);
   researcher_pkg.update_citations(3, 170000);
   DBMS_OUTPUT.PUT_LINE(researcher_pkg.get_level(200000));
END;
/
```

✅ **Your turn:**
1. Create a `company_pkg` package with a procedure to print a company's details and a function returning the number of researchers in a company
2. Add a package-level variable to track how many times `print_info` has been called in the session

---

# PHASE 6: DATABASE INTERACTION

## Lesson 15: Cursors

### Learn

A **cursor** is a pointer to the result set of a SQL query. Use cursors when a query returns multiple rows that you need to process row by row.

**Implicit Cursors** — automatically created by Oracle for every DML statement and single-row SELECT INTO. Accessed via `SQL%ROWCOUNT`, `SQL%FOUND`, `SQL%NOTFOUND`.

**Explicit Cursors** — declared by the programmer for multi-row result sets:

```sql
-- Declare
CURSOR cursor_name IS select_statement;

-- Open → Fetch → Close cycle
OPEN cursor_name;
LOOP
   FETCH cursor_name INTO variable(s);
   EXIT WHEN cursor_name%NOTFOUND;
   -- process row
END LOOP;
CLOSE cursor_name;
```

**Cursor FOR Loop** — the preferred shortcut (Oracle opens, fetches, and closes automatically):

```sql
FOR rec IN cursor_name LOOP
   -- rec.column_name
END LOOP;
```

**Parameterized Cursors:**

```sql
CURSOR c_by_company(p_comp_id NUMBER) IS
   SELECT * FROM researchers WHERE company_id = p_comp_id;
```

### Implement

```sql
DECLARE
   -- Explicit cursor declaration
   CURSOR c_top_researchers IS
      SELECT name, citations, field
      FROM   researchers
      WHERE  citations > 50000
      ORDER  BY citations DESC;

   -- Record to hold each fetched row
   v_rec c_top_researchers%ROWTYPE;

   -- Parameterized cursor
   CURSOR c_by_field(p_field VARCHAR2) IS
      SELECT name, citations
      FROM   researchers
      WHERE  field = p_field;
BEGIN
   -- Method 1: Manual OPEN / FETCH / CLOSE
   DBMS_OUTPUT.PUT_LINE('--- Top Researchers (manual cursor) ---');
   OPEN c_top_researchers;
   LOOP
      FETCH c_top_researchers INTO v_rec;
      EXIT WHEN c_top_researchers%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(v_rec.name || ' | ' || v_rec.citations || ' | ' || v_rec.field);
   END LOOP;
   CLOSE c_top_researchers;

   -- Method 2: Cursor FOR loop (preferred)
   DBMS_OUTPUT.PUT_LINE('--- All Researchers (cursor FOR loop) ---');
   FOR r IN (SELECT name, citations FROM researchers ORDER BY name) LOOP
      DBMS_OUTPUT.PUT_LINE(r.name || ': ' || r.citations);
   END LOOP;

   -- Method 3: Parameterized cursor
   DBMS_OUTPUT.PUT_LINE('--- Deep Learning Researchers ---');
   FOR r IN c_by_field('Deep Learning') LOOP
      DBMS_OUTPUT.PUT_LINE(r.name || ': ' || r.citations);
   END LOOP;

   -- Implicit cursor attributes after DML
   UPDATE researchers SET citations = citations + 1000 WHERE company_id = 2;
   DBMS_OUTPUT.PUT_LINE('Rows updated: ' || SQL%ROWCOUNT);
END;
/
```

✅ **Your turn:**
1. Write a cursor FOR loop that prints all publications with their researcher name (inline query joining two tables)
2. Write a parameterized cursor that accepts a company_id and returns all researchers for that company

---

## Lesson 16: Transactions

### Learn

A **transaction** is a unit of work that is either fully committed or fully rolled back.

**Key commands:**

| Command | Description |
|---|---|
| `COMMIT` | Save all changes permanently |
| `ROLLBACK` | Undo all changes since last COMMIT |
| `SAVEPOINT name` | Create a named rollback point |
| `ROLLBACK TO name` | Roll back to a specific savepoint |

**Transaction rules in PL/SQL:**
- DDL statements (`CREATE`, `DROP`, `ALTER`) auto-commit implicitly
- DML (`INSERT`, `UPDATE`, `DELETE`) is part of the transaction until you COMMIT or ROLLBACK
- An unhandled exception causes an automatic ROLLBACK

**Best practice:** Always explicitly COMMIT or ROLLBACK — never rely on implicit behavior.

### Implement

```sql
DECLARE
   v_new_id  researchers.id%TYPE;
BEGIN
   -- Start of transaction

   -- Insert a new researcher
   INSERT INTO researchers (name, company_id, field, citations, email)
   VALUES ('Yoshua Bengio', 1, 'Deep Learning', 200000, 'yoshua@google.com')
   RETURNING id INTO v_new_id;

   DBMS_OUTPUT.PUT_LINE('Inserted researcher ID: ' || v_new_id);

   -- Create a savepoint before the next DML
   SAVEPOINT after_insert;

   -- Update citations
   UPDATE researchers
   SET    citations = citations + 5000
   WHERE  company_id = 1;
   DBMS_OUTPUT.PUT_LINE('Updated rows: ' || SQL%ROWCOUNT);

   -- Suppose the update was a mistake — roll back to savepoint
   ROLLBACK TO after_insert;
   DBMS_OUTPUT.PUT_LINE('Rolled back the UPDATE, insert is preserved.');

   -- Commit the insert
   COMMIT;
   DBMS_OUTPUT.PUT_LINE('Insert committed.');

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Error — full rollback. ' || SQLERRM);
END;
/
```

✅ **Your turn:**
1. Write a transaction that inserts a new company AND a researcher for that company — if either INSERT fails, roll back both
2. Practice using `SAVEPOINT` to selectively keep some DML and undo other DML

---

## Lesson 17: DBMS Output

### Learn

`DBMS_OUTPUT` is Oracle's built-in package for printing messages to the console. It's the primary debugging and logging tool for PL/SQL.

**Procedures:**

| Procedure | Description |
|---|---|
| `DBMS_OUTPUT.PUT_LINE(msg)` | Print message with newline |
| `DBMS_OUTPUT.PUT(msg)` | Print message without newline |
| `DBMS_OUTPUT.NEW_LINE` | Print a blank line |
| `DBMS_OUTPUT.ENABLE(size)` | Set buffer size (default 20000 bytes) |
| `DBMS_OUTPUT.DISABLE` | Disable output |
| `DBMS_OUTPUT.GET_LINE(line, status)` | Read one line from buffer |

**Enable in your session (run once):**

```sql
SET SERVEROUTPUT ON SIZE UNLIMITED;
```

**Formatting tips:**
- Use `LPAD`/`RPAD` for column alignment
- Use `TO_CHAR` to format numbers and dates for readable output
- Use `CHR(10)` for embedded newlines in strings

### Implement

```sql
-- Enable output first
SET SERVEROUTPUT ON SIZE UNLIMITED;

DECLARE
   v_separator VARCHAR2(50) := RPAD('-', 40, '-');
BEGIN
   -- Basic output
   DBMS_OUTPUT.PUT_LINE('=== Researcher Report ===');
   DBMS_OUTPUT.NEW_LINE;

   -- Formatted table-style output
   DBMS_OUTPUT.PUT_LINE(
      RPAD('Name', 20) || RPAD('Field', 20) || LPAD('Citations', 12)
   );
   DBMS_OUTPUT.PUT_LINE(v_separator);

   FOR r IN (SELECT name, field, citations FROM researchers ORDER BY citations DESC) LOOP
      DBMS_OUTPUT.PUT_LINE(
         RPAD(r.name, 20) ||
         RPAD(NVL(r.field, 'N/A'), 20) ||
         LPAD(TO_CHAR(r.citations, '999,999'), 12)
      );
   END LOOP;

   DBMS_OUTPUT.PUT_LINE(v_separator);

   -- PUT (no newline) + NEW_LINE
   DBMS_OUTPUT.PUT('Report generated: ');
   DBMS_OUTPUT.PUT(TO_CHAR(SYSDATE, 'YYYY-MM-DD'));
   DBMS_OUTPUT.NEW_LINE;
END;
/
```

✅ **Your turn:**
1. Print a formatted company summary showing company name, count of researchers, and total citations in aligned columns
2. Use `DBMS_OUTPUT.PUT` to print a progress bar style output (e.g., `[=====     ] 50%`)

---

# PHASE 7: ADVANCED FEATURES

## Lesson 18: Exception Handling

### Learn

PL/SQL's `EXCEPTION` block catches runtime errors and lets you handle them gracefully instead of crashing.

**Structure:**

```sql
BEGIN
   -- risky code
EXCEPTION
   WHEN exception_name THEN
      -- handle it
   WHEN another_exception THEN
      -- handle it
   WHEN OTHERS THEN
      -- catch-all for anything else
END;
```

**Built-in exceptions (predefined):**

| Exception | Cause |
|---|---|
| `NO_DATA_FOUND` | SELECT INTO returns no rows |
| `TOO_MANY_ROWS` | SELECT INTO returns more than one row |
| `ZERO_DIVIDE` | Division by zero |
| `VALUE_ERROR` | Data type/conversion error |
| `DUP_VAL_ON_INDEX` | Unique constraint violation |
| `INVALID_CURSOR` | Illegal cursor operation |
| `CURSOR_ALREADY_OPEN` | Opening an already open cursor |
| `OTHERS` | Catch-all for any unhandled exception |

**Error info functions:**
- `SQLCODE` — numeric error code (negative for Oracle errors)
- `SQLERRM` — error message string

**User-defined exceptions:**

```sql
DECLARE
   e_too_many_citations EXCEPTION;
   PRAGMA EXCEPTION_INIT(e_too_many_citations, -20001); -- bind to error number
BEGIN
   RAISE e_too_many_citations;   -- trigger it
EXCEPTION
   WHEN e_too_many_citations THEN
      DBMS_OUTPUT.PUT_LINE('Custom error raised!');
END;
/
```

### Implement

```sql
DECLARE
   v_citations  NUMBER;
   e_bad_data   EXCEPTION;
BEGIN
   -- NO_DATA_FOUND
   BEGIN
      SELECT citations INTO v_citations
      FROM   researchers
      WHERE  id = 9999;  -- doesn't exist
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('No researcher with that ID.');
         v_citations := 0;
   END;

   -- TOO_MANY_ROWS
   BEGIN
      SELECT citations INTO v_citations
      FROM   researchers;  -- more than one row returned
   EXCEPTION
      WHEN TOO_MANY_ROWS THEN
         DBMS_OUTPUT.PUT_LINE('Query returned multiple rows — use a cursor instead.');
   END;

   -- ZERO_DIVIDE
   BEGIN
      v_citations := 100 / 0;
   EXCEPTION
      WHEN ZERO_DIVIDE THEN
         DBMS_OUTPUT.PUT_LINE('Cannot divide by zero.');
   END;

   -- User-defined exception
   v_citations := -5;
   BEGIN
      IF v_citations < 0 THEN
         RAISE e_bad_data;
      END IF;
   EXCEPTION
      WHEN e_bad_data THEN
         DBMS_OUTPUT.PUT_LINE('Custom error: citations cannot be negative.');
   END;

   -- OTHERS catch-all with SQLCODE/SQLERRM
   BEGIN
      EXECUTE IMMEDIATE 'SELECT * FROM nonexistent_table';
   EXCEPTION
      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('Unexpected error ' || SQLCODE || ': ' || SQLERRM);
   END;
END;
/
```

✅ **Your turn:**
1. Write a procedure that accepts a researcher ID, raises a user-defined exception if the citation count is above 500,000, and handles it with a descriptive message
2. Use `SQLCODE` and `SQLERRM` in a catch-all handler that logs error details to a table

---

## Lesson 19: Triggers

### Learn

A **trigger** is PL/SQL code that executes automatically in response to a database event.

**Types of triggers:**

| Type | Fires on |
|---|---|
| `BEFORE INSERT` | Before a row is inserted |
| `AFTER INSERT` | After a row is inserted |
| `BEFORE UPDATE` | Before a row is updated |
| `AFTER UPDATE` | After a row is updated |
| `BEFORE DELETE` | Before a row is deleted |
| `AFTER DELETE` | After a row is deleted |
| `INSTEAD OF` | On views — replaces the DML |

**Row-level vs Statement-level:**
- `FOR EACH ROW` — fires once per affected row (most common)
- Without it — fires once per DML statement

**Inside a row trigger:**
- `:NEW.column` — the new value (INSERT/UPDATE)
- `:OLD.column` — the old value (UPDATE/DELETE)

```sql
CREATE OR REPLACE TRIGGER trigger_name
BEFORE | AFTER  INSERT | UPDATE | DELETE
ON table_name
[FOR EACH ROW]
BEGIN
   -- code
END;
/
```

### Implement

```sql
-- Audit table for tracking changes
CREATE TABLE researcher_audit (
   audit_id    NUMBER GENERATED ALWAYS AS IDENTITY,
   action      VARCHAR2(10),
   researcher_id NUMBER,
   old_citations NUMBER,
   new_citations NUMBER,
   changed_at  TIMESTAMP DEFAULT SYSTIMESTAMP,
   changed_by  VARCHAR2(50) DEFAULT USER
);

-- Trigger 1: Auto-uppercase the field column on INSERT/UPDATE
CREATE OR REPLACE TRIGGER trg_format_field
BEFORE INSERT OR UPDATE OF field ON researchers
FOR EACH ROW
BEGIN
   :NEW.field := INITCAP(:NEW.field);
END;
/

-- Trigger 2: Audit citation changes
CREATE OR REPLACE TRIGGER trg_audit_citations
AFTER UPDATE OF citations ON researchers
FOR EACH ROW
BEGIN
   INSERT INTO researcher_audit (action, researcher_id, old_citations, new_citations)
   VALUES ('UPDATE', :OLD.id, :OLD.citations, :NEW.citations);
END;
/

-- Trigger 3: Prevent deletion of highly cited researchers
CREATE OR REPLACE TRIGGER trg_protect_legends
BEFORE DELETE ON researchers
FOR EACH ROW
BEGIN
   IF :OLD.citations > 150000 THEN
      RAISE_APPLICATION_ERROR(-20010,
         'Cannot delete researcher with >150,000 citations: ' || :OLD.name);
   END IF;
END;
/

-- Test the triggers
UPDATE researchers SET citations = 210000 WHERE name = 'Yann LeCun';
SELECT * FROM researcher_audit;
```

✅ **Your turn:**
1. Write a trigger that automatically sets a `last_updated` timestamp column on the `researchers` table whenever a row is updated
2. Write a trigger that prevents inserting a researcher with a duplicate email address (raise an application error with a clear message)

---

## Lesson 20: Object-Oriented PL/SQL

### Learn

Oracle supports object-oriented programming through **Object Types**. You can define custom types with attributes (like class fields) and methods (like class methods).

```sql
-- Create an object type (like a class definition)
CREATE OR REPLACE TYPE type_name AS OBJECT (
   attribute1  datatype,
   attribute2  datatype,
   MEMBER PROCEDURE proc_name,
   MEMBER FUNCTION  func_name RETURN datatype,
   STATIC  FUNCTION static_func RETURN datatype
);
/

-- Create the type body (implementation)
CREATE OR REPLACE TYPE BODY type_name AS
   MEMBER PROCEDURE proc_name IS
   BEGIN
      ...
   END;
   ...
END;
/
```

**Key concepts:**
- `MEMBER` methods receive a `SELF` reference to the object (like `this` in other languages)
- `STATIC` methods belong to the type, not an instance
- Object types can participate in **inheritance** with `UNDER` (subtype)
- `NOT FINAL` allows a type to be subtyped; `NOT INSTANTIABLE` makes it abstract

### Implement

```sql
-- Define a Researcher object type
CREATE OR REPLACE TYPE t_researcher_obj AS OBJECT (
   name         VARCHAR2(100),
   field        VARCHAR2(100),
   citations    NUMBER,

   MEMBER FUNCTION  get_level    RETURN VARCHAR2,
   MEMBER PROCEDURE print_info,
   STATIC FUNCTION  from_id(p_id NUMBER) RETURN t_researcher_obj
)
NOT FINAL;
/

CREATE OR REPLACE TYPE BODY t_researcher_obj AS

   MEMBER FUNCTION get_level RETURN VARCHAR2 IS
   BEGIN
      IF    SELF.citations > 150000 THEN RETURN 'Legend';
      ELSIF SELF.citations > 100000 THEN RETURN 'Highly Cited';
      ELSIF SELF.citations >  50000 THEN RETURN 'Well Cited';
      ELSE                               RETURN 'Emerging';
      END IF;
   END get_level;

   MEMBER PROCEDURE print_info IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE('Name:      ' || SELF.name);
      DBMS_OUTPUT.PUT_LINE('Field:     ' || SELF.field);
      DBMS_OUTPUT.PUT_LINE('Citations: ' || SELF.citations);
      DBMS_OUTPUT.PUT_LINE('Level:     ' || SELF.get_level());
   END print_info;

   STATIC FUNCTION from_id(p_id NUMBER) RETURN t_researcher_obj IS
      v_name  researchers.name%TYPE;
      v_field researchers.field%TYPE;
      v_cit   researchers.citations%TYPE;
   BEGIN
      SELECT name, field, citations
      INTO   v_name, v_field, v_cit
      FROM   researchers
      WHERE  id = p_id;
      RETURN t_researcher_obj(v_name, v_field, v_cit);
   END from_id;

END;
/

-- Use the object type
DECLARE
   v_r1 t_researcher_obj;
   v_r2 t_researcher_obj;
BEGIN
   -- Construct manually
   v_r1 := t_researcher_obj('Andrew Ng', 'Machine Learning', 160000);
   v_r1.print_info;

   DBMS_OUTPUT.PUT_LINE('---');

   -- Construct from DB using static factory
   v_r2 := t_researcher_obj.from_id(2);
   v_r2.print_info;
END;
/
```

**Inheritance example:**

```sql
-- Subtype that extends t_researcher_obj
CREATE OR REPLACE TYPE t_senior_researcher UNDER t_researcher_obj (
   years_experience NUMBER,
   OVERRIDING MEMBER PROCEDURE print_info
);
/
```

✅ **Your turn:**
1. Create a `t_publication_obj` type with attributes for `title`, `year`, and `citations`, plus a method that returns whether it is "Classic" (>10 years old) or "Recent"
2. Create a subtype of `t_researcher_obj` called `t_lead_researcher` with an added `team_size` attribute

---

# COMPLETE PROJECT CHALLENGES

These challenges integrate everything you've learned. Complete them in order for maximum impact.

### Challenge 1: Researcher Ranking Package

```sql
-- Build a complete analytics package
CREATE OR REPLACE PACKAGE analytics_pkg IS
   PROCEDURE print_ranking       (p_top_n IN NUMBER DEFAULT 5);
   FUNCTION  company_avg_cit     (p_company_id IN NUMBER) RETURN NUMBER;
   PROCEDURE field_report;
END analytics_pkg;
/

CREATE OR REPLACE PACKAGE BODY analytics_pkg IS

   PROCEDURE print_ranking(p_top_n IN NUMBER DEFAULT 5) IS
      v_rank NUMBER := 0;
   BEGIN
      DBMS_OUTPUT.PUT_LINE('=== Top ' || p_top_n || ' Researchers ===');
      FOR r IN (
         SELECT r.name, c.name AS company, r.citations
         FROM   researchers r JOIN companies c ON r.company_id = c.id
         ORDER  BY r.citations DESC
         FETCH FIRST p_top_n ROWS ONLY
      ) LOOP
         v_rank := v_rank + 1;
         DBMS_OUTPUT.PUT_LINE(
            LPAD(v_rank,2) || '. ' ||
            RPAD(r.name,22) ||
            RPAD(r.company,15) ||
            TO_CHAR(r.citations,'999,999')
         );
      END LOOP;
   END print_ranking;

   FUNCTION company_avg_cit(p_company_id IN NUMBER) RETURN NUMBER IS
      v_avg NUMBER;
   BEGIN
      SELECT AVG(citations) INTO v_avg FROM researchers WHERE company_id = p_company_id;
      RETURN NVL(ROUND(v_avg), 0);
   END company_avg_cit;

   PROCEDURE field_report IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE('=== Researchers by Field ===');
      FOR f IN (
         SELECT field, COUNT(*) AS cnt, AVG(citations) AS avg_cit
         FROM   researchers
         GROUP  BY field
         ORDER  BY avg_cit DESC
      ) LOOP
         DBMS_OUTPUT.PUT_LINE(
            RPAD(NVL(f.field,'Unknown'),25) ||
            'Count: ' || LPAD(f.cnt,3) ||
            '   Avg cit: ' || TO_CHAR(ROUND(f.avg_cit),'999,999')
         );
      END LOOP;
   END field_report;

END analytics_pkg;
/

-- Run it
EXEC analytics_pkg.print_ranking(3);
EXEC analytics_pkg.field_report;
```

---

### Challenge 2: Audit & Logging System

```sql
-- Full audit trail for all researcher changes
CREATE TABLE researcher_change_log (
   log_id       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   event_time   TIMESTAMP DEFAULT SYSTIMESTAMP,
   event_type   VARCHAR2(10),
   researcher_id NUMBER,
   field_changed VARCHAR2(50),
   old_value    VARCHAR2(200),
   new_value    VARCHAR2(200),
   db_user      VARCHAR2(50) DEFAULT USER
);

CREATE OR REPLACE TRIGGER trg_full_audit
AFTER INSERT OR UPDATE OR DELETE ON researchers
FOR EACH ROW
DECLARE
   v_event VARCHAR2(10);
BEGIN
   IF    INSERTING THEN v_event := 'INSERT';
   ELSIF UPDATING  THEN v_event := 'UPDATE';
   ELSE                 v_event := 'DELETE';
   END IF;

   IF INSERTING THEN
      INSERT INTO researcher_change_log(event_type, researcher_id, field_changed, new_value)
      VALUES (v_event, :NEW.id, 'ALL', :NEW.name || ' | ' || :NEW.field);
   ELSIF UPDATING('citations') THEN
      INSERT INTO researcher_change_log(event_type, researcher_id, field_changed, old_value, new_value)
      VALUES (v_event, :OLD.id, 'citations', :OLD.citations, :NEW.citations);
   ELSIF DELETING THEN
      INSERT INTO researcher_change_log(event_type, researcher_id, field_changed, old_value)
      VALUES (v_event, :OLD.id, 'ALL', :OLD.name);
   END IF;
END;
/
```

---

### Challenge 3: Data Validation Procedure

```sql
-- Procedure that validates and cleans researcher data
CREATE OR REPLACE PROCEDURE clean_researcher_data IS
   v_count    NUMBER := 0;
   v_fixed    NUMBER := 0;
BEGIN
   FOR r IN (SELECT id, name, email, field, citations FROM researchers) LOOP
      v_count := v_count + 1;

      -- Fix null fields
      IF r.field IS NULL THEN
         UPDATE researchers SET field = 'Unspecified' WHERE id = r.id;
         v_fixed := v_fixed + 1;
      END IF;

      -- Normalize field casing
      UPDATE researchers
      SET    field = INITCAP(field), name = INITCAP(TRIM(name))
      WHERE  id = r.id;

      -- Fix negative citations
      IF r.citations < 0 THEN
         UPDATE researchers SET citations = 0 WHERE id = r.id;
         v_fixed := v_fixed + 1;
      END IF;
   END LOOP;

   COMMIT;
   DBMS_OUTPUT.PUT_LINE('Processed: ' || v_count || ' rows, fixed: ' || v_fixed);
END clean_researcher_data;
/

EXEC clean_researcher_data;
```

---

### Challenge 4: Dynamic Report Generator

```sql
-- Procedure using dynamic SQL to generate flexible reports
CREATE OR REPLACE PROCEDURE generate_report (
   p_table     IN VARCHAR2,
   p_where     IN VARCHAR2 DEFAULT NULL,
   p_order_by  IN VARCHAR2 DEFAULT 'id'
)
IS
   v_sql     VARCHAR2(1000);
   v_cursor  SYS_REFCURSOR;
   v_line    VARCHAR2(500);
BEGIN
   v_sql := 'SELECT name, citations FROM ' || DBMS_ASSERT.SIMPLE_SQL_NAME(p_table);
   IF p_where IS NOT NULL THEN
      v_sql := v_sql || ' WHERE ' || p_where;
   END IF;
   v_sql := v_sql || ' ORDER BY ' || p_order_by;

   DBMS_OUTPUT.PUT_LINE('Report SQL: ' || v_sql);
   DBMS_OUTPUT.PUT_LINE(RPAD('-',40,'-'));

   OPEN v_cursor FOR v_sql;
   LOOP
      FETCH v_cursor INTO v_line, v_line;   -- simplified: adjust to real columns
      EXIT WHEN v_cursor%NOTFOUND;
   END LOOP;
   CLOSE v_cursor;
EXCEPTION
   WHEN OTHERS THEN
      IF v_cursor%ISOPEN THEN CLOSE v_cursor; END IF;
      RAISE;
END generate_report;
/
```

---

### Challenge 5: Complete Research Database Summary

```sql
-- Comprehensive summary block tying it all together
DECLARE
   v_total_researchers  NUMBER;
   v_total_companies    NUMBER;
   v_total_publications NUMBER;
   v_top_researcher     researchers.name%TYPE;
   v_top_company        companies.name%TYPE;

   CURSOR c_company_stats IS
      SELECT c.name, COUNT(r.id) AS researchers, NVL(SUM(r.citations),0) AS total_cit
      FROM   companies c LEFT JOIN researchers r ON c.id = r.company_id
      GROUP  BY c.name
      ORDER  BY total_cit DESC;
BEGIN
   SELECT COUNT(*) INTO v_total_researchers  FROM researchers;
   SELECT COUNT(*) INTO v_total_companies    FROM companies;
   SELECT COUNT(*) INTO v_total_publications FROM publications;

   SELECT name INTO v_top_researcher
   FROM   researchers WHERE citations = (SELECT MAX(citations) FROM researchers);

   DBMS_OUTPUT.PUT_LINE('========== DATABASE SUMMARY ==========');
   DBMS_OUTPUT.PUT_LINE('Total researchers:  ' || v_total_researchers);
   DBMS_OUTPUT.PUT_LINE('Total companies:    ' || v_total_companies);
   DBMS_OUTPUT.PUT_LINE('Total publications: ' || v_total_publications);
   DBMS_OUTPUT.PUT_LINE('Top researcher:     ' || v_top_researcher);
   DBMS_OUTPUT.PUT_LINE('');
   DBMS_OUTPUT.PUT_LINE(RPAD('Company',20) || RPAD('Researchers',15) || 'Total Citations');
   DBMS_OUTPUT.PUT_LINE(RPAD('-',50,'-'));

   FOR cs IN c_company_stats LOOP
      DBMS_OUTPUT.PUT_LINE(
         RPAD(cs.name,20) ||
         RPAD(cs.researchers,15) ||
         TO_CHAR(cs.total_cit,'999,999,999')
      );
   END LOOP;

   DBMS_OUTPUT.PUT_LINE('======================================');
END;
/
```

---

## Congratulations! 🎉

You've completed the PL/SQL tutorial from anonymous blocks to object-oriented types. You can now:

✅ Write structured PL/SQL blocks with DECLARE / BEGIN / EXCEPTION / END
✅ Use all scalar data types, records, VARRAYs, nested tables, and associative arrays
✅ Control program flow with IF/CASE/LOOP/WHILE/FOR
✅ Call and write procedures, functions, and packages
✅ Work with explicit and implicit cursors
✅ Manage transactions with COMMIT, ROLLBACK, and SAVEPOINTs
✅ Handle exceptions gracefully with built-in and user-defined exceptions
✅ Create triggers to automate database behavior
✅ Define and instantiate object types with inheritance

**Next Steps:**
- Explore `BULK COLLECT` and `FORALL` for high-performance batch DML
- Learn Dynamic SQL with `EXECUTE IMMEDIATE` and `DBMS_SQL`
- Study Oracle's built-in packages: `DBMS_SCHEDULER`, `UTL_FILE`, `DBMS_CRYPTO`
- Practice query optimization with `EXPLAIN PLAN` and SQL tuning advisor
- Explore Oracle Advanced Queuing for message-driven PL/SQL applications
# DBMS Exercises

SQL and PL/SQL exercises covering core database concepts, from DDL and DML through to PL/SQL programming.

## Exercises

| # | Topic | Concepts Covered |
|---|-------|-----------------|
| [1](exercises/exercise-1.md) | Creating Database Tables | `CREATE TABLE`, `ALTER TABLE`, `DROP`, `TRUNCATE`, `RENAME` |
| [2](exercises/exercise-2.md) | Data Manipulation Language | `INSERT`, `UPDATE`, `DELETE`, `SELECT` |
| [3](exercises/exercise-3.md) | Basic SELECT Statements | Filtering, sorting, `LIKE`, `IN`, `BETWEEN`, `IS NULL`, `DISTINCT` |
| [4](exercises/exercise-4.md) | Integrity Constraints | `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `NOT NULL`, `CHECK`, `DEFAULT` |
| [5](exercises/exercise-5.md) | DCL and TCL | `GRANT`, `REVOKE`, `COMMIT`, `ROLLBACK`, `SAVEPOINT` |
| [6](exercises/exercise-6.md) | SQL Aggregate Functions | `COUNT`, `SUM`, `AVG`, `MAX`, `MIN`, `GROUP BY`, `HAVING` |
| [7](exercises/exercise-7.md) | Joining Tables | `INNER JOIN`, `LEFT JOIN`, `CROSS JOIN`, equi-joins |
| [8](exercises/exercise-8.md) | Sub Queries | Scalar, multi-row, correlated subqueries, `ANY`, `ALL`, `IN` |
| [9](exercises/exercise-9.md) | Views | `CREATE VIEW`, `CREATE OR REPLACE VIEW`, `WITH READ ONLY`, `DROP VIEW` |
| [10](exercises/exercise-10.md) | PL/SQL Conditionals & Loops | `IF/ELSIF/ELSE`, `FOR` loop, `WHILE` loop, substitution variables |
| [11](exercises/exercise-11.md) | PL/SQL Procedures | `CREATE PROCEDURE`, `IN`/`OUT` parameters, `EXECUTE` |
| [12](exercises/exercise-12.md) | PL/SQL Functions | `CREATE FUNCTION`, `RETURN`, recursive functions, `DUAL` |
| [13](exercises/exercise-13.md) | PL/SQL Cursors | Implicit cursors, explicit cursors, `OPEN/FETCH/CLOSE`, cursor attributes |
| [14](exercises/exercise-14.md) | Exception Handling | Predefined exceptions, user-defined exceptions, `RAISE`, `SQLERRM` |
| [15](exercises/exercise-15.md) | PL/SQL Triggers | `BEFORE/AFTER` triggers, `:NEW`/`:OLD`, `INSERTING`/`UPDATING` predicates |

## Schema

Most exercises use the classic Oracle **EMP** and **DEPT** tables:

**DEPT**

| Column | Type         | Description         |
|--------|--------------|---------------------|
| DEPTNO | NUMBER(2)    | Department number (PK) |
| DNAME  | VARCHAR2(14) | Department name     |
| LOC    | VARCHAR2(13) | Location            |

**EMP**

| Column   | Type         | Description              |
|----------|--------------|--------------------------|
| EMPNO    | NUMBER(4)    | Employee number (PK)     |
| ENAME    | VARCHAR2(10) | Employee name            |
| JOB      | VARCHAR2(9)  | Designation              |
| MGR      | NUMBER(4)    | Manager's EMPNO (FK)     |
| HIREDATE | DATE         | Date of joining          |
| SAL      | NUMBER(7,2)  | Monthly salary           |
| COMM     | NUMBER(7,2)  | Commission (NULL = none) |
| DEPTNO   | NUMBER(2)    | Department (FK → DEPT)   |

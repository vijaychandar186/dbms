# MySQL Tutorial - Complete Learning Guide

A comprehensive, step-by-step guide to MySQL with integrated Learn → Implement pairs for every concept.

---

## Table of Contents

### **PHASE 1: Foundations**
- Introduction & Setup

### **PHASE 2: Database & Table Creation**
1. [Lesson 1: Create Database](#lesson-1-create-database) (Learn + Implement)
2. [Lesson 2: Create Tables](#lesson-2-create-tables) (Learn + Implement)
3. [Lesson 3: Table Constraints](#lesson-3-table-constraints) (Learn + Implement)

### **PHASE 3: Data Management**
4. [Lesson 4: Insert Data](#lesson-4-insert-data) (Learn + Implement)
5. [Lesson 5: Update Data](#lesson-5-update-data) (Learn + Implement)
6. [Lesson 6: Delete Data](#lesson-6-delete-data) (Learn + Implement)

### **PHASE 4: Basic Queries**
7. [Lesson 7: SELECT Basics](#lesson-7-select-basics) (Learn + Implement)
8. [Lesson 8: WHERE Filtering](#lesson-8-where-filtering) (Learn + Implement)
9. [Lesson 9: AND, OR, NOT](#lesson-9-and-or-not) (Learn + Implement)

### **PHASE 5: Advanced Filtering**
10. [Lesson 10: LIKE Pattern Matching](#lesson-10-like-pattern-matching) (Learn + Implement)
11. [Lesson 11: IN & BETWEEN](#lesson-11-in--between) (Learn + Implement)

### **PHASE 6: Organizing Results**
12. [Lesson 12: ORDER BY & LIMIT](#lesson-12-order-by--limit) (Learn + Implement)
13. [Lesson 13: Aliases](#lesson-13-aliases) (Learn + Implement)

### **PHASE 7: Aggregate Analysis**
14. [Lesson 14: COUNT, SUM, AVG](#lesson-14-count-sum-avg) (Learn + Implement)
15. [Lesson 15: MIN & MAX](#lesson-15-min--max) (Learn + Implement)
16. [Lesson 16: GROUP BY](#lesson-16-group-by) (Learn + Implement)
17. [Lesson 17: HAVING](#lesson-17-having) (Learn + Implement)

### **PHASE 8: Table Relationships**
18. [Lesson 18: INNER JOIN](#lesson-18-inner-join) (Learn + Implement)
19. [Lesson 19: LEFT JOIN](#lesson-19-left-join) (Learn + Implement)
20. [Lesson 20: Complex Joins](#lesson-20-complex-joins) (Learn + Implement)

### **PHASE 9: Advanced Queries**
21. [Lesson 21: UNION](#lesson-21-union) (Learn + Implement)
22. [Lesson 22: CASE Statements](#lesson-22-case-statements) (Learn + Implement)
23. [Lesson 23: EXISTS](#lesson-23-exists) (Learn + Implement)

### **PHASE 10: Advanced Features**
24. [Lesson 24: Views](#lesson-24-views) (Learn + Implement)
25. [Lesson 25: Stored Procedures](#lesson-25-stored-procedures) (Learn + Implement)

### **PHASE 11: Capstone Project**
- [Complete Project Challenges](#complete-project-challenges)

---

## FOUNDATIONS

### MySQL HOME

Welcome to the MySQL Tutorial! This guide will teach you MySQL, one of the most popular relational database management systems. Whether you're storing research data, model metadata, or user interactions for your applications, MySQL provides a robust foundation.

### MySQL Intro

MySQL is an open-source relational database management system (RDBMS) that uses Structured Query Language (SQL). It's widely used in web applications, data science, and machine learning workflows for storing and retrieving data efficiently.

### MySQL RDBMS

RDBMS stands for Relational Database Management System. MySQL is a relational database that organizes data into tables with relationships between them.

**Key concepts:**
- **Tables**: Collections of related data (e.g., researchers, models, companies)
- **Rows**: Individual records
- **Columns**: Data attributes
- **Relationships**: Connections between tables (e.g., a researcher works for a company)

### MySQL SQL

SQL (Structured Query Language) is the standard language for interacting with relational databases.

### MySQL Comments & Operators

**Comments:** `--` for single line, `/* */` for multi-line.

**Operators:**
- Arithmetic: `+`, `-`, `*`, `/`
- Comparison: `=`, `!=`, `<>`, `<`, `>`, `<=`, `>=`
- Logical: `AND`, `OR`, `NOT`

---

# PHASE 2: DATABASE & TABLE CREATION

## Lesson 1: Create Database

### Learn

A database is a container for all your tables and data. Before you can create tables, you must first create a database.

**Syntax:**
```sql
CREATE DATABASE database_name;
```

**Example:**
```sql
CREATE DATABASE deep_learning_research;
```

### Implement

Create your first database:

```sql
-- Create the database
CREATE DATABASE ai_research;

-- Verify it was created (optional, in MySQL client)
SHOW DATABASES;
```

✅ **Your turn:** Create a database called `my_first_db`

---

## Lesson 2: Create Tables

### Learn

Tables hold your actual data. Each table has columns (fields) with specific data types.

**Syntax:**
```sql
CREATE TABLE table_name (
    column1 datatype constraints,
    column2 datatype constraints,
    ...
);
```

**Common Data Types:**
- `INT` - Integer numbers
- `VARCHAR(100)` - Text strings up to 100 characters
- `DECIMAL(5,4)` - Decimal numbers
- `DATE` - Date values
- `BOOLEAN` - True/False values

### Implement

Create the complete schema for tracking AI researchers:

```sql
-- Create companies table
CREATE TABLE companies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    founded_year INT,
    headquarters VARCHAR(100)
);

-- Create researchers table
CREATE TABLE researchers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    company_id INT,
    field VARCHAR(100),
    citations INT DEFAULT 0,
    email VARCHAR(100)
);

-- Create publications table
CREATE TABLE publications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    researcher_id INT,
    year INT,
    citations INT DEFAULT 0
);
```

✅ **Your turn:** Create a table called `projects` with columns: id, name, and description

---

## Lesson 3: Table Constraints

### Learn

Constraints are rules that enforce data integrity. Key constraints:

- **PRIMARY KEY** - Uniquely identifies each record
- **FOREIGN KEY** - Links tables together using relationships
- **NOT NULL** - Column must have a value
- **UNIQUE** - All values must be different
- **DEFAULT** - Provides a default value
- **CHECK** - Enforces a condition

### Implement

Add constraints to enforce relationships between tables:

```sql
-- Add relationships between tables
ALTER TABLE researchers 
ADD FOREIGN KEY (company_id) REFERENCES companies(id);

ALTER TABLE publications 
ADD FOREIGN KEY (researcher_id) REFERENCES researchers(id);

-- Add unique email constraint
ALTER TABLE researchers 
ADD UNIQUE (email);

-- Add not null constraint on field
ALTER TABLE researchers 
MODIFY field VARCHAR(100) NOT NULL;
```

✅ **Your turn:** 
1. Create a PROJECTS table with a FOREIGN KEY linking to researchers
2. Add a UNIQUE constraint on project_name

---

# PHASE 3: DATA MANAGEMENT

## Lesson 4: Insert Data

### Learn

The `INSERT` statement adds new records to a table.

**Syntax:**
```sql
INSERT INTO table_name (column1, column2, ...)
VALUES (value1, value2, ...);
```

### Implement

Insert sample data into your tables:

```sql
-- Insert companies
INSERT INTO companies (name, founded_year, headquarters) VALUES
('Google', 1998, 'Mountain View'),
('OpenAI', 2015, 'San Francisco'),
('DeepMind', 2010, 'London'),
('Meta', 2004, 'Menlo Park'),
('Anthropic', 2021, 'San Francisco');

-- Insert researchers
INSERT INTO researchers (name, company_id, field, citations, email) VALUES
('Yann LeCun', 1, 'Deep Learning', 150000, 'yann@google.com'),
('Geoffrey Hinton', 1, 'Neural Networks', 180000, 'hinton@google.com'),
('Andrew Ng', 1, 'Machine Learning', 160000, 'andrew@google.com'),
('Ilya Sutskever', 2, 'AI Safety', 45000, 'ilya@openai.com'),
('Demis Hassabis', 3, 'Reinforcement Learning', 55000, 'demis@deepmind.com');

-- Insert publications
INSERT INTO publications (title, researcher_id, year, citations) VALUES
('ConvNets Explained', 1, 2015, 50000),
('Deep Neural Networks', 2, 2012, 60000),
('Machine Learning Basics', 3, 2016, 55000),
('Scaling Language Models', 4, 2020, 25000),
('AlphaGo Algorithm', 5, 2016, 40000);
```

✅ **Your turn:** Insert 3 new researchers into the database

---

## Lesson 5: Update Data

### Learn

The `UPDATE` statement modifies existing records.

**Syntax:**
```sql
UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE condition;
```

⚠️ **Important:** Always use a WHERE clause to specify which records to update!

### Implement

Practice updating records:

```sql
-- Update a single researcher's citations
UPDATE researchers 
SET citations = 200000 
WHERE name = 'Yann LeCun';

-- Update multiple columns
UPDATE researchers 
SET field = 'Computer Vision', citations = 155000 
WHERE name = 'Geoffrey Hinton';

-- Update based on company
UPDATE researchers 
SET citations = citations + 10000 
WHERE company_id = 1;
```

✅ **Your turn:** 
1. Update a researcher's email address
2. Increase all citations by 5000 for researchers in a specific company

---

## Lesson 6: Delete Data

### Learn

The `DELETE` statement removes records from a table.

**Syntax:**
```sql
DELETE FROM table_name
WHERE condition;
```

⚠️ **WARNING:** Always use a WHERE clause! Without it, you delete ALL records!

### Implement

Practice deleting records:

```sql
-- Delete a specific researcher (if they don't match our criteria)
DELETE FROM researchers 
WHERE name = 'Test Researcher';

-- Delete researchers with very low citations
DELETE FROM researchers 
WHERE citations < 1000;
```

✅ **Your turn:** Delete a researcher from the database (make sure you have data backed up!)

---

# PHASE 4: BASIC QUERIES

## Lesson 7: SELECT Basics

### Learn

The `SELECT` statement retrieves data from tables. This is the most important command!

**Syntax:**
```sql
SELECT column1, column2, ...
FROM table_name;
```

Use `*` to select all columns, or specify exact columns.

### Implement

Try these SELECT queries on your data:

```sql
-- Get all researchers and all columns
SELECT * FROM researchers;

-- Get only names and citations
SELECT name, citations FROM researchers;

-- Get company names
SELECT name FROM companies;

-- Get publication titles and years
SELECT title, year FROM publications;
```

✅ **Your turn:** 
1. Select all names from the researchers table
2. Select all publications with year and title only

---

## Lesson 8: WHERE Filtering

### Learn

The `WHERE` clause filters records based on conditions.

**Syntax:**
```sql
SELECT column1, column2, ...
FROM table_name
WHERE condition;
```

### Implement

Filter your data with WHERE:

```sql
-- Find researchers from a specific company
SELECT name, field FROM researchers WHERE company_id = 1;

-- Find highly cited researchers
SELECT name, citations FROM researchers WHERE citations > 100000;

-- Find publications from a specific year
SELECT title FROM publications WHERE year = 2015;

-- Find researchers in a specific field
SELECT name FROM researchers WHERE field = 'Deep Learning';
```

✅ **Your turn:** 
1. Find all researchers with more than 50,000 citations
2. Find all publications from the year 2016

---

## Lesson 9: AND, OR, NOT

### Learn

Combine multiple conditions using logical operators.

- `AND` - Both conditions must be true
- `OR` - Either condition can be true
- `NOT` - Reverse the condition

### Implement

Combine conditions in your queries:

```sql
-- AND example: researchers from Google in Deep Learning
SELECT name FROM researchers 
WHERE company_id = 1 AND field = 'Deep Learning';

-- OR example: researchers from Google OR OpenAI
SELECT name FROM researchers 
WHERE company_id = 1 OR company_id = 2;

-- NOT example: researchers NOT from Google
SELECT name FROM researchers 
WHERE NOT company_id = 1;

-- Complex: high citations AND from Google
SELECT name, citations FROM researchers 
WHERE citations > 100000 AND company_id = 1;
```

✅ **Your turn:** 
1. Find researchers with more than 100,000 citations OR from DeepMind
2. Find researchers NOT in AI Safety field

---

# PHASE 5: ADVANCED FILTERING

## Lesson 10: LIKE Pattern Matching

### Learn

The `LIKE` operator searches for text patterns using wildcards.

- `%` = any number of characters
- `_` = exactly one character

### Implement

Search for patterns:

```sql
-- Find names starting with 'Y'
SELECT name FROM researchers WHERE name LIKE 'Y%';

-- Find fields containing 'Learning'
SELECT name, field FROM researchers WHERE field LIKE '%Learning%';

-- Find titles with 'Neural' anywhere
SELECT title FROM publications WHERE title LIKE '%Neural%';

-- Find names with exactly one character after 'G'
SELECT name FROM researchers WHERE name LIKE 'G_nneth';
```

✅ **Your turn:** 
1. Find all researchers whose name starts with 'D'
2. Find publications with 'Deep' in the title

---

## Lesson 11: IN & BETWEEN

### Learn

- `IN` - Matches any value in a list
- `BETWEEN` - Matches values within a range

### Implement

Filter using IN and BETWEEN:

```sql
-- IN example: find researchers from specific companies
SELECT name FROM researchers 
WHERE company_id IN (1, 2, 3);

-- IN with names
SELECT * FROM researchers 
WHERE name IN ('Yann LeCun', 'Geoffrey Hinton', 'Andrew Ng');

-- BETWEEN for citations range
SELECT name, citations FROM researchers 
WHERE citations BETWEEN 50000 AND 150000;

-- BETWEEN for years
SELECT title, year FROM publications 
WHERE year BETWEEN 2015 AND 2020;
```

✅ **Your turn:** 
1. Find researchers with citations between 40,000 and 60,000
2. Find publications from years 2010-2015

---

# PHASE 6: ORGANIZING RESULTS

## Lesson 12: ORDER BY & LIMIT

### Learn

- `ORDER BY` - Sorts results (ASC = ascending, DESC = descending)
- `LIMIT` - Restricts number of rows returned

### Implement

Sort and limit your results:

```sql
-- Sort by name A-Z
SELECT name, citations FROM researchers ORDER BY name ASC;

-- Sort by citations highest to lowest
SELECT name, citations FROM researchers ORDER BY citations DESC;

-- Get top 3 researchers by citations
SELECT name, citations FROM researchers 
ORDER BY citations DESC LIMIT 3;

-- Get bottom 2 lowest cited researchers
SELECT name, citations FROM researchers 
ORDER BY citations ASC LIMIT 2;

-- Skip first 2 rows and get next 2
SELECT name FROM researchers 
ORDER BY citations DESC 
LIMIT 2 OFFSET 2;
```

✅ **Your turn:** 
1. Sort researchers by name Z-A
2. Get the top 5 highest cited researchers
3. Get researchers ranked 3-5 by citations

---

## Lesson 13: Aliases

### Learn

Aliases give temporary names to columns or tables for readability.

**Syntax:**
```sql
SELECT column AS alias_name FROM table_name;
SELECT * FROM table_name AS t1;
```

### Implement

Use aliases to improve readability:

```sql
-- Column aliases
SELECT 
    name AS researcher_name, 
    citations AS total_citations,
    field AS specialty
FROM researchers;

-- Table aliases (useful for joins later)
SELECT 
    r.name, 
    r.field
FROM researchers AS r;

-- Aliases in WHERE clause
SELECT 
    name AS researcher_name,
    citations AS citation_count
FROM researchers 
WHERE citations > 100000
ORDER BY citation_count DESC;
```

✅ **Your turn:** 
1. Alias company names and headquarters for readability
2. Create aliases for publications showing title, researcher, and citations

---

# PHASE 7: AGGREGATE ANALYSIS

## Lesson 14: COUNT, SUM, AVG

### Learn

Aggregate functions process multiple rows and return a single value:

- `COUNT()` - Count number of records
- `SUM()` - Add up values
- `AVG()` - Calculate average

### Implement

Analyze your data:

```sql
-- Count total researchers
SELECT COUNT(*) as total_researchers FROM researchers;

-- Count researchers in each field
SELECT COUNT(*) FROM researchers;

-- Sum all citations
SELECT SUM(citations) as total_citations FROM researchers;

-- Average citations
SELECT AVG(citations) as avg_citations FROM researchers;

-- Average citations for publications
SELECT AVG(citations) as avg_publication_citations FROM publications;
```

✅ **Your turn:** 
1. Count total publications
2. Calculate total citations across all researchers
3. Find average citations per researcher

---

## Lesson 15: MIN & MAX

### Learn

- `MIN()` - Find smallest value
- `MAX()` - Find largest value

### Implement

Find extremes in your data:

```sql
-- Highest citations
SELECT MAX(citations) as highest_citations FROM researchers;

-- Lowest citations
SELECT MIN(citations) as lowest_citations FROM researchers;

-- Earliest and latest publication years
SELECT 
    MIN(year) as earliest, 
    MAX(year) as latest 
FROM publications;

-- Publication with most citations
SELECT MAX(citations) FROM publications;
```

✅ **Your turn:** 
1. Find the researcher with minimum citations
2. Find the year range of all publications

---

## Lesson 16: GROUP BY

### Learn

`GROUP BY` groups rows with the same values and runs aggregates on each group.

**Syntax:**
```sql
SELECT column, aggregate_function(column)
FROM table_name
GROUP BY column;
```

### Implement

Group and analyze your data:

```sql
-- Count researchers by company
SELECT 
    company_id, 
    COUNT(*) as researcher_count 
FROM researchers 
GROUP BY company_id;

-- Average citations by field
SELECT 
    field, 
    AVG(citations) as avg_citations 
FROM researchers 
GROUP BY field;

-- Publications by year
SELECT 
    year, 
    COUNT(*) as publication_count 
FROM publications 
GROUP BY year;
```

✅ **Your turn:** 
1. Group researchers by field and count them
2. Calculate average citations grouped by company

---

## Lesson 17: HAVING

### Learn

`HAVING` filters groups (like WHERE but for grouped data).

**Syntax:**
```sql
SELECT column, aggregate_function(column)
FROM table_name
GROUP BY column
HAVING group_condition;
```

### Implement

Filter groups:

```sql
-- Find companies with more than 1 researcher
SELECT 
    company_id, 
    COUNT(*) as count 
FROM researchers 
GROUP BY company_id 
HAVING COUNT(*) > 1;

-- Find fields with average citations > 50000
SELECT 
    field, 
    AVG(citations) as avg 
FROM researchers 
GROUP BY field 
HAVING AVG(citations) > 50000;

-- Find years with multiple publications
SELECT 
    year, 
    COUNT(*) as pub_count 
FROM publications 
GROUP BY year 
HAVING COUNT(*) > 1;
```

✅ **Your turn:** 
1. Find fields with more than 1 researcher
2. Find companies where average researcher citations > 100,000

---

# PHASE 8: TABLE RELATIONSHIPS

## Lesson 18: INNER JOIN

### Learn

`INNER JOIN` combines data from two tables where there's a match in both.

**Syntax:**
```sql
SELECT columns
FROM table1
INNER JOIN table2 ON table1.key = table2.key;
```

### Implement

Connect data from multiple tables:

```sql
-- Get researcher names with company names
SELECT 
    r.name as researcher, 
    c.name as company
FROM researchers r
INNER JOIN companies c ON r.company_id = c.id;

-- Get publications with researcher names
SELECT 
    p.title, 
    r.name as researcher
FROM publications p
INNER JOIN researchers r ON p.researcher_id = r.id;

-- Three-table join
SELECT 
    p.title,
    r.name as researcher,
    c.name as company
FROM publications p
INNER JOIN researchers r ON p.researcher_id = r.id
INNER JOIN companies c ON r.company_id = c.id;
```

✅ **Your turn:** 
1. Join researchers with companies and show field
2. Join publications with researchers showing year and citations

---

## Lesson 19: LEFT JOIN

### Learn

`LEFT JOIN` returns all rows from the left table, even if no match exists in the right table.

**Syntax:**
```sql
SELECT columns
FROM table1
LEFT JOIN table2 ON table1.key = table2.key;
```

### Implement

Find unmatched records and relationships:

```sql
-- Get all researchers with their publication count (if any)
SELECT 
    r.name, 
    COUNT(p.id) as publication_count
FROM researchers r
LEFT JOIN publications p ON r.id = p.researcher_id
GROUP BY r.name;

-- Find researchers with NO publications
SELECT r.name
FROM researchers r
LEFT JOIN publications p ON r.id = p.researcher_id
WHERE p.id IS NULL;

-- All companies and count of researchers
SELECT 
    c.name as company, 
    COUNT(r.id) as researcher_count
FROM companies c
LEFT JOIN researchers r ON c.id = r.company_id
GROUP BY c.name;
```

✅ **Your turn:** 
1. Find researchers and count their publications (use GROUP BY)
2. Find companies with no researchers

---

## Lesson 20: Complex Joins

### Learn

Combine multiple joins with WHERE and other operations.

### Implement

Advanced joining scenarios:

```sql
-- Get all publications from Google researchers
SELECT 
    p.title,
    r.name as researcher,
    c.name as company
FROM publications p
INNER JOIN researchers r ON p.researcher_id = r.id
INNER JOIN companies c ON r.company_id = c.id
WHERE c.name = 'Google';

-- Researchers with publication count, ordered
SELECT 
    r.name,
    c.name as company,
    COUNT(p.id) as publications
FROM researchers r
LEFT JOIN companies c ON r.company_id = c.id
LEFT JOIN publications p ON r.id = p.researcher_id
GROUP BY r.id, r.name, c.name
ORDER BY publications DESC;
```

✅ **Your turn:** 
1. Find researchers from OpenAI with their publications
2. Count publications by company

---

# PHASE 9: ADVANCED QUERIES

## Lesson 21: UNION

### Learn

`UNION` combines results from multiple SELECT statements.

**Syntax:**
```sql
SELECT column FROM table1
UNION
SELECT column FROM table2;
```

### Implement

Combine different data sets:

```sql
-- Combine researcher and company names
SELECT name, 'Researcher' as type FROM researchers
UNION
SELECT name, 'Company' as type FROM companies;

-- All fields and company headquarters
SELECT field FROM researchers
UNION
SELECT headquarters FROM companies;
```

✅ **Your turn:** Combine publication titles and company names using UNION

---

## Lesson 22: CASE Statements

### Learn

`CASE` adds conditional logic to queries.

**Syntax:**
```sql
SELECT 
    column,
    CASE 
        WHEN condition1 THEN result1
        WHEN condition2 THEN result2
        ELSE result3
    END AS new_column
FROM table_name;
```

### Implement

Categorize data with CASE:

```sql
-- Categorize researchers by impact
SELECT 
    name,
    citations,
    CASE 
        WHEN citations > 100000 THEN 'Highly Cited'
        WHEN citations > 50000 THEN 'Well Cited'
        WHEN citations > 10000 THEN 'Notable'
        ELSE 'Emerging'
    END AS citation_level
FROM researchers
ORDER BY citations DESC;

-- Categorize by field
SELECT 
    name,
    field,
    CASE 
        WHEN field = 'Deep Learning' THEN 'Vision & Recognition'
        WHEN field = 'AI Safety' THEN 'Safety & Ethics'
        ELSE 'Other Specialties'
    END AS category
FROM researchers;
```

✅ **Your turn:** Create a CASE statement that categorizes publication years as "Older", "Recent", or "New"

---

## Lesson 23: EXISTS

### Learn

`EXISTS` checks if a sub-query returns any rows.

**Syntax:**
```sql
SELECT ...
WHERE EXISTS (SELECT ... WHERE ...)
```

### Implement

Check for relationships:

```sql
-- Find researchers who HAVE publications
SELECT name FROM researchers r
WHERE EXISTS (
    SELECT 1 FROM publications p 
    WHERE p.researcher_id = r.id
);

-- Find researchers with NO publications
SELECT name FROM researchers r
WHERE NOT EXISTS (
    SELECT 1 FROM publications p 
    WHERE p.researcher_id = r.id
);

-- Find companies with researchers
SELECT name FROM companies c
WHERE EXISTS (
    SELECT 1 FROM researchers r 
    WHERE r.company_id = c.id
);
```

✅ **Your turn:** Find researchers that DON'T have any publications

---

# PHASE 10: ADVANCED FEATURES

## Lesson 24: Views

### Learn

A `VIEW` is a saved query that works like a table.

**Syntax:**
```sql
CREATE VIEW view_name AS
SELECT ... FROM ...;
```

### Implement

Create reusable views:

```sql
-- View of high-impact researchers
CREATE VIEW top_researchers AS
SELECT 
    r.name,
    c.name as company,
    r.citations
FROM researchers r
LEFT JOIN companies c ON r.company_id = c.id
WHERE r.citations > 100000;

-- Query the view
SELECT * FROM top_researchers;

-- View of publications with full details
CREATE VIEW publication_details AS
SELECT 
    p.title,
    r.name as researcher,
    c.name as company,
    p.year,
    p.citations
FROM publications p
INNER JOIN researchers r ON p.researcher_id = r.id
INNER JOIN companies c ON r.company_id = c.id;

-- Query the view
SELECT * FROM publication_details WHERE year > 2015;
```

✅ **Your turn:** 
1. Create a view showing researchers by field
2. Create a view showing company statistics

---

## Lesson 25: Stored Procedures

### Learn

A stored procedure is reusable SQL code saved in the database.

**Syntax:**
```sql
CREATE PROCEDURE procedure_name() 
BEGIN
  -- SQL statements here
END;

-- Call it
CALL procedure_name();
```

### Implement

Create procedures to automate tasks:

```sql
-- Simple procedure to get all researchers
DELIMITER //
CREATE PROCEDURE GetAllResearchers()
BEGIN
    SELECT * FROM researchers;
END //
DELIMITER ;

-- Call it
CALL GetAllResearchers();

-- Procedure with parameter
DELIMITER //
CREATE PROCEDURE GetResearchersByCompany(IN comp_id INT)
BEGIN
    SELECT name, field, citations FROM researchers 
    WHERE company_id = comp_id;
END //
DELIMITER ;

-- Call with parameter
CALL GetResearchersByCompany(1);
```

✅ **Your turn:** Create a procedure that shows researchers by field

---

# COMPLETE PROJECT CHALLENGES

These challenges bring together everything you've learned. Complete them in order:

### Challenge 1: Research Team Report
```sql
-- Show all researchers with their company, field, and publication count
SELECT 
    r.name as researcher,
    c.name as company,
    r.field,
    COUNT(p.id) as publications,
    r.citations
FROM researchers r
LEFT JOIN companies c ON r.company_id = c.id
LEFT JOIN publications p ON r.id = p.researcher_id
GROUP BY r.id, r.name, c.name, r.field, r.citations
ORDER BY r.citations DESC;
```

### Challenge 2: Company Impact Analysis
```sql
-- Find the company with the most total citations
SELECT 
    c.name as company,
    COUNT(r.id) as researchers,
    SUM(r.citations) as total_citations,
    AVG(r.citations) as avg_citations
FROM companies c
LEFT JOIN researchers r ON c.id = r.company_id
GROUP BY c.id, c.name
ORDER BY total_citations DESC;
```

### Challenge 3: Publication Timeline
```sql
-- Show publications by year with researcher and company info
SELECT 
    p.year,
    COUNT(p.id) as publications,
    MAX(p.citations) as max_citations,
    AVG(p.citations) as avg_citations
FROM publications p
GROUP BY p.year
ORDER BY p.year DESC;
```

### Challenge 4: Research Field Analysis
```sql
-- Find which field has the most researchers and highest impact
SELECT 
    r.field,
    COUNT(r.id) as researcher_count,
    AVG(r.citations) as avg_citations,
    MAX(r.citations) as top_citations
FROM researchers r
GROUP BY r.field
HAVING COUNT(r.id) > 1
ORDER BY avg_citations DESC;
```

### Challenge 5: Complex Multi-Table Report
```sql
-- Show each researcher with company, publications, and impact category
SELECT 
    r.name as researcher,
    c.name as company,
    COUNT(p.id) as total_publications,
    r.citations,
    CASE 
        WHEN r.citations > 100000 THEN 'Top Tier'
        WHEN r.citations > 50000 THEN 'High Impact'
        ELSE 'Growing'
    END as impact_level
FROM researchers r
LEFT JOIN companies c ON r.company_id = c.id
LEFT JOIN publications p ON r.id = p.researcher_id
GROUP BY r.id, r.name, c.name, r.citations
ORDER BY r.citations DESC;
```

---

## Congratulations! 🎉

You've learned MySQL from creating databases to complex multi-table queries. You can now:

✅ Create databases and tables with proper relationships
✅ Insert, update, and delete data
✅ Query data with SELECT and advanced filtering
✅ Join multiple tables together
✅ Analyze data with aggregates and grouping
✅ Create views and stored procedures
✅ Build complex reporting queries

**Next Steps:**
- Practice with your own datasets
- Optimize queries with indexes
- Learn advanced database administration
- Explore MySQL frameworks and tools
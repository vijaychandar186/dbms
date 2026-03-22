# Exercise 7 — Joining Tables

## Setup — Create and Populate Tables

### Customer1 Table

| customer_id | cust_name      | city       | grade | salesman_id |
|-------------|----------------|------------|-------|-------------|
| 3001        | Brad Guzan     | London     | NULL  | 5005        |
| 3002        | Nick Rimando   | New York   | 100   | 5001        |
| 3003        | Jozy Altidor   | Moscow     | 200   | 5007        |
| 3004        | Fabian Johnson | Paris      | 300   | 5006        |
| 3005        | Graham Zusi    | California | 200   | 5002        |
| 3007        | Brad Davis     | New York   | 200   | 5001        |
| 3008        | Julian Green   | London     | 300   | 5002        |
| 3009        | Geoff Cameron  | Berlin     | 100   | 5003        |

### Salesman1 Table

| salesman_id | name       | city      | commission |
|-------------|------------|-----------|------------|
| 5001        | James Hoog | New York  | 0.15       |
| 5002        | Nail Knite | Paris     | 0.13       |
| 5003        | Lauson Hen | San Jose  | 0.12       |
| 5005        | Pit Alex   | London    | 0.11       |
| 5006        | Mc Lyon    | Paris     | 0.14       |
| 5007        | Paul Adam  | Rome      | 0.13       |

### Order1 Table

| ord_no | purch_amt | ord_date   | customer_id | salesman_id |
|--------|-----------|------------|-------------|-------------|
| 70001  | 150.50    | 2012-10-05 | 3005        | 5002        |
| 70002  | 65.26     | 2012-10-05 | 3002        | 5001        |
| 70003  | 2480.40   | 2012-10-10 | 3009        | 5003        |
| 70004  | 110.50    | 2012-08-17 | 3009        | 5003        |
| 70005  | 2400.60   | 2012-07-27 | 3007        | 5001        |
| 70007  | 948.50    | 2012-09-10 | 3005        | 5002        |
| 70008  | 5760.00   | 2012-09-10 | 3002        | 5001        |
| 70009  | 270.65    | 2012-09-10 | 3001        | 5005        |
| 70010  | 1983.43   | 2012-10-10 | 3004        | 5006        |
| 70011  | 75.29     | 2012-08-17 | 3003        | 5007        |
| 70012  | 250.45    | 2012-06-27 | 3008        | 5002        |
| 70013  | 3045.60   | 2012-04-25 | 3002        | 5001        |

```sql
CREATE TABLE Customer1 (
    customer_id INT,
    cust_name   VARCHAR2(50),
    city        VARCHAR2(50),
    grade       INT,
    salesman_id INT
);

INSERT INTO Customer1 VALUES (3002, 'Nick Rimando',   'New York',   100, 5001);
INSERT INTO Customer1 VALUES (3007, 'Brad Davis',     'New York',   200, 5001);
INSERT INTO Customer1 VALUES (3005, 'Graham Zusi',    'California', 200, 5002);
INSERT INTO Customer1 VALUES (3008, 'Julian Green',   'London',     300, 5002);
INSERT INTO Customer1 VALUES (3004, 'Fabian Johnson', 'Paris',      300, 5006);
INSERT INTO Customer1 VALUES (3009, 'Geoff Cameron',  'Berlin',     100, 5003);
INSERT INTO Customer1 VALUES (3003, 'Jozy Altidor',   'Moscow',     200, 5007);
INSERT INTO Customer1 VALUES (3001, 'Brad Guzan',     'London',     NULL,5005);

CREATE TABLE Salesman1 (
    salesman_id INT,
    name        VARCHAR2(50),
    city        VARCHAR2(50),
    commission  DECIMAL(4,2)
);

INSERT INTO Salesman1 VALUES (5001, 'James Hoog', 'New York', 0.15);
INSERT INTO Salesman1 VALUES (5002, 'Nail Knite', 'Paris',    0.13);
INSERT INTO Salesman1 VALUES (5005, 'Pit Alex',   'London',   0.11);
INSERT INTO Salesman1 VALUES (5006, 'Mc Lyon',    'Paris',    0.14);
INSERT INTO Salesman1 VALUES (5007, 'Paul Adam',  'Rome',     0.13);
INSERT INTO Salesman1 VALUES (5003, 'Lauson Hen', 'San Jose', 0.12);

CREATE TABLE Order1 (
    ord_no      INT,
    purch_amt   DECIMAL(8,2),
    ord_date    DATE,
    customer_id INT,
    salesman_id INT
);

ALTER SESSION SET nls_date_format = 'YYYY-MM-DD';

INSERT INTO Order1 VALUES (70001, 150.50,  '2012-10-05', 3005, 5002);
INSERT INTO Order1 VALUES (70009, 270.65,  '2012-09-10', 3001, 5005);
INSERT INTO Order1 VALUES (70002, 65.26,   '2012-10-05', 3002, 5001);
INSERT INTO Order1 VALUES (70004, 110.50,  '2012-08-17', 3009, 5003);
INSERT INTO Order1 VALUES (70007, 948.50,  '2012-09-10', 3005, 5002);
INSERT INTO Order1 VALUES (70005, 2400.60, '2012-07-27', 3007, 5001);
INSERT INTO Order1 VALUES (70008, 5760.00, '2012-09-10', 3002, 5001);
INSERT INTO Order1 VALUES (70010, 1983.43, '2012-10-10', 3004, 5006);
INSERT INTO Order1 VALUES (70003, 2480.40, '2012-10-10', 3009, 5003);
INSERT INTO Order1 VALUES (70012, 250.45,  '2012-06-27', 3008, 5002);
INSERT INTO Order1 VALUES (70011, 75.29,   '2012-08-17', 3003, 5007);
INSERT INTO Order1 VALUES (70013, 3045.60, '2012-04-25', 3002, 5001);
```

---

## Questions and Solutions

### Q1) Find salespeople and customers who reside in the same city

```sql
SELECT s.name     AS Salesman,
       c.cust_name,
       c.city
FROM Salesman1 s
INNER JOIN Customer1 c ON s.city = c.city;
```

**Expected result:**

| SALESMAN   | CUST_NAME    | CITY     |
|------------|--------------|----------|
| James Hoog | Nick Rimando | New York |
| James Hoog | Brad Davis   | New York |
| Pit Alex   | Brad Guzan   | London   |
| Nail Knite | Julian Green | London   |

**Explanation:**
- `INNER JOIN ... ON s.city = c.city` returns only rows where the join condition is satisfied — salesperson and customer share the same city.
- Rows from either table with no match in the other are excluded.

---

### Q2) Find each customer and the salesperson who handles them; show commission

```sql
SELECT c.cust_name  AS customer_name,
       c.city,
       s.name       AS salesman,
       s.commission
FROM Customer1 c
INNER JOIN Salesman1 s ON c.salesman_id = s.salesman_id;
```

**Explanation:**
- The join is on `salesman_id` — each customer is linked to their assigned salesperson.
- `INNER JOIN` means only customers who have a matching salesperson appear (all do in this dataset).
- This is a classic **equi-join** on a foreign key relationship.

---

### Q3) Make a Cartesian product between Salesman1 and Customer1

```sql
SELECT * FROM Salesman1 CROSS JOIN Customer1;
```

**Explanation:**
- A **Cartesian product** (also called a cross join) pairs every row from Salesman1 with every row from Customer1.
- With 6 salespeople and 8 customers, the result has 6 × 8 = **48 rows**.
- This is rarely useful in practice but demonstrates what happens when a join condition is missing.
- The explicit `CROSS JOIN` keyword is preferred over the old comma syntax (`FROM Salesman1, Customer1`) because it makes the intent clear.

---

### Q4) List all salespeople in ascending order — including those with no customers

```sql
SELECT DISTINCT s.name AS Salesman
FROM Salesman1 s
LEFT JOIN Customer1 c ON s.salesman_id = c.salesman_id
ORDER BY s.name ASC;
```

**Explanation:**
- `LEFT JOIN` returns **all rows from the left table** (Salesman1) regardless of whether a match exists in Customer1.
- Salespeople with no customers will appear with NULL in Customer1 columns.
- `DISTINCT` removes duplicate salesperson names (a salesperson with multiple customers would appear once per customer without it).
- The result includes every salesperson — those with customers and those without.

---

### Q5) Find salespeople who earned more than 10% commission; show customer name, city, salesman, commission

```sql
SELECT c.cust_name  AS customer_name,
       c.city       AS customer_city,
       s.name       AS salesman,
       s.commission
FROM Customer1 c
JOIN Salesman1 s ON c.salesman_id = s.salesman_id
WHERE s.commission > 0.10
ORDER BY s.name ASC;
```

**Explanation:**
- `commission > 0.10` means "more than 10%". All six salespeople in the dataset have commission > 0.10 (minimum is 0.11), so all customer-salesman pairs appear.
- To find exactly those with strictly more than 10%: `> 0.10` is correct (not `>= 0.10`).
- `JOIN` without a qualifier defaults to `INNER JOIN`.

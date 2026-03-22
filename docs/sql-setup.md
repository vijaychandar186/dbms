# SQL Practice Environment

This workspace provides a MySQL database for practicing SQL queries and database operations.

## Quick Start

### Connect to MySQL

```bash
mysql -h db -u user -ppassword --skip-ssl-verify-server-cert
```

Or if you prefer to be prompted for the password:

```bash
mysql -h db -u user -p --skip-ssl-verify-server-cert
```
Password: `password`

**Connection Details:**
- Host: `db`
- Username: `user`
- Password: `password`
- Database: `DB` (pre-created)

### Alternative: Connect as Root

```bash
mysql -h db -u root -ppassword --skip-ssl-verify-server-cert
```

## Basic SQL Commands

### View Databases
```sql
SHOW DATABASES;
```

### Use a Database
```sql
USE DB;
```

### Create a Table
```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100),
    age INT
);
```

### Insert Data
```sql
INSERT INTO users (name, email, age) VALUES ('Alice', 'alice@example.com', 25);
INSERT INTO users (name, email, age) VALUES ('Bob', 'bob@example.com', 30);
INSERT INTO users (name, email, age) VALUES ('Charlie', 'charlie@example.com', 28);
```

### Query Data
```sql
SELECT * FROM users;
SELECT * FROM users WHERE age > 25;
SELECT name, email FROM users WHERE age >= 28;
```

### Update Data
```sql
UPDATE users SET age = 26 WHERE name = 'Alice';
```

### Delete Data
```sql
DELETE FROM users WHERE name = 'Bob';
```

### Describe Table Structure
```sql
DESCRIBE users;
SHOW COLUMNS FROM users;
```

### List All Tables
```sql
SHOW TABLES;
```

### Drop a Table
```sql
DROP TABLE users;
```

## Practice Exercises

### Exercise 1: Create a Products Table
```sql
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    price DECIMAL(10, 2),
    quantity INT
);

INSERT INTO products (name, price, quantity) VALUES ('Laptop', 999.99, 5);
INSERT INTO products (name, price, quantity) VALUES ('Mouse', 29.99, 50);
INSERT INTO products (name, price, quantity) VALUES ('Keyboard', 79.99, 25);

SELECT * FROM products;
SELECT * FROM products WHERE price > 100;
```

### Exercise 2: Create an Orders Table with Foreign Key
```sql
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    product_id INT,
    quantity INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Insert sample data
INSERT INTO orders (user_id, product_id, quantity) VALUES (1, 1, 2);
INSERT INTO orders (user_id, product_id, quantity) VALUES (3, 2, 1);

-- Query with JOIN
SELECT u.name, p.name, o.quantity FROM orders o
JOIN users u ON o.user_id = u.id
JOIN products p ON o.product_id = p.id;
```

### Exercise 3: Aggregation Functions
```sql
-- Count total orders
SELECT COUNT(*) FROM orders;

-- Sum total quantity ordered
SELECT SUM(quantity) FROM orders;

-- Average price of products
SELECT AVG(price) FROM products;

-- Get highest price
SELECT MAX(price) FROM products;
```

### Exercise 4: Group By
```sql
-- Count orders per user
SELECT u.name, COUNT(o.id) as order_count
FROM orders o
JOIN users u ON o.user_id = u.id
GROUP BY u.name;
```

## Exit MySQL
```sql
EXIT;
```
or
```sql
QUIT;
```

## Tips

- Use `.schema` to see the current database schema
- Use `;` to end statements
- Use `\G` instead of `;` for vertical output format: `SELECT * FROM users\G`
- Comments: `-- this is a comment` or `/* multi-line comment */`
- To clear the screen, use `system clear;` (note: `clear` alone is a shell command, not MySQL)
- Use `\c` to cancel and clear the current input line

## Run SQL File

To execute an SQL file:

```bash
mysql -h db -u user -ppassword --skip-ssl-verify-server-cert < script.sql
```

## Resources

- [MySQL Documentation](https://dev.mysql.com/doc/)
- [SQL Tutorial](https://www.w3schools.com/sql/)

Happy learning! 🚀
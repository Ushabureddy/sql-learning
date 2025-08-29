# sql-learning
SQL Practice using ClassicModels and a custom Customers_Orders database with queries, constraints, joins, views, triggers, and stored procedures in MySQL.

# 📊 SQL Assignments – ClassicModels & Custom Customers_Orders Database

This repository contains **detailed SQL assignments and solutions** using the **ClassicModels** sample database along with a **custom Customers_Orders database**.  
The project is designed to strengthen SQL skills by covering everything from **basic queries** to **advanced concepts** like views, triggers, stored procedures, error handling, and window functions in MySQL.  

---

## 🚀 Project Overview
The project is divided into two parts:
1. **ClassicModels Database Queries** – Pre-loaded sample database used for practicing queries.  
2. **Custom Customers_Orders Database** – Created from scratch with **customers** and **orders** tables including foreign keys and check constraints.  

This combination ensures a balance of **theoretical understanding** and **hands-on database design**.

---

## 📌 Features Implemented
- ✅ **Database Design**
  - Primary keys, foreign keys, unique, not null, and check constraints  
  - `customers` and `orders` tables with referential integrity  
- ✅ **SQL Queries**
  - Filtering with `WHERE`, `AND`, `OR`, `LIKE`  
  - Removing duplicates using `DISTINCT`  
  - Sorting with `ORDER BY`  
- ✅ **Aggregations**
  - Grouping using `GROUP BY`  
  - Aggregate functions (`SUM`, `AVG`, `COUNT`, `MAX`, `MIN`)  
- ✅ **Joins**
  - Inner joins, left joins, right joins, and self joins  
  - Country-wise order summaries  
- ✅ **Views**
  - Simplified query reporting  
- ✅ **Stored Procedures**
  - With parameters  
  - With error handling  
- ✅ **Window Functions**
  - Ranking (RANK, DENSE_RANK, ROW_NUMBER)  
  - Year-over-Year (YoY) sales growth analysis  
- ✅ **Triggers**
  - Ensuring data integrity (e.g., `total_amount > 0`)  
- ✅ **Subqueries**
  - Finding values above/below average  

---

## 🗄️ Databases Used
### 1️⃣ ClassicModels
- Preloaded MySQL database used for practicing queries.  
- Contains tables like `customers`, `orders`, `orderdetails`, `employees`, `products`, etc.  

### 2️⃣ Customers_Orders
A custom database created for this assignment:
- **customers**
  - `customer_id` (PK, AUTO_INCREMENT)  
  - `first_name`  
  - `last_name`  
  - `email`  
- **orders**
  - `order_id` (PK, AUTO_INCREMENT)  
  - `customer_id` (FK → customers.customer_id)  
  - `order_date` (DATE)  
  - `total_amount` (DECIMAL with CHECK constraint)  

---


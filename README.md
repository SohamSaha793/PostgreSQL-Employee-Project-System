# 🧠 SQL 50 Questions Project – Employee & Project Analysis

## 📌 Project Overview
This project demonstrates **SQL problem-solving skills** through **50 real-world business questions** using a relational database.

The focus areas include:
- Data retrieval & filtering
- Joins & subqueries
- Aggregations & grouping
- Window functions
- CTEs
- Manager–employee hierarchy analysis
- Department & project analytics

---

## 🛠️ Tools & Concepts Used
- SQL (DDL & DML)
- Joins (INNER, LEFT)
- Subqueries
- CTEs
- Window Functions (RANK, DENSE_RANK, ROW_NUMBER)
- Date & Time functions
- Self joins (Manager–Employee relationships)

---

## 🗄️ Database Schema
### Tables:
- **Departments**
- **Employees**
- **Projects**

Each table is connected using **foreign keys** to simulate a real company structure.

---

## 🧹 Data Setup
- Created tables using `CREATE TABLE`
- Inserted sample data using `INSERT INTO`
- Maintained referential integrity with primary & foreign keys

---

## 📊 Key Business Questions Solved

### 🔹 Employee Analysis
- Employees by department
- Salary-based filtering & ranking
- Employees earning above department/company average
- Employees earning more than their manager
- Employees hired before their manager
- Manager vs non-manager identification

### 🔹 Department Insights
- Average, min & max salary per department
- Departments with highest salary expense
- Departments without projects
- Employee count per department

### 🔹 Project Analysis
- Highest & lowest budget projects
- Longest running project
- Projects by year
- Department-wise project count

### 🔹 Advanced SQL
- Window functions for ranking
- Self joins for hierarchy analysis
- Correlated subqueries
- CTE-based analytics

---

## 🧪 Sample Query (Ranking Employees by Salary)
```sql
SELECT 
    first_name || ' ' || last_name AS name,
    salary,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM Employees;


📎 Author
[Your Name]
Aspiring Data Analyst | SQL | Data Analytics

Supermarket Sales Analysis (SQL)


📋 Project Overview

This project contains a comprehensive suite of SQL queries designed to clean, transform, and analyze supermarket sales data. The analysis focuses on identifying high-performing branches, profitable product lines, and distinct customer shopping behaviors to drive data-driven decision-making.



🛠️ Technical Stack

Language: SQL (T-SQL / MS SQL Server)

Key Techniques: * Data Aggregation: GROUP BY, SUM, AVG, COUNT

Advanced Analytics: Common Table Expressions (CTEs), Window Functions (RANK, DENSE_RANK)

Conditional Logic: CASE statements for time-of-day bucketing

Data Cleaning: String manipulation (SUBSTRING), Type casting (TRY_CONVERT), and Date formatting

🔍 Key Insights & Queries

1. Branch Performance
Evaluates the efficiency of different locations (Branches A, B, and C) by comparing:

Total revenue and average customer ratings.

The number of transactions per city.

Performance vs. Branch Average (using Subqueries and CTEs).

2. Product Intelligence
Deep dives into the inventory to find:

Total revenue per product line.

Top 3 most profitable products per branch (using DENSE_RANK).

High-value product categories (Revenue > £25,000).

3. Customer Demographics
Segments data to understand the "who" behind the sales:

Member vs. Normal: Comparing profit contribution and average spend.

Payment Methods: Analysis of cash vs. digital transactions.

Shopping Windows: Categorizing sales into Morning, Afternoon, and Evening peaks.

4. Data Transformation & Maintenance
Includes scripts for database maintenance, such as:

Permanently altering column data types for precision.

Standardizing date formats to UK standards (DD/MM/YYYY).

Handling dates stored as strings vs. date objects.

🚀 Getting Started
Prerequisites
SQL Server Management Studio (SSMS) or any SQL-compatible IDE.

A database named Supermarket_Data.

A table named Supermarket_Sales_Data_Original.

Usage
Clone this repository.

Open Clean Supermarket Query.sql in your SQL editor.

Run the "Show everything" query to verify your data connection.

Execute specific blocks to generate reports for stakeholders.

📈 Example Output
The library includes a sophisticated Profitability Ranking query that calculates:

Gross Profit

Gross Margin Percentage

Profit per Transaction

This allows for a nuanced view of performance beyond just top-line revenue.

Note: For job applications and professional portfolios, ensure the layout remains straight and exact as prompted, excluding unnecessary links or excessive spacing.

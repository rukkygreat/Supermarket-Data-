--Show everything
Select *
From Supermarket_Sales_Data_Original

--Show only a few columns
use [Supermarket_Data]
Go

--Show a few columns
Select [Invoice ID], Branch, City, [Gross income Total], Rating
From Supermarket_Sales_Data_Original;


-- Show only 10 rows
SELECT Top 10 *
FROM Supermarket_Sales_Data_original

--Show distinct values
SELECT Branch, City, COUNT(Gender) as No_of_customer
FROM Supermarket_Sales_Data_Original
GROUP BY Branch, City;

SELECT City, COUNT(Gender) as No_of_customer
FROM Supermarket_Sales_Data_Original
GROUP BY City;

SELECT Branch, City, COUNT(Gender) as No_of_customer
FROM Supermarket_Sales_Data_Original
GROUP BY Branch, City;

--select each branch
select * 
From Supermarket_Sales_Data_Original
Where Branch='a';

select * 
From Supermarket_Sales_Data_Original
Where Branch='b';

select * 
From Supermarket_Sales_Data_Original
Where Branch='c';

--total>500
select [Invoice ID], [Gross income Total], [Product line]
from Supermarket_Sales_Data_Original
where [Gross income Total] > 500;



--select a few product categories
select [Invoice ID], [Product line]
from Supermarket_Sales_Data_Original
where [Product line] in ('sports and travel', 'electronic accessories');

--select higher ratings of products
select [Invoice ID], city, [Product line], Rating
from Supermarket_Sales_Data_Original
Where Rating > 8;

--select higher ratings but this time with members only
select [Invoice ID], city,  [Product line], [Customer type], Rating 
from Supermarket_Sales_Data_Original
Where Rating > 8 and [Customer type] = 'member';

--select cash payment
select [Invoice ID], City, [Product line], [Customer type], Payment
from Supermarket_Sales_Data_Original
Where Payment = 'cash';

--how many invoices per branch
select Branch, city, count(*) as number_of_transactions 
from Supermarket_Sales_Data_Original
Group by Branch, city;

--total revenue per product
select [Product line], Round(sum([Gross income Total]), 2) as Total_revenue
from Supermarket_Sales_Data_Original
Group by [Product line]
Order by Total_revenue desc;

--average spend per customer type
select [Customer type], round(avg([gross margin percentage]), 2) as Avg_spend, count(*) as No_of_transactions
from Supermarket_Sales_Data_Original
group by [Customer type];

--show revenue, number of transactions and avg ratings for each branch
select Branch, round(sum([Gross income Total]), 2) as Total_revenue, round(avg(Rating), 2) as Avg_rating
from Supermarket_Sales_Data_Original
Group by Branch
Order by Total_revenue;

--Product lines of more than £25,000
select [Product line], round(sum(try_convert(decimal(10,2), [Gross income Total])), 2) as Revenue
from Supermarket_Sales_Data_Original
Group By [Product line]
Having sum([Gross income Total]) > 25000
Order by Revenue Desc;

--Branches with average rating >= 7.0
select Branch, round(avg(Rating), 2) as Avg_rating
from Supermarket_Sales_Data_Original
Group by Branch
Having avg(Rating) >= 7
Order by Avg_rating;

--permanently convert data type
--EXEC sp_help 'Supermarket_Sales_Data_Query';
-- or
--SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE
--FROM INFORMATION_SCHEMA.COLUMNS
--WHERE TABLE_NAME = 'Supermarket_Sales_Data_Query'
--  AND COLUMN_NAME = 'Gross income Total';

--ALTER TABLE Supermarket_Sales_Data_Original
--ADD Gross_Income_Decimal decimal(18,4) NULL;
--Now I can use it normally

--Date handling for date that is formatted as strings 
select
	SUBSTRING(Date, 4, 7) as month_year,
	round(sum([Gross income Total]), 2) as revenue
from Supermarket_Sales_Data_Original
Group by SUBSTRING(Date, 4, 7)
Order by month_year;

--Date handling for date that is formatted as date
SELECT 
    FORMAT(Date, 'MM/yyyy') as month_year, 
    ROUND(SUM([Gross income Total]), 2) as revenue
FROM Supermarket_Sales_Data_Original
GROUP BY FORMAT(Date, 'MM/yyyy')
ORDER BY MIN(Date); -- This will now sort correctly by time!


--sales only in january
SELECT *
FROM dbo.Supermarket_Sales_Data_Original
WHERE date >= '2019-01-01' AND date < '2019-02-01';

--format date to Uk standard
Select [Invoice ID],
	format(date, 'dd/mm/yyyy') As [UK_Date],
	[Gross income Total]
From Supermarket_Sales_Data_Original;


--Time of the day categories (morning/afternoon/evening)
select
	[Invoice ID],
	[Product line],
	City
	Time,
	case
		when time <'12:00' then 'morning'
		when time <'18:00' then 'afternoon'
		else 'evening'
	end as time_of_day
from Supermarket_Sales_Data_Original

--compare each transactions to the average total of its branch (subquery)
--Valid one that works
SELECT 
    [Invoice ID], 
    Branch, 
    [Gross Income Total], 
    ROUND((SELECT AVG([Gross Income Total]) 
           FROM Supermarket_Sales_Data_Original s2 
           WHERE s2.Branch = s1.Branch), 2) AS branch_avg
FROM dbo.Supermarket_Sales_Data_Original s1
ORDER BY Branch, [Gross Income Total] DESC;

--Using CTE
with Branch_Averages AS (
	select Branch, round(Avg([Gross income Total]), 2) as Avg_total
	from Supermarket_Sales_Data_Original
	Group by Branch
	)
select 
	s.[Invoice ID],
	s.branch,
	s.[Gross income Total],
	b.avg_total, 
	round(s.[Gross income Total] - b.avg_total, 2) as difference_from_avg
from Supermarket_Sales_Data_Original s
join Branch_Averages b on s.Branch = b.Branch
Order by difference_from_avg;

--Profitability ranking by product category
SELECT 
    [Product line],
    ROUND(SUM([Gross income Total]), 2)            AS revenue,
    ROUND(SUM(Profit), 2)     AS gross_profit,
    ROUND(SUM(profit) / SUM([Gross income Total])  * 100, 2) AS gross_margin_pct,
    ROUND(SUM([Gross income Total]) / COUNT(*) , 2) AS profit_per_transaction,
    COUNT(*)                        AS transactions
FROM Supermarket_Sales_Data_Original
GROUP BY [Product line]
ORDER BY gross_profit DESC;

--Member vs Normal customers – profit contribution
SELECT 
    [Customer type],
	ROUND(SUM([Gross income Total]), 2)            AS revenue,
    ROUND(SUM(Profit), 2)     AS gross_profit,
	ROUND(SUM(profit) / SUM([Gross income Total])  * 100, 2) AS gross_margin_pct,
    ROUND(SUM([Gross income Total]) / COUNT(*) , 2) AS profit_per_transaction,
    COUNT(*)                        AS transactions,
    ROUND(100.0 * SUM([Gross income Total]) / (SELECT SUM([Gross income Total]) FROM Supermarket_Sales_Data_Original), 2) AS pct_of_total_profit
FROM Supermarket_Sales_Data_Original
GROUP BY [Customer type]
ORDER BY gross_profit DESC;

-- 9. Rank product lines by profit within each branch
SELECT 
    Branch,
    [Product line],
    ROUND(SUM([Gross income Total]), 2) AS gross_profit,
    RANK() OVER (PARTITION BY Branch ORDER BY SUM([Gross income Total]) DESC) AS profit_rank_in_branch,
    ROUND(100.0 * SUM([Gross income Total]) / SUM(SUM([Gross income Total])) OVER (PARTITION BY Branch), 2) AS pct_of_branch_profit
FROM Supermarket_Sales_Data_Original
GROUP BY Branch, [Product line]
ORDER BY Branch, gross_profit Desc, profit_rank_in_branch;

-- Top 3 most profitable product lines per branch (with ties)
WITH ranked AS (
    SELECT 
        Branch,
        [Product line],
        ROUND(SUM([gross income total]), 2) AS gross_profit,
        DENSE_RANK() OVER (PARTITION BY Branch ORDER BY SUM([gross income total]) DESC) AS rank
    FROM Supermarket_Sales_Data_Original
    GROUP BY Branch, [Product line]
)
SELECT * 
FROM ranked
WHERE rank <= 3
ORDER BY Branch, rank;

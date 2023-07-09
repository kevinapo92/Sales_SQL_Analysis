USE sales_product_data ;
-- How many orders are there in the dataset? -- 
SELECT SUM(TABLE_ROWS) AS total_rows
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'sales_product_data' ;

-- What are the top 5 most frequently ordered products by month?
CREATE TABLE IF NOT EXISTS top5_Joined ; 
INSERT INTO top5_joined (Product, Number_Products, Month)
SELECT * FROM (
SELECT PRODUCT, Number_Products, January AS Month  
FROM (
(SELECT PRODUCT, COUNT(PRODUCT) AS Number_Products, 'January'
FROM 01_sales_january_2019
GROUP BY PRODUCT
ORDER BY Number_Products DESC
LIMIT 5 )  
UNION 
(SELECT PRODUCT, COUNT(PRODUCT) AS Number_Products, 'February'
FROM 02_sales_february_2019
GROUP BY PRODUCT
ORDER BY Number_Products DESC
LIMIT 5 ) 
UNION  
(SELECT PRODUCT, COUNT(PRODUCT) AS Number_Products, 'March'
FROM 03_sales_march_2019
GROUP BY PRODUCT
ORDER BY Number_Products DESC
LIMIT 5)
UNION 
(SELECT PRODUCT, COUNT(PRODUCT) AS Number_Products, 'April'
FROM 04_sales_april_2019
GROUP BY PRODUCT
ORDER BY Number_Products DESC
LIMIT 5)
UNION 
(SELECT PRODUCT, COUNT(PRODUCT) AS Number_Products, 'May'
FROM 05_sales_may_2019
GROUP BY PRODUCT
ORDER BY Number_Products DESC
LIMIT 5)
UNION 
(SELECT PRODUCT, COUNT(PRODUCT) AS Number_Products, 'June'
FROM 06_sales_june_2019
GROUP BY PRODUCT
ORDER BY Number_Products DESC
LIMIT 5)
UNION  
(SELECT PRODUCT, COUNT(PRODUCT) AS Number_Products, 'July'
FROM 07_sales_july_2019
GROUP BY PRODUCT
ORDER BY Number_Products DESC
LIMIT 5)
UNION 
(SELECT PRODUCT, COUNT(PRODUCT) AS Number_Products, 'August'
FROM 08_sales_august_2019
GROUP BY PRODUCT
ORDER BY Number_Products DESC
LIMIT 5)
UNION 
(SELECT PRODUCT, COUNT(PRODUCT) AS Number_Products, 'September'
FROM 09_sales_september_2019
GROUP BY PRODUCT
ORDER BY Number_Products DESC
LIMIT 5)
UNION
(SELECT PRODUCT, COUNT(PRODUCT) AS Number_Products, 'October'
FROM 10_sales_october_2019
GROUP BY PRODUCT
ORDER BY Number_Products DESC
LIMIT 5)
UNION
(SELECT PRODUCT, COUNT(PRODUCT) AS Number_Products, 'November'
FROM 11_sales_november_2019
GROUP BY PRODUCT
ORDER BY Number_Products DESC
LIMIT 5) 
UNION 
(SELECT PRODUCT, COUNT(PRODUCT) AS Number_Products, 'December'
FROM 12_sales_december_2019
GROUP BY PRODUCT
ORDER BY Number_Products DESC
LIMIT 5) ) AS JOIN_TABLE ) AS JOINED_TABLE;

 -- Products that repeat in the top 5 all the months
SELECT PRODUCT
FROM Top5_Joined 
WHERE Month = 'January'
INTERSECT
SELECT PRODUCT
FROM Top5_Joined 
WHERE Month = 'February'
INTERSECT
SELECT PRODUCT
FROM Top5_Joined 
WHERE Month = 'March'
INTERSECT
SELECT PRODUCT
FROM Top5_Joined 
WHERE Month = 'April'
INTERSECT
SELECT PRODUCT
FROM Top5_Joined 
WHERE Month = 'May'
INTERSECT
SELECT PRODUCT
FROM Top5_Joined 
WHERE Month = 'June'
INTERSECT
SELECT PRODUCT
FROM Top5_Joined 
WHERE Month = 'July'
INTERSECT
SELECT PRODUCT
FROM Top5_Joined 
WHERE Month = 'August'
INTERSECT
SELECT PRODUCT
FROM Top5_Joined 
WHERE Month = 'September'
INTERSECT
SELECT PRODUCT
FROM Top5_Joined 
WHERE Month = 'October'
INTERSECT
SELECT PRODUCT
FROM Top5_Joined 
WHERE Month = 'November'
INTERSECT
SELECT PRODUCT
FROM Top5_Joined 
WHERE Month = 'December';

-- What is the total revenue generated by each product?
DROP TABLE Consolidated_Year ;
CREATE TABLE IF NOT EXISTS Consolidated_Year (
Order_ID INT,
    Product VARCHAR(255),
    Quantity_Ordered INT,
    Price_Each DECIMAL(10, 2),
    Order_Date VARCHAR(255)  ,
    Purchase_Address VARCHAR(255),
    Month VARCHAR(20)
); 
INSERT INTO Consolidated_Year (Order_ID, Product, Quantity_Ordered, Price_Each, Order_Date, Purchase_Address, Month)
SELECT  Order_ID, Product, Quantity_Ordered, Price_Each,  Order_Date , Purchase_Address, Month
FROM (
	SELECT * , 'January' AS Month
    FROM 01_sales_january_2019
    UNION 
    SELECT * , 'February' AS Month
    FROM 02_sales_february_2019
    UNION 
    SELECT * ,'March' AS Month
    FROM 03_sales_march_2019
    UNION 
    SELECT * , 'April' AS Month
    FROM 04_sales_april_2019
	UNION 
	SELECT * , 'May' AS Month
    FROM 05_sales_may_2019
	UNION 
    SELECT * , 'June' AS Month
    FROM 06_sales_june_2019
    UNION
	SELECT * , 'July' AS Month
    FROM 07_sales_july_2019
    UNION 
    SELECT * , 'August' AS Month
	FROM 08_sales_august_2019
	UNION 
	SELECT * , 'September' AS Month
	FROM 09_sales_september_2019
	UNION 
	SELECT * , 'October' AS Month
    FROM 10_sales_october_2019
    UNION 
	SELECT * , 'November' AS Month
    FROM 11_sales_november_2019
    UNION 
	SELECT * , 'December' AS Month
    FROM 12_sales_december_2019 ) AS JOINED_TABLE;

SELECT Product, SUM(Price_Each) AS Total_Revenue
FROM consolidated_year
GROUP BY Product
ORDER BY Total_Revenue DESC 
LIMIT 10 ;

-- What is the average price of each product?
SELECT AVG(Price_Each) AS Avg_Price
FROM consolidated_year;

-- How many units of each product were sold?
SELECT Product, SUM(Quantity_Ordered)
FROM consolidated_year
GROUP BY Product ;

-- What is the total revenue for each month?
SELECT Month, SUM(Price_Each) AS Total_Revenue
FROM consolidated_year
GROUP BY Month 
ORDER BY Total_Revenue DESC ;

-- What is the average quantity ordered per month?
Select Month, AVG(Quantity_Ordered) 
FROM consolidated_year
GROUP BY Month 
ORDER BY AVG(Quantity_Ordered) DESC ; 

-- Which month had the highest revenue?
SELECT Month, SUM(Price_Each) AS Total_Revenue
FROM consolidated_year
GROUP BY Month 
ORDER BY Total_Revenue DESC 
LIMIT 1 ; 

-- What is the average price of products in each month?
SELECT Month, Product,  ROUND(AVG(Price_Each),2) AS Avg_Price
FROM consolidated_year
GROUP BY Month, Product
ORDER BY Month ;

-- How many orders were shipped to each address?
SELECT Purchase_Address, COUNT(Order_ID) AS Nb_Orders
FROM consolidated_year
GROUP BY Purchase_Address 
order by Nb_Orders DESC;

-- How many unique products were ordered?
SELECT COUNT(Order_ID) AS Nb_Unique_Orders
FROM consolidated_year
WHERE Quantity_Ordered = 1 ; 

-- Which product generated the highest revenue by Month?

WITH Max_Revenue_Month AS (
  SELECT Month, MAX(Revenue) AS Max_Revenue
  FROM (
    SELECT Month, Product, SUM(Price_Each) AS Revenue
    FROM consolidated_year
    GROUP BY Month, Product
  ) AS Month_table
  GROUP BY Month
)
SELECT Max_Revenue_Month.Month, Month_table.Product, Max_Revenue
FROM Max_Revenue_Month
INNER JOIN (
  SELECT Month, Product, SUM(Price_Each) AS Revenue
  FROM consolidated_year
  GROUP BY Month, Product
) AS Month_table 
ON  Max_Revenue_Month.Max_Revenue = Month_table.Revenue;
    
-- Which product had the highest quantity ordered by month?
WITH Table2 AS (
SELECT Month, MAX(Quantity) AS Quantity_Product
FROM (
SELECT Month, Product, SUM(Quantity_Ordered) AS Quantity
FROM consolidated_year
GROUP BY Month, Product) AS Table1
GROUP BY Month ) 
SELECT Table2.Month, Product, Quantity_Product
FROM Table2
INNER JOIN (
SELECT Month, Product, SUM(Quantity_Ordered) AS Quantity
FROM consolidated_year
GROUP BY Month, Product) AS Table3
ON  Table2.Quantity_Product = Table3.Quantity;

-- How many orders were placed on each day of the week?
ALTER TABLE consolidated_year
ADD COLUMN Nb_Char INT; 
SET SQL_SAFE_UPDATES = 0;
UPDATE consolidated_year
SET Nb_Char = CHAR_LENGTH(Order_Date); 
ALTER TABLE consolidated_year
MODIFY COLUMN Nb_Char INT;
UPDATE consolidated_year
SET Order_Date = REPLACE(Order_Date, '2019', '19')
WHERE Nb_Char = 16 ;
UPDATE consolidated_year
SET Order_Date = REPLACE(Order_Date, '2020', '20')
WHERE Nb_Char > 14  ;
UPDATE consolidated_year
SET Order_Date = STR_TO_DATE(Order_Date, '%m/%d/%y %H:%i') ;
SET SQL_SAFE_UPDATES = 1;

SELECT SUM(Quantity_Ordered) AS Nb_Orders, DAYNAME(Order_Date) AS day_of_week
FROM consolidated_year
GROUP BY day_of_week 
ORDER BY Nb_Orders DESC ;

-- Which product had the highest quantity ordered by each day of the week?
WITH TABLE2 AS (
SELECT day_of_week, MAX(Nb_Orders) AS Max_orders
FROM (
SELECT Product, DAYNAME(Order_Date) AS day_of_week, SUM(Quantity_Ordered) AS Nb_Orders
FROM consolidated_year
GROUP BY Product, day_of_week ) AS TABLE1 
GROUP BY day_of_week ) 
SELECT Product, TABLE2.day_of_week, TABLE2.Max_Orders
FROM TABLE2 
INNER JOIN (
SELECT Product, DAYNAME(Order_Date) AS day_of_week, SUM(Quantity_Ordered) AS Nb_Orders
FROM consolidated_year
GROUP BY Product, day_of_week ) AS TABLE3
ON TABLE2.Max_Orders = TABLE3.Nb_Orders
ORDER BY Max_Orders DESC ;

-- Which Postal Code and state put more orders in 2019 ?
SELECT Postal_Code, State, SUM(Quantity_Ordered) AS Order_PostalCode, 
	    RANK() OVER(ORDER BY SUM(Quantity_Ordered) DESC) AS Nb_Rank
FROM 
(SELECT * , 
	TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Purchase_Address,',',-1),' ',-1)) AS Postal_Code,
    TRIM(SUBSTRING(SUBSTRING_INDEX(Purchase_Address, ', ', -1), 1 ,3)) AS State
FROM consolidated_year) AS Table1 
GROUP BY Postal_Code, State
ORDER BY Nb_Rank ; 

-- Identify the unique orders in 2019, how many?
SELECT * , CASE WHEN Quantity_Ordered = 1 THEN 'Unique Product'
		        WHEN Quantity_Ordered = 0 THEN 'Null Product'
		   ELSE 'Multiple Products' END AS Type_Order
FROM consolidated_year;

SELECT Type_Order, COUNT(Type_Order)
FROM ( SELECT * , CASE WHEN Quantity_Ordered = 1 THEN 'Unique Product'
		   ELSE 'Multiple Products' END AS Type_Order
		FROM consolidated_year) AS T1
GROUP BY Type_Order ;

-- Create a histogram for Price of each product 
CREATE TEMPORARY TABLE Temp_histogram (
				bin_start DECIMAL(10,2) , 
                bin_edn   DECIMAL(10,2) , 
                bin_count INT ) ;
SET @num_bins := 10;
SET @bin_width := 100; 
INSERT INTO temp_histogram (bin_start, bin_edn, bin_count)
SELECT 
	FLOOR (Price_Each / @bin_width) * @bin_width AS bin_start,
    FLOOR (Price_Each / @bin_width) * @bin_width + @bin_width AS bin_edn,
    COUNT(*) AS bin_count
FROM consolidated_year
GROUP BY bin_start, bin_edn
ORDER BY bin_start ;

SELECT CONCAT(bin_start, ' - ', bin_edn) AS bin_range, bin_count
FROM temp_histogram;
                


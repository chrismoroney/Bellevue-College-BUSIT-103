--*  BUSIT 103				Assignment   #10				DUE DATE :  Consult course calendar
							
--You are to develop SQL statements for each task listed.  
--You should type your SQL statements under each task.  

--  It is your responsibility to provide a meaningful column name for the return value of the function.
--  These statements will NOT use GROUP BY or HAVING. Those keywords are introduced in the next module. One cell 
--	results sets (one column and one row) do not need to have an ORDER BY clause.

--	Recall that sales to resellers are stored in the FactResellerSales table and sales to customers are stored in
--	the FactInternetSales table. 

--	Do not remove the USE statement
USE AdventureWorksDW2012;

-- 1.a.	Find the count of customers who are married. Be sure give each derived field 
--		an appropriate alias.


SELECT COUNT(MaritalStatus) AS TotalCustMarried
FROM [dbo].[DimCustomer]
WHERE MaritalStatus = 'M';


--1.b.	Check your result. Write queries to determine if the answer to 1.a. is correct.
--		You should be writing proofs for all of your statements.

SELECT * 
FROM [dbo].[DimCustomer]
WHERE MaritalStatus = 'M';


--1.c.	Find the total children (sum) and the total cars owned (sum) for customers who are married.


SELECT SUM(TotalChildren) AS SumChildren, SUM(NumberCarsOwned) AS SumCars
FROM [dbo].[DimCustomer]
WHERE MaritalStatus = 'M';


   
--1.d.	Find the total children, total cars owned, and average yearly income for customers who are married.


SELECT SUM(TotalChildren) AS SumChildren, SUM(NumberCarsOwned) AS SumCars, AVG(YearlyIncome) AS AvgIncome
FROM [dbo].[DimCustomer]
WHERE MaritalStatus = 'M';


--2.a.	List the total dollar amount (SalesAmount) for sales to Resellers. Round to two decimal places.


SELECT CAST(SUM(SalesAmount) AS DECIMAL(18,2)) AS TotalSalesAmount
FROM [dbo].[FactResellerSales];



--2.b.	List the total dollar amount (SalesAmount) for 2008 sales to resellers in Germany.
--		Show only the total sales--one row, one column--rounded to two decimal places. 


SELECT CAST(SUM(SalesAmount) AS DECIMAL(18,2)) AS TotalSalesAmount
FROM [dbo].[FactResellerSales] AS rs INNER JOIN [dbo].[DimSalesTerritory] AS t ON rs.SalesTerritoryKey = t.SalesTerritoryKey
WHERE rs.OrderDate BETWEEN '2008-01-01' AND '2008-12-31'AND t.SalesTerritoryKey = 8;


--3.a.	List the total dollar amount (SalesAmount) for sales to Customers. Round to two decimal places.


SELECT CAST(SUM(SalesAmount) AS DECIMAL(18,2)) AS TotalSalesAmount
FROM [dbo].[FactInternetSales];



--3.b.  List the total dollar amount (SalesAmount) for 2008 sales to customers located in the 
--		United Kingdom. Show only the total sales--one row, one column--rounded to two decimal places. 


SELECT CAST(SUM(SalesAmount) AS DECIMAL(18,2)) AS TotalSalesAmount
FROM [dbo].[FactInternetSales] AS fis INNER JOIN [dbo].[DimSalesTerritory] AS t ON fis.SalesTerritoryKey = t.SalesTerritoryKey
WHERE fis.OrderDate BETWEEN '2008-01-01' AND '2008-12-31'AND t.SalesTerritoryKey = 10; 


--4.	List the average unit price for a touring bike sold to customers. Round to
--		two decimal places.


SELECT CAST(AVG(UnitPrice) AS DECIMAL(18,2)) AS AvgUnitPrice
FROM [dbo].[FactInternetSales] AS fis INNER JOIN [dbo].[DimProduct] AS p ON fis.ProductKey = p.ProductKey INNER JOIN [dbo].[DimProductSubcategory] AS ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
WHERE ps.ProductSubcategoryKey = 3;


--5.	List bikes that have a list price less than the average list price for all bikes.
--		Show product key, English product name, and list price.
--		Order descending by list price.

SELECT p.ProductKey, p.EnglishProductName, p.ListPrice
FROM [dbo].[DimProduct] AS p INNER JOIN [dbo].[DimProductSubcategory] AS ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey INNER JOIN [dbo].[DimProductCategory] AS pc ON ps.ProductCategoryKey = pc.ProductCategoryKey
WHERE ListPrice < (
	SELECT AVG(ListPrice) 
	FROM [dbo].[DimProduct] AS p INNER JOIN [dbo].[DimProductSubcategory] AS ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey INNER JOIN [dbo].[DimProductCategory] AS pc ON ps.ProductCategoryKey = pc.ProductCategoryKey
	WHERE pc.ProductCategoryKey = 1
	)
AND pc.ProductCategoryKey = 1
ORDER BY p.ListPrice DESC, p.ProductKey ASC;



--6.	List the lowest list price, the average list price, the highest list price, 
--		and product count for road bikes.


SELECT MIN(p.ListPrice) AS MinListPrice, AVG(p.ListPrice) AS AvgListPrice, MAX(p.ListPrice) AS MaxListPrice, COUNT(*) AS ProductCount
FROM [dbo].[DimProduct] AS p INNER JOIN [dbo].[DimProductSubcategory] AS ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
WHERE ps.ProductSubcategoryKey = 2;



-- 7.	List the product alternate key, product name, and list price for the distinct product(s) 
--		with the lowest List Price. Note several products could tie for the lowest list price.


SELECT ProductAlternateKey, EnglishProductName, ListPrice
FROM [dbo].[DimProduct] 
WHERE ListPrice = (
	SELECT DISTINCT MIN(ListPrice)
	FROM [dbo].[DimProduct] 
	);


-- 8.a.	List the product alternate key, product name, list price, dealer price, and the 
--		difference (calculated field) for distinct product(s). Show all money values to 2 decimal places.
--		Sort on difference from highest to lowest.


SELECT DISTINCT ProductAlternateKey, EnglishProductName, CAST(ListPrice AS DECIMAL(18,2)) AS ListPrice, CAST(DealerPrice AS DECIMAL(18,2)) AS DearlerPrice, CAST((ListPrice - DealerPrice) AS DECIMAL(18,2)) AS DifferenceMoney
FROM [dbo].[DimProduct]
ORDER BY DifferenceMoney DESC, EnglishProductName, ProductAlternateKey ASC;


-- 8.b.	Use the statement from 8.a. and modify to find the product(s) with the largest difference 
--		between the list price and the dealer price. Show all money values to 2 decimal places.


SELECT DISTINCT ProductAlternateKey, EnglishProductName, CAST(ListPrice AS DECIMAL(18,2)) AS ListPrice, CAST(DealerPrice AS DECIMAL(18,2)) AS DearlerPrice, CAST((ListPrice - DealerPrice) AS DECIMAL(18,2)) AS DifferenceMoney
FROM [dbo].[DimProduct]
WHERE (ListPrice - DealerPrice) = (
	SELECT MAX(ListPrice - DealerPrice) AS DifferenceMoney
	FROM [dbo].[DimProduct]
	)
ORDER BY DifferenceMoney DESC, EnglishProductName, ProductAlternateKey ASC;


-- 9.	List total Internet sales for product BK-M82S-44 using two methods: Total the sales amount field
--		and calculate the total amount using unit price and quantity. Place both calculations in different 
--		columns in the SAME Select statement. There will be one results set with two columns and one row. 
--		Show all money values to 2 decimal places. The values should be the same.


SELECT SUM(SalesAmount) AS TotalSalesAmount, SUM(UnitPrice * OrderQuantity) AS OrderQuantityTimesUnitPrice
FROM [dbo].[FactInternetSales] AS fis INNER JOIN [dbo].[DimProduct] AS p ON p.ProductKey = fis.ProductKey
WHERE p.ProductAlternateKey = 'BK-M82S-44';





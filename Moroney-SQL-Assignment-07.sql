--*  BUSIT 103				Assignment   #7					 DUE DATE :  Consult course calendar
							
/*	You are to develop SQL statements for each task listed. You should type your SQL statements  
	under each task. You are required to use the INNER JOIN syntax to solve each problem. INNER JOIN is 
	ANSI syntax. Even if you have prior experience with joins, you will still use the INNER JOIN  
	syntax and refrain from using any OUTER or FULL joins in modules introducing INNER JOINs. */

/*	Ideas for consideration: Run the statement in stages: Write the SELECT and FROM clauses first 
	and run the statement. Add the ORDER BY clause. Then add the WHERE clause; if it is a compound
	WHERE clause, add piece at a time. Lastly perform the CAST or CONVERT. When the statement is 
	created in steps, it is easier to isolate the error. Check the number of records returned 
	to see if it makes sense.*/

/*  When there are multiple versions of a field, such as EnglishCountryRegionName, 
	SpanishCountryRegionName, FrenchCountryRegionName, use the English version of the field.*/

-- Do not remove the USE statement
USE AdventureWorksDW2012; 

--1.a.	List the names and locations of AdventureWorks customers who are male.   
--		Show customer key, first name, last name, state name, and country name. Order the list  
--		by country name, state name, last name, and first name in alphabetical order.
--		Check your results. Did you get 9,351 records? yep:)


SELECT c.CustomerKey, c.FirstName, c.LastName, g.StateProvinceName, g.EnglishCountryRegionName
FROM [dbo].[DimCustomer] AS c INNER JOIN [dbo].[DimGeography] AS g ON c.GeographyKey = g.GeographyKey
WHERE c.Gender LIKE 'M'
ORDER BY g.EnglishCountryRegionName, g.StateProvinceName, c.LastName, c.FirstName ASC;


--1.b.	Copy/paste the statement from 1.a to 1.b. Modify the WHERE clause in 1.b to show only  
--		those AdventureWorks customers who are female and from the US City of Birmingham. 
--		Show customer key, first name, last name, and city name.
--		Change the sort order to list by last name, then first name in alphabetical order.


SELECT c.CustomerKey, c.FirstName, c.LastName, g.StateProvinceName, g.EnglishCountryRegionName
FROM [dbo].[DimCustomer] AS c INNER JOIN [dbo].[DimGeography] AS g ON c.GeographyKey = g.GeographyKey
WHERE c.Gender LIKE 'F' AND g.City IN ('Birmingham') AND g.EnglishCountryRegionName IN ('United States')
ORDER BY c.LastName, c.FirstName ASC;



--1.c.	Copy/paste statement from 1.b to 1.c. Modify the WHERE clause in 1.c to list only   
--		AdventureWorks customers from the US city of Seattle who are female and have 2 or more cars. 
--		Show customer key, first name, last name, and total number of cars. 
--		Order the list by number of cars in descending order, then by last name and first name 
--		in alphabetical order.


SELECT c.CustomerKey, c.FirstName, c.LastName, g.StateProvinceName, g.EnglishCountryRegionName
FROM [dbo].[DimCustomer] AS c INNER JOIN [dbo].[DimGeography] AS g ON c.GeographyKey = g.GeographyKey
WHERE c.Gender LIKE 'F' AND g.City IN ('Seattle') AND g.EnglishCountryRegionName IN ('United States') AND c.NumberCarsOwned >= 2
ORDER BY NumberCarsOwned DESC, c.LastName, c.FirstName ASC;



--2.a.	Explore the data warehouse using ONLY the DimProduct table. No joins required.
--		Show the English product name, product key, product alternate key, standard cost, list price,
--		and status. Sort on English product name. Notice that some of the products appear to be duplicates. 
--		The name and the alternate key remain the same but the product is added again with a new product  
--		key to track the history of changes to the product attributes. For example, look at AWC Logo Cap. 
--		Notice the history of changes to StandardCost and ListPrice and to the value in the Status field.


SELECT EnglishProductName, ProductKey, ProductAlternateKey, StandardCost, ListPrice, Status
FROM [dbo].[DimProduct]
ORDER BY EnglishProductName ASC;



--2.b.	Write two SELECT statements (no joins required) using the DimProduct table and write down  
--		the row count returned when you run the statement in the place below where you see "List row count..." 
--		1. Show the product key, English product name, and product alternate key for each product only once.
--		Sort on English product name.
--		2. Show the English product name and product alternate key for each product only once. Sort on English product
--		name. Recall terms like “only once”, “one time”, and "unique" all indicate the need for the DISTINCT keyword.
--		(1) List row count for the results set for 1. 606 rows
--		(2) List row count for the results set for 2. 504 rows



SELECT DISTINCT ProductKey, EnglishProductName, ProductAlternateKey
FROM [dbo].[DimProduct]
ORDER BY EnglishProductName ASC;


SELECT DISTINCT EnglishProductName, ProductAlternateKey
FROM [dbo].[DimProduct]
ORDER BY EnglishProductName ASC;



--2.c.	Join tables to the product table to also show the category and subcategory name for each product.
--		Show the English category name, English subcategory name, English product name, and product alternate key
--		only once. Sort the results by the English category name, English subcategory name,  
--		and English product name. The record count will decrease to 295. Some products in the product  
--		table are inventory and not for sale. They don't have a value in the ProductSubcategory field and 
--		are removed from the results set by the INNER JOIN. We will explore this more in OUTER JOINs.


SELECT DISTINCT pc.EnglishProductCategoryName, ps.ProductSubcategoryAlternateKey, p.EnglishProductName, p.ProductAlternateKey
FROM [dbo].[DimProduct] AS p INNER JOIN [dbo].[DimProductSubcategory] AS ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey INNER JOIN [dbo].[DimProductCategory] AS pc ON pc.ProductCategoryKey = ps.ProductCategoryKey;



--3.a.	List the English name for products purchased over the Internet by customers who indicate education  
--		as high school or partial high school. Show Product key and English Product Name and English Education.   
--		Order the list by English Product name. Show a product only once even if it has been purchased several times.   
--		We are not interested in the customer names because we are looking only at the broad demographics of buyers.



SELECT DISTINCT p.ProductKey, p.EnglishProductName, c.EnglishEducation
FROM [dbo].[DimProduct] AS p INNER JOIN [dbo].[FactInternetSales] AS fis ON p.ProductKey = fis.ProductKey INNER JOIN [dbo].[DimCustomer] AS c ON c.CustomerKey = fis.CustomerKey
WHERE c.EnglishEducation LIKE 'high school' OR c.EnglishEducation LIKE 'partial high school'
ORDER BY p.EnglishProductName ASC;




--3.b.	List the English name for products purchased over the Internet by customers who indicate 
--		high school or partial high school, or partial college. Show Product key and English Product Name   
--		and English Education. Order the list by English Product name and then by English Education.
--		Show a product only once even if it has been purchased several times. 


SELECT DISTINCT p.ProductKey, p.EnglishProductName, c.EnglishEducation
FROM [dbo].[DimProduct] AS p INNER JOIN [dbo].[FactInternetSales] AS fis ON p.ProductKey = fis.ProductKey INNER JOIN [dbo].[DimCustomer] AS c ON c.CustomerKey = fis.CustomerKey
WHERE c.EnglishEducation LIKE 'high school' OR c.EnglishEducation LIKE 'partial high school' OR c.EnglishEducation LIKE 'partial college'
ORDER BY p.EnglishProductName ASC;



--4.	List the English name for products purchased over the Internet by customers who work in clerical,  
--		manual, or skilled manual occupations. Show Product key and English Product Name and English Occupation. 
--		Add a meaningful sort. In this example, show a product each time it was purchased, even if it was purchased 
--		multiple times.


SELECT p.ProductKey, p.EnglishProductName, c.EnglishOccupation
FROM [dbo].[DimProduct] AS p INNER JOIN [dbo].[FactInternetSales] AS fis ON p.ProductKey = fis.ProductKey INNER JOIN [dbo].[DimCustomer] AS c ON c.CustomerKey = fis.CustomerKey
WHERE c.EnglishOccupation LIKE 'clerical' OR c.EnglishOccupation LIKE 'manual' OR c.EnglishOccupation LIKE 'skilled manual'
ORDER BY p.EnglishProductName ASC;




--	Question 5 contains exploratory questions. You may wish to read all three questions before beginning. 
--	Seeing the purpose of the questions may help understand the requests. 

--5.a.	List customers who have purchased clothing over the Internet.  Show the customer first name, 
--		last name, and English product category. If a customer has purchased clothing items more than once,
--		show only one row for that customer. This means that the customer should not appear twice.
--		order the list by last name, then first name. 

--		Did you return 6,839 records in your results set? yep

SELECT DISTINCT c.FirstName, c.LastName, pc.EnglishProductCategoryName
FROM [dbo].[DimProduct] AS p INNER JOIN [dbo].[FactInternetSales] AS fis ON p.ProductKey = fis.ProductKey INNER JOIN [dbo].[DimCustomer] AS c ON c.CustomerKey = fis.CustomerKey INNER JOIN [dbo].[DimProductSubcategory] AS psc ON psc.ProductSubcategoryKey = p.ProductSubcategoryKey INNER JOIN [dbo].[DimProductCategory] AS pc ON pc.ProductCategoryKey = psc.ProductCategoryKey
WHERE pc.ProductCategoryKey = 3
ORDER BY c.LastName, c.FirstName ASC;



--5.b.	Copy/paste 5.a to 5.b and modify 5.b.  This time show the customer id, first name, last name, and English 
--		product category. Like before, if a customer has purchased clothing more than once, show only one row for that customer.
--		This means that the customer should not appear twice. Order the list by last name, then first name. 

--		Consider: How do your 5a and 5b record numbers differ?  Why do they differ? This received 6852 records opposed to 6839. This means that there were name duplicates beforehand that bought clothing, but were actually different people with different customer ID's. 
--		Which version of the code would be more accurate?  5a or 5b? 5b is more accurate for the reason above.


SELECT DISTINCT c.CustomerKey, c.FirstName, c.LastName, pc.EnglishProductCategoryName
FROM [dbo].[DimProduct] AS p INNER JOIN [dbo].[FactInternetSales] AS fis ON p.ProductKey = fis.ProductKey INNER JOIN [dbo].[DimCustomer] AS c ON c.CustomerKey = fis.CustomerKey INNER JOIN [dbo].[DimProductSubcategory] AS psc ON psc.ProductSubcategoryKey = p.ProductSubcategoryKey INNER JOIN [dbo].[DimProductCategory] AS pc ON pc.ProductCategoryKey = psc.ProductCategoryKey
WHERE pc.ProductCategoryKey = 3
ORDER BY c.LastName, c.FirstName ASC;

 


--6.	List all Internet sales for accessories that occurred during 2008 (Order Date in 2008).  
--		Show Order date, product key, product name, and sales amount for each line item sale.
--		Show the date as mm/dd/yyyy as DateOfOrder. Use CONVERT and look up the style code.
--		Show the list in oldest to newest order by date and alphabetically by product name.
--		21,067 Rows: got it


SELECT CONVERT(VARCHAR, OrderDate, 101) AS DateOfOrder, p.ProductKey, p.EnglishProductName, fis.SalesAmount
FROM [dbo].[DimProduct] AS p INNER JOIN [dbo].[FactInternetSales] AS fis ON p.ProductKey = fis.ProductKey INNER JOIN [dbo].[DimCustomer] AS c ON c.CustomerKey = fis.CustomerKey INNER JOIN [dbo].[DimProductSubcategory] AS psc ON psc.ProductSubcategoryKey = p.ProductSubcategoryKey INNER JOIN [dbo].[DimProductCategory] AS pc ON pc.ProductCategoryKey = psc.ProductCategoryKey
WHERE fis.OrderDate BETWEEN '2008-01-01'AND '2008-12-31' AND pc.ProductCategoryKey = 4
ORDER BY DateOfOrder, p.EnglishProductName ASC;



--*  BUSIT 103           Assignment   #9              DUE DATE :  Consult course calendar
							
-- You are to develop SQL statements for each task listed.  
-- You should type your SQL statements under each task.  


--	Do not remove the USE statement.
USE AdventureWorksDW2012;

-- Note 1:  When the task does not specify sort order, it is your responsibility to order the  
-- information so that is easy to interpret and add an alias to any columns without a name.

-- Note 2:  When asked to calculate an average or a count, for example, and then write a statement
-- using that value, be sure you are using the subquery and not hard coding the value.  

-- Note 3:  The questions are numbered. 1.a., 1.b., 2.a., 2.b., etc., to remind you of the steps in 
-- developing and testing your queries/subqueries. The first steps will not require subqueries 
-- unless specified. The last step in every sequence will require a subquery, regardless of
-- whether the result can be created using another method, unless otherwise specified. 

--1.	Read all of the requests for question 1 before beginning. Instructions in later requests
--		may answer questions about earlier requests. The joins are not complex but the WHERE is.

--1.a.	List the ProductKey, ProductAlternateKey, ProductSubcategoryKey, EnglishProductName, 
--		FinishedGoodsFlag, Color, ListPrice, Size, Class, StartDate, EndDate, and Status for all 
--		current products. One table only. Look at the results and pay attention to the values in 
--		the fields. Understanding the data will help you make decisions about your filters in the 
--		following statements. You will want to find simple filters that are sustainable--will still  
--		work when the data set grows. Be sure to add a meaningful sort. Hint: Don't know how 
--		to find current products? Run the statement with the WHERE and look for current.

----- Records: 406


SELECT ProductKey, ProductAlternateKey, ProductSubcategoryKey, EnglishProductName, FinishedGoodsFlag, Color, ListPrice, Size, Class, StartDate, EndDate, Status
FROM [dbo].[DimProduct]
WHERE Status IS NOT NULL
ORDER BY ProductKey, ProductAlternateKey, EnglishProductName ASC;


-- 1.b. List the distinct ProductKey for products sold to Resellers. (One table, one field, many rows)
--		No sort needed. Here you need to understand in which table sales to Resellers are stored.

----- Records: 334


SELECT DISTINCT p.ProductKey
FROM [dbo].[DimProduct] AS p INNER JOIN [dbo].[FactResellerSales] AS frs ON p.ProductKey = frs.ProductKey INNER JOIN [dbo].[DimReseller] AS r ON r.ResellerKey = frs.ResellerKey;


-- 1.c. Using an Outer Join find current Products that have not been sold to Resellers. Show Product
--		Key and the English Product Name. Add a meaningful sort.

----- Records: 239


SELECT DISTINCT p.ProductKey, p.EnglishProductName
FROM [dbo].[FactResellerSales] AS frs RIGHT OUTER JOIN [dbo].[DimProduct] AS p ON frs.ProductKey = p.ProductKey 
WHERE p.Status IS NOT NULL AND frs.ProductKey IS NULL
ORDER BY EnglishProductName, ProductKey ASC;


--1.d.  Using the Outer Join from 1.c. find all current products have not been sold to Resellers 
--		and are for sale (they are not inventory). Show Product Key, the English Product Name, and the  
--		field(s) you used to find products that are for sale. Add a meaningful sort. Recall that inventory   
--		was talked about in Assignment 7, Question 2c. There are several ways to find products that are   
--		for sale. Pick a method that works and makes sense to you. Include a comment about why 
--		you chose the method you did.  

----- Records: 30

SELECT p.ProductKey, p.EnglishProductName, ps.ProductSubcategoryKey
FROM [dbo].[FactResellerSales] AS frs RIGHT OUTER JOIN [dbo].[DimProduct] AS p ON frs.ProductKey = p.ProductKey INNER JOIN [dbo].[DimProductSubcategory] AS ps ON p.ProductSubcategoryKey = ps.ProductSubCategoryKey
WHERE p.Status IS NOT NULL AND frs.ProductKey IS NULL AND ps.ProductSubcategoryKey IS NOT NULL
ORDER BY p.EnglishProductName, p.ProductKey ASC;


--1.e.  Rewrite the Outer Join from 1d as a subquery to find all current Products that are for sale and   
--		have not been sold to Resellers. HINT: Review 1a and 1b. There will be no joins in the statement for 1e.  
--		1b will be used as a subquery in the WHERE clause to return a list. You want to find product keys that 
--		are not in that list and are for sale. This statement is likely simpler than you think it should be. 

----- Records: 30

SELECT DISTINCT ProductKey, EnglishProductName
FROM [dbo].[DimProduct] 
WHERE ProductKey NOT IN 
	(SELECT DISTINCT ProductKey
	FROM FactResellerSales) 
AND Status IS NOT NULL AND ProductSubcategoryKey IS NOT NULL
ORDER BY EnglishProductName, ProductKey ASC;

-- 2.a.	List the average listprice of accessory items for sale by AdventureWorks. No sort  
--		needed. Remember to provide a column alias. Use the AVG function.

----- Records: 1
----- 34.2281

SELECT AVG(ListPrice) AS AvgListPrice
FROM [dbo].[DimProduct] AS p INNER JOIN [dbo].[DimProductSubcategory] AS ps ON p.ProductSubCategoryKey = ps.ProductSubcategoryKey
WHERE ps.ProductCategoryKey = 4


-- 2.b. List the products in the Accessory category that have a listprice higher than the average
--		listprice of Accessory items.  Show product alternate key, product name, and listprice in the
--		results set. Order the information so it is easy to understand. Be sure 
--		to use a subquery; do not enter the actual value from 2.a. into the statement.

----- Records: 10

SELECT ProductAlternateKey, EnglishProductName, ListPrice
FROM [dbo].[DimProduct]
WHERE ListPrice >= (
	SELECT AVG(ListPrice) AS AvgListPrice
	FROM [dbo].[DimProduct] AS p INNER JOIN [dbo].[DimProductSubcategory] AS ps ON p.ProductSubCategoryKey = ps.ProductSubcategoryKey
	WHERE ps.ProductCategoryKey = 4
	)
AND ProductSubCategoryKey BETWEEN 26 AND 37
ORDER BY EnglishProductName, ProductAlternateKey, ListPrice ASC;

-- 3.a. Find the average yearly income of all houseowners in the customer table. 

----- Records: 1
----- 58326.6677


SELECT AVG(YearlyIncome) AS AvgYearlyIncome 
FROM [dbo].[DimCustomer]
WHERE HouseOwnerFlag = 1;


-- 3.b. Find all houseowners in the customers table with an income less than or the same as  
--		the average income of all customers. List last name, a comma and space, and first name in 
--		one column, the customer key, and yearly income. There will be three columns in the Results 
--		set. Be sure to use a subquery; do not enter the actual value from 3.a. into the statement.

----- Records: 5,513


SELECT LastName + ', ' + FirstName AS FullName, CustomerKey, YearlyIncome
FROM [dbo].[DimCustomer]
WHERE YearlyIncome <= (
	SELECT AVG(YearlyIncome) AS AvgYearlyIncome 
	FROM [dbo].[DimCustomer]
	)
AND HouseOwnerFlag = 1
ORDER BY LastName, FirstName, CustomerKey ASC;


-- 4.a.	List the product name and list price for the bike named Road-150 Red, 62

----- Records: 1

SELECT EnglishProductName, ListPrice
FROM [dbo].[DimProduct]
WHERE EnglishProductName LIKE 'Road-150 Red, 62';


-- 4.b.	List the product name and price for each bike that has a price greater than or equal to
--	    that of the Road-150 Red, 62. Be sure you are using the subquery not an actual value.

----- Records: 5


SELECT EnglishProductName, ListPrice
FROM [dbo].[DimProduct] AS p INNER JOIN [dbo].[DimProductSubcategory] AS ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
WHERE ListPrice >= (
	SELECT ListPrice
	FROM [dbo].[DimProduct]
	WHERE EnglishProductName LIKE 'Road-150 Red, 62'
	)
AND ps.ProductCategoryKey = 1
ORDER BY EnglishProductName, ListPrice ASC;


-- 5.a.	Find the average of total children for all customers.
--		Use the Average function and provide an appropriate alias. 

----- Records: 1


SELECT AVG(TotalChildren) AS AvgTotalChildren
FROM [dbo].[DimCustomer];


-- 5.b.	Use a correlated subquery to find customers who have more children than the  
--		average for customers in their same occupation. List customer key, last name, 
--		first name, total children, and English occupation. Add a meaningful sort.
--		In a correlated subquery the inner query is dependent on the outer query for its value.
--		There is an example of a similar request in the Subqueries demo file. 

----- Records: 7,898


SELECT CustomerKey, LastName, FirstName, TotalChildren, EnglishOccupation
FROM [dbo].[DimCustomer] AS c1
WHERE TotalChildren > (
	SELECT AVG(TotalChildren)
	FROM [dbo].[DimCustomer] AS c2
	WHERE c1.EnglishOccupation = c2.EnglishOccupation
	)
ORDER BY EnglishOccupation, LastName, FirstName, CustomerKey, TotalChildren ASC;


-- 6.	List resellers of any business type who have annual sales above the average  
--		annual sales for resellers whose Business Type is "Warehouse". Show Business type, 
--		Reseller Name, and annual sales. Use appropriate subqueries. 

----- Records: 204


SELECT BusinessType, ResellerName, AnnualSales
FROM [dbo].[DimReseller]
WHERE AnnualSales > (
	SELECT AVG(AnnualSales)
	FROM [dbo].[DimReseller]
	WHERE BusinessType LIKE 'Warehouse'
	)
;
------------------------------------------------------------------------------------------------------------
------------- BUSIT 103 Final Exam Fall 2018 ---------------------------------------------------------------
------------- 30 points						 ---------------------------------------------------------------
------------- Due as posted in Canvas		 ---------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

-- All result-answers should be display with a single query statement
-- (not multiple statements)

-- Question 1 is worth 6 points
-- All other questions are worth 3 points each.

-- Use the following database for the following questions:
use [AdventureWorksDW2012];

-- You are amazing and most excellent! Go forth with peaceful mental clarity.
-- Check in with me if you have questions.


----------------------------------------------------------------------------------------------------------
-- 1.	For this first question - and only this first question - I am asking you to research, learn and use 
--		what is called a "self-join." There are many videos and tutorials that demonstrate "self-joins"
--		and I would like you to find one and mimic the code in order to answer this question.

--		You may have noticed, when creating diagrams, that some tables have a join line that connects into 
--		itself. This is because there is a relationship between two fields within the same table.

--		This is the case with the DimEmployee table. This table lists all employees by EmployeeKey. However, 
--		notice that each employee record has a field for ParentEmployeeKey which lists a value. The value in
--		the ParentEmployeeKey field is actually the EmployeeKey of a different employee in the table that 
--		manages that employee. For example, EmployeeKey=1 is Guy Gilbert. Guy is managed by 
--		ParentEmployeeKey=18 who is Jo Brown.

--		What to dislay ...

--		List the employees and the managers they report to. Again, all data needed is within the DimEmployee 
--		table. Include the EmployeeKey, first name, last name, and then the ParentEmployeeKey, 
--		and corresponding first name, and last name. 
--		
--		Without any sort added, your first record should display as follows:

--		4	Rob	Walters		3	Roberto	Tamburello 

--		This record shows us that Rob is managed by Roberto.

--		Hint: Search for "self-joins." Many of the self-join demos show the same Employee--Manager example.
--		Notice that you will join the table to itself and notice what you will do differntly in your ON statement.
 
--      Include the code you used to determine the answer. 
--		Include a comment with the number of records returned.

--		Records: 295

SELECT a.EmployeeKey, a.FirstName, a.LastName, b.EmployeeKey, b.FirstName, b.LastName
FROM [dbo].[DimEmployee] AS a JOIN [dbo].[DimEmployee] AS b ON a.ParentEmployeeKey = b.EmployeeKey
ORDER BY b.EmployeeKey, a.EmployeeKey ASC;


-----------------------------------------------------------------------------------------------
-- 2.	Find customers who have ordered a product from BOTH the jersey and the vest categories.  
 
--      Include the code you used to determine the answer. 
--		Include a comment with the number of records returned.


--		Records: 34


SELECT DISTINCT c.CustomerKey, c.FirstName, c.LastName
FROM [dbo].[DimCustomer] AS c INNER JOIN [dbo].[FactInternetSales] AS fis ON c.CustomerKey = fis.CustomerKey INNER JOIN [dbo].[DimProduct] AS p ON fis.ProductKey = p.ProductKey INNER JOIN [dbo].[DimProductSubcategory] AS ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
WHERE ps.EnglishProductSubcategoryName LIKE 'jerseys'
INTERSECT
SELECT DISTINCT c.CustomerKey, c.FirstName, c.LastName
FROM [dbo].[DimCustomer] AS c INNER JOIN [dbo].[FactInternetSales] AS fis ON c.CustomerKey = fis.CustomerKey INNER JOIN [dbo].[DimProduct] AS p ON fis.ProductKey = p.ProductKey INNER JOIN [dbo].[DimProductSubcategory] AS ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
WHERE ps.EnglishProductSubcategoryName LIKE 'vests'
ORDER BY c.CustomerKey ASC;


--------------------------------------------------------------------------------
-- 3.	Find customers who have *not* ordered from the tires and tubes category.  
--		Display the customer ID, first name, and last name. 
 
--      Include the code you used to determine the answer. 
--		Include a comment with the number of records returned.

--		Records: 16230


SELECT DISTINCT c.CustomerKey, c.FirstName, c.LastName
FROM [dbo].[DimCustomer] AS c LEFT OUTER JOIN [dbo].[FactInternetSales] AS fis ON c.CustomerKey = fis.CustomerKey INNER JOIN [dbo].[DimProduct] AS p ON p.ProductKey = fis.ProductKey INNER JOIN [dbo].[DimProductSubcategory] AS ps ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey
WHERE ps.EnglishProductSubcategoryName NOT LIKE 'tires and tubes'
ORDER BY c.CustomerKey ASC;


---------------------------------------------------------------------------------
--	4.	Show the price of the cheapest headsets listed, the most expensive headsets
--		listed, and the average list price for headsets. Use one code statement
--		to simultaneously display all three of these data points (three columns).

--      Include the code you used to determine the answer. 
--		Include a comment with the number of records returned.

--		Records: 1 (min=34.20, max=124.73, avg=87.07)


SELECT MIN(p.ListPrice) AS CheapestPrice, MAX(p.ListPrice) AS MostExpensivePrice, CONVERT(decimal(18,2), AVG(p.ListPrice)) AS AvgListPrice
FROM [dbo].[DimProduct] AS p INNER JOIN [dbo].[DimProductSubcategory] AS ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
WHERE ps.EnglishProductSubcategoryName LIKE 'headsets';


----------------------------------------------------------------------------------
--	5.	List all products and the last date each product was ordered via an
--		internet sale.

--      Include the code you used to determine the answer. 
--		Include a comment with the number of records returned.

--		Records 158


SELECT p.ProductKey, p.EnglishProductName, MAX(fis.OrderDate) AS LastPurchasedDate
FROM [dbo].[DimProduct] AS p INNER JOIN [dbo].[FactInternetSales] AS fis ON p.ProductKey = fis.ProductKey
GROUP BY p.ProductKey, p.EnglishProductName
ORDER BY p.ProductKey ASC;


---------------------------------------------------------------------------------------
--  6.	Show the count of customers, by country and by homeownership. 
--		Display english country region name, house owner flag, and the 
--		corresponding count of customers.  

--      Include the code you used to determine the answer. 
--		Include a comment with the number of records returned.

--		Records: 12


SELECT g.EnglishCountryRegionName, c.HouseOwnerFlag, COUNT(c.GeographyKey) AS NumberOfCustomers
FROM [dbo].[DimCustomer] AS c INNER JOIN [dbo].[DimGeography] AS g ON c.GeographyKey = g.GeographyKey
GROUP BY g.EnglishCountryRegionName, c.HouseOwnerFlag
ORDER BY EnglishCountryRegionName, HouseOwnerFlag ASC;


-------------------------------------------------------------------------------
--	7.	Find all employees who have vacation hours that are BELOW the average 
--		number of vacation hours for all employees.  Display the employee key, 
--		first name, last name, and the vacation hours.  Include a comment with 
--		the number of records returned.
 
--      Include the code you used to determine the answer. 
--		Include a comment with the number of records returned.

--		Records: 146


SELECT EmployeeKey, FirstName, LastName, VacationHours
FROM [dbo].[DimEmployee]
WHERE VacationHours < 
	(SELECT AVG(VacationHours) AS AvgVacationHours
	FROM [dbo].[DimEmployee])
GROUP BY EmployeeKey, FirstName, LastName, VacationHours
ORDER BY VacationHours, EmployeeKey ASC;


-------------------------------------------------------------------------------
--	8.	Find all customers whose yearly income is ABOVE the average yearly income 
--		for their level of education.  Display the customer key, first name,
--		last name, english education, and yearly income.  Include a comment 
--		with the number of records returned.  
 
--      Include the code you used to determine the answer. 
--		Include a comment with the number of records returned.

--		Records: 8125


SELECT c1.CustomerKey, c1.FirstName, c1.LastName, c1.EnglishEducation, c1.YearlyIncome
FROM [dbo].[DimCustomer] AS c1
WHERE c1.YearlyIncome > 
	(SELECT AVG(c2.YearlyIncome)
	FROM [dbo].[DimCustomer] AS c2
	WHERE c1.EnglishEducation = c2.EnglishEducation)
GROUP BY CustomerKey, FirstName, LastName, EnglishEducation, YearlyIncome
ORDER BY EnglishEducation, YearlyIncome, CustomerKey ASC;


---------------------------------------------------------------------------------------
--	9.	Show a list of customers who have placed more than 20 orders in a single year.
--		Show the year, customer key, first name, last name, and the number of orders.
 
--      Include the code you used to determine the answer. 
--		Include a comment with the number of records returned.

--		Records: 30

SELECT YEAR(fis.OrderDate) AS YearOfSell, c.CustomerKey, c.FirstName, c.LastName, COUNT(*) AS NumberOfOrdersInYear
FROM [dbo].[FactInternetSales] AS fis INNER JOIN [dbo].[DimCustomer] AS c ON c.CustomerKey = fis.CustomerKey
GROUP BY YEAR(fis.OrderDate), c.CustomerKey, c.FirstName, c.LastName
HAVING COUNT(*) > 20
ORDER BY YearOfSell, NumberOfOrdersInYear, CustomerKey ASC;

----------------------------------------------------------------------------------------
----- End of Final ---------------------------------------------------------------------
----------------------------------------------------------------------------------------
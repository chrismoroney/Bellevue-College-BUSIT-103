--*  BUSIT 103           Assignment   #11              DUE DATE :  Consult course calendar
							
--You are to develop SQL statements for each task listed.  
--You should type your SQL statements under each task.  

--  It is your responsibility to provide a meaningful column name for the return value of the function 
--  and use an appropriate sort order. All joins are to use the ANSI standard syntax.

USE AdventureWorksDW2012;

--1.	AdventureWorks wants geographic information about its resellers.
--		Be sure to add a meaningful sort as appropriate and give each derived column an alias.

--1a.	First check to determine if there are resellers without geography info.


SELECT * 
FROM [dbo].[DimReseller] AS r INNER JOIN [dbo].[DimGeography] AS g ON r.GeographyKey = g.GeographyKey
WHERE r.GeographyKey IS NULL;


--1b.	Display a count of resellers in each Country.
--		Show country name and the count of resellers.


SELECT g.EnglishCountryRegionName, COUNT(*) AS NumberOfResellers
FROM [dbo].[DimReseller] AS r INNER JOIN [dbo].[DimGeography] AS g ON r.GeographyKey = g.GeographyKey
GROUP BY g.EnglishCountryRegionName
ORDER BY NumberOfResellers, g.EnglishCountryRegionName ASC;


--1c.	Display a count of resellers in each City. 
--		Show count of resellers, City name, State name, and Country name.
 

SELECT COUNT(*) AS NumberOFResellers, g.City, g.StateProvinceName, g.EnglishCountryRegionName
FROM [dbo].[DimReseller] AS r INNER JOIN [dbo].[DimGeography] AS g ON r.GeographyKey = g.GeographyKey
GROUP BY g.City, g.StateProvinceName, g.EnglishCountryRegionName
ORDER BY EnglishCountryRegionName, City, StateProvinceName ASC;


--2.	AdventureWorks wants banking and historical information about its resellers.
--		Be sure to add a meaningful sort as appropriate and give each derived column an alias. 

--2a. 	Check to see if there are any resellers without a value in the bank name field.


SELECT *
FROM [dbo].[DimReseller]
WHERE BankName IS NULL


--2b.	List the name of each bank and the number of resellers using that bank.


SELECT BankName, COUNT(*) AS NumberOfResellers
FROM [dbo].[DimReseller]
GROUP BY BankName
ORDER BY NumberOfResellers, BankName ASC;


--2c.	List the year opened and the number of resellers opening in that year.


SELECT YearOpened, COUNT(*) AS NumberOfResellers
FROM [dbo].[DimReseller]
GROUP BY YearOpened
ORDER BY NumberOfResellers, YearOpened ASC;


--2d.	List the order frequency and the number of resellers with that order frequency.


SELECT OrderFrequency, COUNT(*) AS NumberOfResellers
FROM [dbo].[DimReseller]
GROUP BY OrderFrequency
ORDER BY NumberOfResellers, OrderFrequency ASC;


--2e.	List the average number of employees in each of the three business types.


SELECT BusinessType, AVG(NumberEmployees) AS AvgNumberEmployees
FROM [dbo].[DimReseller]
GROUP BY BusinessType
ORDER BY AvgNumberEmployees, BusinessType ASC;


--2f.	List business type, the count of resellers in that type, and average of Annual Revenue 
--		in that business type. 


SELECT BusinessType, COUNT(*) AS NumberOfResellers, AVG(AnnualRevenue) AS AvgAnnualRevenue
FROM [dbo].[DimReseller]
GROUP BY BusinessType
ORDER BY AvgAnnualRevenue, NumberOfResellers, BusinessType ASC;


--3.	AdventureWorks wants information about sales to its resellers. Be sure to add a 
--		meaningful sort and give each derived column an alias. Remember that Annual Revenue 
--		is a measure of the size of the business and is NOT the total of the AdventureWorks 
--		products sold to the reseller. Be sure to use SalesAmount when total sales are 
--		requested.

--3a. 	List the name of any reseller to which AdventureWorks has not sold a product. 
--		Hint: Use a join.


SELECT r.ResellerName
FROM [dbo].[DimReseller] AS r LEFT OUTER JOIN [dbo].[FactResellerSales] AS rs ON r.ResellerKey = rs.ResellerKey
WHERE rs.ResellerKey IS NULL
ORDER BY ResellerName;


--3b.	List ALL resellers and total of sales amount to each reseller. Show Reseller 
--		name, business type, and total sales with the sales showing two decimal places. 		
--		Be sure to include resellers for which there were no sales. NULL will appear.


SELECT r.ResellerName, r.BusinessType, CAST(SUM(rs.SalesAmount) AS DECIMAL (9,2)) AS TotalSalesAmount
FROM [dbo].[DimReseller] AS r LEFT OUTER JOIN [dbo].[FactResellerSales] AS rs ON r.ResellerKey = rs.ResellerKey
GROUP BY r.ResellerName, r.BusinessType
ORDER BY BusinessType, ResellerName, TotalSalesAmount ASC;

--3c.	List resellers and total sales to each.  Show reseller name, business type, and total sales 
--		with the sales showing two decimal places. Limit the results to resellers to which 
--		total sales are less than $500 and greater than $500,000.


SELECT r.ResellerName, r.BusinessType, CAST(SUM(rs.SalesAmount) AS DECIMAL (9,2)) AS TotalSalesAmount
FROM [dbo].[DimReseller] AS r LEFT OUTER JOIN [dbo].[FactResellerSales] AS rs ON r.ResellerKey = rs.ResellerKey
GROUP BY r.ResellerName, r.BusinessType
HAVING CAST(SUM(rs.SalesAmount) AS DECIMAL (9,2)) < 500 OR CAST(SUM(rs.SalesAmount) AS DECIMAL (9,2)) > 500000
ORDER BY TotalSalesAmount, ResellerName, BusinessType ASC;



--3d.	List resellers and total sales to each for 2008.  
--		Show Reseller name, business type, and total sales with the sales showing two decimal places.
--		Limit the results to resellers to which total sales are between $5,000 and $7,500 and between 
--		$50,000 and $75,000


SELECT r.ResellerName, r.BusinessType, CAST(SUM(rs.SalesAmount) AS DECIMAL (9,2)) AS TotalSalesAmount
FROM [dbo].[DimReseller] AS r LEFT OUTER JOIN [dbo].[FactResellerSales] AS rs ON r.ResellerKey = rs.ResellerKey
WHERE rs.OrderDate BETWEEN '2008-01-01' AND '2008-12-31'
GROUP BY r.ResellerName, r.BusinessType
HAVING CAST(SUM(rs.SalesAmount) AS DECIMAL (9,2)) BETWEEN 5000 AND 7500 OR CAST(SUM(rs.SalesAmount) AS DECIMAL (9,2)) BETWEEN 50000 AND 75000
ORDER BY TotalSalesAmount, ResellerName, BusinessType ASC;


--4.	AdventureWorks wants information about the demographics of its customers.
--		Be sure to add a meaningful sort as appropriate and give each derived column an alias. 

--4a.	List customer education level (use EnglishEducation) and the number of customers reporting
--		each level of education.


SELECT EnglishEducation, COUNT(*) AS NumberPerEducationLevel
FROM [dbo].[DimCustomer]
GROUP BY EnglishEducation
ORDER BY NumberPerEducationLevel, EnglishEducation ASC;


--4b.	List customer education level (use EnglishEducation), the number of customers reporting
--		each level of education, and the average yearly income for each level of education.
--		Show the average income rounded to two (2) decimal places. 


SELECT EnglishEducation, COUNT(*) AS NumberPerEducationLevel, CAST(AVG(YearlyIncome) AS DECIMAL (9,2)) AS AvgYearlyIncome
FROM [dbo].[DimCustomer]
GROUP BY EnglishEducation
ORDER BY AvgYearlyIncome, NumberPerEducationLevel, EnglishEducation ASC;


--5.	List all customers and the most recent date on which they placed an order (2 fields). Show the  
--		customer's first name, middle name, and last name in one column with a space between each part of the  
--		name. No name should show NULL - use the CONCAT function so that no names displays as NULL. 
--		Show the date of the most recent order as mm/dd/yyyy. 
--		Make sure you do not miss any customers. If you need to add one more field to the SELECT 
--		or the GROUP BY clause, go ahead. 


SELECT c.CustomerKey, CONCAT(FirstName, ' ', MiddleName, ' ', LastName) AS FullName, CONVERT(nvarchar, MAX(OrderDate), 101) AS MostRecentOrderDate
FROM [dbo].[DimCustomer] AS c LEFT OUTER JOIN [dbo].[FactInternetSales] AS fis ON c.CustomerKey = fis.CustomerKey
GROUP BY c.CustomerKey, c.FirstName, c.MiddleName, c.LastName
ORDER BY c.LastName, c.FirstName, c.MiddleName, MostRecentOrderDate, c.CustomerKey;



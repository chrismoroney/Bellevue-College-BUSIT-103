--*  BUSIT 103           Assignment   #8              DUE DATE:  Consult course calendar
							
--You are to develop SQL statements for each task listed.  
--You should type your SQL statements under each task.  



/*	Ideas for consideration: Run the statement in stages: Write the SELECT and FROM clauses first 
	and run the statement. Add the ORDER BY clause. Then add the WHERE clause; if it is a compound
	WHERE clause, add piece at a time. Remember that the order in which the joins are processed does make 
	a difference with OUTER JOINs. 

	PLEASE NOTE:
	You will not use Cross-Joins, Full Outer Joins, or Unions in the required exercises. All are to be 
	accomplished with outer joins or a combination of outer and inner joins using ANSI standard Join syntax. */

--	Do not remove the USE statement
USE AdventureWorksDW2012; 


--NOTE:	When the task does not specify sort order, it is your responsibility to order the information
--		so that is easy to interpret. 

--1.	List the name of ALL products and the name of the product subcategory to which the
--		product belongs. Sort on product subcategory name and product name. 

----- Records: 606


SELECT p.EnglishProductName, ps.EnglishProductSubcategoryName
FROM [dbo].[DimProduct] AS p LEFT OUTER JOIN [dbo].[DimProductSubcategory] AS ps ON p.ProductSubCategoryKey = ps.ProductSubcategoryKey
ORDER BY ps.EnglishProductSubcategoryName, p.EnglishProductName ASC;


--2.	List the name of all Sales Reasons that have not been associated with a sale. Add a meaningful 
--		sort. Explanation: AdventureWorks has a prepopulated list of reasons why customers purchase their 
--		products. You are finding the reasons on the list that have not been selected by a customer buying 
--		over the Internet. Hint:  Use DimSalesReason and FactInternetSalesReason 
--		and test for null in the matching field in the fact table.  

----- Records: 3

SELECT sr.SalesReasonName
FROM [dbo].[DimSalesReason] AS sr LEFT OUTER JOIN [dbo].[FactInternetSalesReason] AS fisr ON sr.SalesReasonKey = fisr.SalesReasonKey
WHERE fisr.SalesReasonKey IS NULL
ORDER BY fisr.SalesReasonKey ASC; 


--3.	List all internet sales that do not have a sales reason associated. List SalesOrderNumber, 
--		SalesOrderLineNumber and the order date. Add a meaningful sort.
--		Explanation: Now we are looking at sales reasons from another angle. Above we wanted to know which 
--		sales reasons had not been used, so we wanted the reason name. Now we are looking at which sales do not 
--		have a reason associated with the sale. Since we are looking at the sales, we don't need the reason name 
--		and the corresponding link to that table. Hint:  Use FactInternetSales and FactInternetSalesReason. 

----- Records: 6,429


SELECT fis.SalesOrderNumber, fis.SalesOrderLineNumber, fis.OrderDate
FROM [dbo].[FactInternetSales] AS fis LEFT OUTER JOIN [dbo].[FactInternetSalesReason] AS fisr ON fis.SalesOrderNumber = fisr.SalesOrderNumber
WHERE fisr.SalesReasonKey IS NULL
ORDER BY SalesOrderNumber, OrderDate ASC;


--4.a.	List all promotions that have not been associated with a reseller sale. Show only
--		the English promotion name in alphabetical order.
--		Hint: Recall that details about sales to resellers are recorded in the FactResellerSales table.

----- Records: 4

SELECT p.EnglishPromotionName
FROM [dbo].[DimPromotion] AS p LEFT OUTER JOIN [dbo].[FactResellerSales] AS frs ON p.PromotionKey = frs.PromotionKey
WHERE frs.PromotionKey IS NULL
ORDER BY p.EnglishPromotionName ASC;


--4.b.	List all promotions that have not been associated with an internet sale. Show only
--		the English promotion name in alphabetical order.
--		Hint: Recall that details about sales to customers are recorded in the FactInternetSales table.

----- Records: 12


SELECT p.EnglishPromotionName
FROM [dbo].[DimPromotion] AS p LEFT OUTER JOIN [dbo].[FactInternetSales] AS fis ON p.PromotionKey = fis.PromotionKey
WHERE fis.PromotionKey IS NULL
ORDER BY p.EnglishPromotionName ASC;



--5.a.	Find any PostalCodes in which AdventureWorks has no internet customers.
--		List Postal Code and the English country/region name.
--		List each Postal Code only one time. Sort by country and postal code.

----- Records: 317


SELECT DISTINCT g.PostalCode, g.EnglishCountryRegionName
FROM [dbo].[DimGeography] AS g LEFT OUTER JOIN [dbo].[DimCustomer] AS c ON g.GeographyKey = c.GeographyKey
WHERE c.CustomerKey IS NULL
ORDER BY g.EnglishCountryRegionName, g.PostalCode;



--5.b	Find any PostalCodes in which AdventureWorks has no resellers.
--		List Postal Code and the English country/region name.
--		List each Postal Code only one time. Sort by country and postal code.


----- Records: 141


SELECT DISTINCT g.PostalCode, g.EnglishCountryRegionName
FROM [dbo].[DimGeography] AS g LEFT OUTER JOIN [dbo].[DimReseller] AS r ON g.GeographyKey = r.GeographyKey
WHERE r.ResellerKey IS NULL
ORDER BY g.EnglishCountryRegionName, g.PostalCode;



--6.a.	List the name of all currencies and the name of each organization that uses that currency.
--		You will use an Outer Join to list the name of each currency in the Currency table regardless if
--		it has a matching value in the Organization table. You will see NULL in many rows. Add a 
--		meaningful sort. Hint: Use DimCurrency and DimOrganization. 

----- Records: 115


SELECT c.CurrencyName, o.OrganizationName
FROM [dbo].[DimCurrency] AS c LEFT OUTER JOIN [dbo].[DimOrganization] AS o ON c.CurrencyKey = o.CurrencyKey
ORDER BY c.CurrencyName, OrganizationName ASC;


--6.b.  List the name of all currencies that are NOT used by any organization. In this situation 
--		we are using the statement from 6.a. and making a few modifications. We want to find the
--		currencies that do not have a match in the common field in the Organization table. 
--		Sort ascending on currency name. 

----- Records: 101


SELECT c.CurrencyName, o.OrganizationName
FROM [dbo].[DimCurrency] AS c LEFT OUTER JOIN [dbo].[DimOrganization] AS o ON c.CurrencyKey = o.CurrencyKey
WHERE o.OrganizationName IS NULL
ORDER BY c.CurrencyName, OrganizationName ASC;


--7.a.	List the unique name of all currencies and the CustomerKey of customers that use that 
--		currency. You will list the name of each currency in the Currency table regardless if
--		it has a matching value in the Internet Sales table. You will see some currencies are repeated
--		because more than one customer uses the currency. You may see the CustomerKey repeated because
--		a customer may buy in more than one currency. You will see NULL in a few rows. Add a 
--		meaningful sort. Hint: This will be all customers, with some duplicated, and the unused
--		currencies.

----- Records: 18,983


SELECT DISTINCT c.CurrencyName, fis.CustomerKey
FROM [dbo].[DimCurrency] AS c LEFT OUTER JOIN [dbo].[FactInternetSales] AS fis ON c.CurrencyKey = fis.CurrencyKey
ORDER BY c.CurrencyName, fis.CustomerKey ASC;


--7.b.	Copy/paste 7.a. to 7.b. Modify 7.b. to list only the unique name of currencies that are not used 
--		by any internet customer. Add a meaningful sort. This will be a small number--just unused currencies.
		
----- Records: 99


SELECT DISTINCT c.CurrencyName, fis.CustomerKey
FROM [dbo].[DimCurrency] AS c LEFT OUTER JOIN [dbo].[FactInternetSales] AS fis ON c.CurrencyKey = fis.CurrencyKey
WHERE fis.CustomerKey IS NULL
ORDER BY c.CurrencyName, fis.CustomerKey ASC;



--7.c.	This question is a variation on 7.a. 
--		List the unique name of all currencies, the last name, first name, and the CustomerKey 
--		of customers that use that currency. You will list the name of each currency in the Currency table 
--		regardless if it has a matching value in the Internet Sales table. Same number of rows as 7.a.

----- Records: 18,983


SELECT DISTINCT c.CurrencyName, cust.LastName, cust.FirstName, fis.CustomerKey
from ([dbo].[FactInternetSales] AS fis INNER JOIN [dbo].[DimCustomer] AS cust ON cust.CustomerKey = fis.CustomerKey) RIGHT OUTER JOIN [dbo].[DimCurrency] AS c ON c.CurrencyKey = fis.CurrencyKey
ORDER BY c.CurrencyName, cust.LastName, cust.FirstName, fis.CustomerKey ASC;


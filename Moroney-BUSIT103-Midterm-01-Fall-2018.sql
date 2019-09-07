-------------------------------------------------------------------
------------- BUSIT 103 Midterm 1		---------------------------
------------- Part 2 of 2				---------------------------
------------- Due as posted in Canvas	---------------------------
-------------------------------------------------------------------

-- Use WideWorldImporters for all questions.

use [WideWorldImporters];

-- Note that the Midterm Part 1 of 2 is worth 10 points
-- This midterm file, Part 2 of 2, is worth 20 points.
-- Together both parts are worth 30 points, as posted.  


---------------------------------------------------------------------------------
-- 1.	Write a SELECT statement that displays all fields and records for the Sales.Customer table. 
--		In your SELECT list each of the fields in the table (i.e. do NOT simply use SELECT *).
--		1 point.


SELECT CustomerID, CustomerName, BillToCustomerId, CustomerCategoryID, BuyingGroupID, PrimaryContactPersonID, AlternateContactPersonID, DeliveryMethodID, DeliveryCityID, 
PostalCityID, CreditLimit, AccountOpenedDate, StandardDiscountPercentage, IsStatementSent, IsOnCreditHold, PaymentDays, PhoneNumber, FaxNumber, DeliveryRun, 
RunPosition, WebsiteURL, DeliveryAddressLine1, DeliveryAddressLine2, DeliveryPostalCode, DeliveryLocation, PostalAddressLine1, PostalAddressLine2, DeliveryPostalCode, LastEditedBy, 
ValidFrom, ValidTo 
FROM [Sales].[Customers];


---------------------------------------------------------------------------------
-- 2.	Develop a display message for customers, displayed all in one column, 
--		structured as follows:
--
--			Welcome back, Aakriti Byrraju. Your current credit limit is: 3500.00
--
--		If a customer has no credit limit, use the ISNULL() function to 
--		display (Pending) instead, as in this example:
--
--			Welcome back, Wingtip Toys (Yaak, MT). Your current credit limit is: (Pending)

--		4 points. 



SELECT 'Welcome back, ' + CustomerName + '. ' + 'Your current credit limit is: ' + ISNULL(CAST(CreditLimit AS nvarchar), '(Pending)')
FROM [Sales].[Customers];


---------------------------------------------------------------------------------
-- 3.	Display a list of all of the products that are chocolate.

--		3 points.

SELECT *
FROM [Warehouse].[StockItems]
WHERE StockItemName LIKE '%chocolate%'
ORDER BY StockItemID ASC;

---------------------------------------------------------------------------------
-- 4.	Display the product IDs for all of the products that are clothing.

--		3 points.

SELECT * 
FROM [Warehouse].[StockItems]
WHERE SupplierID = 4;

---------------------------------------------------------------------------------
-- 5.	Show all of the J,K, and L stock bin locations that have 
--		reorder levels at 5 or less.

--		4 points.

SELECT *
FROM [Warehouse].[StockItemHoldings]
WHERE BinLocation BETWEEN 'J' AND 'M' AND ReorderLevel <= 5
ORDER BY BinLocation ASC;


----------------------------------------------------------------------------------------
-- 6.	Though Wide World Importers has over 600 customers, they have multiple customers
--		in the same delivery zip code. Display the list of each of the customer 
--		delivery zip codes without showing the duplicates.

--		2 points.

SELECT DISTINCT DeliveryPostalCode
FROM [Sales].[Customers]
ORDER BY DeliveryPostalCode ASC;



-----------------------------------------------------------------------------------------
-- 7.	Show the sales orders that were placed in the month of December in 2014 and 2015.

--		3 points.

SELECT *
FROM [Sales].[Orders]
WHERE OrderDate BETWEEN '2014-12-01' AND '2015-12-01'
ORDER BY OrderDate ASC;

------------------------------------------------------------------------------------------
----- End of Assignment ------------------------------------------------------------------
------------------------------------------------------------------------------------------
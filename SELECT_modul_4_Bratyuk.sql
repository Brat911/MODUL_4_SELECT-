USE SalesOrders
GO


------------------------------------  1
SELECT CustCIty FROM Customers ;

------------------------------------  2

SELECT EmpFirstName, EmpLastName, EmpPhoneNumber FROM Employees ;

------------------------------------  3

SELECT * FROM Categories WHERE CategoryID IN (SELECT CategoryID FROM Products) ;

------------------------------------  4
SELECT DISTINCT ProductName,RetailPrice,Categories.CategoryDescription FROM Products LEFT JOIN Product_Vendors on Products.ProductNumber=Product_Vendors.ProductNumber LEFT JOIN
Categories on Products.CategoryID=Categories.CategoryID ;

------------------------------------  5

SELECT VendName FROM Vendors ORDER By VendZipCode ;

------------------------------------  6

SELECT EmployeeID, EmpFirstName, EmpLastName,EmpPhoneNumber FROM Employees ORDER By EmpLastName, EmpFirstName ;

------------------------------------  7

SELECT VendName FROM Vendors ;

------------------------------------  8

SELECT DISTINCT custstate FROM Customers ;

------------------------------------  9

SELECT DISTINCT ProductName,Products.RetailPrice AS Price FROM Products LEFT JOIN Order_Details on Products.ProductNumber=Order_Details.ProductNumber  ;


------------------------------------  10

SELECT * FROM Employees ;

------------------------------------  11

SELECT VendCity, VendName  FROM Vendors ORDER By VendCity  ;

------------------------------------  12

SELECT  Order_Details.OrderNumber, max(DaysToDeliver) AS DaysToDeliver FROM Product_Vendors LEFT JOIN  Order_Details on Product_Vendors.ProductNumber=Order_Details.ProductNumber GROUP BY Order_Details.OrderNumber ORDER BY Order_Details.OrderNumber  ;


------------------------------------  13

SELECT RetailPrice * QuantityOnHand AS remnant$ FROM Products ;


------------------------------------  14

SELECT DATEDIFF(day, OrderDate, ShipDate) + (SELECT  max(DaysToDeliver) FROM Product_Vendors LEFT JOIN  Order_Details on Product_Vendors.ProductNumber=Order_Details.ProductNumber) FROM Orders;

------------------------------------  15

WITH CTE AS  
(SELECT 1 as num 
UNION ALL 
SELECT num + 1  AS num FROM CTE WHERE num < 10000)
SELECT * FROM CTE 

OPTION (MAXRECURSION 10000)
GO
------------------------------------  16

SELECT DATEDIFF(WEEK, '2019/01/01', '2019/12/31')* 2 AS DateDiff ;   -- ))))


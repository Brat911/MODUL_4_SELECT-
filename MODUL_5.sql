USE master;
GO
CREATE DATABASE YURII_BRATYUK
GO

USE YURII_BRATYUK
GO


CREATE TABLE [suppliers]   (

		[supplierid]				integer PRIMARY KEY,
		[name]						varchar (20),
		[rating]					integer,
		[city]						varchar (20),
			
)
GO


CREATE TABLE [details]   (

		[detailid]					integer PRIMARY KEY,
		[name]						varchar (20),
		[color]						varchar (20),
		[weight]					integer,
		[city]						varchar (20),
)
GO

CREATE TABLE [products]   (

		[productid]				integer PRIMARY KEY,
		[name]						varchar (20),
		[city]						varchar (20),
)
GO

CREATE TABLE [supplies]   (

		[supplierid]				integer FOREIGN KEY REFERENCES suppliers(supplierid),
		[detailid]					integer FOREIGN KEY REFERENCES details(detailid),
		[productid]				    integer FOREIGN KEY REFERENCES products(productid),
		[quantity]					integer ,
)
GO

USE YURII_BRATYUK
GO

INSERT INTO suppliers VALUES (1,	'Smith',	20,	'London'),
							 (2,	'Jonth',	10,	'Paris'),
							 (3,	'Blacke',	30,	'Paris'),
							 (4,	'Clarck',	20,	'London'),
							 (5,	'Adams',	30,	'Athens');


INSERT INTO details VALUES (1, 'Screw',		'Red',		12,	'London'),
						   (2, 'Bolt',			'Green',	17,	'Paris'),
						   (3, 'Male-screw',	'Blue',		17,	'Roma'),
						   (4, 'Male-screw',	'Red',		14,	'London'),
						   (5, 'Whell',		'Blue',		12,	'Paris'),
						   (6, 'Bloom',		'Red',		19,	'London');
						


INSERT INTO products VALUES (1, 'HDD',			'Paris'),
							(2, 'Perforator',	'Roma'),
							(3, 'Reader',		'Athens'),
							(4, 'Printer',		'Athens'),
							(5, 'FDD',			'London'),
							(6, 'Terminal',		'Oslo'),
							(7, 'Ribbon',		'London');



INSERT INTO supplies VALUES (1,	1,	1,	200),
							(1,	1,	4,	700),
							(2,	3,	1,	400),
							(2,	3,	2,	200),
							(2,	3,	3,	200),
							(2,	3,	4,	500),
							(2,	3,	5,	600),
							(2,	3,	6,	400),
							(2,	3,	7,	800),
							(2,	5,	2,	100),
							(3,	3,	1,	200),
							(3,	4,	2,	500),
							(4,	6,	3,	300),
							(4,	6,	7,	300),
							(5,	2,	2,	200),
							(5,	2,	4,	100),
							(5,	5,	5,	500),
							(5,	5,	7,	100),
							(5,	6,	2,	200),
							(5,	1,	4,	100),
							(5,	3,	4,	200),
							(5,	4,	4,	800),
							(5,	5,	4,	400),
							(5,	6,	4,	500);
						

GO

------------------------------------------------------------------------------------------------
 USE YURII_BRATYUK
 GO


-----1.1

SELECT productid
FROM supplies
WHERE productid NOT IN (SELECT productid FROM supplies WHERE supplierid <> 3);
GO
-----------------------------------------------------------------------------------------------
-----1.2

SELECT supplierid, name FROM Suppliers 
WHERE supplierid 
IN (SELECT DISTINCT supplierid FROM Supplies  WHERE detailid= 1 
AND quantity > (SELECT AVG([quantity]) FROM Supplies 
WHERE productid = productid));
GO

----------------------------------------------------------------------------------------------
-----1.3

SELECT detailid FROM 
(SELECT DISTINCT D.detailid FROM Details AS D
JOIN Supplies AS S ON D.detailid=S.detailid
JOIN Products AS P ON S.productid=P.productid
WHERE p.city = 'London') AS DT;
GO

----------------------------------------------------------------------------------------------
-----1.4

SELECT DISTINCT supplierid, name FROM Suppliers 
WHERE supplierid IN 
(SELECT supplierid FROM Supplies AS S
JOIN Details AS D ON D.detailid = S.detailid
AND D.color = 'Red')
GO

----------------------------------------------------------------------------------------------
-----1.5

SELECT DISTINCT X.detailid
FROM details AS X, supplies AS S1
WHERE X.detailid = S1.detailid AND S1.productid 
IN (SELECT productid FROM supplies  WHERE supplierid = 2)
GO
----------------------------------------------------------------------------------------------
-----1.6

SELECT detailid FROM Supplies
GROUP BY detailid
HAVING AVG(quantity) > (SELECT MAX(quantity) FROM Supplies 
WHERE productid = 1)
GO

----------------------------------------------------------------------------------------------
-----1.7

SELECT productid
FROM products
WHERE productid NOT IN (SELECT productid FROM supplies)



------------------CTE-------------------------------------------------------------------------

-----1

WITH XXX AS 
	(SELECT * FROM supplies),
	ZZZ AS
	(SELECT * FROM XXX WHERE XXX.supplierid = 3)
SELECT DISTINCT productid
FROM ZZZ
 JOIN details ON details.detailid = [ZZZ].detailid;
 GO
----------------------------------------------------------------------------------------------
-----2

WITH [WWW] AS
	(SELECT 0 AS Position, 1 AS [Value]
	UNION ALL
	SELECT Position+1, [Value]*([Position]+1)
	FROM [WWW]
	WHERE Position<10)
SELECT Position, [Value]
FROM [WWW]
WHERE Position = 10;
GO

----------------------------------------------------------------------------------------------
-----3

WITH [CTE] AS
	(SELECT 1 AS P, 0 AS F, 1 AS V
	UNION ALL
	SELECT P+1, V, F+V 
	FROM [CTE]
	WHERE P<20)
SELECT P AS Position, V AS [Value]
FROM [CTE];
GO

----------------------------------------------------------------------------------------------
------4

DECLARE @StartDate DATE, @EndDate DATE
SET @StartDate = '20131125'
SET @EndDate = '20140305'
;WITH CTE (StartDate, EndDate)
AS
(SELECT @StartDate AS StartDate, EOMONTH(@StartDate) AS EndDate
UNION ALL
SELECT DATEADD(DAY, 1, EndDate ) AS StartDate, 
IIF(EOMONTH(DATEADD(MONTH, 1, StartDate )) > @EndDate, 
@EndDate, EOMONTH(DATEADD(MONTH, 1, StartDate )))   AS EndDate FROM CTE 
WHERE EndDate < @EndDate)
SELECT * FROM CTE;
GO

----------------------------------------------------------------------------------------------
-----5
SET DATEFIRST 1
GO
DECLARE @Date DATE = getdate();
WITH [CTE] AS
(
   SELECT DATEADD(month, datediff(month, 0, @Date),0) AS d
            ,DATEPART(week, dateadd(month, datediff(month, 0, @Date),0)) AS WK
   UNION ALL
   SELECT  DATEADD(day, 1, d)
            ,DATEPART(week, dateadd(day, 1, d))
   FROM [CTE]
   WHERE d < DATEADD(month, datediff(month, 0, @Date)+1,-1)
)
SELECT  MAX(case when datepart(dw, d) = 1 then datepart(d,d) else null end) AS [Monday]
        ,MAX(case when datepart(dw, d) = 2 then datepart(d,d) else null end) AS [Tuesday]
        ,MAX(case when datepart(dw, d) = 3 then datepart(d,d) else null end) AS [Wednesday]
        ,MAX(case when datepart(dw, d) = 4 then datepart(d,d) else null end) AS [Thursday]
        ,MAX(case when datepart(dw, d) = 5 then datepart(d,d) else null end) AS [Friday]
        ,MAX(case when datepart(dw, d) = 6 then datepart(d,d) else null end) AS [Saturday]
        ,MAX(case when datepart(dw, d) = 7 then datepart(d,d) else null end) AS [Sunday]
FROM [CTE]
GROUP BY WK;

-----------------------------------------------------------------------------------------------
--  GEOGRAPHY

-----1
 
CREATE TABLE [geography]
(id int not null primary key, name varchar(20), region_id int);

ALTER TABLE [geography]
		ADD CONSTRAINT R_GB
				FOREIGN KEY (region_id)
							REFERENCES [geography] (id);

insert into [geography] values (1, 'Ukraine', null);
insert into [geography] values (2, 'Lviv', 1);
insert into [geography] values (8, 'Brody', 2);
insert into [geography] values (18, 'Gayi', 8);
insert into [geography] values (9, 'Sambir', 2);
insert into [geography] values (17, 'St.Sambir', 9);
insert into [geography] values (10, 'Striy', 2);
insert into [geography] values (11, 'Drogobych', 2);
insert into [geography] values (15, 'Shidnytsja', 11);
insert into [geography] values (16, 'Truskavets', 11);
insert into [geography] values (12, 'Busk', 2);
insert into [geography] values (13, 'Olesko', 12);
insert into [geography] values (30, 'Lvivska st', 13);
insert into [geography] values (14, 'Verbljany', 12);
insert into [geography] values (3, 'Rivne', 1);
insert into [geography] values (19, 'Dubno', 3);
insert into [geography] values (31, 'Lvivska st', 19);
insert into [geography] values (20, 'Zdolbuniv', 3);
insert into [geography] values (4, 'Ivano-Frankivsk', 1);
insert into [geography] values (21, 'Galych', 4);
insert into [geography] values (32, 'Svobody st', 21);
insert into [geography] values (22, 'Kalush', 4);
insert into [geography] values (23, 'Dolyna', 4);
insert into [geography] values (5, 'Kiyv', 1);
insert into [geography] values (24, 'Boryspil', 5);
insert into [geography] values (25, 'Vasylkiv', 5);
insert into [geography] values (6, 'Sumy', 1);
insert into [geography] values (26, 'Shostka', 6);
insert into [geography] values (27, 'Trostjanets', 6);
insert into [geography] values (7, 'Crimea', 1);
insert into [geography] values (28, 'Yalta', 7);
insert into [geography] values (29, 'Sudack', 7);

----------------------------------------------------------------------------------------
----- GEOGRAPHY
----- 2

;WITH GEO AS 
(SELECT region_id, id AS Place_ID, name, 1 AS PlaceLevel FROM geography
WHERE region_id = 1)
SELECT * from GEO;
GO

----------------------------------------------------------------------------------------
----- GEOGRAPHY
----- 3 

;WITH IVF AS
(SELECT region_id, id AS Place_ID, name, 0 AS PlaceLevel 
 FROM geography
 WHERE region_id = 4
    UNION ALL
SELECT T.region_id, T.id, T.name, PlaceLevel +1 FROM IVF  AS F
     JOIN geography AS T
ON F.Place_ID =T.[region_id])
SELECT region_id, Place_ID, name, PlaceLevel FROM IVF;
GO

----------------------------------------------------------------------------------------
----- GEOGRAPHY
----- 4

WITH [CTE](region_id, id, name, pllevel) AS (
	SELECT region_id, id, name, 0
	FROM [geography]
	WHERE region_id IS NULL
	UNION ALL
	SELECT geo.region_id, geo.id, geo.name, [CTE].pllevel + 1
	FROM [geography] AS geo
	INNER JOIN [CTE] ON geo.region_id = [CTE].id
	)
SELECT name AS 'Name', id, region_id, pllevel AS 'level' 
FROM [CTE]; 
GO

----------------------------------------------------------------------------------------
----- GEOGRAPHY
----- 5

WITH [CTE](region_id, id, name, pllevel) AS (
SELECT region_id, id, name, 1
FROM [geography]
WHERE name = 'Lviv'
UNION ALL
SELECT geo.region_id, geo.id, geo.name, [CTE].pllevel + 1
FROM [geography] AS geo
 JOIN [CTE] ON geo.region_id = [CTE].id
)
SELECT name AS 'Name', id, region_id, pllevel AS 'level'
FROM [CTE]
WHERE pllevel > 0;
GO

----------------------------------------------------------------------------------------
----- GEOGRAPHY
----- 6


;WITH CTE_L AS
(SELECT [name], [id], [region_id], 1 AS [level], CAST([name] AS VARCHAR(50)) AS Treepath
FROM geography
WHERE [id]=2
UNION ALL
SELECT G.[name], G.[id], G.[region_id], [level] + 1, CAST(Treepath + '/' + CAST(G.[name] AS VARCHAR(50)) AS VARCHAR(50))
FROM geography AS G
 JOIN CTE_L AS L
ON L.[id] = G.[region_id])
SELECT [name], [id], ('/' + Treepath) AS Treepath FROM CTE_L;
go

----------------------------------------------------------------------------------------
----- GEOGRAPHY
----- 7
;WITH CTE_L AS
(SELECT [name], [id], [region_id], 1 AS [PathLen], CAST([name] AS VARCHAR(50)) AS Treepath
FROM [geography]
WHERE [id]=2 
     UNION ALL
SELECT G.[name], G.[id], G.[region_id], [PathLen] + 1, CAST(Treepath + '/' + CAST(G.[name] AS VARCHAR(50)) AS VARCHAR(50))
FROM [dbo].[geography] AS G
     INNER JOIN CTE_L AS L
ON L.[id] = G.[region_id])
SELECT [name], 'Lviv' AS center, [PathLen],  ('/Lviv/' + Treepath) AS Treepath FROM CTE_L;
go


----------------------------------------------------------------------------------------------
------  UNION, UNION ALL, EXCEPT, INTERSECT
--1
SELECT supplierid
FROM suppliers
WHERE city = 'London'
UNION ALL
SELECT supplierid
FROM suppliers
WHERE city = 'Paris';
GO
----------------------------------------------------------------------------------------------
--2

SELECT city
FROM suppliers
UNION ALL
SELECT city
FROM details
ORDER BY city;
GO
------------------------------------
SELECT city
FROM suppliers
UNION
SELECT city
FROM details
ORDER BY city;
GO

----------------------------------------------------------------------------------------------
--3

SELECT supplierid
FROM suppliers
EXCEPT
SELECT supplierid
FROM supplies
WHERE detailid IN (SELECT detailid FROM details WHERE city = 'London');
GO

---------------------------------------------------------------------------------------------
--4

(SELECT [productid], [name], [city] FROM [dbo].[Products]
WHERE [city] IN ('Paris', 'London')
     EXCEPT
SELECT[productid], [name], [city] FROM [dbo].[Products]
WHERE [city] IN ('Paris', 'Roma'))
     UNION ALL
(SELECT [productid], [name], [city] FROM [dbo].[Products]
WHERE [city] IN ('Paris', 'Roma')
     EXCEPT
SELECT [productid], [name], [city] FROM [dbo].[Products]
WHERE [city] IN ('Paris', 'London'));
go

---------------------------------------------------------------------------------------------
--5

SELECT supplierid, detailid, productid
FROM supplies
WHERE supplierid IN (SELECT supplierid FROM suppliers WHERE city = 'London')
UNION
SELECT supplierid, detailid, productid
FROM supplies
WHERE detailid IN (SELECT detailid FROM details WHERE color = 'Green') AND productid NOT IN  (SELECT productid FROM products WHERE city = 'London');
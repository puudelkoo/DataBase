-- Zadanie 1

EXPLAIN ANALYZE
SELECT
c.customerid,
c.personid,
c.storeid,
c.territoryid,
soh.salesorderid,
soh.orderdate,
soh.duedate,
soh.shipdate
FROM sales.customer c
INNER JOIN sales.salesorderheader soh ON c.customerid = soh.customerid
WHERE c.territoryid = 5

CREATE INDEX idx_customerid2 ON sales.customer (customerid);
CREATE INDEX idx_territoryid2 ON sales.customer (territoryid);
CREATE INDEX idx_orderdate ON sales.salesorderheader (orderdate);

EXPLAIN ANALYZE
SELECT
c.customerid,
c.personid,
c.storeid,
c.territoryid,
soh.salesorderid,
soh.orderdate,
soh.duedate,
soh.shipdate
FROM sales.customer c
INNER JOIN sales.salesorderheader soh ON c.customerid = soh.customerid
WHERE c.territoryid = 5

--Zadanie 2
--a) Napisz zapytanie, które wykorzystuje transakcję (zaczyna ją), a następnie aktualizuje cenę 
-- produktu o ProductID równym 680 w tabeli Production.Product o 10% i następnie zatwierdza transakcję.

BEGIN TRANSACTION; 

UPDATE production.product
SET listprice = listprice + 0.1*listprice  
WHERE productid = 680;

COMMIT TRANSACTION;

--b) Napisz zapytanie, które zaczyna transakcję, usuwa produkt o ProductID równym 707
-- z tabeli Production. Product, ale następnie wycofuje transakcję

BEGIN WORK;

DELETE FROM production.product
WHERE productid = 707; 

ROLLBACK; 

--c) Napisz zapytanie, które zaczyna transakcję, dodaje nowy produkt do tabeli
BEGIN WORK;

INSERT INTO production.product 
(
  	name, productnumber, makeflag, finishedgoodsflag, color, safetystocklevel, reorderpoint, standardcost, listprice, size, sizeunitmeasurecode,
  	weightunitmeasurecode, weight, daystomanufacture, productline, class, style, productsubcategoryid, productmodelid, sellstartdate, sellenddate,
  	discontinueddate, rowguid, modifieddate
)
VALUES 
('Produkt', 'NP001', 1, 0, 'Zielony', 12, 7, 15.00, 30.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, GETDATE(), NULL, NULL, NEWID(), GETDATE()
);

COMMIT;

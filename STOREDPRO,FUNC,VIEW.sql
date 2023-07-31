---------------------------------stored procedure -----------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE uspProductList
AS
BEGIN
    SELECT 
        product_name, 
        list_price
    FROM 
        production.products
    ORDER BY 
        product_name;
END;

EXEC uspProductList;

DROP PROCEDURE uspProductList;


CREATE PROCEDURE uspFindProducts
AS
BEGIN
    SELECT
        product_name,
        list_price
    FROM 
        production.products
    ORDER BY
        list_price;
END;

ALTER PROCEDURE uspFindProducts(@min_list_price AS DECIMAL)
AS
BEGIN
    SELECT
        product_name,
        list_price
    FROM 
        production.products
    WHERE
        list_price >= @min_list_price
    ORDER BY
        list_price;
END;

EXEC uspFindProducts 20.00;

EXEC uspFindProducts 200;

-----------------------------------------variables---------------------------------------------------------------------------------------------------------------

DECLARE @model_year SMALLINT;

SET @model_year = 2018;

SELECT
    product_name,
    model_year,
    list_price 
FROM 
    production.products
WHERE
    model_year = @model_year
ORDER BY
    product_name;

-------------------------stored procedure variables-------------------------

CREATE  PROC uspGetProductList(
    @model_year SMALLINT
) AS 
BEGIN
    DECLARE @product_list VARCHAR(MAX);

    SET @product_list = '';

    SELECT
        @product_list = @product_list + product_name 
                        + CHAR(10)
    FROM 
        production.products
    WHERE
        model_year = @model_year
    ORDER BY 
        product_name;

    PRINT @product_list;
END;

EXEC uspGetProductList 2018;

--------------------------function 1.scaler-------------------------------------
CREATE TABLE Employees4 (
    EmployeeId INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentId INT,
    BasicSalary DECIMAL(10, 2), 
    Allowance DECIMAL(10, 2)    
);

INSERT INTO Employees4 (EmployeeId, FirstName, LastName, DepartmentId, BasicSalary, Allowance)
VALUES
    (1, 'John', 'Doe', 101, 50000.00, 3000.00),
    (2, 'Jane', 'Smith', 102, 48000.00, 2000.00),
    (3, 'Mike', 'Johnson', 101, 55000.00, 3500.00),
    (4, 'Emily', 'Williams', 103, 60000.00, 4000.00);



	CREATE FUNCTION dbo.CalculateTotalSalary1(@basicSalary DECIMAL(10, 2), @allowance DECIMAL(10, 2))
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @totalSalary DECIMAL(10, 2);
    SET @totalSalary = @basicSalary + @allowance;
    RETURN @totalSalary;
END;

SELECT
    EmployeeId,
    FirstName,
    LastName,
    DepartmentId,
    BasicSalary,
    Allowance,
    dbo.CalculateTotalSalary1(BasicSalary, Allowance) AS TotalSalary
FROM Employees4;


---------------------------------------------function for table valued ------------------------------------------------------------
-- Example of a table-valued function that returns a list of employees from a specific department
CREATE FUNCTION dbo.GetEmployeesInDepartment(@departmentId INT)
RETURNS TABLE
AS
RETURN
    SELECT * FROM Employees4
    WHERE DepartmentId = @departmentId;


SELECT * FROM dbo.GetEmployeesInDepartment(101);

---------------------------views-------------------------------------------------------------------------------
CREATE VIEW sales.product_info
AS
SELECT
    product_name, 
    brand_name, 
    list_price
FROM
    production.products p
INNER JOIN production.brands b 
        ON b.brand_id = p.brand_id;

SELECT * FROM sales.product_info;


CREATE VIEW sales.info
AS
SELECT
    product_name, 
    list_price
FROM
    production.products p;

SELECT * FROM sales.info;

CREATE VIEW CaliforniaCustomers AS
SELECT city, COUNT(*) AS count_total
FROM sales.customers
WHERE state = 'CA'
GROUP BY city;

SELECT city, count_total
FROM CaliforniaCustomers
ORDER BY city;



CREATE VIEW EmployeeInfo AS
SELECT id, name AS full_name, age
FROM Employees;

SELECT * FROM EmployeeInfo;


CREATE VIEW EmployeeAgeCategory AS
SELECT 
    id,name AS full_name,age,
    CASE
        WHEN age <= 30 THEN 'Young'
        WHEN age > 30 AND age <= 40 THEN 'Middle-Aged'
        ELSE 'Senior'
    END AS age_category
FROM Employees;

SELECT * FROM EmployeeAgeCategory;
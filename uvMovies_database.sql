-- NON CONTRIBUTORS
-- Liam Kennedy



DROP SCHEMA IF EXISTS `uvMovies` ;
CREATE SCHEMA IF NOT EXISTS `uvMovies` DEFAULT CHARACTER SET utf8mb4 ;


USE `uvMovies` ;


-- -------------------------------------------------------------------------------------------------------
-- CREATING Customer_Dim TABLE (CREATED BY ANGEL)
-- -------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS `Customer_Dim` ;

CREATE TABLE IF NOT EXISTS `Customer_Dim` (
	`Customer_ID` INT NOT NULL,
    `FirstName` varchar(30) not Null,
    `LastName` varchar(30) not null,
    `Gender` char(1) not null,
    `Street1` varchar(100) not null,
    `Street2` varchar(100) not null,
    `City` varchar(30) not null,
    `StateAbbrev` char(2) not null,
    `ZipCode` char(5) not null,
    `PrimaryPhone` varchar(10) null,
    `EmailAddress` varchar(50) null,
    primary key (`Customer_ID`),
    
    constraint chk_gender check(Gender in ('F', 'M')),
    constraint chk_zipcode check(ZipCode regexp '[0-9]{5}'),
    constraint chk_primaryphone check(PrimaryPhone regexp '[0-9]{10}')
);

-- -------------------------------------------------------------------------------------------------------
-- CREATING Date_Dim TABLE (CREATED BY Shivani)
-- -------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS `Date_Dim` ;

CREATE TABLE IF NOT EXISTS `Date_Dim` (
	`Date_ID` INT NOT NULL,
    `Order_Date` DATE NOT NULL,
    `Order_Day` CHAR(3) NOT NULL,
    `Order_Month` CHAR(3) NOT NULL,
    `Order_Quarter` CHAR(2) NOT NULL,
	primary key (`Date_ID`),
    
    constraint chk_orderday check(Order_Day in ('MON','TUE','WED','THU','FRI','SAT','SUN')),
    constraint chk_ordermonth check(Order_Month in ('JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC')),
    constraint chk_orderqtr check(Order_Quarter in ('Q1','Q2','Q3','Q4')),
    -- Need to figure out how to add less than current date constraint...curdate() function isn't working
    constraint chk_orderdate check((Order_Date > '2015-12-31'))
);

-- -------------------------------------------------------------------------------------------------------
-- CREATING Product_Dim TABLE (CREATED BY Kynndal Teel)
-- -------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `Product_Dim`;

CREATE TABLE IF NOT EXISTS `Product_Dim`(
        `Product_ID` int NOT NULL,
        `Movie_Name` varchar(100) NOT NULL,
        `Movie_Genre`  varchar(10) NOT NULL,
        `Movie_Rating` varchar(4) NOT NULL,
        `Length_Minutes` int NOT NULL,
        `Digital_Type` varchar(3) NOT NULL,
        `Redemption_Method` varchar(15) NOT NULL,
        `Redemption_Code` varchar(25) NOT NULL,
        `Retail_Price` Decimal(19,4) NOT NULL,
        `PreOrder_Release_date` date NULL,
        primary key (Product_ID),

        constraint chk_Genre check (Movie_Genre in ('Action','Adventure','Comedy','Family','Horror','Sci-Fi')),
        constraint chk_Rating check (Movie_Rating in ('G','PG','PG13','R','NR')),
        constraint chk_Length check (Length_Minutes > 0 AND Length_Minutes <=360),
        constraint chk_type check (Digital_Type in ('SD', 'HDX', 'UHD')),
        constraint chk_Method check (Redemption_Method in ('Movies Anywhere', 'VUDU', 'iTunes','Amazon'))
);

-- -------------------------------------------------------------------------------------------------------
-- CREATING Product_Dim TABLE (CREATED BY Kynndal Teel)
-- -------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `Sales_Fact`;

CREATE TABLE IF NOT EXISTS `Sales_Fact`(
        `Sales_ID` int NOT NULL,
        `Customer_ID` INT NOT NULL,
        `Date_ID` int NOT NULL,
        `Product_ID` int NULL,
        `Order_Quantity` int  NOT NULL,
        `Cart_Total` Decimal(19,4) NOT NULL,
        `Discount_Amount` Decimal(19,4)  NOT NULL,       
        `Tax_percent` decimal(4,2) NOT NULL,
        `Tax_Amount` DECIMAL(19, 4) GENERATED ALWAYS as (CONCAT(ROUND(Cart_Total - Discount_Amount * (Tax_Percent/100), 2))),
        `Sales_Amount` DECIMAL(19, 4) as (ROUND(CONCAT(Cart_Total - Discount_Amount * (1 + (Tax_Percent/100))), 2)),

        primary key (Sales_ID),

        constraint FK_customerID FOREIGN KEY (`Customer_ID`) REFERENCES Customer_Dim (`Customer_ID`),
        -- This foregin key constraint fails, not sure why
        -- constraint FK_DateID FOREIGN KEY (`Date_ID`) REFERENCES Date_Dim (`Date_ID`),
        constraint FK_ProductID FOREIGN KEY (`Product_ID`) REFERENCES Product_Dim (`Product_ID`)
);
-- -------------------------------------------------------------------------------------------------------
-- INSERT DATA INTO CUSTOMER DIM
insert into Customer_Dim(Customer_ID,FirstName,LastName,Gender,Street1,Street2,
City,StateAbbrev,ZipCode,PrimaryPhone,EmailAddress)
values
    (1, 'test_FirstName', 'test_LastName', 'M', 'test street1 123','test street2 123', 
        'testCity', 'CO', '81234', '1234567890', 'test@gmail.com');
insert into Customer_Dim(Customer_ID,FirstName,LastName,Gender,Street1,Street2,
City,StateAbbrev,ZipCode,PrimaryPhone,EmailAddress)
VALUES
    (2, 'test2_FirstName', 'test2_LastName', 'F', 'test2 street1 123','test2 street2 123', 
        'testCity2', 'CO', '81234', '1234567890', 'test2@gmail.com'),
    (3, 'test3_FirstName', 'test3_LastName', 'M', 'test3 street1 123','test3 street2 123', 
        'testCity3', 'CO', '81234', '1234567890', 'test3@gmail.com'),
    (4, 'test4_FirstName', 'test4_LastName', 'F', 'test4 street1 123','test4 street2 123', 
        'testCity4', 'CO', '81234', '1234567890', 'test4@gmail.com');

-- -------------------------------------------------------------------------------------------------------
-- INSERT DATA INTO DATE DIM
insert into Date_Dim(Date_ID, Order_Date, Order_Day, Order_Month, Order_Quarter)
values
    (1,'2017-01-02', 'MON','JAN','Q1'),
    (2,'2018-02-01','THU','FEB','Q1'),
    (3,'2019-03-02','FRI','MAR','Q1');

-- -------------------------------------------------------------------------------------------------------
-- INSERT DATA INTO PRODUCT DIM
insert into Product_Dim(Product_ID, Movie_Name, Movie_Genre, Movie_Rating, Length_minutes,
Digital_Type, Redemption_Method, Redemption_Code, Retail_Price, PreOrder_Release_date)
VALUES
    (1, 'King Kong','Action','R', 200, 'HDX','Movies Anywhere','Z10',9.50,'2018-4-10'),
    (2, 'Frozen','Family','G', 90, 'SD','Amazon','Z12',7.00,'2020-10-04'),
    (3, 'Hangover','Comedy','PG13', 176, 'UHD','iTunes','Z14',12.75,'2019-01-20');
-- -------------------------------------------------------------------------------------------------------
-- INSERT DATA INTO SALES FACT
insert into Sales_Fact(Sales_ID, Customer_ID, Date_ID, Product_ID, Order_Quantity,
cart_total, Discount_amount, Tax_percent)
VALUES
    (123, 1, 1, 1, 60, 160.00, 15, .3),
    (345, 2, 2, 2, 45, 200.00, 20, .25),
    (678, 3, 3, 3, 100, 550.00, 40, .45);

select * From Sales_Fact;
select * from Customer_Dim;
select * From Product_Dim;
select * from Date_Dim;
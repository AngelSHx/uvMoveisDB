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
-- CREATE RANDOM DATA
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
select * from Customer_Dim;
-- ------------------------------------------------------------------------------------------------------------
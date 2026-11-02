-- ============================================================================
-- Week 06 - AddressBook System Database
-- Author: Ashish Srivastava
-- UC8: Retrieve contacts of a city sorted alphabetically by name
--
-- Execute using the MySQL Command Line Client:
--   mysql -u root -p < sql/UC8_sort_by_name.sql
--
-- ORDER BY uses FirstName first and LastName second. Multiple cities are
-- tested, including one with no contacts.
-- ============================================================================

USE AddressBookService;

-- ---------------------------------------------------------------------------
-- Pune
-- ---------------------------------------------------------------------------
SET @city = 'Pune';

SELECT ContactID,
       FirstName,
       LastName,
       CONCAT(FirstName, ' ', LastName) AS FullName,
       City, State, Zip, PhoneNumber, Email
FROM Contacts
WHERE City = @city
ORDER BY FirstName ASC, LastName ASC;

-- ---------------------------------------------------------------------------
-- Bengaluru (two contacts, sorted by first name)
-- ---------------------------------------------------------------------------
SET @city = 'Bengaluru';

SELECT ContactID,
       FirstName,
       LastName,
       CONCAT(FirstName, ' ', LastName) AS FullName,
       City, State, Zip, PhoneNumber, Email
FROM Contacts
WHERE City = @city
ORDER BY FirstName ASC, LastName ASC;

-- ---------------------------------------------------------------------------
-- Mumbai
-- ---------------------------------------------------------------------------
SET @city = 'Mumbai';

SELECT ContactID,
       FirstName,
       LastName,
       CONCAT(FirstName, ' ', LastName) AS FullName,
       City, State, Zip, PhoneNumber, Email
FROM Contacts
WHERE City = @city
ORDER BY FirstName ASC, LastName ASC;

-- ---------------------------------------------------------------------------
-- Edge case: no contacts in the city
-- ---------------------------------------------------------------------------
SET @city = 'Chennai';

SELECT ContactID,
       FirstName,
       LastName,
       CONCAT(FirstName, ' ', LastName) AS FullName,
       City, State, Zip, PhoneNumber, Email
FROM Contacts
WHERE City = @city
ORDER BY FirstName ASC, LastName ASC;

-- ============================================================================
-- Week 06 - AddressBook System Database
-- Author: Ashish Srivastava
-- UC13: Verify UC6, UC7, UC8, and UC10 against the final normalized schema
--
-- Execute using the MySQL Command Line Client:
--   mysql -u root -p < sql/UC13_verify_final_queries.sql
--
-- Final schema:
--   Contacts (ContactID PK)
--   AddressBook (AddressBookID PK)
--   ContactAddressBook (ContactID, AddressBookID) composite PK
--
-- UC6, UC7, and UC8 only use Contacts, so they remain valid. UC10 previously
-- used Contacts.AddressBookID; it is rewritten here to JOIN through
-- ContactAddressBook.
-- ============================================================================

USE AddressBookService;

-- ---------------------------------------------------------------------------
-- Final schema check
-- ---------------------------------------------------------------------------
SELECT TABLE_NAME
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = DATABASE()
ORDER BY TABLE_NAME;

-- Confirm that Contacts.AddressBookID no longer exists.
SELECT COUNT(*) AS OldContactColumnPresent
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'Contacts'
  AND COLUMN_NAME = 'AddressBookID';

-- ---------------------------------------------------------------------------
-- UC6 - Retrieve contacts by City and State (final schema)
-- ---------------------------------------------------------------------------
SET @city = 'Pune';

SELECT ContactID,
       CONCAT(FirstName, ' ', LastName) AS FullName,
       Address, City, State, Zip, PhoneNumber, Email
FROM Contacts
WHERE City = @city
ORDER BY FirstName, LastName;

SET @state = 'Maharashtra';

SELECT ContactID,
       CONCAT(FirstName, ' ', LastName) AS FullName,
       Address, City, State, Zip, PhoneNumber, Email
FROM Contacts
WHERE State = @state
ORDER BY FirstName, LastName;

SET @city = 'Chennai';

SELECT ContactID,
       CONCAT(FirstName, ' ', LastName) AS FullName,
       Address, City, State, Zip, PhoneNumber, Email
FROM Contacts
WHERE City = @city
ORDER BY FirstName, LastName;

-- ---------------------------------------------------------------------------
-- UC7 - Count contacts by City and State (final schema)
-- ---------------------------------------------------------------------------
SELECT City,
       COUNT(*) AS ContactCount
FROM Contacts
GROUP BY City
ORDER BY ContactCount DESC, City ASC;

SELECT State,
       COUNT(*) AS ContactCount
FROM Contacts
GROUP BY State
ORDER BY ContactCount DESC, State ASC;

SELECT COUNT(*) AS TotalContacts FROM Contacts;

-- ---------------------------------------------------------------------------
-- UC8 - Sort contacts alphabetically for a city (final schema)
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
-- UC10 - Count contacts by AddressBook type (final schema, JOIN version)
-- ---------------------------------------------------------------------------
SELECT a.AddressBookID,
       a.AddressBookName,
       a.AddressBookType,
       COUNT(cab.ContactID) AS ContactCount
FROM AddressBook AS a
LEFT JOIN ContactAddressBook AS cab
    ON cab.AddressBookID = a.AddressBookID
GROUP BY a.AddressBookID, a.AddressBookName, a.AddressBookType
ORDER BY a.AddressBookType, a.AddressBookName;

SELECT a.AddressBookType,
       COUNT(cab.ContactID) AS ContactCount
FROM AddressBook AS a
LEFT JOIN ContactAddressBook AS cab
    ON cab.AddressBookID = a.AddressBookID
GROUP BY a.AddressBookType
ORDER BY a.AddressBookType;

-- A contact can appear in more than one type; this is the many-to-many result.
SELECT c.ContactID,
       CONCAT(c.FirstName, ' ', c.LastName) AS FullName,
       COUNT(cab.AddressBookID) AS AddressBookCount
FROM Contacts AS c
JOIN ContactAddressBook AS cab
    ON cab.ContactID = c.ContactID
GROUP BY c.ContactID, c.FirstName, c.LastName
HAVING COUNT(cab.AddressBookID) > 1;

-- Reconciliation: 12 membership rows for 11 distinct contacts.
SELECT COUNT(*) AS TotalMemberships FROM ContactAddressBook;

SELECT COUNT(DISTINCT ContactID) AS DistinctContacts
FROM ContactAddressBook;

-- Ensure no contact was duplicated in Contacts to support membership.
SELECT COUNT(*) AS ContactRows,
       COUNT(DISTINCT ContactID) AS DistinctContactIDs
FROM Contacts;

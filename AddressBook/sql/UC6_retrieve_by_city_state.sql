-- ============================================================================
-- Week 06 - AddressBook System Database
-- Author: Ashish Srivastava
-- UC6: Retrieve contacts by City or State
--
-- Execute using the MySQL Command Line Client:
--   mysql -u root -p < sql/UC6_retrieve_by_city_state.sql
--
-- Tests multiple cities and states, including a city and a state with no
-- matching contacts after the UC5 deletion.
-- ============================================================================

USE AddressBookService;

-- ---------------------------------------------------------------------------
-- Retrieve by City
-- ---------------------------------------------------------------------------
SET @city = 'Pune';

SELECT ContactID,
       CONCAT(FirstName, ' ', LastName) AS FullName,
       Address, City, State, Zip, PhoneNumber, Email
FROM Contacts
WHERE City = @city
ORDER BY FirstName, LastName;

SET @city = 'Bengaluru';

SELECT ContactID,
       CONCAT(FirstName, ' ', LastName) AS FullName,
       Address, City, State, Zip, PhoneNumber, Email
FROM Contacts
WHERE City = @city
ORDER BY FirstName, LastName;

-- Edge case: Ananya Iyer of Chennai was deleted in UC5.
SET @city = 'Chennai';

SELECT ContactID,
       CONCAT(FirstName, ' ', LastName) AS FullName,
       Address, City, State, Zip, PhoneNumber, Email
FROM Contacts
WHERE City = @city
ORDER BY FirstName, LastName;

-- ---------------------------------------------------------------------------
-- Retrieve by State
-- ---------------------------------------------------------------------------
SET @state = 'Maharashtra';

SELECT ContactID,
       CONCAT(FirstName, ' ', LastName) AS FullName,
       Address, City, State, Zip, PhoneNumber, Email
FROM Contacts
WHERE State = @state
ORDER BY FirstName, LastName;

SET @state = 'Karnataka';

SELECT ContactID,
       CONCAT(FirstName, ' ', LastName) AS FullName,
       Address, City, State, Zip, PhoneNumber, Email
FROM Contacts
WHERE State = @state
ORDER BY FirstName, LastName;

-- Edge case: Delhi no longer matches because Vivaan Gupta moved to Haryana
-- in UC4.
SET @state = 'Delhi';

SELECT ContactID,
       CONCAT(FirstName, ' ', LastName) AS FullName,
       Address, City, State, Zip, PhoneNumber, Email
FROM Contacts
WHERE State = @state
ORDER BY FirstName, LastName;

-- Edge case: a state that still has a contact after the earlier edits.
SET @state = 'Haryana';

SELECT ContactID,
       CONCAT(FirstName, ' ', LastName) AS FullName,
       Address, City, State, Zip, PhoneNumber, Email
FROM Contacts
WHERE State = @state
ORDER BY FirstName, LastName;

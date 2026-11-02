-- ============================================================================
-- Week 06 - AddressBook System Database
-- Author: Ashish Srivastava
-- UC4: Edit an existing contact using the person's name
--
-- Execute using the MySQL Command Line Client:
--   mysql -u root -p < sql/UC4_update_contact.sql
--
-- The script updates every editable attribute (address, city, state, ZIP,
-- phone, email), verifies the correct row, and demonstrates the result when
-- the requested person does not exist.
-- ============================================================================

USE AddressBookService;

-- In this dataset FirstName + LastName identifies the person being edited.
SET @firstName = 'Vivaan';
SET @lastName  = 'Gupta';

START TRANSACTION;

-- Show the row before the update.
SELECT ContactID,
       CONCAT(FirstName, ' ', LastName) AS FullName,
       Address, City, State, Zip, PhoneNumber, Email
FROM Contacts
WHERE FirstName = @firstName
  AND LastName  = @lastName;

UPDATE Contacts
SET Address     = 'Plot 21, Golf Course Road',
    City        = 'Gurugram',
    State       = 'Haryana',
    Zip         = '122002',
    PhoneNumber = '+91-98765-44002',
    Email       = 'vivaan.gupta@newmail.com'
WHERE FirstName = @firstName
  AND LastName  = @lastName;

SELECT ROW_COUNT() AS RowsUpdated;

-- Show the row after the update. Only this contact should have changed.
SELECT ContactID,
       CONCAT(FirstName, ' ', LastName) AS FullName,
       Address, City, State, Zip, PhoneNumber, Email
FROM Contacts
WHERE FirstName = @firstName
  AND LastName  = @lastName;

COMMIT;

-- Edge case: a person that is not present in the table.
-- MySQL reports 0 affected rows, so the caller can detect "contact not found".
UPDATE Contacts
SET Address = 'Unknown'
WHERE FirstName = 'Rahul'
  AND LastName  = 'Missing';

SELECT ROW_COUNT() AS MissingContactRowsUpdated;

-- Verification: the table still contains twelve contacts and the edited row
-- is the only one with the new email address.
SELECT COUNT(*) AS TotalContacts FROM Contacts;

SELECT COUNT(*) AS EditedContactCount
FROM Contacts
WHERE FirstName = 'Vivaan'
  AND LastName  = 'Gupta'
  AND Email     = 'vivaan.gupta@newmail.com';

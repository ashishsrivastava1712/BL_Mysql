-- ============================================================================
-- Week 06 - AddressBook System Database
-- Author: Ashish Srivastava
-- UC5: Delete a person using the person's name
--
-- Execute using the MySQL Command Line Client:
--   mysql -u root -p < sql/UC5_delete_contact.sql
--
-- Deletes Ananya Iyer, then verifies that the row is gone and that unrelated
-- contacts are untouched. Also demonstrates the missing-contact case.
-- ============================================================================

USE AddressBookService;

SET @firstName = 'Ananya';
SET @lastName  = 'Iyer';

START TRANSACTION;

-- Show the target before deletion.
SELECT ContactID,
       CONCAT(FirstName, ' ', LastName) AS FullName,
       City, State, PhoneNumber, Email
FROM Contacts
WHERE FirstName = @firstName
  AND LastName  = @lastName;

DELETE FROM Contacts
WHERE FirstName = @firstName
  AND LastName  = @lastName;

SELECT ROW_COUNT() AS RowsDeleted;

-- Verification: total remaining contacts and an unrelated contact.
SELECT COUNT(*) AS RemainingContacts FROM Contacts;

SELECT COUNT(*) AS UnrelatedContactStillPresent
FROM Contacts
WHERE FirstName = 'Kavya'
  AND LastName  = 'Nair';

-- The target should no longer be returned.
SELECT COUNT(*) AS DeletedContactStillPresent
FROM Contacts
WHERE FirstName = @firstName
  AND LastName  = @lastName;

COMMIT;

-- Edge case: deleting a person who does not exist affects zero rows.
DELETE FROM Contacts
WHERE FirstName = 'Rahul'
  AND LastName  = 'Missing';

SELECT ROW_COUNT() AS MissingContactRowsDeleted;

-- ============================================================================
-- Week 06 - AddressBook System Database
-- Author: Ashish Srivastava
-- UC11: Add one person to multiple AddressBooks (many-to-many)
--
-- Execute using the MySQL Command Line Client:
--   mysql -u root -p < sql/UC11_contact_addressbook_many_to_many.sql
--
-- Steps:
--   1. Create the ContactAddressBook junction table with a composite PK.
--   2. Copy the UC9 one-to-many assignments into the junction table.
--   3. Remove the temporary Contacts.AddressBookID column.
--   4. Add Aarav Sharma to both Family and Friends.
-- ============================================================================

USE AddressBookService;

-- ---------------------------------------------------------------------------
-- 1. Junction table
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS ContactAddressBook (
    ContactID     INT UNSIGNED NOT NULL,
    AddressBookID INT UNSIGNED NOT NULL,
    AddedAt       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (ContactID, AddressBookID),

    CONSTRAINT fk_contactaddressbook_contact
        FOREIGN KEY (ContactID)
        REFERENCES Contacts (ContactID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_contactaddressbook_addressbook
        FOREIGN KEY (AddressBookID)
        REFERENCES AddressBook (AddressBookID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------------------------
-- 2. Preserve the UC9 assignments
-- ---------------------------------------------------------------------------
INSERT INTO ContactAddressBook (ContactID, AddressBookID)
SELECT ContactID, AddressBookID
FROM Contacts
WHERE AddressBookID IS NOT NULL
ON DUPLICATE KEY UPDATE
    ContactAddressBook.ContactID = ContactAddressBook.ContactID;

-- ---------------------------------------------------------------------------
-- 3. Remove the temporary one-to-many column
-- ---------------------------------------------------------------------------
ALTER TABLE Contacts
    DROP FOREIGN KEY fk_contacts_addressbook;

ALTER TABLE Contacts
    DROP COLUMN AddressBookID;

-- ---------------------------------------------------------------------------
-- 4. One person in both Family and Friends
-- ---------------------------------------------------------------------------
-- Aarav Sharma is already in Family. Add the same ContactID to Friends.
INSERT INTO ContactAddressBook (ContactID, AddressBookID)
SELECT c.ContactID, a.AddressBookID
FROM Contacts AS c
JOIN AddressBook AS a
    ON a.AddressBookType = 'Friends'
WHERE c.FirstName = 'Aarav'
  AND c.LastName  = 'Sharma'
ON DUPLICATE KEY UPDATE
    ContactAddressBook.ContactID = ContactAddressBook.ContactID;

-- ---------------------------------------------------------------------------
-- 5. Verification
-- ---------------------------------------------------------------------------
SHOW TABLES LIKE 'ContactAddressBook';

SHOW CREATE TABLE ContactAddressBook;

-- The contact exists only once in Contacts.
SELECT COUNT(*) AS ContactRows
FROM Contacts
WHERE FirstName = 'Aarav'
  AND LastName  = 'Sharma';

-- ...but has two memberships.
SELECT c.ContactID,
       CONCAT(c.FirstName, ' ', c.LastName) AS FullName,
       a.AddressBookName,
       a.AddressBookType
FROM Contacts AS c
JOIN ContactAddressBook AS cab
    ON cab.ContactID = c.ContactID
JOIN AddressBook AS a
    ON a.AddressBookID = cab.AddressBookID
WHERE c.FirstName = 'Aarav'
  AND c.LastName  = 'Sharma'
ORDER BY a.AddressBookType;

-- Membership totals (a contact can be counted in more than one type).
SELECT COUNT(*) AS TotalMemberships FROM ContactAddressBook;

SELECT COUNT(DISTINCT ContactID) AS DistinctContacts
FROM ContactAddressBook;

-- Confirm the old column is gone.
SELECT COUNT(*) AS OldColumnStillPresent
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'Contacts'
  AND COLUMN_NAME = 'AddressBookID';

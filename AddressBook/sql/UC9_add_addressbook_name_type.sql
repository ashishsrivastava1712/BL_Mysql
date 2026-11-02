-- ============================================================================
-- Week 06 - AddressBook System Database
-- Author: Ashish Srivastava
-- UC9: Add AddressBook name and type
--
-- Execute using the MySQL Command Line Client:
--   mysql -u root -p < sql/UC9_add_addressbook_name_type.sql
--
-- Introduces the AddressBook entity (ID, name, type) and links each contact to
-- one address book. This one-to-many link is the starting point for the
-- many-to-many relationship introduced in UC11.
-- ============================================================================

USE AddressBookService;

-- ---------------------------------------------------------------------------
-- 1. AddressBook table
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS AddressBook (
    AddressBookID   INT UNSIGNED NOT NULL AUTO_INCREMENT,
    AddressBookName VARCHAR(100) NOT NULL,
    AddressBookType ENUM('Family', 'Friends', 'Professional') NOT NULL,
    Description     VARCHAR(255) NULL,
    CreatedAt       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (AddressBookID),
    CONSTRAINT uq_addressbook_name_type
        UNIQUE (AddressBookName, AddressBookType)
) ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;

INSERT INTO AddressBook (AddressBookName, AddressBookType, Description)
VALUES
    ('Family Book',       'Family',       'Family members and relatives'),
    ('Friends Book',      'Friends',      'Personal friends'),
    ('Professional Book', 'Professional', 'Work and business contacts')
ON DUPLICATE KEY UPDATE
    AddressBookID = AddressBookID;

-- ---------------------------------------------------------------------------
-- 2. Link Contacts to an AddressBook (one address book per contact for now)
-- ---------------------------------------------------------------------------
ALTER TABLE Contacts
    ADD COLUMN AddressBookID INT UNSIGNED NULL AFTER Email,
    ADD CONSTRAINT fk_contacts_addressbook
        FOREIGN KEY (AddressBookID)
        REFERENCES AddressBook (AddressBookID)
        ON DELETE SET NULL
        ON UPDATE CASCADE;

-- ---------------------------------------------------------------------------
-- 3. Assign the existing contacts to their address books
-- ---------------------------------------------------------------------------
UPDATE Contacts AS c
JOIN AddressBook AS a
    ON a.AddressBookType = 'Family'
SET c.AddressBookID = a.AddressBookID
WHERE CONCAT(c.FirstName, ' ', c.LastName) IN
      ('Aarav Sharma', 'Diya Patel', 'Kavya Nair', 'Meera Joshi');

UPDATE Contacts AS c
JOIN AddressBook AS a
    ON a.AddressBookType = 'Friends'
SET c.AddressBookID = a.AddressBookID
WHERE CONCAT(c.FirstName, ' ', c.LastName) IN
      ('Ishaan Verma', 'Rohan Mehta', 'Arjun Rao', 'Nisha Kapoor');

UPDATE Contacts AS c
JOIN AddressBook AS a
    ON a.AddressBookType = 'Professional'
SET c.AddressBookID = a.AddressBookID
WHERE CONCAT(c.FirstName, ' ', c.LastName) IN
      ('Vivaan Gupta', 'Saanvi Reddy', 'Aditya Singh');

-- ---------------------------------------------------------------------------
-- 4. Verification
-- ---------------------------------------------------------------------------
SHOW TABLES LIKE 'AddressBook';

SELECT AddressBookID, AddressBookName, AddressBookType, Description
FROM AddressBook
ORDER BY AddressBookID;

SHOW COLUMNS FROM Contacts LIKE 'AddressBookID';

SELECT c.ContactID,
       CONCAT(c.FirstName, ' ', c.LastName) AS FullName,
       a.AddressBookName,
       a.AddressBookType
FROM Contacts AS c
LEFT JOIN AddressBook AS a
    ON a.AddressBookID = c.AddressBookID
ORDER BY c.ContactID;

-- Every contact should have been assigned.
SELECT COUNT(*) AS UnassignedContacts
FROM Contacts
WHERE AddressBookID IS NULL;

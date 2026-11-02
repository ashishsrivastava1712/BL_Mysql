-- ============================================================================
-- Week 06 - AddressBook System Database
-- Author: Ashish Srivastava
-- UC10: Count contacts by AddressBook type
--
-- Execute using the MySQL Command Line Client:
--   mysql -u root -p < sql/UC10_count_by_addressbook_type.sql
--
-- Uses a JOIN from AddressBook to Contacts and GROUP BY. LEFT JOIN is used so
-- an address book with zero contacts is still reported.
--
-- NOTE: This query uses Contacts.AddressBookID, the one-to-many link added in
-- UC9. UC11 replaces that link with the ContactAddressBook junction table; the
-- updated version of this report is in UC13.
-- ============================================================================

USE AddressBookService;

-- Count per named address book.
SELECT a.AddressBookID,
       a.AddressBookName,
       a.AddressBookType,
       COUNT(c.ContactID) AS ContactCount
FROM AddressBook AS a
LEFT JOIN Contacts AS c
    ON c.AddressBookID = a.AddressBookID
GROUP BY a.AddressBookID, a.AddressBookName, a.AddressBookType
ORDER BY a.AddressBookType, a.AddressBookName;

-- Count per address book type (Family, Friends, Professional).
SELECT a.AddressBookType,
       COUNT(c.ContactID) AS ContactCount
FROM AddressBook AS a
LEFT JOIN Contacts AS c
    ON c.AddressBookID = a.AddressBookID
GROUP BY a.AddressBookType
ORDER BY a.AddressBookType;

-- Verification: counts must add up to the total number of contacts.
SELECT SUM(TypeCount) AS SumOfTypeCounts
FROM (
    SELECT COUNT(c.ContactID) AS TypeCount
    FROM AddressBook AS a
    LEFT JOIN Contacts AS c
        ON c.AddressBookID = a.AddressBookID
    GROUP BY a.AddressBookType
) AS TypeCounts;

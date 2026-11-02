-- ============================================================================
-- Week 06 - AddressBook System Database
-- Author: Ashish Srivastava
-- UC7: Count contacts grouped by City and by State
--
-- Execute using the MySQL Command Line Client:
--   mysql -u root -p < sql/UC7_count_by_city_state.sql
--
-- The "size" of the address book is the number of contacts in each city or
-- state. COUNT() is combined with GROUP BY.
-- ============================================================================

USE AddressBookService;

-- Overall size of the address book.
SELECT COUNT(*) AS TotalContacts FROM Contacts;

-- Size by city.
SELECT City,
       COUNT(*) AS ContactCount
FROM Contacts
GROUP BY City
ORDER BY ContactCount DESC, City ASC;

-- Size by state.
SELECT State,
       COUNT(*) AS ContactCount
FROM Contacts
GROUP BY State
ORDER BY ContactCount DESC, State ASC;

-- Cities with more than one contact.
SELECT City,
       COUNT(*) AS ContactCount
FROM Contacts
GROUP BY City
HAVING COUNT(*) > 1
ORDER BY ContactCount DESC, City ASC;

-- Verification: the per-city counts must add up to the overall total.
SELECT SUM(ContactCount) AS SumOfCityCounts
FROM (
    SELECT COUNT(*) AS ContactCount
    FROM Contacts
    GROUP BY City
) AS CityCounts;

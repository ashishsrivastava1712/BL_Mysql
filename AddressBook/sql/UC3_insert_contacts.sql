-- ============================================================================
-- Week 06 - AddressBook System Database
-- Author: Ashish Srivastava
-- UC3: Insert sample contacts into the Contacts table
--
-- Execute using the MySQL Command Line Client:
--   mysql -u root -p < sql/UC3_insert_contacts.sql
--
-- Assumes UC1 and UC2 have already created the database and Contacts table.
-- The ON DUPLICATE KEY clause makes this script safe to re-run without
-- creating duplicate rows. The CHECK constraints from UC2 reject bad data.
-- ============================================================================

USE AddressBookService;

INSERT INTO Contacts
    (FirstName, LastName, Address, City, State, Zip, PhoneNumber, Email)
VALUES
    ('Aarav',  'Sharma', '12 MG Road',           'Pune',      'Maharashtra',    '411001', '+91-98765-43210', 'aarav.sharma@example.com'),
    ('Diya',   'Patel',  '45 CG Road',           'Ahmedabad', 'Gujarat',        '380009', '+91-98765-43211', 'diya.patel@example.com'),
    ('Vivaan', 'Gupta',  '8 Rajpath',            'New Delhi', 'Delhi',          '110001', '+91-98765-43212', 'vivaan.gupta@example.com'),
    ('Ananya', 'Iyer',   '22 Marina Walk',       'Chennai',   'Tamil Nadu',     '600001', '+91-98765-43213', 'ananya.iyer@example.com'),
    ('Ishaan', 'Verma',  '17 Park Street',       'Kolkata',   'West Bengal',    '700016', '+91-98765-43214', 'ishaan.verma@example.com'),
    ('Kavya',  'Nair',   '5 Residency Road',     'Bengaluru', 'Karnataka',      '560025', '+91-98765-43215', 'kavya.nair@example.com'),
    ('Rohan',  'Mehta',  '31 Linking Road',      'Mumbai',    'Maharashtra',    '400050', '+91-98765-43216', 'rohan.mehta@example.com'),
    ('Meera',  'Joshi',  '9 FC Road',            'Pune',      'Maharashtra',    '411004', '+91-98765-43217', 'meera.joshi@example.com'),
    ('Arjun',  'Rao',    '14 Jubilee Hills',     'Hyderabad', 'Telangana',      '500033', '+91-98765-43218', 'arjun.rao@example.com'),
    ('Saanvi', 'Reddy',  '27 Indiranagar',       'Bengaluru', 'Karnataka',      '560038', '+91-98765-43219', 'saanvi.reddy@example.com'),
    ('Aditya', 'Singh',  '3 Civil Lines',        'Jaipur',    'Rajasthan',      '302006', '+91-98765-43220', 'aditya.singh@example.com'),
    ('Nisha',  'Kapoor', '6 Sector 18',          'Noida',     'Uttar Pradesh',  '201301', '+91-98765-43221', 'nisha.kapoor@example.com')
ON DUPLICATE KEY UPDATE
    ContactID = ContactID;

-- Verification: total count and all inserted records.
SELECT COUNT(*) AS TotalContacts FROM Contacts;

SELECT ContactID,
       CONCAT(FirstName, ' ', LastName) AS FullName,
       City,
       State,
       Zip,
       PhoneNumber,
       Email
FROM Contacts
ORDER BY ContactID;

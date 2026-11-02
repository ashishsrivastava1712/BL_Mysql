-- ============================================================================
-- Week 06 - AddressBook System Database
-- Author: Ashish Srivastava
-- UC2: Create the Contacts table
--
-- Execute using the MySQL Command Line Client:
--   mysql -u root -p < sql/UC2_create_contacts_table.sql
--
-- Assumes UC1 has already created and selected AddressBookService.
-- ============================================================================

USE AddressBookService;

CREATE TABLE IF NOT EXISTS Contacts (
    ContactID   INT UNSIGNED NOT NULL AUTO_INCREMENT,
    FirstName   VARCHAR(50)  NOT NULL,
    LastName    VARCHAR(50)  NOT NULL,
    Address     VARCHAR(255) NOT NULL,
    City        VARCHAR(100) NOT NULL,
    State       VARCHAR(100) NOT NULL,
    Zip         VARCHAR(10)  NOT NULL,
    PhoneNumber VARCHAR(20)  NOT NULL,
    Email       VARCHAR(254) NOT NULL,
    CreatedAt   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
                             ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (ContactID),

    -- A person is uniquely identified for this exercise by name + phone.
    CONSTRAINT uq_contacts_name_phone
        UNIQUE (FirstName, LastName, PhoneNumber),
    CONSTRAINT uq_contacts_email
        UNIQUE (Email),

    -- Enforce database-level data validation constraints.
    CONSTRAINT chk_contacts_zip
        CHECK (Zip REGEXP '^[0-9]{5,6}(-[0-9]{4})?$'),
    CONSTRAINT chk_contacts_phone
        CHECK (PhoneNumber REGEXP '^[+]?[0-9() -]{7,18}$'),
    CONSTRAINT chk_contacts_email
        CHECK (Email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+[.][A-Za-z]{2,}$')
) ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;

-- Validation check.
SHOW TABLES LIKE 'Contacts';

DESCRIBE Contacts;

SHOW CREATE TABLE Contacts;

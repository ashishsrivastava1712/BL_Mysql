# AddressBook System Database

MySQL implementation of the AddressBook System Database assignment (UC1-UC13).

## Objective

Build a normalized AddressBook database that stores contacts, supports multiple
named address books (Family, Friends, Professional), and allows a contact to
belong to more than one address book.

## Folder Layout

```text
AddressBook/
├── README.md
├── sql/
└── er-diagram/
```

| Folder | Purpose |
| --- | --- |
| `sql/` | Numbered MySQL scripts, one or more per use case. |
| `er-diagram/` | Final ER diagram and normalization notes. |

## Requirements

- MySQL 8.0+
- MySQL Command Line Client or MySQL Workbench

No Java, JDBC, Spring Boot, C#, or ADO.NET code is used.

## Running the Scripts

Run the scripts in the order documented in [`sql/README.md`](sql/README.md).
Each script selects the `AddressBookService` database (or creates it first).

```bash
cd AddressBook
mysql -u root -p < sql/UC1_create_database.sql
```

## Use Case Status

| Use Case | Feature Branch | Status |
| --- | --- | --- |
| UC1 - Create AddressBook database | `feature/UC1` | Complete |
| UC2 - Create Contacts table | `feature/UC2` | Complete |
| UC3 - Insert contacts | `feature/UC3` | Complete |
| UC4 - Edit contact | `feature/UC4` | Complete |
| UC5 - Delete contact | `feature/UC5` | Complete |
| UC6 - Retrieve by city/state | `feature/UC6` | Complete |
| UC7 - Count by city/state | `feature/UC7` | Pending |
| UC8 - Sort by name | `feature/UC8` | Pending |
| UC9 - AddressBook name and type | `feature/UC9` | Pending |
| UC10 - Count by AddressBook type | `feature/UC10` | Pending |
| UC11 - Many-to-many membership | `feature/UC11` | Pending |
| UC12 - Normalization and ER diagram | `feature/UC12` | Pending |
| UC13 - Verify queries on final schema | `feature/UC13` | Pending |

## Testing Record

Tests are executed against MySQL 8.0 before a use case is merged into `develop`.

| Use Case | Test Performed | Result |
| --- | --- | --- |
| UC1 | Ran `UC1_create_database.sql` on a clean MySQL 8.0 instance. Verified `DATABASE()`, `information_schema.SCHEMATA`, and `SHOW DATABASES LIKE 'AddressBookService'`. | Pass |
| UC2 | Ran `UC2_create_contacts_table.sql`. Verified table, columns, keys, and constraints with `SHOW CREATE TABLE`. Tested invalid ZIP, phone, and email values; each was rejected. | Pass |
| UC3 | Ran `UC3_insert_contacts.sql`; verified 12 rows. Re-ran the script; count stayed at 12. Attempted an invalid ZIP insert; rejected and count stayed at 12. | Pass |
| UC4 | Ran `UC4_update_contact.sql`. Verified 1 row updated with all six editable fields changed. Missing-contact test returned 0 rows and total count stayed at 12. | Pass |
| UC5 | Ran `UC5_delete_contact.sql`. Verified 1 row deleted, 11 records remained, an unrelated contact still existed, and the deleted contact was absent. Missing-contact delete returned 0. | Pass |
| UC6 | Ran `UC6_retrieve_by_city_state.sql`. Verified Pune (2), Bengaluru (2), Maharashtra (3), Karnataka (2), Haryana (1), and empty results for Chennai and Delhi. | Pass |

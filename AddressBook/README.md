# AddressBook System Database

MySQL implementation of the AddressBook System Database assignment (UC1-UC13).

## Objective

Build a normalized AddressBook database that stores contacts, supports multiple
named address books (Family, Friends, Professional), and allows one contact to
belong to more than one address book.

This project uses **MySQL and SQL only**. JDBC, MySQL Connector/J, Java,
Spring Boot, C#, and ADO.NET are intentionally not used because JDBC is not part
of the current syllabus.

## Folder Layout

```text
AddressBook/
├── README.md
├── sql/
│   ├── README.md
│   ├── UC1_create_database.sql
│   ├── UC2_create_contacts_table.sql
│   ├── UC3_insert_contacts.sql
│   ├── UC4_update_contact.sql
│   ├── UC5_delete_contact.sql
│   ├── UC6_retrieve_by_city_state.sql
│   ├── UC7_count_by_city_state.sql
│   ├── UC8_sort_by_name.sql
│   ├── UC9_add_addressbook_name_type.sql
│   ├── UC10_count_by_addressbook_type.sql
│   ├── UC11_contact_addressbook_many_to_many.sql
│   └── UC13_verify_final_queries.sql
└── er-diagram/
    ├── README.md
    ├── ER_Diagram.md
    ├── AddressBook_ER_Diagram.png
    ├── AddressBook_ER_Diagram.svg
    └── Normalization.md
```

## Requirements

- MySQL 8.0+
- MySQL Command Line Client or MySQL Workbench

## Final Database Structure

```text
AddressBookService
├── Contacts            (ContactID PK)
├── AddressBook         (AddressBookID PK)
└── ContactAddressBook  (ContactID, AddressBookID) composite PK
```

| Table | Purpose |
| --- | --- |
| `Contacts` | One row per person, with name, address, ZIP, phone, and email. |
| `AddressBook` | Named address books and their type (Family/Friends/Professional). |
| `ContactAddressBook` | Junction table that allows one contact to belong to many address books. |

`ContactAddressBook.ContactID` and `ContactAddressBook.AddressBookID` are
foreign keys to their parent tables. The composite primary key prevents the
same contact from being added to the same address book twice. Both foreign keys
use `ON DELETE CASCADE` and `ON UPDATE CASCADE`.

The final ER diagram is
[`er-diagram/AddressBook_ER_Diagram.png`](er-diagram/AddressBook_ER_Diagram.png).
See [`er-diagram/ER_Diagram.md`](er-diagram/ER_Diagram.md) and
[`er-diagram/Normalization.md`](er-diagram/Normalization.md) for keys,
cardinalities, and 1NF/2NF/3NF/BCNF analysis.

## Use Cases

| Use Case | Branch | SQL Script | Summary |
| --- | --- | --- | --- |
| UC1 | `feature/UC1` | `UC1_create_database.sql` | Create and select `AddressBookService`. |
| UC2 | `feature/UC2` | `UC2_create_contacts_table.sql` | Create `Contacts` with keys and check constraints. |
| UC3 | `feature/UC3` | `UC3_insert_contacts.sql` | Insert twelve sample contacts. |
| UC4 | `feature/UC4` | `UC4_update_contact.sql` | Edit a contact by name; handle a missing contact. |
| UC5 | `feature/UC5` | `UC5_delete_contact.sql` | Delete a contact by name; verify unrelated rows. |
| UC6 | `feature/UC6` | `UC6_retrieve_by_city_state.sql` | Retrieve contacts by city or state. |
| UC7 | `feature/UC7` | `UC7_count_by_city_state.sql` | Count contacts with `COUNT()` and `GROUP BY`. |
| UC8 | `feature/UC8` | `UC8_sort_by_name.sql` | Sort a city's contacts by first and last name. |
| UC9 | `feature/UC9` | `UC9_add_addressbook_name_type.sql` | Add `AddressBook` name/type and link contacts. |
| UC10 | `feature/UC10` | `UC10_count_by_addressbook_type.sql` | Count contacts per address book type with a JOIN. |
| UC11 | `feature/UC11` | `UC11_contact_addressbook_many_to_many.sql` | Add the `ContactAddressBook` junction table. |
| UC12 | `feature/UC12` | Documentation | Normalization review and ER diagram. |
| UC13 | `feature/UC13` | `UC13_verify_final_queries.sql` | Re-verify UC6, UC7, UC8, and UC10 on the final schema. |

Detailed expected output for each use case is in [`sql/README.md`](sql/README.md).

## Execution Order

Run the scripts in this exact order. UC12 is documentation only and has no SQL
script.

| Order | Script |
| --- | --- |
| 1 | `UC1_create_database.sql` |
| 2 | `UC2_create_contacts_table.sql` |
| 3 | `UC3_insert_contacts.sql` |
| 4 | `UC4_update_contact.sql` |
| 5 | `UC5_delete_contact.sql` |
| 6 | `UC6_retrieve_by_city_state.sql` |
| 7 | `UC7_count_by_city_state.sql` |
| 8 | `UC8_sort_by_name.sql` |
| 9 | `UC9_add_addressbook_name_type.sql` |
| 10 | `UC10_count_by_addressbook_type.sql` |
| 11 | `UC11_contact_addressbook_many_to_many.sql` |
| 12 | Review the ER diagram and normalization notes. |
| 13 | `UC13_verify_final_queries.sql` |

UC10 uses the temporary `Contacts.AddressBookID` column from UC9. Run it before
UC11. The final, JOIN-based version of the same report is in UC13.

### Command Line Client

From the `AddressBook` directory:

```bash
mysql -u root -p < sql/UC1_create_database.sql
mysql -u root -p < sql/UC2_create_contacts_table.sql
mysql -u root -p < sql/UC3_insert_contacts.sql
mysql -u root -p < sql/UC4_update_contact.sql
mysql -u root -p < sql/UC5_delete_contact.sql
mysql -u root -p < sql/UC6_retrieve_by_city_state.sql
mysql -u root -p < sql/UC7_count_by_city_state.sql
mysql -u root -p < sql/UC8_sort_by_name.sql
mysql -u root -p < sql/UC9_add_addressbook_name_type.sql
mysql -u root -p < sql/UC10_count_by_addressbook_type.sql
mysql -u root -p < sql/UC11_contact_addressbook_many_to_many.sql
mysql -u root -p < sql/UC13_verify_final_queries.sql
```

To start from an empty database, drop it first:

```sql
DROP DATABASE IF EXISTS AddressBookService;
```

Then run the scripts in order.

### MySQL Workbench

1. Connect to the local MySQL server.
2. Open each script in the order above.
3. Execute the whole script (the scripts call `USE AddressBookService;`).
4. Compare the result sets with the expected output in
   [`sql/README.md`](sql/README.md).

## Sample Data

Twelve contacts are inserted in UC3. UC4 moves Vivaan Gupta to Gurugram,
Haryana. UC5 deletes Ananya Iyer. The final dataset therefore has:

- 11 contacts.
- 3 address books.
- 12 memberships: Family 4, Friends 5, Professional 3.
- Aarav Sharma is the single contact who belongs to both Family and Friends.
- Contacts are stored once; only the junction table has multiple rows for
  Aarav.

## Testing

Testing instructions:

1. Execute the scripts in the documented order.
2. For each script, compare the verification queries with the expected results
   in [`sql/README.md`](sql/README.md).
3. Test edge cases: invalid ZIP/phone/email, missing contact on update/delete,
   empty city/state results, duplicate address-book membership, and contacts in
   multiple address books.
4. Confirm that re-running UC3 does not duplicate contacts.
5. Run UC13 last to confirm that the earlier retrieval, counting, sorting, and
   type-count queries still work after the many-to-many migration.

### Test Record

Tests were executed against MySQL 8.0.39.

| Use Case | Test Performed | Result |
| --- | --- | --- |
| UC1 | Ran `UC1_create_database.sql`. Verified `DATABASE()`, `information_schema.SCHEMATA`, and `SHOW DATABASES`. | Pass |
| UC2 | Ran `UC2_create_contacts_table.sql`. Verified table, columns, keys, and constraints with `SHOW CREATE TABLE`. Invalid ZIP, phone, and email values were rejected. | Pass |
| UC3 | Ran `UC3_insert_contacts.sql`; verified 12 rows. Re-ran the script; count stayed at 12. Invalid insert was rejected and count stayed at 12. | Pass |
| UC4 | Ran `UC4_update_contact.sql`. Verified 1 row updated with all six editable fields changed. Missing-contact test returned 0 rows. | Pass |
| UC5 | Ran `UC5_delete_contact.sql`. Verified 1 row deleted, 11 remained, unrelated contact was present, and target was absent. Missing-contact delete returned 0. | Pass |
| UC6 | Ran `UC6_retrieve_by_city_state.sql`. Verified Pune (2), Bengaluru (2), Maharashtra (3), Karnataka (2), Haryana (1), and empty results for Chennai and Delhi. | Pass |
| UC7 | Ran `UC7_count_by_city_state.sql`. Verified total 11, city counts summing to 11, state counts, and the `HAVING` result. | Pass |
| UC8 | Ran `UC8_sort_by_name.sql`. Verified alphabetical output for Pune, Bengaluru, and Mumbai, plus an empty result for Chennai. | Pass |
| UC9 | Ran `UC9_add_addressbook_name_type.sql`. Verified the AddressBook table, three types, the new foreign key, all eleven assignments, and zero unassigned contacts. | Pass |
| UC10 | Ran `UC10_count_by_addressbook_type.sql`. Verified Family 4, Friends 4, Professional 3, and a type-count sum of 11. | Pass |
| UC11 | Ran `UC11_contact_addressbook_many_to_many.sql`. Verified the composite key and foreign keys, 12 memberships for 11 contacts, Aarav in Family and Friends, removal of the old column, and rejection of a duplicate membership. | Pass |
| UC12 | Reviewed the final schema and verified the PNG/SVG ER diagram, Mermaid source, normalization notes, keys, and cardinalities. | Pass |
| UC13 | Ran `UC13_verify_final_queries.sql` on the final schema. Verified all UC6/UC7/UC8/UC10 results, 12 memberships, 11 distinct contacts, and no duplicate contact rows. | Pass |
| Full run | Dropped `AddressBookService` and executed UC1-UC11 plus UC13 in order. Every script exited with code `0`; final counts matched the expected values. | Pass |

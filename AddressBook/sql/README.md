# SQL Scripts

Scripts are numbered in execution order. Run each script with the MySQL Command
Line Client or MySQL Workbench while connected to the `AddressBookService`
database unless the script itself creates/selects it.

## Execution Order

| Order | Script | Use Case |
| --- | --- | --- |
| 1 | `UC1_create_database.sql` | Create the `AddressBookService` database. |
| 2 | `UC2_create_contacts_table.sql` | Create the `Contacts` table. |
| 3 | `UC3_insert_contacts.sql` | Insert twelve sample contacts. |
| 4 | `UC4_update_contact.sql` | Edit a contact by name. |
| 5 | `UC5_delete_contact.sql` | Delete a contact by name. |
| 6 | `UC6_retrieve_by_city_state.sql` | Retrieve contacts by city or state. |
| 7 | `UC7_count_by_city_state.sql` | Count contacts by city and state. |

---

## UC1 - Create AddressBook Database

**Script:** `UC1_create_database.sql`

Creates `AddressBookService` using `utf8mb4`, selects it, and verifies its
existence through `information_schema` and `SHOW DATABASES`.

### Command Line

```bash
mysql -u root -p < sql/UC1_create_database.sql
```

### MySQL Workbench

1. Open a new SQL tab.
2. Open `UC1_create_database.sql`.
3. Execute the whole script.

### Expected Result

- `CurrentDatabase` is `AddressBookService`.
- One row is returned for `AddressBookService` with `utf8mb4` and
  `utf8mb4_0900_ai_ci`.
- `SHOW DATABASES` lists `AddressBookService`.

---

## UC2 - Create Contacts Table

**Script:** `UC2_create_contacts_table.sql`

Creates the `Contacts` table with a surrogate primary key (`ContactID`),
contact attributes, timestamps, a unique name/phone business key, a unique
email, and `CHECK` constraints for ZIP, phone, and email formats.

| Column | Type | Constraint |
| --- | --- | --- |
| `ContactID` | `INT UNSIGNED` | Primary key, auto-increment |
| `FirstName` | `VARCHAR(50)` | Not null |
| `LastName` | `VARCHAR(50)` | Not null |
| `Address` | `VARCHAR(255)` | Not null |
| `City` | `VARCHAR(100)` | Not null |
| `State` | `VARCHAR(100)` | Not null |
| `Zip` | `VARCHAR(10)` | Not null, format check |
| `PhoneNumber` | `VARCHAR(20)` | Not null, format check |
| `Email` | `VARCHAR(254)` | Not null, unique, format check |
| `CreatedAt` | `TIMESTAMP` | Defaults to current time |
| `UpdatedAt` | `TIMESTAMP` | Updates automatically |

### Expected Result

- `Contacts` appears in `SHOW TABLES`.
- `DESCRIBE Contacts` lists all eleven columns.
- `SHOW CREATE TABLE Contacts` shows the primary key, unique keys, and check
  constraints.
- Invalid ZIP, phone, or email values are rejected with error `3819`.

---

## UC3 - Insert New Contacts

**Script:** `UC3_insert_contacts.sql`

Inserts twelve sample contacts across ten cities and nine states. The script uses
`ON DUPLICATE KEY UPDATE` so a second execution does not create duplicates.
Invalid data is rejected by the UC2 `CHECK` constraints instead of being
silently accepted.

### Sample Data

| Name | City | State |
| --- | --- | --- |
| Aarav Sharma | Pune | Maharashtra |
| Diya Patel | Ahmedabad | Gujarat |
| Vivaan Gupta | New Delhi | Delhi |
| Ananya Iyer | Chennai | Tamil Nadu |
| Ishaan Verma | Kolkata | West Bengal |
| Kavya Nair | Bengaluru | Karnataka |
| Rohan Mehta | Mumbai | Maharashtra |
| Meera Joshi | Pune | Maharashtra |
| Arjun Rao | Hyderabad | Telangana |
| Saanvi Reddy | Bengaluru | Karnataka |
| Aditya Singh | Jaipur | Rajasthan |
| Nisha Kapoor | Noida | Uttar Pradesh |

### Expected Result

- `TotalContacts` is `12`.
- Twelve rows are listed in `ContactID` order.
- Re-running the script leaves the count at `12`.
- An insert with an invalid ZIP, phone, or email fails with error `3819` and does
  not add a row.

---

## UC4 - Edit Existing Contact

**Script:** `UC4_update_contact.sql`

Updates Vivaan Gupta by first and last name. The update changes address, city,
state, ZIP, phone, and email inside a transaction. The script prints the record
before and after the change.

### Expected Result

- The "before" query shows the New Delhi address.
- `RowsUpdated` is `1`.
- The "after" query shows Gurugram, Haryana, `122002`, the new phone, and
  `vivaan.gupta@newmail.com`.
- The missing-contact test returns `MissingContactRowsUpdated = 0`, which is the
  SQL signal that no matching person exists.
- `TotalContacts` remains `12` and `EditedContactCount` is `1`.

---

## UC5 - Delete Contact

**Script:** `UC5_delete_contact.sql`

Deletes Ananya Iyer by first and last name and verifies the deletion. An
unrelated contact (Kavya Nair) is checked to confirm that only the target row is
removed. The final dataset contains eleven contacts after this script.

### Expected Result

- The "before" query displays Ananya Iyer from Chennai.
- `RowsDeleted` is `1`.
- `RemainingContacts` is `11`.
- `UnrelatedContactStillPresent` is `1`.
- `DeletedContactStillPresent` is `0`.
- Deleting a missing person returns `MissingContactRowsDeleted = 0`.

---

## UC6 - Retrieve Contacts by City or State

**Script:** `UC6_retrieve_by_city_state.sql`

Runs separate `SELECT` statements filtered by `City` and by `State`. The city
and state values are stored in session variables so they are easy to change.

### Tested Values

| Filter | Value | Expected rows |
| --- | --- | --- |
| City | Pune | Aarav Sharma, Meera Joshi |
| City | Bengaluru | Kavya Nair, Saanvi Reddy |
| City | Chennai | None (deleted in UC5) |
| State | Maharashtra | Aarav Sharma, Meera Joshi, Rohan Mehta |
| State | Karnataka | Kavya Nair, Saanvi Reddy |
| State | Delhi | None (Vivaan Gupta moved in UC4) |
| State | Haryana | Vivaan Gupta |

---

## UC7 - Count Contacts by City and State

**Script:** `UC7_count_by_city_state.sql`

Uses `COUNT(*)` with `GROUP BY` to report the size of the address book per city
and per state. It also includes a `HAVING` example and a reconciliation query
proving that the city counts add up to the total.

### Expected Result

- `TotalContacts` is `11`.
- Bengaluru and Pune each have `2` contacts; the other cities have `1`.
- Maharashtra has `3` contacts and Karnataka has `2`.
- The `HAVING COUNT(*) > 1` query returns Bengaluru and Pune.
- `SumOfCityCounts` equals `11`.

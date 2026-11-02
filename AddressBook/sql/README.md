# SQL Scripts

Scripts are numbered in execution order. Run each script with the MySQL Command
Line Client or MySQL Workbench while connected to the `AddressBookService`
database unless the script itself creates/selects it.

## Execution Order

| Order | Script | Use Case |
| --- | --- | --- |
| 1 | `UC1_create_database.sql` | Create the `AddressBookService` database. |
| 2 | `UC2_create_contacts_table.sql` | Create the `Contacts` table. |

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

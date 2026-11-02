# SQL Scripts

Scripts are numbered in execution order. Run each script with the MySQL Command
Line Client or MySQL Workbench while connected to the `AddressBookService`
database unless the script itself creates/selects it.

## Execution Order

| Order | Script | Use Case |
| --- | --- | --- |
| 1 | `UC1_create_database.sql` | Create the `AddressBookService` database. |

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

# Week 06 - MySQL, ER Diagrams and JDBC

Repository for the Week 06 MySQL database assignment.

> **Scope note:** This submission uses **MySQL and SQL only**. JDBC and MySQL
> Connector/J have not been taught yet, so there is no Java database code,
> Spring Boot, C#, or ADO.NET.

## Projects

| Project | Status | Documentation |
| --- | --- | --- |
| **AddressBook System Database** (UC1-UC13) | Complete | [`AddressBook/README.md`](AddressBook/README.md) |
| **Employee Payroll** (Learning Problem) | Awaiting class problem statement | [`EmployeePayroll/README.md`](EmployeePayroll/README.md) |

## AddressBook Overview

The AddressBook project creates the `AddressBookService` MySQL database with:

- `Contacts` - one row per person.
- `AddressBook` - named address books of type Family, Friends, or Professional.
- `ContactAddressBook` - a junction table implementing a many-to-many
  relationship between contacts and address books.

All 13 use cases are implemented as separate SQL scripts. Sample data, test
results, execution order, and expected output are documented in
[`AddressBook/README.md`](AddressBook/README.md) and
[`AddressBook/sql/README.md`](AddressBook/sql/README.md).

The final ER diagram is
[`AddressBook/er-diagram/AddressBook_ER_Diagram.png`](AddressBook/er-diagram/AddressBook_ER_Diagram.png).
Normalization analysis is in
[`AddressBook/er-diagram/Normalization.md`](AddressBook/er-diagram/Normalization.md).

## Git Workflow

The repository follows the required feature-branch workflow:

```text
main
└── develop
    ├── feature/UC1
    ├── feature/UC2
    ├── ...
    └── feature/UC13
```

Rules followed:

- `main` contains only the initial README.
- `develop` is the integration branch.
- Each use case was implemented on its own feature branch created from the
  latest `develop`.
- Each feature branch was pushed, merged into `develop`, and left on the remote.
- No feature branch was merged into `main`.
- No use case was skipped.

## Quick Start

```bash
cd AddressBook
mysql -u root -p < sql/UC1_create_database.sql
# Continue with UC2 ... UC13 in the documented order.
```

See [`AddressBook/README.md`](AddressBook/README.md) for the complete command
sequence and testing instructions.

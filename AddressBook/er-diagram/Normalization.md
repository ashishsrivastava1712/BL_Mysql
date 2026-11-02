# Normalization and Database Design Review

## Final Schema

```text
Contacts (ContactID, FirstName, LastName, Address, City, State, Zip,
          PhoneNumber, Email, CreatedAt, UpdatedAt)
AddressBook (AddressBookID, AddressBookName, AddressBookType, Description, CreatedAt)
ContactAddressBook (ContactID, AddressBookID, AddedAt)
```

## Functional Dependencies

### Contacts

- `ContactID -> FirstName, LastName, Address, City, State, Zip, PhoneNumber,
  Email, CreatedAt, UpdatedAt`
- `(FirstName, LastName, PhoneNumber) -> ContactID, Address, City, State, Zip,
  Email, CreatedAt, UpdatedAt`
- `Email -> ContactID, FirstName, LastName, Address, City, State, Zip,
  PhoneNumber, CreatedAt, UpdatedAt`

`ContactID` is the surrogate primary key. The unique constraints on
`(FirstName, LastName, PhoneNumber)` and `Email` are candidate keys.

### AddressBook

- `AddressBookID -> AddressBookName, AddressBookType, Description, CreatedAt`
- `(AddressBookName, AddressBookType) -> AddressBookID, Description, CreatedAt`

`AddressBookID` is the surrogate primary key. The pair
`(AddressBookName, AddressBookType)` is a candidate key.

### ContactAddressBook

- `(ContactID, AddressBookID) -> AddedAt`

The composite key prevents the same contact from being added to the same
address book twice.

## Normalization Applied

### First Normal Form (1NF)

- Every column stores one atomic value.
- Full names are split into `FirstName` and `LastName`.
- Addresses are split into `Address`, `City`, `State`, and `Zip`.
- Repeating address-book membership is not stored as a list inside `Contacts`.
  It is moved to the `ContactAddressBook` rows.
- Each table has a primary key.

### Second Normal Form (2NF)

- `Contacts` and `AddressBook` have single-column primary keys, so partial
  dependency on part of a key is not possible.
- Every non-key column in `ContactAddressBook` (`AddedAt`) depends on the whole
  composite key `(ContactID, AddressBookID)`, not on only one part.

### Third Normal Form (3NF)

- Contact attributes depend on `ContactID`, not on another non-key attribute.
- Address-book name, type, and description depend on `AddressBookID`.
- Membership data depends on the membership pair.
- The temporary `Contacts.AddressBookID` column from UC9 created a one-to-many
  association. UC11 removed it and moved membership to the junction table, so
  membership data is no longer mixed into the `Contacts` entity.
- Every determinant is a candidate key, so the implemented schema also satisfies
  Boyce-Codd Normal Form (BCNF).

`Zip` is stored as part of a contact's address rather than as a key to a postal
master table. If the application needed an authoritative ZIP-to-city/state
reference, a `PostalCode(Zip PK, City, State)` table would be added and
`Contacts` would reference it. That postal master is outside the assignment
scope.

## Composite Attributes

| Attribute | Components | Treatment |
| --- | --- | --- |
| Person name | `FirstName`, `LastName` | Stored in separate atomic columns. |
| Address | street address, `City`, `State`, `Zip` | Stored in separate atomic columns. |
| Phone number | country code, area code, subscriber number | Stored as a validated formatted string. |

## Multivalued Attributes

- **Address-book membership** is multivalued for a contact: one person can
  belong to several address books. This is implemented by the
  `ContactAddressBook` junction table with a composite primary key.
- **Phone and email** are single-valued in the current assignment: each contact
  row has one phone number and one email address. If multiple phones or emails
  per person were required, the normalized extension would be separate
  `ContactPhone(ContactID, PhoneNumber)` and
  `ContactEmail(ContactID, Email)` tables. They are not added here because no
  use case requires multiple values.

## Primary Keys

| Table | Primary Key |
| --- | --- |
| `Contacts` | `ContactID` |
| `AddressBook` | `AddressBookID` |
| `ContactAddressBook` | `(ContactID, AddressBookID)` composite key |

## Foreign Keys

| Child column | Parent | Delete rule | Update rule |
| --- | --- | --- | --- |
| `ContactAddressBook.ContactID` | `Contacts.ContactID` | `CASCADE` | `CASCADE` |
| `ContactAddressBook.AddressBookID` | `AddressBook.AddressBookID` | `CASCADE` | `CASCADE` |

The `CASCADE` rules keep the junction table consistent: a removed contact or
address book cannot leave orphaned membership rows.

## Business Rules Enforced by the Database

- A contact row requires first name, last name, address, city, state, ZIP,
  phone, and email.
- ZIP, phone, and email formats are checked by `CHECK` constraints.
- `Email` is unique.
- `(FirstName, LastName, PhoneNumber)` is unique.
- An address book name is unique within its type.
- The same contact cannot appear twice in the same address book.
- Only `Family`, `Friends`, and `Professional` are accepted as address book
  types.

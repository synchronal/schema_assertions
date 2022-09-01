# Changelog

## Unreleased changes

## v0.3.0

- Update `assert_schema` failure message to show expected/actual, highlighting differences.
- Handle array fields in `assert_schema`.

## v0.2.2

- formatter doesn't put parens around `assert_belongs_to`, `assert_has_many` and `assert_has_one`

## v0.2.1

- `SchemaAssertions.assert_belongs_to/3` verifies that the column exists in the table.

## v0.2.0

- add `assert_has_one/3`.

## v0.1.4

- make `ChangesetAssertions.errors_on` private because many projects already have such a function,
  causing conflicts when `ChangesetAssertions` is imported.
  
## v0.1.3

- match `:utc_datetime_usec` in `assert_schema`.
- match `:naive_datetime` and `:naive_datetime_usec` - matches if the database is
  `:utc_datetime` / `:utc_datetime_usec`, as we're currently unable to tell the two apart
  from the database columns.

## v0.1.2

- add `SchemaAssertions.ChangesetAssertions`.

## v0.1.1

- initial release.

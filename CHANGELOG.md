# Changelog

## Unreleased changes

## v0.2.0

- add `assert_has_one/3`

## v0.1.4

- make `ChangesetAssertions.errors_on` private because many projects already have such a function,
  causing conflicts when `ChangesetAssertions` is imported
  
## v0.1.3

- match `:utc_datetime_usec` in `assert_schema`
- match `:naive_datetime` and `:naive_datetime_usec` - matches if the database is
  `:utc_datetime` / `:utc_datetime_usec`, as we're currently unable to tell the two apart
  from the database columns.

## v0.1.2

- add `SchemaAssertions.ChangesetAssertions`

## v0.1.1

- initial release

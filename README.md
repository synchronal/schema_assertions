# SchemaAssertions

ExUnit assertions for Ecto schemas.

## Installation

```elixir
def deps do
  [
    {:schema_assertions, "~> 2.0"}
  ]
end
```

## Development

SchemaAssertions uses [medic](https://github.com/synchronal/medic-rs) for its development workflow.

``` shell
brew bundle
medic doctor
medic test
medic audit
medic update
medic shipit
```

## Other useful schema-related libraries

* [excellent_migrations](https://hexdocs.pm/excellent_migrations/readme.html)

## License

This code is available under the Apache 2.0 license. See also [license](./license.txt).
Based on code from [Epi Viewpoint](https://github.com/RatioPBC/epi-viewpoint).

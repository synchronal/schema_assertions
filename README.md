# SchemaAssertions

ExUnit assertions for Ecto schemas.

## Sponsorship 💕

This library is part of the [Synchronal suite of libraries and tools](https://github.com/synchronal)
which includes more than 15 open source Elixir libraries as well as some Rust libraries and tools.

You can support our open source work by [sponsoring us](https://github.com/sponsors/reflective-dev).
If you have specific features in mind, bugs you'd like fixed, or new libraries you'd like to see,
file an issue or contact us at [contact@reflective.dev](mailto:contact@reflective.dev).

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

# Configuration for the test environments

import Config

if Mix.env() == :test do
  config :schema_assertions, ecto_repos: [SchemaAssertions.Test.Repo]

  config :schema_assertions, SchemaAssertions.Test.Repo,
    database: "schema_assertions_test",
    username: "postgres",
    password: "postgres",
    hostname: "localhost",
    port: 5432
end

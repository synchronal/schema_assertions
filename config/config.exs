# Configuration for the test environments

import Config

if Mix.env() == :test do
  config :logger, level: :warning, metadata: :all

  config :schema_assertions, ecto_repos: [SchemaAssertions.Test.Repo]

  config :schema_assertions, SchemaAssertions.Test.Repo,
    database: "schema_assertions_test",
    hostname: "localhost",
    password: "postgres",
    pool_size: 16,
    pool: Ecto.Adapters.SQL.Sandbox,
    port: 5432,
    queue_interval: 5000,
    queue_target: 300,
    username: "postgres"
end

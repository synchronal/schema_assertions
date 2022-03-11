defmodule SchemaAssertions.Test.Repo do
  use Ecto.Repo, otp_app: :schema_assertions, adapter: Ecto.Adapters.Postgres
end

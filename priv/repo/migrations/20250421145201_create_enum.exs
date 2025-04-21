defmodule SchemaAssertions.Test.Repo.Migrations.CreateEnums do
  use Ecto.Migration

  def change do
    execute "DROP TYPE IF EXISTS my_test_result_type", ""
    execute "DROP TYPE IF EXISTS bird_type", ""

    execute """
            CREATE TYPE my_test_result_type AS ENUM ('failed', 'succeeded', 'pending', 'running')
            """,
            "DROP TYPE my_test_result_type"

    execute """
            CREATE TYPE bird_type AS ENUM ('pigeon', 'sparrow')
            """,
            "DROP TYPE bird_type"
  end
end

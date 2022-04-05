defmodule SchemaAssertions do
  @moduledoc """
  ExUnit assertions for Ecto schemas.
  """

  import ExUnit.Assertions
  alias SchemaAssertions.Database
  alias SchemaAssertions.Schema

  @doc """
  Asserts that the given schema module exists.
  """
  @spec assert_schema(module(), binary()) :: true
  def assert_schema(schema_module, table_name) do
    if !Schema.module_exists?(schema_module) do
      flunk("Schema module #{inspect(schema_module)} does not exist.")
    end

    if !Schema.ecto_schema?(schema_module) do
      flunk("Schema module #{inspect(schema_module)} is not an Ecto schema.")
    end

    if !Database.table_exists?(table_name) do
      flunk("Database table #{inspect(table_name)} not found in #{inspect(Database.all_table_names())}")
    end

    true
  end
end

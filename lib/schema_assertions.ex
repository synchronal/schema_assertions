defmodule SchemaAssertions do
  @moduledoc """
  ExUnit assertions for Ecto schemas.
  """

  import ExUnit.Assertions
  alias SchemaAssertions.Database
  alias SchemaAssertions.Fieldset
  alias SchemaAssertions.Schema

  @doc """
  Asserts that the given schema module exists and that its corresponding database table exists.
  """
  @spec assert_schema(module(), binary(), Keyword.t()) :: true
  def assert_schema(schema_module, table_name, fields \\ []) do
    assert_schema_module_exists(schema_module)
    assert_is_ecto_schema(schema_module)
    assert_schema_table_exists(table_name)
    assert_schema_table_name(schema_module, table_name)
    assert_fields(schema_module, fields)

    true
  end

  def assert_fields(schema_module, fields) do
    schema_module
    |> Schema.table_name()
    |> Database.fieldset()
    |> Fieldset.same?(fields)
    |> case do
      :ok ->
        true

      {:error, [added: added, missing: missing]} ->
        flunk(
          to_string([
            "Expected fields to match database\n",
            "Added fields:\n  ",
            inspect(added),
            "\nMissing fields:\n  ",
            inspect(missing)
          ])
        )
    end
  end

  def assert_is_ecto_schema(schema_module) do
    assert Schema.ecto_schema?(schema_module),
           to_string(["Schema module ", inspect(schema_module), " is not an Ecto schema."])
  end

  def assert_schema_module_exists(schema_module) do
    assert Schema.module_exists?(schema_module),
           to_string(["Schema module ", inspect(schema_module), " does not exist."])
  end

  def assert_schema_table_exists(table_name) do
    assert Database.table_exists?(table_name),
           to_string(["Database table ", inspect(table_name), " not found in ", inspect(Database.all_table_names())])
  end

  def assert_schema_table_name(schema_module, expected_table_name) do
    table_name = Schema.table_name(schema_module)

    assert table_name == expected_table_name,
           to_string([
             "Expected ",
             inspect(schema_module),
             " to specify table name ",
             inspect(expected_table_name),
             " but was ",
             inspect(table_name)
           ])
  end
end

defmodule SchemaAssertions do
  # @related [test](/test/schema_assertions_test.exs)
  @moduledoc """
  ExUnit assertions for Ecto schemas.

  ## Examples

      iex> import SchemaAssertions
      iex> alias SchemaAssertions.Test.Schema
      ...>
      iex> assert_schema Schema.House, "houses",
      ...>     address: :text,
      ...>     id: :bigserial
      ...>
      iex> assert_schema Schema.House, "houses",
      ...>     address: :text,
      ...>     id: :id
  """

  import ExUnit.Assertions
  alias SchemaAssertions.Database
  alias SchemaAssertions.Fieldset
  alias SchemaAssertions.Schema

  @doc """
  Asserts that the given schema module has a belongs_to association.

  ## Example

      iex> alias SchemaAssertions.Test.Schema
      iex> SchemaAssertions.assert_belongs_to(Schema.Room, :house, Schema.House)
      true
  """
  @spec assert_belongs_to(module(), atom(), module()) :: true
  def assert_belongs_to(schema_module, association, association_module) do
    case Schema.belongs_to?(schema_module, association, association_module) do
      :ok ->
        true

      {:error, error} ->
        flunk(
          to_string([
            "Expected ",
            inspect(schema_module),
            " to belong to\n  ",
            inspect(association),
            "\nvia\n  ",
            inspect(association_module),
            "\n\n",
            error
          ])
        )
    end
  end

  @doc """
  Asserts that the given schema module exists and that its corresponding database table exists.
  """
  @spec assert_schema(module(), binary(), Keyword.t()) :: true | no_return()
  def assert_schema(schema_module, table_name, fields \\ []) do
    assert_schema_module_exists(schema_module)
    assert_is_ecto_schema(schema_module)
    assert_schema_table_exists(table_name)
    assert_schema_table_name(schema_module, table_name)
    assert_fields(schema_module, fields)

    true
  end

  @doc """
  Asserts that the given schema module has a has_one association.

  ## Example

      iex> alias SchemaAssertions.Test.Schema
      iex> SchemaAssertions.assert_has_one(Schema.House, :foundation, Schema.Foundation)
      true
  """
  @spec assert_has_one(module(), atom(), module()) :: true | no_return()
  def assert_has_one(schema_module, association, association_module) do
    case Schema.has_one?(schema_module, association, association_module) do
      :ok ->
        true

      {:error, error} ->
        flunk(
          to_string([
            "Expected ",
            inspect(schema_module),
            " to have one\n  ",
            inspect(association),
            "\nto\n  ",
            inspect(association_module),
            "\n\n",
            error
          ])
        )
    end
  end

  @doc """
  Asserts that the given schema module has a has_many or has_many :through association.

  ## Example

      iex> alias SchemaAssertions.Test.Schema
      iex> SchemaAssertions.assert_has_many(Schema.House, :rooms, Schema.Room)
      true

      iex> alias SchemaAssertions.Test.Schema
      iex> SchemaAssertions.assert_has_many(Schema.House, :windows, through: [:rooms, :windows])
      true
  """
  @spec assert_has_many(module(), atom(), module() | Keyword.t()) :: true
  def assert_has_many(schema_module, association, association_module_or_opts) do
    case Schema.has_many?(schema_module, association, association_module_or_opts) do
      :ok ->
        true

      {:error, :has_many, error} ->
        flunk(
          to_string([
            "Expected ",
            inspect(schema_module),
            " to have many\n  ",
            inspect(association),
            "\nto\n  ",
            inspect(association_module_or_opts),
            "\n\n",
            error
          ])
        )

      {:error, :has_many_through, error} ->
        flunk(
          to_string([
            "Expected ",
            inspect(schema_module),
            " to have many\n  ",
            inspect(association),
            "\n\n",
            inspect(association_module_or_opts),
            "\n\n",
            error
          ])
        )
    end
  end

  # # #

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

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

      iex> alias SchemaAssertions.Test.Schema
      iex> SchemaAssertions.assert_belongs_to(Schema.Pet, :home, Schema.House, source: :house_id)
      true
  """
  @spec assert_belongs_to(module(), atom(), module(), opts :: Schema.belongs_to_opts()) :: true
  def assert_belongs_to(schema_module, association, association_module, opts \\ []) do
    case Schema.belongs_to?(schema_module, association, association_module, opts) do
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

  def assert_enum(name, values) do
    enums = Database.all_enums()
    assert_is_enum(enums, name)
    assert_enum_values(enums, name, values)
    true
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
  def assert_has_one(schema_module, association, association_module_or_opts) do
    case Schema.has_one?(schema_module, association, association_module_or_opts) do
      :ok ->
        true

      {:error, :has_one, error} ->
        flunk(
          to_string([
            "Expected ",
            inspect(schema_module),
            " to have one\n  ",
            inspect(association),
            "\nto\n  ",
            inspect(association_module_or_opts),
            "\n\n",
            error
          ])
        )

      {:error, :has_one_through, error} ->
        flunk(
          to_string([
            "Expected ",
            inspect(schema_module),
            " to have one\n  ",
            inspect(association),
            "\n\n",
            inspect(association_module_or_opts),
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

  defp assert_enum_values(enums, name, expected) do
    expected = Enum.sort(expected)

    case Map.fetch!(enums, name) do
      ^expected ->
        :ok

      found ->
        flunk(
          to_string(
            IO.ANSI.format([
              :red,
              "Expected enum values to match\n",
              :cyan,
              "enum:     ",
              :bright,
              name,
              :reset,
              :cyan,
              "\nfound:    ",
              :green,
              Enum.join(found, "\n          "),
              :cyan,
              "\nexpected: ",
              :red,
              Enum.join(expected, "\n          "),
              :reset
            ])
          )
        )
    end
  end

  def assert_fields(schema_module, fields) do
    fieldset =
      schema_module
      |> Schema.table_name()
      |> Database.fieldset()

    fieldset
    |> Fieldset.same?(fields)
    |> case do
      :ok ->
        true

      {:error, [added: added, missing: missing]} ->
        flunk(
          to_string(
            IO.ANSI.format([
              "Expected fields to match database",
              :cyan,
              "\n\nExpected:\n",
              format_list_for_exception(fields, missing),
              :cyan,
              "\n\nActual:\n",
              format_list_for_exception(fieldset, added)
            ])
          )
        )
    end
  end

  def assert_is_ecto_schema(schema_module) do
    assert Schema.ecto_schema?(schema_module),
           to_string(["Schema module ", inspect(schema_module), " is not an Ecto schema."])
  end

  defp assert_is_enum(enums, name) when is_map_key(enums, name), do: true

  defp assert_is_enum(enums, name) do
    flunk(
      to_string(
        IO.ANSI.format([
          :red,
          "Expected enum to exist\n",
          :cyan,
          "expected: ",
          :red,
          name,
          "\n",
          :cyan,
          "found:    ",
          :green,
          Enum.join(Map.keys(enums), "\n          "),
          :reset
        ])
      )
    )
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

  defp format_list_for_exception(list, mismatched) do
    list
    |> Enum.sort_by(fn {k, _v} -> k end)
    |> Enum.reduce(["  [\n", :reset], fn {field, type}, acc ->
      acc = if Keyword.has_key?(mismatched, field), do: [:red | acc], else: acc
      [:reset, "    #{field}: #{inspect(type)}\n" | acc]
    end)
    |> Enum.reverse()
    |> IO.ANSI.format()
    |> to_string()
    |> Kernel.<>("  ]")
  end
end

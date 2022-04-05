defmodule SchemaAssertions.Database do
  @moduledoc """
  Functions for inspecting the database.

  Assumes Postgres for now.
  """

  @doc "Returns a sorted list of all the table names"
  @spec all_table_names() :: [binary()]
  def all_table_names() do
    "select table_name from information_schema.tables where table_schema = 'public'"
    |> query()
    |> List.flatten()
    |> Enum.sort()
  end

  @spec fieldset(binary()) :: Keyword.t()
  def fieldset(table_name) do
    query(
      """
      SELECT information_schema.columns.column_name, information_schema.columns.data_type, information_schema.columns.udt_name, information_schema.element_types.data_type
        FROM information_schema.columns
        LEFT JOIN information_schema.element_types
          ON information_schema.columns.dtd_identifier=information_schema.element_types.collection_type_identifier
            AND information_schema.element_types.object_name = $1
            AND information_schema.element_types.object_type = 'TABLE'
        WHERE information_schema.columns.table_name = $1
        ORDER BY information_schema.columns.column_name
      """,
      [table_name]
    )
    |> Enum.map(&to_field/1)
  end

  @doc "Returns true if a table with the given name is in the database"
  @spec table_exists?(binary()) :: boolean()
  def table_exists?(table_name) do
    table_name in all_table_names()
  end

  # # #

  defp query(string, args \\ []),
    do: repo().query!(string, args).rows

  defp repo() do
    case Application.get_env(:schema_assertions, :ecto_repos) do
      [repo] ->
        repo

      repos ->
        raise """
        Expected exactly 1 repo but got: #{inspect(repos)}
             Add the following to `config/test.exs`:

             config :schema_assertions, :ecto_repos, [MyApp.Repo]
        """
    end
  end

  defp to_field([column_name, "character varying", _udt_name, _element_type]),
    do: {String.to_atom(column_name), :string}

  defp to_field([column_name, "timestamp without time zone", _udt_name, _element_type]),
    do: {String.to_atom(column_name), :utc_datetime}

  defp to_field([column_name, column_type, _udt_name, _element_type]),
    do: {String.to_atom(column_name), String.to_atom(column_type)}
end

defmodule SchemaAssertions.Database do
  @moduledoc """
  Functions for inspecting the database.

  Assumes Postgres for now.
  """

  @doc "Returns a sorted list of all the table names"
  @spec all_table_names() :: [binary()]
  def all_table_names do
    "select table_name from information_schema.tables where table_schema = 'public'"
    |> query()
    |> List.flatten()
    |> Enum.sort()
  end

  @spec fieldset(binary()) :: Keyword.t()
  def fieldset(table_name) do
    query(
      """
      SELECT a.attname,
        CASE WHEN a.atttypid = ANY ('{int,int8,int2}'::regtype[])
                AND EXISTS (
                   SELECT FROM pg_attrdef ad
                   WHERE  ad.adrelid = a.attrelid
                   AND    ad.adnum   = a.attnum
                   AND    pg_get_expr(ad.adbin, ad.adrelid)
                        = 'nextval('''
                       || (pg_get_serial_sequence (a.attrelid::regclass::text
                                                , a.attname))::regclass
                       || '''::regclass)'
                   )
              THEN CASE a.atttypid
                      WHEN 'int'::regtype  THEN 'serial'
                      WHEN 'int8'::regtype THEN 'bigserial'
                      WHEN 'int2'::regtype THEN 'smallserial'
                   END
              ELSE format_type(a.atttypid, a.atttypmod)
              END AS data_type
      FROM   pg_attribute  a
      WHERE  a.attrelid = $1::text::regclass
      AND    a.attnum > 0
      AND    NOT a.attisdropped
      ORDER  BY a.attname;
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

  defp repo do
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

  defp to_field([column_name, "character varying" <> _]),
    do: {String.to_atom(column_name), :string}

  defp to_field([column_name, "timestamp(0) without time zone"]),
    do: {String.to_atom(column_name), :utc_datetime}

  defp to_field([column_name, "timestamp without time zone"]),
    do: {String.to_atom(column_name), :utc_datetime_usec}

  defp to_field([column_name, column_type]),
    do: {String.to_atom(column_name), String.to_atom(column_type)}
end

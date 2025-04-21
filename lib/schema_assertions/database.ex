defmodule SchemaAssertions.Database do
  @moduledoc """
  Functions for inspecting the database.

  Assumes Postgres for now.
  """

  def all_enums do
    """
    select t.typname as enum_name,
           array_agg(e.enumlabel) as enum_value,
           n.nspname as enum_schema
    from pg_type t
      join pg_enum e on t.oid = e.enumtypid
      join pg_catalog.pg_namespace n ON n.oid = t.typnamespace
    group by enum_schema, enum_name
    order by enum_name, enum_schema;
    """
    |> query()
    |> Map.new(fn [name, fields, _schema] ->
      {name, Enum.sort(fields)}
    end)
  end

  @doc "Returns a sorted list of all the table names"
  @spec all_table_names() :: [binary()]
  def all_table_names do
    all_tables_and_views_statement = """
    SELECT
      table_name
    FROM
      information_schema.tables
    WHERE
      table_schema = 'public'
    """

    all_materialized_views_statement = """
    SELECT
      matviewname AS table_name
    FROM
      pg_matviews
    WHERE
      schemaname = 'public'
    """

    "#{all_tables_and_views_statement} UNION #{all_materialized_views_statement}"
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

  defp to_field([column_name, data_type]) do
    field_type =
      if String.ends_with?(data_type, "[]"),
        do: {:array, to_field(String.trim_trailing(data_type, "[]"))},
        else: to_field(data_type)

    {String.to_atom(column_name), field_type}
  end

  defp to_field("character varying" <> _), do: :string
  defp to_field("timestamp(0) without time zone"), do: :utc_datetime
  defp to_field("timestamp without time zone"), do: :utc_datetime_usec
  defp to_field(column_type), do: String.to_atom(column_type)
end

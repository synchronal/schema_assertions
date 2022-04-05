defmodule SchemaAssertions.Database do
  def all_table_names() do
    "select table_name from information_schema.tables where table_schema = 'public'"
    |> query()
    |> List.flatten()
    |> Enum.sort()
  end

  def table_exists?(table_name) do
    table_name in all_table_names()
  end

  # # #

  defp query(string, args \\ []),
    do: repo().query!(string, args).rows

  defp repo() do
    case Application.get_env(:schema_assertions, :ecto_repos) do
      [repo] -> repo
      repos -> raise "Expected exactly 1 repo but got: #{inspect(repos)}"
    end
  end
end

defmodule SchemaAssertions.Schema do
  @moduledoc "Ecto schema introspection"

  @doc "Returns true if the given module is an Ecto schema"
  @spec ecto_schema?(module()) :: boolean()
  def ecto_schema?(module) do
    function_exported?(module, :__schema__, 1)
  end

  @doc "Returns true if the schema has a has_many relationship"
  @spec has_many?(module(), atom(), module() | Keyword.t()) :: :ok | {:error, atom(), String.t()}
  def has_many?(module, assoc_name, assoc_module_or_options) do
    case assoc_module_or_options do
      through: through ->
        has_many_through?(module, assoc_name, through)

      _ ->
        case module.__schema__(:association, assoc_name) do
          %Ecto.Association.Has{queryable: ^assoc_module_or_options} ->
            :ok

          %Ecto.Association.Has{queryable: queryable} ->
            {:error, :has_many, "Found module: #{queryable}"}

          _other ->
            {:error, :has_many, "Association not found"}
        end
    end
  end

  @doc "Returns true if the given module exists"
  @spec module_exists?(module()) :: boolean()
  def module_exists?(module) do
    Code.ensure_loaded?(module)
  end

  @doc "Returns the database table name for the given module"
  @spec table_name(module()) :: binary()
  def table_name(module) do
    module.__schema__(:source)
  end

  # # #

  defp has_many_through?(module, assoc_name, through) do
    case module.__schema__(:association, assoc_name) do
      %Ecto.Association.HasThrough{through: ^through} -> :ok
      %Ecto.Association.HasThrough{through: actual} -> {:error, :has_many_through, "Found: #{inspect(actual)}"}
      _other -> {:error, :has_many_through, "Association not found"}
    end
  end
end

defmodule SchemaAssertions.Schema do
  @moduledoc "Ecto schema introspection"

  @doc "Returns true if the given module is an Ecto schema"
  @spec ecto_schema?(module()) :: boolean()
  def ecto_schema?(module) do
    function_exported?(module, :__schema__, 1)
  end

  @doc "Returns true if the given module exists"
  @spec module_exists?(module()) :: boolean()
  def module_exists?(module) do
    Code.ensure_loaded?(module)
  end
end

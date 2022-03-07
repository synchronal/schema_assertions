defmodule SchemaAssertions.Schema do
  @moduledoc "Ecto schema introspection"
  def module_exists?(module) do
    Code.ensure_loaded?(module)
  end
end

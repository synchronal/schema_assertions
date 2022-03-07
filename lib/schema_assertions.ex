defmodule SchemaAssertions do
  @moduledoc """
  ExUnit assertions for Ecto schemas.
  """

  import ExUnit.Assertions
  alias SchemaAssertions.Schema

  @doc """
  Asserts that the given schema module exists.
  """
  @spec assert_schema(module()) :: true
  def assert_schema(schema_module) do
    if !Schema.module_exists?(schema_module) do
      flunk("Schema module #{schema_module} does not exist.")
    end

    true
  end
end

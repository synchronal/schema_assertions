defmodule SchemaAssertions.SchemaTest do
  use ExUnit.Case, async: true

  alias SchemaAssertions.Schema
  alias SchemaAssertions.Test

  describe "module_exists?" do
    test "returns true if the given module exists" do
      assert Schema.module_exists?(Test.Schema.House)
    end

    test "returns false if the given module does not exist" do
      refute Schema.module_exists?(Test.Schema.NonExistent)
    end
  end
end

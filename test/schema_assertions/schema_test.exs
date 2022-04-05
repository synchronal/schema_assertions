defmodule SchemaAssertions.SchemaTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias SchemaAssertions.Schema
  alias SchemaAssertions.Test

  describe "ecto_schema?" do
    test "returns true when the module is an Ecto schema" do
      Code.ensure_loaded?(Test.Schema.House)
      assert Schema.ecto_schema?(Test.Schema.House)
    end

    test "returns false when the module is not an Ecto schema" do
      Code.ensure_loaded?(Test.Schema.NotAnEctoSchema)
      refute Schema.ecto_schema?(Test.Schema.NotAnEctoSchema)
    end
  end

  describe "module_exists?" do
    test "returns true if the given module exists" do
      assert Schema.module_exists?(Test.Schema.House)
    end

    test "returns false if the given module does not exist" do
      refute Schema.module_exists?(Test.Schema.NonExistent)
    end
  end

  describe "table_name" do
    test "returns the name of the schema's database table" do
      assert Schema.table_name(Test.Schema.House) == "houses"
    end
  end
end

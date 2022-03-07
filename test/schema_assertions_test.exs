defmodule SchemaAssertionsTest do
  @moduledoc false
  use ExUnit.Case, async: true

  describe "assert_schema" do
    test "succeeds when the schema module exists" do
      SchemaAssertions.assert_schema(SchemaAssertions.Test.Schema.House)
    end

    test "fails when the schema module does not exist" do
      assert_raise ExUnit.AssertionError, fn ->
        SchemaAssertions.assert_schema(SchemaAssertions.Test.Schema.NonExistent)
      end
    end
  end
end

defmodule SchemaAssertionsTest do
  @moduledoc false
  use ExUnit.Case, async: true

  describe "assert_schema" do
    test "succeeds when the schema is valid according to the function args" do
      SchemaAssertions.assert_schema(SchemaAssertions.Test.Schema.House)
    end

    test "fails when the schema module does not exist" do
      assert_raise ExUnit.AssertionError,
                   "\n\nSchema module SchemaAssertions.Test.Schema.NonExistent does not exist.\n",
                   fn ->
                     SchemaAssertions.assert_schema(SchemaAssertions.Test.Schema.NonExistent)
                   end
    end

    test "fails when the schema module exists but is not an Ecto schema" do
      assert_raise ExUnit.AssertionError,
                   "\n\nSchema module SchemaAssertions.Test.Schema.NotAnEctoSchema is not an Ecto schema.\n",
                   fn ->
                     SchemaAssertions.assert_schema(SchemaAssertions.Test.Schema.NotAnEctoSchema)
                   end
    end
  end
end

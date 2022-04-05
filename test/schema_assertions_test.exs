defmodule SchemaAssertionsTest do
  @moduledoc false
  use ExUnit.Case, async: true

  describe "assert_schema" do
    test "succeeds when the schema is valid according to the function args" do
      SchemaAssertions.assert_schema(SchemaAssertions.Test.Schema.House, "houses")
    end

    test "fails when the schema module does not exist" do
      assert_raise ExUnit.AssertionError,
                   "\n\nSchema module SchemaAssertions.Test.Schema.NonExistent does not exist.\n",
                   fn ->
                     SchemaAssertions.assert_schema(SchemaAssertions.Test.Schema.NonExistent, "non_existent")
                   end
    end

    test "fails when the schema module exists but is not an Ecto schema" do
      assert_raise ExUnit.AssertionError,
                   "\n\nSchema module SchemaAssertions.Test.Schema.NotAnEctoSchema is not an Ecto schema.\n",
                   fn ->
                     SchemaAssertions.assert_schema(SchemaAssertions.Test.Schema.NotAnEctoSchema, "not_an_ecto_schema")
                   end
    end

    test "fails when the table does not exist" do
      assert_raise ExUnit.AssertionError,
                   "\n\nDatabase table \"wrong_table_name\" not found in [\"houses\", \"schema_migrations\"]\n",
                   fn ->
                     SchemaAssertions.assert_schema(SchemaAssertions.Test.Schema.House, "wrong_table_name")
                   end
    end
  end
end

defmodule SchemaAssertionsTest do
  @moduledoc false
  use ExUnit.Case, async: true

  describe "assert_schema" do
    test "succeeds when the schema is valid according to the function args" do
      SchemaAssertions.assert_schema(SchemaAssertions.Test.Schema.House, "houses", address: :text, id: :id)
    end

    test "fails when an expected field does not exist in the database" do
      assert_raise ExUnit.AssertionError,
                   """
                   \n\nExpected fields to match database
                        Added fields:
                          [id: :bigint]
                        Missing fields:
                          [id: :id, population: :integer]
                   """,
                   fn ->
                     SchemaAssertions.assert_schema(SchemaAssertions.Test.Schema.House, "houses",
                       address: :text,
                       id: :id,
                       population: :integer
                     )
                   end
    end

    test "fails when the schema module does not exist" do
      assert_raise ExUnit.AssertionError,
                   ~s|\n\nSchema module SchemaAssertions.Test.Schema.NonExistent does not exist.\n|,
                   fn ->
                     SchemaAssertions.assert_schema(SchemaAssertions.Test.Schema.NonExistent, "non_existent")
                   end
    end

    test "fails when the schema module exists but is not an Ecto schema" do
      assert_raise ExUnit.AssertionError,
                   ~s|\n\nSchema module SchemaAssertions.Test.Schema.NotAnEctoSchema is not an Ecto schema.\n|,
                   fn ->
                     SchemaAssertions.assert_schema(SchemaAssertions.Test.Schema.NotAnEctoSchema, "not_an_ecto_schema")
                   end
    end

    test "fails when the table does not exist" do
      assert_raise ExUnit.AssertionError,
                   ~s|\n\nDatabase table "non_existent_table_name" not found in ["cars", "houses", "pets", "schema_migrations"]\n|,
                   fn ->
                     SchemaAssertions.assert_schema(SchemaAssertions.Test.Schema.House, "non_existent_table_name")
                   end
    end

    test "fails when the table name does not match the schema's table name" do
      assert_raise ExUnit.AssertionError,
                   ~s|\n\nExpected SchemaAssertions.Test.Schema.House to specify table name "cars" but was "houses"\n|,
                   fn ->
                     SchemaAssertions.assert_schema(SchemaAssertions.Test.Schema.House, "cars")
                   end
    end
  end
end

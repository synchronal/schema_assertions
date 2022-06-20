defmodule SchemaAssertionsTest do
  # @related [subject](/lib/schema_assertions.ex)
  @moduledoc false
  use ExUnit.Case, async: true
  alias SchemaAssertions.Test.Schema

  doctest SchemaAssertions

  describe "assert_belongs_to" do
    test "succeeds when the schema has a relationship according the function args" do
      SchemaAssertions.assert_belongs_to(Schema.Room, :house, Schema.House)
    end

    test "fails when no association exists" do
      assert_raise ExUnit.AssertionError,
                   """
                   \n\nExpected SchemaAssertions.Test.Schema.Room to belong to
                          :window
                        via
                          SchemaAssertions.Test.Schema.Window
                        
                        Association not found
                   """,
                   fn ->
                     SchemaAssertions.assert_belongs_to(Schema.Room, :window, Schema.Window)
                   end
    end

    test "fails when through association does not match" do
      assert_raise ExUnit.AssertionError,
                   """
                   \n\nExpected SchemaAssertions.Test.Schema.Room to belong to
                          :house
                        via
                          SchemaAssertions.Test.Schema.Window
                        
                        Found module: Elixir.SchemaAssertions.Test.Schema.House
                   """,
                   fn ->
                     SchemaAssertions.assert_belongs_to(Schema.Room, :house, Schema.Window)
                   end
    end
  end

  describe "assert_schema" do
    test "succeeds when the schema is valid according to the function args" do
      SchemaAssertions.assert_schema(SchemaAssertions.Test.Schema.House, "houses", address: :text, id: :id)
    end

    test "fails when an expected field does not exist in the database" do
      assert_raise ExUnit.AssertionError,
                   """
                   \n\nExpected fields to match database
                        Added fields:
                          [id: :bigserial]
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

    test "fails when low-precision datetimes are incorrectly compared with high-precision datetimes" do
      assert_raise ExUnit.AssertionError,
                   """
                   \n\nExpected fields to match database
                        Added fields:
                          [dob: :utc_datetime, dob_usec: :utc_datetime_usec, last_seen_vet: :utc_datetime, last_seen_vet_usec: :utc_datetime_usec]
                        Missing fields:
                          [dob: :naive_datetime_usec, dob_usec: :naive_datetime, last_seen_vet: :utc_datetime_usec, last_seen_vet_usec: :utc_datetime]
                   """,
                   fn ->
                     SchemaAssertions.assert_schema(SchemaAssertions.Test.Schema.Pet, "pets",
                       id: :uuid,
                       feet_count: :integer,
                       friendly: :boolean,
                       last_seen_vet: :utc_datetime_usec,
                       last_seen_vet_usec: :utc_datetime,
                       dob: :naive_datetime_usec,
                       dob_usec: :naive_datetime,
                       nickname: :string,
                       teeth_count: :bigint
                     )
                   end
    end

    test "passes when low-precision datetimes are correctly compared with high-precision datetimes" do
      SchemaAssertions.assert_schema(SchemaAssertions.Test.Schema.Pet, "pets",
        id: :uuid,
        feet_count: :integer,
        friendly: :boolean,
        last_seen_vet: :utc_datetime,
        last_seen_vet_usec: :utc_datetime_usec,
        dob: :naive_datetime,
        dob_usec: :naive_datetime_usec,
        nickname: :string,
        teeth_count: :bigint
      )
    end
  end

  describe "assert_has_one" do
    alias SchemaAssertions.Test.Schema.House

    test("succeeds when the schema has a relationship according the function args") do
      SchemaAssertions.assert_has_one(House, :foundation, SchemaAssertions.Test.Schema.Foundation)
    end

    test "fails when no association exists" do
      assert_raise ExUnit.AssertionError,
                   """
                   \n\nExpected SchemaAssertions.Test.Schema.House to have one
                          :window
                        to
                          SchemaAssertions.Test.Schema.Window
                        
                        Association not found
                   """,
                   fn ->
                     SchemaAssertions.assert_has_one(House, :window, SchemaAssertions.Test.Schema.Window)
                   end
    end

    test "fails when association module does not match" do
      assert_raise ExUnit.AssertionError,
                   """
                   \n\nExpected SchemaAssertions.Test.Schema.House to have one
                          :foundation
                        to
                          SchemaAssertions.Test.Schema.Window
                        
                        Found module: Elixir.SchemaAssertions.Test.Schema.Foundation
                   """,
                   fn ->
                     SchemaAssertions.assert_has_one(House, :foundation, SchemaAssertions.Test.Schema.Window)
                   end
    end
  end

  describe "assert_has_many" do
    alias SchemaAssertions.Test.Schema.House

    test("succeeds when the schema has a relationship according the function args") do
      SchemaAssertions.assert_has_many(House, :rooms, SchemaAssertions.Test.Schema.Room)
      SchemaAssertions.assert_has_many(House, :windows, through: [:rooms, :windows])
    end

    test "fails when no association exists" do
      assert_raise ExUnit.AssertionError,
                   """
                   \n\nExpected SchemaAssertions.Test.Schema.House to have many
                          :people
                        to
                          SchemaAssertions.Test.Schema.Person
                        
                        Association not found
                   """,
                   fn ->
                     SchemaAssertions.assert_has_many(House, :people, SchemaAssertions.Test.Schema.Person)
                   end
    end

    test "fails when association module does not match" do
      assert_raise ExUnit.AssertionError,
                   """
                   \n\nExpected SchemaAssertions.Test.Schema.House to have many
                          :rooms
                        to
                          SchemaAssertions.Test.Schema.Window
                        
                        Found module: Elixir.SchemaAssertions.Test.Schema.Room
                   """,
                   fn ->
                     SchemaAssertions.assert_has_many(House, :rooms, SchemaAssertions.Test.Schema.Window)
                   end
    end

    test "fails when no through association exists" do
      assert_raise ExUnit.AssertionError,
                   """
                   \n\nExpected SchemaAssertions.Test.Schema.House to have many
                          :people
                        
                        [through: [:rooms, :people]]
                        
                        Association not found
                   """,
                   fn ->
                     SchemaAssertions.assert_has_many(House, :people, through: [:rooms, :people])
                   end
    end

    test "fails when through association does not match" do
      assert_raise ExUnit.AssertionError,
                   """
                   \n\nExpected SchemaAssertions.Test.Schema.House to have many
                          :windows
                        
                        [through: [:rooms, :people]]
                        
                        Found: [:rooms, :windows]
                   """,
                   fn ->
                     SchemaAssertions.assert_has_many(House, :windows, through: [:rooms, :people])
                   end
    end
  end
end

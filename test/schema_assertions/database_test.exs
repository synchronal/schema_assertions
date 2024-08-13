defmodule SchemaAssertions.DatabaseTest do
  use SchemaAssertions.DataCase, async: true

  alias SchemaAssertions.Database

  describe "all_table_names" do
    test "lists all the table names, in alphabetical order" do
      assert Database.all_table_names() == [
               "cars",
               "house_addresses",
               "houses",
               "materialized_house_addresses",
               "pets",
               "rooms",
               "schema_migrations"
             ]
    end
  end

  describe "fieldset" do
    test "translates columns for a table into a keyword list of fields, in alphabetical order" do
      assert Database.fieldset("houses") == [
               address: :text,
               id: :bigserial
             ]
    end

    test "translates columns for a view into a keyword list of fields, in alphabetical order" do
      assert Database.fieldset("house_addresses") == [
               address: :text,
               house_id: :bigint
             ]
    end

    test "translates columns for a materialized view into a keyword list of fields, in alphabetical order" do
      assert Database.fieldset("materialized_house_addresses") == [
               address: :text,
               house_id: :bigint
             ]
    end

    test "translates different types of fields" do
      assert Database.fieldset("pets") == [
               dob: :utc_datetime,
               dob_usec: :utc_datetime_usec,
               favorite_numbers: {:array, :integer},
               feet_count: :integer,
               friendly: :boolean,
               house_id: :bigint,
               id: :uuid,
               last_seen_vet: :utc_datetime,
               last_seen_vet_usec: :utc_datetime_usec,
               nickname: :string,
               teeth_count: :bigint,
               toys: {:array, :string}
             ]
    end
  end

  describe "table_exists?" do
    test "returns true if the table exists" do
      assert Database.table_exists?("houses")
    end

    test "returns false if the table does not exist" do
      refute Database.table_exists?("not_a_table_name")
    end
  end
end

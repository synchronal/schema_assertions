defmodule SchemaAssertions.DatabaseTest do
  use SchemaAssertions.DataCase, async: true

  alias SchemaAssertions.Database

  describe "all_table_names" do
    test "lists all the table names" do
      assert Database.all_table_names() == ["houses", "schema_migrations"]
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

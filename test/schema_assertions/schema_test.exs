defmodule SchemaAssertions.SchemaTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias SchemaAssertions.Schema
  alias SchemaAssertions.Test

  setup do
    Code.ensure_loaded?(Test.Schema.House)
    Code.ensure_loaded?(Test.Schema.Room)
    Code.ensure_loaded?(Test.Schema.NotAnEctoSchema)
    :ok
  end

  describe "belongs_to?" do
    test "returns :ok when the schema has a has_many relationship" do
      assert :ok = Schema.belongs_to?(Test.Schema.Room, :house, Test.Schema.House)
    end

    test "returns error when the associated module does not match" do
      assert {:error, "Found module: Elixir.SchemaAssertions.Test.Schema.House"} =
               Schema.belongs_to?(Test.Schema.Room, :house, Test.Schema.Window)
    end

    test "returns error when the schema does not have a belongs_to relationship" do
      assert {:error, "Association not found"} = Schema.belongs_to?(Test.Schema.House, :person, Test.Schema.Person)
    end
  end

  describe "ecto_schema?" do
    test "returns true when the module is an Ecto schema" do
      assert Schema.ecto_schema?(Test.Schema.House)
    end

    test "returns false when the module is not an Ecto schema" do
      refute Schema.ecto_schema?(Test.Schema.NotAnEctoSchema)
    end
  end

  describe "has_many?" do
    test "returns :ok when the schema has a has_many relationship" do
      assert :ok = Schema.has_many?(Test.Schema.House, :rooms, Test.Schema.Room)
    end

    test "returns :ok when the schema has a has_many :through relationship" do
      assert :ok = Schema.has_many?(Test.Schema.House, :windows, through: [:rooms, :windows])
    end

    test "returns error when the associated module does not match" do
      assert {:error, :has_many, "Found module: Elixir.SchemaAssertions.Test.Schema.Room"} =
               Schema.has_many?(Test.Schema.House, :rooms, Test.Schema.Window)
    end

    test "returns error when the schema does not have a has_many relationship" do
      assert {:error, :has_many, "Association not found"} =
               Schema.has_many?(Test.Schema.House, :people, Test.Schema.Person)
    end

    test "returns error when the schema does not have a has_many :through relationship" do
      assert {:error, :has_many_through, "Association not found"} =
               Schema.has_many?(Test.Schema.House, :people, through: [:rooms, :people])
    end

    test "returns error when the :through relationship does not match" do
      assert {:error, :has_many_through, "Found: [:rooms, :windows]"} =
               Schema.has_many?(Test.Schema.House, :windows, through: [:rooms, :people])
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

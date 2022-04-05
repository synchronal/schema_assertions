defmodule SchemaAssertions.FieldsetTest do
  use SchemaAssertions.DataCase, async: true

  alias SchemaAssertions.Fieldset

  describe "same?" do
    test "succeeds when the database fields match the expected fields" do
      assert :ok = Fieldset.same?([id: :bigint, name: :string], name: :string, id: :bigint)
    end

    test "succeeds when an expected :id field is a bigint" do
      assert :ok = Fieldset.same?([id: :bigint, name: :string], id: :id, name: :string)
    end

    test "succeeds when an expected :binary_id field is a uuid" do
      assert :ok = Fieldset.same?([id: :uuid, name: :string], id: :binary_id, name: :string)
    end

    test "fails when an expected field is not present in the database" do
      assert {:error, [added: [], missing: [name: :string]]} =
               Fieldset.same?(
                 [id: :bigint],
                 id: :bigint,
                 name: :string
               )
    end

    test "fails when the database has extra fields" do
      assert {:error, [added: [name: :string], missing: []]} =
               Fieldset.same?(
                 [id: :bigint, name: :string],
                 id: :bigint
               )
    end

    test "fails when a field type does not match" do
      assert {:error, [added: [name: :string], missing: [name: :text]]} =
               Fieldset.same?(
                 [id: :bigint, name: :string],
                 id: :bigint,
                 name: :text
               )
    end
  end
end

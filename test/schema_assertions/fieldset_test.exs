defmodule SchemaAssertions.FieldsetTest do
  use SchemaAssertions.DataCase, async: true

  alias SchemaAssertions.Fieldset

  describe "same?" do
    test "succeeds when the database fields match the expected fields" do
      assert :ok = Fieldset.same?([foo: :bigint, bar: :string], bar: :string, foo: :bigint)
    end

    test "succeeds when an expected :id field is a bigserial" do
      assert :ok = Fieldset.same?([foo: :bigserial, bar: :string], foo: :id, bar: :string)
      assert :ok = Fieldset.same?([foo: :bigserial, bar: :string], foo: :bigserial, bar: :string)
    end

    test "succeeds when an expected :binary_id field is a uuid" do
      assert :ok = Fieldset.same?([foo: :uuid, bar: :string], foo: :binary_id, bar: :string)
      assert :ok = Fieldset.same?([foo: :uuid, bar: :string], foo: :uuid, bar: :string)
    end

    test "succeeds when an expected :decimal field is a numeric" do
      assert :ok = Fieldset.same?([foo: :numeric, bar: :string], foo: :decimal, bar: :string)
    end

    test "fails when an expected field is not present in the database" do
      assert {:error, [added: [], missing: [bar: :string]]} =
               Fieldset.same?(
                 [foo: :bigint],
                 foo: :bigint,
                 bar: :string
               )
    end

    test "fails when the database has extra fields" do
      assert {:error, [added: [bar: :string], missing: []]} =
               Fieldset.same?(
                 [foo: :bigint, bar: :string],
                 foo: :bigint
               )
    end

    test "fails when a field type does not match" do
      assert {:error, [added: [bar: :string], missing: [bar: :text]]} =
               Fieldset.same?(
                 [foo: :bigint, bar: :string],
                 foo: :bigint,
                 bar: :text
               )
    end
  end
end

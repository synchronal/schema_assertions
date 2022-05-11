defmodule SchemaAssertions.ChangesetAssertions do
  @moduledoc """
  Assertions for changeset validity.
  """

  import ExUnit.Assertions

  @doc """
  Assert that a changeset's fields match the expected values. The field values are obtained via
  `Ecto.Changeset.fetch_field!/2` and are the values from either the changes or the data.
  """
  def assert_changeset_fields(changeset, fields) do
    expected = fields |> Enum.into(%{})
    actual = Map.new(expected, fn {name, _value} -> {name, Ecto.Changeset.fetch_field!(changeset, name)} end)
    assert actual == expected
    changeset
  end

  @doc """
  Assert that a changeset is invalid, including asserting on all of its validation errors

  Example: `assert_changeset_invalid(changeset, start_date: ["please enter dates as mm/dd/yyyy"])`
  """
  def assert_changeset_invalid(tuple_or_changeset, expected_errors \\ nil)

  def assert_changeset_invalid({:error, %Ecto.Changeset{} = changeset}, expected_errors),
    do: assert_changeset_invalid(changeset, expected_errors)

  def assert_changeset_invalid({:ok, _} = arg, _expected_errors),
    do: flunk("Got an {:ok, _} tuple, expected an {:error, _} tuple or no tuple:\n#{inspect(arg)}")

  def assert_changeset_invalid(%Ecto.Changeset{valid?: true}, _expected_errors),
    do: flunk("Expected changeset to be invalid but it was valid.")

  def assert_changeset_invalid(%Ecto.Changeset{valid?: false} = changeset, nil = _expected_errors),
    do: changeset

  def assert_changeset_invalid(%Ecto.Changeset{valid?: false} = changeset, expected_errors) do
    assert(errors_on(changeset) == Enum.into(expected_errors, %{}))
    changeset
  end

  @doc """
  Assert that a changeset is valid

  Example: `assert_changeset_valid(changeset)`
  """
  def assert_changeset_valid(%Ecto.Changeset{valid?: false} = changeset),
    do: flunk("Expected changeset to be valid, but it was invalid:\n#{inspect(errors_on(changeset))}")

  def assert_changeset_valid(%Ecto.Changeset{valid?: true} = changeset),
    do: changeset

  # # #

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end

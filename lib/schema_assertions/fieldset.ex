defmodule SchemaAssertions.Fieldset do
  @moduledoc """
  Functions for comparing fieldsets from different sources.
  """

  @spec same?(Keyword.t(), Keyword.t()) :: :ok | {:error, [added: Keyword.t(), missing: Keyword.t()]}
  def same?(database_fieldset, expected_fieldset) do
    db_fields = database_fieldset |> MapSet.new()
    ex_fields = expected_fieldset |> MapSet.new()

    if MapSet.equal?(normalize(db_fields), normalize(ex_fields)) do
      :ok
    else
      added = db_fields |> MapSet.difference(ex_fields)
      missing = ex_fields |> MapSet.difference(db_fields)

      {:error, [added: Enum.into(added, []), missing: Enum.into(missing, [])]}
    end
  end

  defp normalize(fieldset) do
    Enum.map(fieldset, fn
      {key, :binary_id} -> {key, :uuid}
      {key, :id} -> {key, :bigint}
      other -> other
    end)
    |> MapSet.new()
  end
end

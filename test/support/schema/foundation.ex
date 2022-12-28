defmodule SchemaAssertions.Test.Schema.Foundation do
  @moduledoc false
  use Ecto.Schema

  schema "foundations" do
    belongs_to :house, SchemaAssertions.Test.Schema.House
    belongs_to :foundation_type, SchemaAssertions.Test.Schema.FoundationType
  end
end

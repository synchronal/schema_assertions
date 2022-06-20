defmodule SchemaAssertions.Test.Schema.Foundation do
  @moduledoc false
  use Ecto.Schema

  schema "foundations" do
    belongs_to :house, SchemaAssertions.Test.Schema.House
  end
end

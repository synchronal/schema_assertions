defmodule SchemaAssertions.Test.Schema.MaterializedHouseAddress do
  @moduledoc false
  use Ecto.Schema

  schema "materialized_house_addresses" do
    field :address, :string

    belongs_to :house, SchemaAssertions.Test.Schema.House
  end
end

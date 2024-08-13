defmodule SchemaAssertions.Test.Schema.HouseAddress do
  @moduledoc false
  use Ecto.Schema

  schema "house_addresses" do
    field :address, :string

    belongs_to :house, SchemaAssertions.Test.Schema.House
  end
end

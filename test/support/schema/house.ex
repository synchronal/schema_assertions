defmodule SchemaAssertions.Test.Schema.House do
  @moduledoc false
  use Ecto.Schema

  schema "houses" do
    field :address, :string

    has_one :foundation, SchemaAssertions.Test.Schema.Foundation
    has_many :rooms, SchemaAssertions.Test.Schema.Room
    has_many :windows, through: [:rooms, :windows]
  end
end

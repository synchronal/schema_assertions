defmodule SchemaAssertions.Test.Schema.Room do
  @moduledoc false
  use Ecto.Schema

  schema "rooms" do
    belongs_to :house, SchemaAssertions.Test.Schema.House
    has_many :windows, SchemaAssertions.Test.Schema.Window
  end
end

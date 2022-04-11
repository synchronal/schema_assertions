defmodule SchemaAssertions.Test.Schema.Window do
  @moduledoc false
  use Ecto.Schema

  schema "windows" do
    belongs_to :room, SchemaAssertions.Test.Schema.Room
  end
end

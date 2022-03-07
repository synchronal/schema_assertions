defmodule SchemaAssertions.Test.Schema.House do
  @moduledoc false
  use Ecto.Schema

  schema "houses" do
    field :address, :string
  end
end

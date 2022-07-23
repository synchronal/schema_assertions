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

defmodule SchemaAssertions.Test.Schema.HouseBadAssoc do
  @moduledoc false
  use Ecto.Schema

  schema "houses" do
    field :address, :string

    belongs_to :foundation, SchemaAssertions.Test.Schema.Foundation
  end
end

defmodule SchemaAssertions.Test.Schema.Pet do
  @moduledoc false
  use Ecto.Schema

  schema "pets" do
    field :feet_count, :integer
    field :friendly, :boolean
    field :last_seen_vet, :utc_datetime_usec
    field :last_seen_vet_usec, :utc_datetime
    field :dob, :naive_datetime_usec
    field :dob_usec, :naive_datetime
    field :nickname, :string
    field :teeth_count, :integer

    belongs_to :home, SchemaAssertions.Test.Schema.House, source: :house_id
  end
end

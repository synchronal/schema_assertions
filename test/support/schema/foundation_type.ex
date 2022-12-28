defmodule SchemaAssertions.Test.Schema.FoundationType do
  @moduledoc false
  use Ecto.Schema

  schema "foundation_types" do
    belongs_to :foundation, SchemaAssertions.Test.Schema.Foundation
  end
end

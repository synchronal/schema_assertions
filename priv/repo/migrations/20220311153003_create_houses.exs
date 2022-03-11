defmodule SchemaAssertions.Test.Repo.Migrations.CreateHouses do
  use Ecto.Migration

  def change do
    create table(:houses) do
      add(:address, :text)
    end
  end
end

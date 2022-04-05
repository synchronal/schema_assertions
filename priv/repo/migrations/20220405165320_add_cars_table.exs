defmodule SchemaAssertions.Test.Repo.Migrations.AddCars do
  use Ecto.Migration

  def change do
    create table(:cars) do
      add :brand, :text
    end
  end
end

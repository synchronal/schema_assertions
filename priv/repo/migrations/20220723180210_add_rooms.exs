defmodule SchemaAssertions.Test.Repo.Migrations.AddRooms do
  use Ecto.Migration

  def change do
    create table(:rooms, primary_key: false) do
      add :house_id, references(:houses)
    end
  end
end

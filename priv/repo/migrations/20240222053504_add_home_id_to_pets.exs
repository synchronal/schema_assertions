defmodule SchemaAssertions.Test.Repo.Migrations.AddHomeIdToPets do
  use Ecto.Migration

  def change do
    alter table(:pets) do
      add(:house_id, references(:houses))
    end
  end
end

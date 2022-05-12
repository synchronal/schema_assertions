defmodule SchemaAssertions.Test.Repo.Migrations.AddPets do
  use Ecto.Migration

  def change do
    create table(:pets, primary_key: false) do
      add :id, :binary_id
      add :feet_count, :integer
      add :friendly, :boolean
      add :last_seen_vet, :utc_datetime
      add :last_seen_vet_usec, :utc_datetime_usec
      add :dob, :naive_datetime
      add :dob_usec, :naive_datetime_usec
      add :nickname, :string
      add :teeth_count, :bigint
    end
  end
end

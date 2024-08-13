defmodule SchemaAssertions.Test.Repo.Migrations.CreateHouseAddressesView do
  use Ecto.Migration

  @view_name "house_addresses"

  def change do
    execute(
      """
      CREATE VIEW #{@view_name} AS (
      SELECT
        address AS address,
        id AS house_id
      FROM houses
      )
      """,
      """
      DROP VIEW #{@view_name}
      """
    )
  end
end

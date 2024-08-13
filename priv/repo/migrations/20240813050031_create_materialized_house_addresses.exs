defmodule SchemaAssertions.Test.Repo.Migrations.CreateMaterializedHouseAddresses do
  use Ecto.Migration

  @materialized_view_name "materialized_house_addresses"

  def change do
    execute(
      """
      CREATE MATERIALIZED VIEW #{@materialized_view_name} AS (
      SELECT
        address AS address,
        house_id AS house_id
      FROM house_addresses
      )
      """,
      """
      DROP MATERIALIZED VIEW #{@materialized_view_name}
      """
    )
  end
end

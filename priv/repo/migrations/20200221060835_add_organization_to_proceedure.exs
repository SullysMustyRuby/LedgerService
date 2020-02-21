defmodule HayaiLedger.Repo.Migrations.AddOrganizationToProceedure do
  use Ecto.Migration

  def change do
  	alter table(:procedures) do
  		add :organization_id, references(:organizations, on_delete: :nothing)
  	end
  end
end

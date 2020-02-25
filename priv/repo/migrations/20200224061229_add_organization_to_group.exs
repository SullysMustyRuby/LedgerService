defmodule HayaiLedger.Repo.Migrations.AddOrganizationToGroup do
  use Ecto.Migration

  def change do
  	alter table(:groups) do
  		add :organization_id, references(:organizations, on_delete: :nothing)
  	end
  end
end

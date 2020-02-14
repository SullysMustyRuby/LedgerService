defmodule HayaiLedger.Repo.Migrations.AddOrganizationToAccountsEntries do
  use Ecto.Migration

  def change do
  	alter table(:accounts) do
  		add :organization_id, references(:organizations, on_delete: :nothing)
  	end

  	alter table(:entries) do
  		add :organization_id, references(:organizations, on_delete: :nothing)
  	end
  end
end

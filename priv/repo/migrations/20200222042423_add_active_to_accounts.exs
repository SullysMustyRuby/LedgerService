defmodule HayaiLedger.Repo.Migrations.AddActiveToAccounts do
  use Ecto.Migration

  def change do
		alter table(:accounts) do
			add :active, :boolean, default: true
		end
  end
end

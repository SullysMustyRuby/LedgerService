defmodule HayaiLedger.Repo.Migrations.CreateBalances do
  use Ecto.Migration

  def change do
    create table(:balances) do
      add :amount_subunits, :integer
      add :account_id, references(:accounts, on_delete: :nothing)

      timestamps()
    end

    create index(:balances, [:account_id])
  end
end

defmodule HayaiLedger.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :amount_currency, :string
      add :amount_subunits, :integer
      add :description, :string
      add :type, :string
      add :uid, :string
      add :account_id, references(:accounts, on_delete: :nothing)
      add :entry_id, references(:entries, on_delete: :nothing)

      timestamps()
    end

    create index(:transactions, [:account_id])
    create index(:transactions, [:entry_id])
  end
end

defmodule HayaiLedger.Repo.Migrations.CreateTransactionReports do
  use Ecto.Migration

  def change do
    create table(:transaction_reports) do
      add :name, :string
      add :type, :string
      add :field, :string
      add :timezone, :string
      add :date_from, :string
      add :date_to, :string
      add :organization_id, references(:organizations, on_delete: :nothing)

      timestamps()
    end

    create index(:transaction_reports, [:organization_id])
  end
end

defmodule HayaiLedger.Repo.Migrations.CreateReportAccounts do
  use Ecto.Migration

  def change do
    create table(:report_accounts) do
      add :name, :string
      add :object_type, :string
      add :object_uid, :string
      add :transaction_report_id, references(:transaction_reports, on_delete: :nothing)

      timestamps()
    end

    create index(:report_accounts, [:transaction_report_id])
  end
end

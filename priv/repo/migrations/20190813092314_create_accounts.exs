defmodule HayaiLedger.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :meta_data, :map
      add :name, :string
      add :object_type, :string
      add :object_uid, :string
      add :uid, :string
      add :type_id, references(:account_types, on_delete: :nothing)

      timestamps()
    end

    create index(:accounts, [:type_id])
  end
end

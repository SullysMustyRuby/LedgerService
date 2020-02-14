defmodule HayaiLedger.Repo.Migrations.CreateApiKeys do
  use Ecto.Migration

  def change do
    create table(:api_keys) do
      add :active, :boolean, default: false, null: true
      add :data, :string
      add :kind, :string
      add :organization_id, references(:organizations, on_delete: :nothing)

      timestamps()
    end

    create index(:api_keys, [:organization_id])
  end
end

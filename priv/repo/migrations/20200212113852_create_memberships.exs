defmodule HayaiLedger.Repo.Migrations.CreateMemberships do
  use Ecto.Migration

  def change do
    create table(:memberships) do
      add :active, :boolean, default: true, null: false
      add :organization_id, references(:organizations, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:memberships, [:organization_id])
    create index(:memberships, [:user_id])
  end
end

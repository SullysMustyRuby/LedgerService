defmodule HayaiLedger.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :admin, :boolean, default: false, null: false
      add :email, :string
      add :encrypted_password, :string
      add :email_confirmation, :boolean, default: false, null: false
      add :first_name, :string
      add :last_name, :string
      add :organization_id, references(:organizations, on_delete: :nothing)

      timestamps()
    end

    create index(:users, [:organization_id])
  end
end

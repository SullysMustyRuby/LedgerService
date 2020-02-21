defmodule HayaiLedger.Repo.Migrations.CreateProcedures do
  use Ecto.Migration

  def change do
    create table(:procedures) do
      add :name, :string
      add :description, :text
      add :type_id, references(:procedure_types, on_delete: :nothing)
      add :action_id, references(:procedure_actions, on_delete: :nothing)

      timestamps()
    end

    create index(:procedures, [:type_id])
    create index(:procedures, [:action_id])
  end
end

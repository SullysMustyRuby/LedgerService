defmodule HayaiLedger.Repo.Migrations.CreateGroupProcedures do
  use Ecto.Migration

  def change do
    create table(:group_procedures) do
      add :group_id, references(:groups, on_delete: :nothing)
      add :procedure_id, references(:procedures, on_delete: :nothing)

      timestamps()
    end

    create index(:group_procedures, [:group_id])
    create index(:group_procedures, [:procedure_id])
  end
end

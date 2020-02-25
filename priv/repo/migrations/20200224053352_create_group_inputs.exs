defmodule HayaiLedger.Repo.Migrations.CreateGroupInputs do
  use Ecto.Migration

  def change do
    create table(:group_inputs) do
      add :name, :string
      add :group_id, references(:groups, on_delete: :nothing)

      timestamps()
    end

    create index(:group_inputs, [:group_id])
  end
end

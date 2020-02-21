defmodule HayaiLedger.Repo.Migrations.CreateTypeParams do
  use Ecto.Migration

  def change do
    create table(:type_params) do
      add :name, :string
      add :value, :string
      add :procedure_id, references(:procedures, on_delete: :nothing)
      add :type_id, references(:params_types, on_delete: :nothing)

      timestamps()
    end

    create index(:type_params, [:procedure_id])
    create index(:type_params, [:type_id])
  end
end

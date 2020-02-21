defmodule HayaiLedger.Repo.Migrations.CreateInputs do
  use Ecto.Migration

  def change do
    create table(:inputs) do
      add :name, :string
      add :procedure_id, references(:procedures, on_delete: :nothing)

      timestamps()
    end

    create index(:inputs, [:procedure_id])
  end
end

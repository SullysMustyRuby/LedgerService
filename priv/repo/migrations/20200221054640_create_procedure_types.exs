defmodule HayaiLedger.Repo.Migrations.CreateProcedureTypes do
  use Ecto.Migration

  def change do
    create table(:procedure_types) do
      add :name, :string

      timestamps()
    end

  end
end

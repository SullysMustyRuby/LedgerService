defmodule HayaiLedger.Repo.Migrations.CreateProcedureActions do
  use Ecto.Migration

  def change do
    create table(:procedure_actions) do
      add :name, :string

      timestamps()
    end

  end
end

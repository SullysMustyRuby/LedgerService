defmodule HayaiLedger.Repo.Migrations.ProcedureCascadeDelete do
  use Ecto.Migration

  def change do
		drop constraint("inputs", "inputs_procedure_id_fkey")

  	alter table("inputs") do
  		remove :procedure_id
  		add :procedure_id, references(:procedures, on_delete: :delete_all)
  	end

  	drop table("params")

    create table(:params) do
      add :name, :string
      add :value, :string
      add :type, :string
      add :procedure_id, references(:procedures, on_delete: :delete_all)

      timestamps()
    end

    create index(:params, [:procedure_id])
  end
end

defmodule HayaiLedger.Repo.Migrations.RemoveProcedureTypes do
  use Ecto.Migration

  def change do
  	drop constraint("procedures", "procedures_type_id_fkey")
  	drop table("procedure_types")
  end
end

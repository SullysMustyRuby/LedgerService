defmodule HayaiLedger.Repo.Migrations.RemoveInputs do
  use Ecto.Migration

  def change do
  	drop constraint("inputs", "inputs_procedure_id_fkey")
  	drop table("inputs")
  end
end

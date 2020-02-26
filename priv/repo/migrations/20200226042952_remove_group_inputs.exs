defmodule HayaiLedger.Repo.Migrations.RemoveGroupInputs do
  use Ecto.Migration

  def change do
  	drop constraint("group_inputs", "group_inputs_group_id_fkey")
  	drop table("group_inputs")
  end
end
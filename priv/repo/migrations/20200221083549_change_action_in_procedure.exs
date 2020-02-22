defmodule HayaiLedger.Repo.Migrations.ChangeActionInProcedure do
  use Ecto.Migration

  def change do
  	drop constraint("procedures", "procedures_action_id_fkey")
  	drop table("procedure_actions")

  	alter table ("procedures") do
  		add :action, :string
  		remove :action_id
  	end
  end
end

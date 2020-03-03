defmodule HayaiLedger.Repo.Migrations.RemoveGroupProcedures do
  use Ecto.Migration

  def change do

  	drop constraint("group_procedures", "group_procedures_group_id_fkey")
  	drop constraint("group_procedures", "group_procedures_procedure_id_fkey")
  	drop table("group_procedures") 
  	
  	drop constraint("groups", "groups_organization_id_fkey")
  	drop table("groups") 

  end
end

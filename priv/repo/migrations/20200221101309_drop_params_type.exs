defmodule HayaiLedger.Repo.Migrations.DropParamsType do
  use Ecto.Migration

  def change do
  	drop constraint("type_params", "type_params_type_id_fkey")
  	drop table("params_types")

  	alter table("type_params") do
  		remove :type_id
  		add :type, :string
  	end

  	rename table("type_params"), to: table("params")
  end
end

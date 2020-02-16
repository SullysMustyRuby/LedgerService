defmodule HayaiLedger.Repo.Migrations.RemoveAccountType do
  use Ecto.Migration

  def change do
  	drop constraint("accounts", "accounts_type_id_fkey")
  	drop table("account_types")

  	alter table("accounts") do
  		remove :type_id
  		add :type, :string
  	end
  end
end

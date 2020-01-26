defmodule HayaiLedger.Repo.Migrations.AddNullToTransaction do
  use Ecto.Migration

  def change do
  	drop constraint("transactions", "transactions_account_id_fkey")
  	alter table("transactions") do
			modify(
		    :account_id,
		    references(:accounts, on_delete: :nilify_all),
		    null: false
		  )
  	end
  end
end

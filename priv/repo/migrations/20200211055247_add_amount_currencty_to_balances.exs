defmodule HayaiLedger.Repo.Migrations.AddAmountCurrenctyToBalances do
  use Ecto.Migration

  def change do
  	alter table(:balances) do
  		add :amount_currency, :string
  	end
  end
end

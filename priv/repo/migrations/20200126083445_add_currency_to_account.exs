defmodule HayaiLedger.Repo.Migrations.AddCurrencyToAccount do
  use Ecto.Migration

  def change do
  	alter table(:accounts) do
  		add :currency, :string
  	end
  end
end

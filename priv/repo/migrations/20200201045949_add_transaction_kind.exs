defmodule HayaiLedger.Repo.Migrations.AddTransactionKind do
  use Ecto.Migration

  def change do
  	 alter table(:transactions) do
  		add :kind, :string
  	end
  end
end

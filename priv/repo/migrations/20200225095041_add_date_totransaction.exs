defmodule HayaiLedger.Repo.Migrations.AddDateTotransaction do
  use Ecto.Migration

  def change do
  	alter table(:transactions) do
  		add :date, :utc_datetime
  	end
  end
end

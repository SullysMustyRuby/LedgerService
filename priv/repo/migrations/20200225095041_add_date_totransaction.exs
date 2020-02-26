defmodule HayaiLedger.Repo.Migrations.AddDateTotransaction do
  use Ecto.Migration

  def change do
  	alter table(:transactions) do
  		add :date, :utc_datetime, default: fragment("now()")
  	end
  end
end

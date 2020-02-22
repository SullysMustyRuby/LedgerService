defmodule HayaiLedger.Repo.Migrations.AddTypeString do
  use Ecto.Migration

  def change do
  	alter table("procedures") do
  		add :type, :string
  	end
  end
end

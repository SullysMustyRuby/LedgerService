defmodule HayaiLedger.Repo.Migrations.AddKindToAccount do
  use Ecto.Migration

  def change do
  	alter table(:accounts) do
  		add :kind, :string
  	end
  end
end

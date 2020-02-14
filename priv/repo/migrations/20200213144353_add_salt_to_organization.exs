defmodule HayaiLedger.Repo.Migrations.AddSaltToOrganization do
  use Ecto.Migration

  def change do
  	alter table(:organizations) do
  		add :token_salt, :string
  	end
  end
end

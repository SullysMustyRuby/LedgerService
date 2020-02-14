defmodule HayaiLedger.Repo.Migrations.AddSaltToApiKey do
  use Ecto.Migration

  def change do
  	alter table(:api_keys) do
  		add :token_salt, :string
  	end

  	alter table(:organizations) do
  		remove :token_salt
  	end
  end
end

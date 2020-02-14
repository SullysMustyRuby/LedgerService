defmodule HayaiLedger.Repo.Migrations.ChangeSaltToBinary do
  use Ecto.Migration

  def change do
  	alter table(:api_keys) do
  		remove :token_salt
  	end

  	alter table(:api_keys) do
  		add :token_salt, :binary
  	end
  end
end

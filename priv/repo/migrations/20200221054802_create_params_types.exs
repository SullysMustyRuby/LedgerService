defmodule HayaiLedger.Repo.Migrations.CreateParamsTypes do
  use Ecto.Migration

  def change do
    create table(:params_types) do
      add :name, :string

      timestamps()
    end

  end
end

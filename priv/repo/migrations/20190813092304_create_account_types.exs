defmodule HayaiLedger.Repo.Migrations.CreateAccountTypes do
  use Ecto.Migration

  def change do
    create table(:account_types) do
      add :name, :string
      add :description, :text

      timestamps()
    end

  end
end

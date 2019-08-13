defmodule HayaiLedger.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :description, :text
      add :object_type, :string
      add :object_uid, :string
      add :uid, :string

      timestamps()
    end

  end
end

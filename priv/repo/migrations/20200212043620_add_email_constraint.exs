defmodule HayaiLedger.Repo.Migrations.AddEmailConstraint do
  use Ecto.Migration

  def change do
		create unique_index(:users, [:email])
  end
end

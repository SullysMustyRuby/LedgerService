defmodule HayaiLedger.Accounts.AccountType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "account_types" do
    field :description, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(account_type, attrs) do
    account_type
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end

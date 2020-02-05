defmodule HayaiLedger.Ledgers.Balance do
  use Ecto.Schema
  import Ecto.Changeset

  alias HayaiLedger.Accounts.Account

  schema "balances" do
    field :amount_subunits, :integer
    belongs_to :account, Account

    timestamps()
  end

  @doc false
  def changeset(balance, attrs) do
    balance
    |> cast(attrs, [:amount_subunits])
    |> validate_required([:amount_subunits])
  end
end

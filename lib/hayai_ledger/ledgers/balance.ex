defmodule HayaiLedger.Ledgers.Balance do
  use Ecto.Schema
  import Ecto.Changeset

  alias HayaiLedger.Accounts
  alias HayaiLedger.Accounts.Account

  schema "balances" do
    field :amount_currency, :string
    field :amount_subunits, :integer
    belongs_to :account, Account

    timestamps()
  end

  @doc false
  def changeset(balance, attrs) do
    balance
    |> cast(attrs, [:account_id, :amount_currency, :amount_subunits])
    |> validate_required([:account_id, :amount_currency, :amount_subunits])
    |> validate_account()
    |> foreign_key_constraint(:account_id)
  end

  defp validate_account(%Ecto.Changeset{ changes: %{ account_id: account_id, amount_currency: amount_currency } } = changeset) do
    with %Account{ currency: currency } <- Accounts.get_account(account_id),
      true <- amount_currency == currency
    do
      changeset
    else
      {:error, message} -> Ecto.Changeset.add_error(changeset, :account_id, message, [validation: :required])
      _ -> Ecto.Changeset.add_error(changeset, :amount_currency, "currency must match accounts currency", [validation: :required])
    end
  end

  defp validate_account(changeset), do: changeset
end

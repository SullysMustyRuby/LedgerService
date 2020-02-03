defmodule HayaiLedger.Ledgers.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  import HayaiLedger.Helpers, only: [{:generate_uid, 0}]

  alias HayaiLedger.Accounts
  alias HayaiLedger.Accounts.Account
  alias HayaiLedger.Ledgers.Entry

  schema "transactions" do
    field :amount_currency, :string
    field :amount_subunits, :integer
    field :description, :string
    field :kind, :string
    field :type, :string
    field :uid, :string
    belongs_to :account, Account
    belongs_to :entry, Entry

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:account_id, :amount_currency, :amount_subunits, :description, :entry_id, :kind, :type, :uid])
    |> put_change(:uid, generate_uid())
    |> validate_required([:account_id, :amount_currency, :amount_subunits, :kind, :uid])
    |> validate_inclusion(:kind, ["credit", "debit"])
    |> validate_account_currency_match()
    |> foreign_key_constraint(:account_id)
  end

  defp validate_account_currency_match(%Ecto.Changeset{ changes: %{ account_id: account_id, amount_currency: amount_currency } } = changeset) do
    with %Account{ currency: currency } <- Accounts.get_account(account_id),
      true <- amount_currency == currency
    do
      changeset
    else
      nil -> changeset # if account find fails, return changeset so account validation error gets returned
      _ -> Ecto.Changeset.add_error(changeset, :amount_currency, "currency must match accounts currency")
    end
  end

  defp validate_account_currency_match(changeset), do: changeset
end

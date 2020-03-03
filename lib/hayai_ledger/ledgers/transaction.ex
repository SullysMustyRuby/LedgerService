defmodule HayaiLedger.Ledgers.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  import HayaiLedger.Helpers, only: [{:generate_uid, 0}]
  import HayaiLedger.LockServer, only: [{:account_locked?, 1}]

  alias HayaiLedger.Accounts
  alias HayaiLedger.Accounts.Account
  alias HayaiLedger.Ledgers.Entry


  schema "transactions" do
    field :account_uid, :string, virtual: true
    field :amount_currency, :string
    field :amount_subunits, :integer
    field :date, :utc_datetime
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
    |> cast(attrs, [:account_uid, :amount_currency, :amount_subunits, :date, :description, :entry_id, :kind, :type])
    |> validate_required([:account_uid, :amount_subunits, :kind])
    |> validate_inclusion(:kind, ["credit", "debit"])
    |> validate_account()
    |> delete_change(:account_uid)
    |> put_change(:uid, generate_uid())
    |> foreign_key_constraint(:account_id)
  end

  defp currency_match(%Ecto.Changeset{ changes: %{ amount_currency: amount_currency } } = changeset, currency) do
    case amount_currency == currency do
      true -> changeset
      false -> Ecto.Changeset.add_error(changeset, :amount_currency, "currency must match accounts currency", [validation: :required])
    end
  end

  defp currency_match(changeset, currency) do
    put_change(changeset, :amount_currency, currency)
  end

  defp validate_account(%Ecto.Changeset{ changes: %{ account_uid: account_uid } } = changeset) do
    with {:ok, %Account{ id: account_id, currency: currency }} <- Accounts.get_account_by_uid(account_uid),
      false <- account_locked?(account_uid)
    do
      changeset
      |> currency_match(currency)
      |> put_change(:account_id, account_id)
    else
      {:error, message} -> Ecto.Changeset.add_error(changeset, :account_uid, message, [validation: :required])
      true -> Ecto.Changeset.add_error(changeset, :account_uid, "account #{account_uid} is locked", [validation: :required])
    end
  end

  defp validate_account(changeset), do: changeset
end

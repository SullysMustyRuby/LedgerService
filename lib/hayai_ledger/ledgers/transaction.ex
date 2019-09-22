defmodule HayaiLedger.Ledgers.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  import HayaiLedger.Helpers, only: [{:generate_uid, 0}]

  alias HayaiLedger.Ledgers.Entry

  schema "transactions" do
    field :amount_currency, :string
    field :amount_subunits, :integer
    field :description, :string
    field :type, :string
    field :uid, :string
    belongs_to :account, HayaiLedger.Accounts.Account
    belongs_to :entry, Entry

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:amount_currency, :amount_subunits, :description, :entry_id, :type, :uid])
    |> put_change(:uid, generate_uid())
    |> validate_required([:amount_currency, :amount_subunits, :description, :type, :uid])
  end
end

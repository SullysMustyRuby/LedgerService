defmodule HayaiLedger.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset
  import HayaiLedger.Helpers, only: [{:generate_uid, 0}]

  alias HayaiLedger.Accounts.AccountType

  schema "accounts" do
    field :currency, :string
    field :meta_data, :map
    field :name, :string
    field :object_type, :string
    field :object_uid, :string
    field :uid, :string
    belongs_to :type, AccountType
    has_many :transactions, HayaiLedger.Ledgers.Transaction 

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:currency, :meta_data, :name, :type_id, :object_type, :object_uid])
    |> put_change(:uid, generate_uid())
    |> validate_required([:currency, :name, :type_id])
    |> foreign_key_constraint(:type_id)
  end
end

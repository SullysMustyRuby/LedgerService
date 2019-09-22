defmodule HayaiLedger.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset
  import HayaiLedger.Helpers, only: [{:generate_uid, 0}]

  alias HayaiLedger.Accounts.AccountType

  schema "accounts" do
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
    |> cast(attrs, [:meta_data, :name, :object_type, :object_uid])
    |> put_change(:uid, generate_uid())
    |> validate_required([:name])
  end
end

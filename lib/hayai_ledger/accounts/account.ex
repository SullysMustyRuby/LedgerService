defmodule HayaiLedger.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

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
    |> cast(attrs, [:meta_data, :name, :object_type, :object_uid, :uid])
    |> validate_required([:meta_data, :name, :object_type, :object_uid, :uid])
  end
end

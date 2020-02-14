defmodule HayaiLedger.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset
  import HayaiLedger.Helpers, only: [{:generate_uid, 0}]

  alias HayaiLedger.Accounts.AccountType
  alias HayaiLedger.Ledgers.Transaction
  alias HayaiLedger.Organizations.Organization

  schema "accounts" do
    field :currency, :string
    field :kind, :string
    field :meta_data, :map
    field :name, :string
    field :object_type, :string
    field :object_uid, :string
    field :uid, :string
    belongs_to :type, AccountType
    belongs_to :organization, Organization
    has_many :transactions, Transaction 

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:currency, :kind, :meta_data, :name, :object_type, :object_uid, :organization_id, :type_id])
    |> put_change(:uid, generate_uid())
    |> validate_required([:currency, :kind, :name, :organization_id])
    |> validate_inclusion(:kind, ["asset", "equity", "liability"])
    |> foreign_key_constraint(:organization_id)
  end
end

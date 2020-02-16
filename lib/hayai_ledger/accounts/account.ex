defmodule HayaiLedger.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset
  import HayaiLedger.Helpers, only: [{:generate_uid, 0}]

  alias HayaiLedger.Ledgers.Transaction
  alias HayaiLedger.Organizations.Organization

  @credit_types ["equity", "liability", "revenue"]
  @debit_types ["asset", "expense"]
  @kinds ["credit", "debit"]
  @types @credit_types ++ @debit_types |> Enum.sort()

  schema "accounts" do
    field :currency, :string
    field :kind, :string
    field :meta_data, :map
    field :name, :string
    field :object_type, :string
    field :object_uid, :string
    field :uid, :string
    field :type, :string
    belongs_to :organization, Organization
    has_many :transactions, Transaction 

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:currency, :meta_data, :name, :object_type, :object_uid, :organization_id, :type])
    |> put_change(:uid, generate_uid())
    |> validate_required([:currency, :type, :name, :organization_id])
    |> validate_inclusion(:type, @types)
    |> set_kind()
    |> foreign_key_constraint(:organization_id)
  end

  def types(), do: @types

  def set_kind(%Ecto.Changeset{ changes: %{ type: type } } = changeset) do
    case Enum.member?(@debit_types, type) do
      true -> put_change(changeset, :kind, "debit")
      false -> put_change(changeset, :kind, "credit")
    end
  end

  def set_kind(changeset), do: changeset
end

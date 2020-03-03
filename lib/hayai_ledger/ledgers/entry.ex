defmodule HayaiLedger.Ledgers.Entry do
  use Ecto.Schema
  import Ecto.Changeset
  import HayaiLedger.Helpers, only: [{:generate_uid, 0}]

  alias HayaiLedger.Ledgers.Transaction
  alias HayaiLedger.Organizations.Organization

  schema "entries" do
    field :description, :string
    field :object_type, :string
    field :object_uid, :string
    field :uid, :string
    belongs_to :organization, Organization
    has_many :transactions, Transaction

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:description, :object_type, :object_uid, :organization_id])
    |> cast_assoc(:transactions, with: &Transaction.changeset/2)
    |> put_change(:uid, generate_uid())
    |> validate_required([:uid])
    |> foreign_key_constraint(:organization_id)
  end
end

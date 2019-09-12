defmodule HayaiLedger.Ledgers.Entry do
  use Ecto.Schema
  import Ecto.Changeset
  import HayaiLedger.Helpers, only: [{:generate_uid, 0}]

  alias HayaiLedger.Ledgers.Transaction

  schema "entries" do
    field :description, :string
    field :object_type, :string
    field :object_uid, :string
    field :uid, :string
    has_many :transactions, Transaction

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:description, :object_type, :object_uid])
    |> put_change(:uid, generate_uid())
    |> validate_required([:uid])
  end
end

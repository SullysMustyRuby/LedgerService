defmodule HayaiLedger.Ledgers.Entry do
  use Ecto.Schema
  import Ecto.Changeset

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
    |> cast(attrs, [:description, :object_type, :object_uid, :uid])
    |> validate_required([:description, :object_type, :object_uid, :uid])
  end
end

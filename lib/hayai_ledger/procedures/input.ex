defmodule HayaiLedger.Procedures.Input do
  use Ecto.Schema
  import Ecto.Changeset

  alias HayaiLedger.Procedures.Procedure

  schema "inputs" do
    field :name, :string
    belongs_to :procedure, Procedure

    timestamps()
  end

  @doc false
  def changeset(input, attrs) do
    input
    |> cast(attrs, [:name, :procedure_id])
    |> validate_required([:name, :procedure_id])
    |> foreign_key_constraint(:procedure_id)
  end
end
